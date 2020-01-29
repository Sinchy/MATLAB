
function camParaCalib = VSC(particles_info, calib_path)
%% define parameters
ncams = 4;
fixcamera=[]; % which camera is fixed. fixcamera=[1,4]; camera 1 and 4 are fixed. fixcamera=[]; all camera can be changed. 
fmin_options.Display = 'iter'; %'final' to display only the final mean distance, 'iter' to show the steps along the way.
fmin_options.MaxFunEvals = 3000; %350;

load (calib_path);
camParaCalib = camParaCalib([1,2,3,4]);

%% pick data to shake
data = particles_info;
data1 = data(1:end,:);

%% all data to test
cam2d = zeros(size(data1,1),2,ncams);

%% organize calibration file
for icam = 1 : ncams
    cam2d(:, :, icam) = data1(:,(icam - 1) * 2 + 4 : (icam - 1) * 2 + 5);
    cam2d(:, 1, icam) = (cam2d(:, 1, icam) - camParaCalib(icam).Npixw / 2 ...
        - camParaCalib(icam).Noffw) * camParaCalib(icam).wpix;
    cam2d(:, 2, icam) = (-cam2d(:,2,icam) + camParaCalib(icam).Npixh / 2 ...
        - camParaCalib(icam).Noffh) * camParaCalib(icam).hpix;  %vertical coordinate needed to be switched in sign to make it work--I thought the relection in the rotation matrix took care of this--but it doesn't work without this sign negative
end

data2 = data(1 : end, :);

cam2d_check = zeros(size(data2,1), 2, ncams);

for icam = 1 : ncams
    cam2d_check(:,:,icam) = data2(:, (icam-1) * 2 + 4 : (icam-1) * 2 + 5);
    cam2d_check(:,1,icam) = (cam2d_check(:, 1, icam) - camParaCalib(icam).Npixw / 2 ...
        - camParaCalib(icam).Noffw) * camParaCalib(icam).wpix;
    cam2d_check(:,2,icam) = (-cam2d_check(:, 2, icam) + camParaCalib(icam).Npixh / 2 ...
        - camParaCalib(icam).Noffh) * camParaCalib(icam).hpix;  %vertical coordinate needed to be switched in sign to make it work--I thought the relection in the rotation matrix took care of this--but it doesn't work without this sign negative
end

calinitial=zeros(8,ncams);
for icam = 1 : ncams
    eul = rotm2eul(camParaCalib(icam).R);
    calinitial(1:3,icam) = eul';    
    calinitial(4:6,icam) = camParaCalib(icam).T;
    calinitial(7,icam) = camParaCalib(icam).f_eff;
    calinitial(8,icam) = camParaCalib(icam).k1;
end

%%

%calopt=calarray(1:6,2:ncams);
% calopt=calinitial([1:5,8],:);
% fixpara=calinitial(6:7,:);
calopt = calinitial;

%% fix cameras?

calall = calopt;

if isempty(fixcamera)==0
    calfix = calall(:, fixcamera);
    left = setdiff(1: ncams, fixcamera);
    calnofix = calall(:, left);
else
    calfix = [];
    calnofix = calall;
end


%% remove incorrect ones
ray3mismatch = ray_mismatch(calnofix, cam2d,  ncams);
cam2d(isnan(ray3mismatch),:,:) = [];

ray3mismatch = ray_mismatch(calnofix, cam2d_check,  ncams);
cam2d_check(isnan(ray3mismatch),:,:) = [];

%% key step: nonlinear search for the best parameters
calout = fminsearch(@(x) fitfunc(x,calfix,cam2d,ncams,fixcamera), calnofix, fmin_options);
calarray = calall;

if isempty(fixcamera) == 0
    left = setdiff(1:ncams,fixcamera);
    calarray(:,left) = calout;
else
    calarray = calout;
end

%% Check the quality of the final calibration
[dist3, dist1, pall] = ray_mismatch(calarray,cam2d,ncams);

figure(5);
hist(dist3,50);
title('mismatch distribution after optimization on good matches');
xlabel('mismatch (mm)')
allcams = mean(dist3)
cammismatch2 = zeros(ncams);
for n1 = 1 : ncams
cammismatch2(n1) = mean(dist1(n1,:));
end

[dist3, dist1, pall] = ray_mismatch(calarray, cam2d_check, ncams);

figure(6);
hist(dist3, 50);
title('final mismatch distribution of data not used for the optimization');
xlabel('mismatch (mm)')
allcams_check_with_mismatches = mean(dist3)


% Refill the camParaCalib structure and write it to a .cfg file.
%  (There turns out to be a very small change in the first camera even though it was not
%    dynamically calibrated since the rotation matrix is projected onto a matrix with
%     determinant exactly -1, so it changes just a bit.  The new R needs to be kept since the
%     dynamic calibration was done for this rotation matrix)
for icam = 1:ncams
    camParaCalib(icam).R = eul2rotm(calarray(1:3,icam));
    camParaCalib(icam).Rinv = inv(camParaCalib(icam).R);
    camParaCalib(icam).T = calarray(4:6,icam);
    camParaCalib(icam).Tinv = camParaCalib(icam).Rinv * (-1 * camParaCalib(icam).T);
    camParaCalib(icam).f_eff = calarray(7,icam);
    camParaCalib(icam).k1 = calarray(8,icam);
    camParaCalib(icam).err_x = cammismatch2(icam);
    camParaCalib(icam).err_y = cammismatch2(icam);
end

%fname_cfg=strcat(dist3D_path,'PTVSetup_optimized_',dist3D_stem,'.cfg');
%gv_write_calib_cfg(camParaCalib, ncams, fname_cfg);
% %% save the result
% save ([direc 'VSC_calib.mat'] , 'camParaCalib');
end

function rotm = eul2rotm(eul, sequence)
    if (size(eul,1) ~= 3)
        error('eul2rotm: %s', WBM.wbmErrorMsg.WRONG_VEC_DIM);
    end

    if ~exist('sequence', 'var')
        % use the default axis sequence ...
        sequence = 'ZYX';
    end
    rotm = zeros(3,3);

    s_1 = sin(eul(1,1)); % theta_z or theta_z1
    c_1 = cos(eul(1,1));
    s_2 = sin(eul(2,1)); % theta_y
    c_2 = cos(eul(2,1));
    s_3 = sin(eul(3,1)); % theta_x or theta_z2
    c_3 = cos(eul(3,1));

    %% Convert the given Euler angles theta for the x, y and z-axis into the corresponding
    %  direction cosine rotation matrix R, in dependency of the axis rotation sequence for
    %  the multiplication order of the rotation factors:
    % For further details see:
    %   [1] Geometric Tools Engine, Documentation: <http://www.geometrictools.com/Documentation/EulerAngles.pdf>, p. 9 & 16.
    %   [2] MATLAB TOOLBOX FOR RIGID BODY KINEMATICS, Hanspeter Schaub & John L. Junkins,
    %       9th AAS/AIAA Astrodynamics Specialist Conference, AAS 99-139, 1999, <http://hanspeterschaub.info/Papers/mtb1.pdf>, p. 4.
    %   [3] GitHub: ShoolCode/ASEN 5010-Spacecraft Attitude Dynamics and Control/AIAA Software (2nd)/Matlab Toolbox,
    %       <https://github.com/ZachDischner/SchoolCode/tree/master/ASEN 5010-Spacecraft Attitude Dynamics and Control/AIAA Software (2nd)/Matlab Toolbox/>
    %   [4] Modelling and Control of Robot Manipulators, L. Sciavicco & B. Siciliano, 2nd Edition, Springer, 2008,
    %       pp. 31-32, formulas (2.18) and (2.20).
    switch sequence
        case 'ZYX'
            %            |c_1*c_2    c_1*s_2*s_3 - s_1*c_3    c_1*s_2*c_3 + s_1*s_3|
            % R(Theta) = |s_1*c_2    s_1*s_2*s_3 + c_1*c_3    s_1*s_2*c_3 - c_1*s_3|
            %            |   -s_2                  c_2*s_3                  c_2*c_3|
            rotm(1,1) =  c_1*c_2;
            rotm(1,2) =  c_1*s_2*s_3 - s_1*c_3;
            rotm(1,3) =  c_1*s_2*c_3 + s_1*s_3;

            rotm(2,1) =  s_1*c_2;
            rotm(2,2) =  s_1*s_2*s_3 + c_1*c_3;
            rotm(2,3) =  s_1*s_2*c_3 - c_1*s_3;

            rotm(3,1) = -s_2;
            rotm(3,2) =  c_2*s_3;
            rotm(3,3) =  c_2*c_3;
        case 'ZYZ'
            %            |c_1*c_2*c_3 - s_1*s_3   -c_1*c_2*s_3 - s_1*c_3    c_1*s_2|
            % R(Theta) = |s_1*c_2*c_3 + c_1*s_3   -s_1*c_2*s_3 + c_1*c_3    s_1*s_2|
            %            |             -s_2*c_3                  s_2*s_3        c_2|
            rotm(1,1) =  c_1*c_2*c_3 - s_1*s_3;
            rotm(1,2) = -c_1*c_2*s_3 - s_1*c_3;
            rotm(1,3) =  c_1*s_2;

            rotm(2,1) =  s_1*c_2*c_3 + c_1*s_3;
            rotm(2,2) = -s_1*c_2*s_3 + c_1*c_3;
            rotm(2,3) =  s_1*s_2;

            rotm(3,1) = -s_2*c_3;
            rotm(3,2) =  s_2*s_3;
            rotm(3,3) =  c_2;
        otherwise
            error('eul2rotm: %s', WBM.wbmErrorMsg.UNKNOWN_AXIS_SEQ);
    end
end

function deviation = fitfunc(calpara, calfix, cam2d, ncams, fixcamera)

% This function is for use with dynamic calibration.  It combines the calibration
% parameters into a single array and then calls the routine to calculate the distances
%  between the rays corresponding to given 2d image plane coordinates.  
%
% inputs:

%   calarray     --  full 8 by 3 calibration matrix.  Columns are for each camera.  1:3 are angles, 4:6 are T, 7 is effective focal length (f_eff) and 8 is distortion (k1) 
%   cam2d        --  N by 2 by 3 array containing 2d image plane coordinates of
%                       N matched particles.   Last index is camera id.  Middle index is coordinate (h or w).
%
% outputs:
%   deviation    -- average of the 3D ray mismatch. 
%
%  called functions:
%    gv_calc_ray_mismatch
%change Sep6,2011, calarray(1:6,2:3)=calopt(1:6,1:2) for 3cameras
%to calarray(1:6,2:ncams)=calopt(1:6,:); for 4 cameras
%calarray(1:6,2:ncams)=calopt(1:6,:);   %here we assume camera 1 is fixed.  If this changes, it needs to be changed here also.
%calarray(1:6,3:4)=calopt(1:6,1:2);   %here we assume camera 1,2 are fixed.  If this changes, it needs to be changed here also.


%calarray = [calpara(1:5,:);fixpara;calpara(6,:)];

if isempty(fixcamera)==0
    calarray(:,fixcamera) = calfix;
    left = setdiff(1:ncams,fixcamera);
    calarray(:,left) = calpara;

else
    calarray = calpara;
end



ray3mismatch=ray_mismatch(calarray, cam2d,  ncams);

deviation = mean(ray3mismatch);
end

function [ray3mismatch,h,pall] = ray_mismatch(calarray, cam2d, ncams)

for icam = 1:ncams
    R(:,:,icam) = eul2rotm(calarray(1:3,icam));
    Rinv(:,:,icam) = inv(R(:,:,icam));
    Tinv(:,icam) = Rinv(:,:,icam) * (-1* calarray(4:6,icam));
end
npoints=size(cam2d,1);
ray3mismatch=zeros(npoints,1); %average deviation over all cameras
h = zeros(npoints, ncams); %deviation from each camera
point3D= zeros(npoints,3);

for np=1:npoints 
    M = zeros(3,3);
    pM = zeros(3,ncams);
    u = zeros(3, ncams);
for icam = 1:ncams
        % then find the unit vector designated by the camera position and
        % the 2D pixel coordinates. 
    %u(:,icam) = gv_imgplane2unitvector(calarray(:,icam), Rinv(:,:,icam), cam2d(np,:,icam));
    u(:,icam) = img2unitv(calarray(:,icam), Rinv(:,:,icam), cam2d(np,:,icam));
    uM = eye(3) - u(:,icam) * (u(:,icam))';
    pM(:,icam) = uM * Tinv(:,icam);
    M = M + uM;
end

if (det(M) < 10)
  det(M)  
end
    % find the point minimizing the distance from all rays
    p = M \ sum(pM,2);  % sums pm x together for all three cameras.  Makes a column vector, then does inv(M)*sum(pM,2)
    %find the distances from each ray.

    pall(:,np)=p;
for icam = 1:ncams
    temp = p - ((p') * u(:,icam)) * u(:,icam) - pM(:,icam);
    h(np,icam) = sqrt(temp' *temp);
end
    ray3mismatch(np) = sqrt(mean(h(np,:).*h(np,:)));
end
end

function u = img2unitv(calarray, Rinv, dat2din)

% function to find unit vectors pointing in the direction corresponding to
% 2d image plane coordinates. 
%Similar to gv_pixel2unitvector but accepts a calibration matrix rather
%than a structure, and accepts undistorted image plane coordinates rather than 
% pixels.  These differences are needed to use dyanmic calibration.
%
% inputs:
%    calarray  -- 8 by ncams array with calibration parameters
%   Rinv  -- Inverse rotation matrix--could be calculated from calarray,
%       but this is faster
%   dat2din   -- array(N by 2) containing undistorted image plane
%       coordinates

% turns a 2d position into a unit vector.  The position of a particle in 3D space
% is along the ray given by the point cal.Tinv + lambda*(unit vector) where
% lambda is any real number.

%create arrays 
L=size(dat2din,1);
pos = zeros(L,3);
u=zeros(L,3);

pos(:,1:2)=dat2din;
%include distortion.  k1 seems to be defined using the radial distance
%after distortion
%rather than using the undistorted radius (because calibProj_Tsai iterates) so we
%don't iterate going this way.  I still have some questions about this
%since http://homepages.inf.ed.ac.uk/rbf/CVonline/LOCAL_COPIES/DIAS1/
%puts the (1+k1r_d^2) term as multiplying the distorted position rather than dividing as calibProjTsai
%does.  It is all conventions in the end though--just need to be
%consistent.

x = pos(:,1);
y = pos(:,2);
a = x./y;

y = (1-sqrt(1-4.*y.^2.*calarray(8).*(a.^2+1)))./(2.*y.*calarray(8).*(a.^2+1));
x = a.*y;


% radius2 = pos(:,1)^2 + pos(:,2)^2;
% pos(:,1:2) = pos(:,1:2)/(1+calarray(8)*radius2);

%Now scale by the effective focal length and the z coordinates

pos(:,1:2)=[x,y] .* (calarray(6) / calarray(7));
pos(:,3)=calarray(6);

%we also need to map the pinhole which is a common point on the ray for any
%pixel.  This is the same calculation as for pixin=[0 0], but the initial z
%coordinate is zero rather than cal.T(3)
 
zpoint = [0, 0, 0]; 
zpoint = (zpoint - (calarray(4:6))') * (Rinv)';

for i=1:L
    pos(i,:)=(pos(i,:) - (calarray(4:6))') * (Rinv)'; % I found this by reversing the steps in calibProj_Tsai
    u(i,:)=(pos(i,:)-zpoint)/norm(pos(i,:)-zpoint); %here we subtract zpoint and normalize to a unit vector
end
end

function eul = rotm2eul(rotm, sequence)
    if ( (size(rotm,1) ~= 3) || (size(rotm,2) ~= 3) )
        error('rotm2eul: %s', WBM.wbmErrorMsg.WRONG_MAT_DIM);
    end

    if ~exist('sequence', 'var')
        % use the default axis sequence ...
        sequence = 'ZYX';
    end
    eul = zeros(3,1);

    %% Compute the Euler angles theta for the x, y and z-axis from a rotation matrix R, in
    %  dependency of the specified axis rotation sequence for the rotation factorization:
    % For further details see:
    %   [1] Geometric Tools Engine, Documentation: <http://www.geometrictools.com/Documentation/EulerAngles.pdf>, pp. 9-10, 16-17.
    %   [2] Computing Euler angles from a rotation matrix, Gregory G. Slabaugh, <http://www.staff.city.ac.uk/~sbbh653/publications/euler.pdf>
    %   [3] Modelling and Control of Robot Manipulators, L. Sciavicco & B. Siciliano, 2nd Edition, Springer, 2008,
    %       pp. 30-33, formulas (2.19), (2.19'), (2.21) and (2.21').
    switch sequence
        case 'ZYX'
            % convention used by (*) and (**).
            % note: the final orientation is the same as in XYZ order about fixed axes ...
            if (rotm(3,1) < 1)
                if (rotm(3,1) > -1) % case 1: if r31 ~= �1
                    % Solution with positive sign. It limits the range of the values
                    % of theta_y to (-pi/2, pi/2):
                    eul(1,1) = atan2(rotm(2,1), rotm(1,1)); % theta_z
                    eul(2,1) = asin(-rotm(3,1));            % theta_y
                    eul(3,1) = atan2(rotm(3,2), rotm(3,3)); % theta_x
                else % case 2: if r31 = -1
                    % theta_x and theta_z are linked --> Gimbal lock:
                    % There are infinity number of solutions for theta_x - theta_z = atan2(-r23, r22).
                    % To find a solution, set theta_x = 0 by convention.
                    eul(1,1) = -atan2(-rotm(2,3), rotm(2,2));
                    eul(2,1) = pi/2;
                    eul(3,1) = 0;
                end
            else % case 3: if r31 = 1
                % Gimbal lock: There is not a unique solution for
                %   theta_x + theta_z = atan2(-r23, r22), by convention, set theta_x = 0.
                eul(1,1) = atan2(-rotm(2,3), rotm(2,2));
                eul(2,1) = -pi/2;
                eul(3,1) = 0;
            end
        case 'ZYZ'
            % convention used by (*)
            if (rotm(3,3) < 1)
                if (rotm(3,3) > -1)
                    % Solution with positive sign, i.e. theta_y is in the range (0, pi):
                    eul(1,1) = atan2(rotm(2,3),  rotm(1,3)); % theta_z1
                    eul(2,1) = acos(rotm(3,3));              % theta_y (is equivalent to atan2(sqrt(r13^2 + r23^2), r33) )
                    eul(3,1) = atan2(rotm(3,2), -rotm(3,1)); % theta_z2
                else % if r33 = -1:
                    % Gimbal lock: infinity number of solutions for
                    %   theta_z2 - theta_z1 = atan2(r21, r22), --> set theta_z2 = 0.
                    eul(1,1) = -atan2(rotm(2,1), rotm(2,2)); % theta_z1
                    eul(2,1) = pi;                           % theta_y
                    eul(3,1) = 0;                            % theta_z2
                end
            else % if r33 = 1:
                % Gimbal lock: infinity number of solutions for
                %    theta_z2 + theta_z1 = atan2(r21, r22), --> set theta_z2 = 0.
                eul(1,1) = atan2(rotm(2,1), rotm(2,2)); % theta_z1
                eul(2,1) = 0;                           % theta_y
                eul(3,1) = 0;                           % theta_z2
            end
        % case 'ZYZ-'
        %     % convention used by (**)
        %     if (rotm(3,3) < 1)
        %         if (rotm(3,3) > -1)
        %             % Variant with negative sign. This is a derived solution
        %             % which produces the same effects as the solution above.
        %             % It limits the values of theta_y in the range of (-pi,0):
        %             eul(1,1) = atan2(-rotm(2,3), -rotm(1,3)); % theta_z1
        %             eul(2,1) = -acos(rotm(3,3));              % theta_y (is equivalent to atan2(-sqrt(r13^2 + r23^2), r33) )
        %             eul(3,1) = atan2(-rotm(3,2),  rotm(3,1)); % theta_z2
        %         else % if r33 = -1:
        %             % Gimbal lock: infinity number of solutions for
        %             %   theta_z2 - theta_z1 = atan2(-r12, -r11), --> set theta_z2 = 0.
        %             eul(1,1) = -atan2(-rotm(1,2), -rotm(1,1)); % theta_z1  (correct ???)
        %             eul(2,1) = -pi;                            % theta_y
        %             eul(3,1) = 0;                              % theta_z2
        %         end
        %     else % if r33 = 1:
        %         % Gimbal lock: infinity number of solutions for
        %         %    theta_z2 + theta_z1 = atan2(-r12, -r11), --> set theta_z2 = 0.
        %         eul(1,1) = atan2(-rotm(1,2), -rotm(1,1)); % theta_z1  (correct ???)
        %         eul(2,1) = 0;                             % theta_y
        %         eul(3,1) = 0;                             % theta_z2
        %     end
        otherwise
            error('rotm2eul: %s', WBM.wbmErrorMsg.UNKNOWN_AXIS_SEQ);
    end
end