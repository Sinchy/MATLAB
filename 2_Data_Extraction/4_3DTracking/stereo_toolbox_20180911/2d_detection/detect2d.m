function [ direct_out ] = detect2d( settings, doShow, imagesIn, doUndistort, cameraSystem)
% This function detects the particles in all two or three camera images and
% stores them to the disk: One file per frame, containing the detected
% positions in all cameras.
% Columns in output file: cam1_x , cam1_y, cam2_x, cam2_y, cam3_x, cam3_y
% Please keep in mind that the particle number is usually unequal in different
% images. The output array will be zero-padded in this case.

% Copyright 2016 Michael Himpel. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
% 
%     1. Redistributions of source code must retain the above copyright notice, 
%     this list of conditions and the following disclaimer.
%     2. Redistributions in binary form must reproduce the above copyright notice, 
%     this list of conditions and the following disclaimer in the documentation 
%     and/or other materials provided with the distribution.
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY 
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
% DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY 
% OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
% DAMAGE.

if nargin < 4
    doUndistort = 0;
end


% create output folder
[pathstr,~,~] = fileparts(settings.output2Dcoords);
mkdir(pathstr);

% prepare the graphical output
if doShow
    figure;
    ax_hnd = axes;
    ax_hnd.XLabel.String = 'frame';
    ax_hnd.YLabel.String = 'no. of detected particles';
    ax_hnd.FontSize = 14;
    hold on
    legend_label = cell([0]);
    for k = 1:settings.nCams
       legend_label{k} = sprintf('CAM%d',k); 
    end
end


for frame_to_process = settings.im_range(1):settings.im_range(end)
    fprintf('do_detection_2D:: processing image %05d/%05d ',frame_to_process,settings.im_range(end));
    % cycle through all cameras that are available
    for camNo = 1:settings.nCams
        if nargin==2
            fMask = eval(sprintf('settings.cam%d_filename;',camNo));
            pos = sub_detect(settings.parameters2D(camNo), fMask,           frame_to_process);
        else
            pos = sub_detect(settings.parameters2D(camNo), imagesIn{camNo}, frame_to_process);
        end
        
        if doUndistort
            cam = cameraSystem.cameraCalibrations(camNo).camera;
            intrinsics = cameraIntrinsics([cam.gamma1 ,cam.gamma2], [cam.u0 , cam.v0], [cam.height, cam.width], ...
                'RadialDistortion', [cam.k1 , cam.k2], ...
                'TangentialDistortion', [cam.p1, cam.p2]);
            pos = undistortPoints(pos, intrinsics);
        end
        
        direct_out{camNo} = pos;
        
        if ~isempty(pos)
            current_positions(1:numel(pos(:,1)),camNo*2-1:camNo*2) = pos(:,1:2);
        end
    end
    
    if ~exist('current_positions','var')
        current_positions = [];
    end
    
    % write positions to ascii-file (for each frame)
    dlmwrite(sprintf(settings.output2Dcoords,frame_to_process),current_positions)
    fprintf(1,'%d particles found.\n',size(current_positions,1));
    
    if doShow
        % get the number of found points
        for k = 1:settings.nCams
            try
                numOfPoints(k) = numel(nonzeros(current_positions(:,2*k-1)));
            catch
                numOfPoints(k) = 0;
            end
        end
        plot_data = reshape(numOfPoints,[1 settings.nCams]) ;
        plot(ax_hnd, frame_to_process, plot_data,'.');
        ax_hnd.ColorOrderIndex = 1;
        ylim auto;
        ax_hnd.YLim(1) = 0;
        legend(legend_label);
        drawnow;
    end
    
    clear current_positions;
        
end
%fprintf(1,' ... [ done ]\n');


end


function [ pos ] = sub_detect(params2D, filename, frame_num)
% detect particles in camera:

if ischar(filename)
    I = imread(sprintf(filename,frame_num));
else
    I = filename;
end

% do sobel-filtering if demanded
if params2D.doSobel
    I = sobel_filter(I, params2D.sobelNoise, params2D.sobelGaussian, params2D.sobelGain);
end

% assume grayscale image:
I = double(I(:,:,1));

% load parameters
lNoise = params2D.optionsNoise;
lObject = params2D.optionsObject;
lThreshold = params2D.optionsThreshold;

% detect particles
% this subroutines can be replaced by anything you want...
Ibpass    = bpass(I, lNoise, lObject);
pkfnd_out = pkfnd(Ibpass, lThreshold, lObject);
if isempty(pkfnd_out) % if no particles could be found in that image
    pos = [];
else
    pos = cntrd(Ibpass, pkfnd_out, lObject +2, 0);
    
    if ~isempty(params2D.ROI.X) % empty entry means full ROI
        pos = pos(inpolygon(pos(:,1),pos(:,2), params2D.ROI.X,params2D.ROI.Y ), : );
    end
end

end

