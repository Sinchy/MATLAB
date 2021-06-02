% /////////////////////////////////////////////////////////////////////////////////
% //// 
% ////  easySBA Matlab interface for euclidean sparse bundle adjustment 
% ////  Copyright (C) 2013  Diane H. Theriault (deht@cs.bu.edu)
% ////  Trustees of Boston University, Boston, MA, USA
% ////
% ////  This interface created for sparse bundle adjustment library originally 
% ////  created by Manolis Lourakis (lourakis at ics forth gr)
% ////  Institute of Computer Science, Foundation for Research & Technology - Hellas
% ////  Heraklion, Crete, Greece.
% ////
% ////  This program is free software; you can redistribute it and/or modify
% ////  it under the terms of the GNU General Public License as published by
% ////  the Free Software Foundation; either version 3 of the License, or
% ////  (at your option) any later version.
% ////
% ////  This program is distributed in the hope that it will be useful,
% ////  but WITHOUT ANY WARRANTY; without even the implied warranty of
% ////  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% ////  GNU General Public License for more details.
% ////
% ///////////////////////////////////////////////////////////////////////////////////

function [worldXYZout, camPosout, camRout, intrinsicsout, distortionout] = fakeSBA(imageUV, worldXYZ, camPos, camR, intrinsics, intrinsicsFlag, distortion, distortionFlag)
% Usage: 
%
% [worldXYZout, camPosout, camRout] = easySBA(imageUV, worldXYZ, camPos, camR);
%
% [worldXYZout, camPosout, camRout, intrinsicsOut] = easySBA(imageUV, worldXYZ, camPos, camR, intrinsics, intrinsicsFlag);
%
% [worldXYZout, camPosout, camRout, intrinsicsOut, distortionOut] = easySBA(imageUV, worldXYZ, camPos, camR, intrinsics, intrinsicsFlag, distortion, distortionFlag);
% 
%
% Input:
%
% - imageUV:         Image points (numPoints x ncams*2)
%
% - worldXYZ:  	     Initial estimates for corresponding 3D points (numPoints x 3)
%
% - camPos:          Initial estimate of camera position (ncams x 3)
%
% - camR:            Initial estimate of camera orientation as quaternions (ncams x 4)
%
% - intrinsics:      [optional] Camera intrinsics (ncams x 5) 
%                    format: [focalLength principalPointX principalPointY aspectRatio skew]
% - intrinsicsFlag:  Code for which intrinsics to hold fixed (including none).
%                    0: all free, 1: skew fixed, 2: skew, ar fixed, 4: skew, ar, ppt fixed, 5: all fixed
%
% - distortion:      Camera distortion parameters(ncams x 5)
%                    The employed distortion model is the one used by Bouguet, see
%                    http://www.vision.caltech.edu/bouguetj/calib_doc/htmls/parameters.html.
% - distortionFlag:  Code for which distortion params to hold fixed (including none)
%
%
% Output: [worldXYZout, camPosout, camRout, intrinsicsOut, distortionOut]
% 
% - worldXYZ:       Refined estimates of 3D point locations
%
% - camPosOut:      Refined estimate of camera locations
%
% - camROut:        Refined estimate of camera orientation (as quaternions)
%
% - intrinsicsOut:  Refined estimate of camera intrinsic parameters 
%                   (same as input format)
%
% - distortionOut:  Refined estimate of radial distortion parameters
%
%
% Note - fakeSBA.m accepts the same inputs as easySBA but performs no
% optimization.
if nargout == 0
    warn('No output parameters to receive results of easySBA');
end

% Check number of rows of image and world points
numPoints = size(imageUV,1);
if size(worldXYZ,1) ~= numPoints
    error('mismatch in number of world points and image projections');
end

%construct the visibility mask
visibilityMask = ~isnan(imageUV(:,1:2:end))& ~isnan(imageUV(:,2:2:end));
nGoodImgPts = nnz(visibilityMask);

%check that all the camera pieces are the same length
numCams = size(camPos,1);
if size(camR, 1) ~= numCams
    error('mismatch in size between camera position and camera rotation');
end

%normalize all quaternions to unit length
for c=1:numCams
    camR(c,:) = camR(c,:)/norm(camR(c,:));
end
cameraParameters=[camR camPos];
nCamParams=7;

%check for intrinsic parameters
if exist('intrinsics', 'var') && ~isempty(intrinsics)
    if size(intrinsics,1)~=numCams
        error('mismatch in size between camera extrinsics and camera intrinsics');
    end
    if size(intrinsics,2)~=5
        error('expected: 5 intrinsic parameters (focal length, principal point (x,y), aspect ratio, skew)');
    end
    if ~exist('intrinsicsFlag', 'var')
        error('expected: code for which intrinisc parameters to allow to vary');
    end
    if intrinsicsFlag < 0 || intrinsicsFlag > 5
        error('unexpected value for flag to control which intrinsic parameters are free');
    end
    
    cameraParameters=[intrinsics camR camPos];
    nCamParams=12;
    
    %check for distortion parameters
    if exist('distortion', 'var') && ~isempty(distortion)
        if size(distortion,1) ~= numCams
            error('mismatch in size between camera extrinsics, intrinsics, and distortion');
        end
        if size(distortion,2) ~= 5
            error('expected: 5 distortion parameters');
        end
        if ~exist('distortionFlag', 'var')
            error('expected: code for which distortion parameters to allow to vary');
        end
        if distortionFlag <0 || distortionFlag > 5
            error('unexpected value for flag to control which distortion parameters are free');
        end
        
        cameraParameters=[intrinsics, distortion, camR, camPos];
        nCamParams=17;
    else
        if nargout > 4
            error('distortion parameters requested as output, but initial estimates are not given');
        end
        %if the array of distortion parameters is empty, but the flag value is not the sentinel value
        if exist('distortionFlag','var') && distortionFlag ~= -1
            error('Cannot estimate distortion parameters if no initial estimates are given');
        end
        distortionFlag=-9999; %magic number that was in eucsbademo.c
    end
else
    if nargout > 3
        error('intrinsic parameters requested as output, but initial estimates are not given');
    end
    
    %if the array of intrinsic parameters is empty, but the flag value is not the sentinel value
    if exist('intrinsicsFlag','var') && intrinsicsFlag ~= -1
        error('Cannot estimate intrinsic parameters if no initial estimates are given');
    end
    intrinsicsFlag=-1; %in case it was not previously defined
end

%% call easySBA_mex with appropriate arguments
% // 
% // Interface to easySBA_mex
% //
% // INPUTS
% //prhs[0] = number of points
% //prhs[1] = number of images/cameras
% //prhs[2] = total camera parameters given (7, 12, or 17)
% //prhs[3] = number of intrinsic parameters that are fixed (0 - 5)
% //              -1: N/A, 0: all free, 1: skew fixed, 2: skew, ar fixed, 4: skew, ar, ppt fixed, 5: all fixed
% //prhs[4] = number of distortion parameters that are fixed (-1, 0-5)
% //              -9999: N/A
% //        The employed distortion model is the one used by Bouguet, see
% //        http://www.vision.caltech.edu/bouguetj/calib_doc/htmls/parameters.html.
% //        kc[0] is the 2nd order radial distortion coefficient
% //        kc[1] is the 4th order radial distortion coefficient
% //        kc[2], kc[3] are the tangential distortion coefficients
% //        kc[4] is the 6th order radial distortion coefficient
% //prhs[5] = number of good image projections (where 3D point is visible in the image)
% //prhs[6] = image points (mnp (2) * numCameras x numPoints)
% //prhs[7] = visibility mask (numCameras * numPoints)  @TODO: Double vs bool?
% //prhs[8] = 3D points (pnp (3) x numPoints)
% //prhs[9] = camera parameters (numCameras x numCameraParameters)
% 
% // OUTPUTS
% // plhs[0] = 3D points
% // plhs[1] = camera parameters (all packed together)

%[worldXYZout, cameraParametersout] = easySBA_mex(numPoints, numCams, nCamParams, intrinsicsFlag, distortionFlag, nGoodImgPts, imageUV', double(visibilityMask'), worldXYZ', cameraParameters');

worldXYZout = worldXYZ;
camRout = camR;
camPosout = camPos;
intrinsicsout = intrinsics;
distortionout = distortion;

% %% Unpack output camera parameters
% worldXYZout=worldXYZout';
% %camPos camR intrinsics distortion
% if nCamParams==7
%     camRout   = cameraParametersout(1:4,:)';
%     camPosout = cameraParametersout(5:7,:)';
% elseif nCamParams==12
%     intrinsicsout= cameraParametersout(1:5,:)';
%     camRout      = cameraParametersout(6:9,:)';
%     camPosout    = cameraParametersout(10:12,:)';
% elseif nCamParams==17
%     intrinsicsout = cameraParametersout(1:5,:)';
%     distortionout = cameraParametersout(6:10,:)';
%     camRout       = cameraParametersout(11:14,:)';
%     camPosout     = cameraParametersout(15:17,:)';    
% end
% 
% % camRout as provided by easySBA_mex is actually the rotation away from the
% % initial rotation, so we need to add the rotations. Note that the initial
% % estimate always places the base camera at [1,0,0,0] (i.e. no rotation) so
% % no need to modify it
% for i=1:size(camRout,1)-1
%   camRout(i,:)=RMtoQ(QtoRM(camRout(i,:))*QtoRM(camR(i,:)));
% end

end

function [ RM ] = QtoRM( Q )
%QTORM Takes in quaternion versor Q and returns Rotation Matrix RM
%   Quaternion should be in the form [qr, qi, qj, qk] where qi, qj, and qk 
%   represent the scalars dictating the vector around which we will rotate
%   the 
%   NOTE - Limit use as much as possible. Degeneration is inherant in 
%   conversion as the sin of the rotational angle approaches zero or as the
%   quaternion approaches the identity quanternion. Care has been taken in
%   the implementation of this program to limit this loss but loss will
%   inevitably occur.
    
    a = 2*acos(Q(1));
    s = sin(a);
    c = cos(a);
    v = (1/(sin(a/2)))*Q(2:4);
    q = 1-c;
    
    RM = [c + (v(1)^2)*q, v(1)*v(2)*q-v(3)*s, v(1)*v(3)*q+v(2)*s;...
        v(2)*v(1)*q + v(3)*s, c + (v(2)^2)*q, v(2)*v(3)*q- v(1)*s;...
        v(3)*v(1)*q-v(2)*s, v(3)*v(2)*q+ v(1)*s, c+(v(3)^2)*q];
end

function [ Q ] = RMtoQ( RM )
%QTORM Takes in Rotation Matrix RM and returns quaternion versor Q.
%   RM should be in the form of a 3x3 rotational matrix of the form 
%   R =[ux, vx, wx]
%      [uy, vy, wy]
%      [uz, vz, wz]
%   NOTE - Limit use as much as possible. Degeneration is inherant in 
%   conversion as the sin of the rotational angle approaches zero or as the
%   quaternion approaches the identity quanternion. Care has been taken in
%   the implementation of this program to limit this loss but loss will
%   inevitably occur.

    a = (1/2)*sqrt(1 + RM(1,1) + RM(2,2) + RM(3,3));
    b = (1/2)*sqrt(1 + RM(1,1) - RM(2,2) - RM(3,3));
    
    if a<b
        a = (1/(4*b))*(RM(3,2) - RM(2,3));
        c = (1/(4*b))*(RM(1,2) + RM(2,1));
        d = (1/(4*b))*(RM(1,3) + RM(3,1));
        
    else
        b = (1/(4*a))*(RM(3,2) - RM(2,3));
        c = (1/(4*a))*(RM(1,3) - RM(3,1));
        d = (1/(4*a))*(RM(2,1) - RM(1,2));
    end
    
    Q = [a,b,c,d]; 
end
