addpath('/home/shiyongtan/Documents/MATLAB/Particle/VSC_2017')
addpath('/home/shiyongtan/Documents/MATLAB/Particle/VSC_2017/working')
% addpath('../../step1-calib/2007_calib')
% addpath('../../step3-matlab_stereo/Stereomatching')

%% define parameters
ncams=4;
direc='/home/shiyongtan/Documents/Experiment/EXP20/ForVSC/';  %'./cam1346/';
%addpath '../';
fixcamera=[]; % which camera is fixed. fixcamera=[1,4]; camera 1 and 4 are fixed. fixcamera=[]; all camera can be changed. 
fmin_options.Display='iter'; %'final' to display only the final mean distance, 'iter' to show the steps along the way.
fmin_options.MaxFunEvals= 3000; %350;



%% load the data matrix with 3 col of 3D position and 2 col of 2D position for each camera
%load ([direc 'dataV2.mat']);
% load ('VSC_calib_04.12.18.mat');
%load ([direc 'VSC_1234.mat']);
camParaCalib = camParaCalib([1,2,3,4]);


%% pick data to shake
new_data = C;
data1=new_data(1:37:end,:);

%% all data to test
cam2d=zeros(size(data1,1),2,ncams);

%% organize calibration file

for icam=1:ncams
    cam2d(:,:,icam)=data1(:,(icam-1)*2+4:(icam-1)*2+5);
    cam2d(:,1,icam)=(cam2d(:,1,icam)-camParaCalib(icam).Npixw/2-camParaCalib(icam).Noffw)*camParaCalib(icam).wpix;
    cam2d(:,2,icam)=(-cam2d(:,2,icam)+camParaCalib(icam).Npixh/2-camParaCalib(icam).Noffh)*camParaCalib(icam).hpix;  %vertical coordinate needed to be switched in sign to make it work--I thought the relection in the rotation matrix took care of this--but it doesn't work without this sign negative
end

data2=new_data(1:end,:);

cam2d_check=zeros(size(data2,1),2,ncams);

for icam=1:ncams
    cam2d_check(:,:,icam)=data2(:,(icam-1)*2+4:(icam-1)*2+5);
    cam2d_check(:,1,icam)=(cam2d_check(:,1,icam)-camParaCalib(icam).Npixw/2-camParaCalib(icam).Noffw)*camParaCalib(icam).wpix;
    cam2d_check(:,2,icam)=(-cam2d_check(:,2,icam)+camParaCalib(icam).Npixh/2-camParaCalib(icam).Noffh)*camParaCalib(icam).hpix;  %vertical coordinate needed to be switched in sign to make it work--I thought the relection in the rotation matrix took care of this--but it doesn't work without this sign negative
end



calinitial=zeros(8,ncams);
for icam = 1:ncams
    eul=rotm2eul(camParaCalib(icam).R);
    calinitial(1:3,icam) = eul';    
    calinitial(4:6,icam)=camParaCalib(icam).T;
    calinitial(7,icam)=camParaCalib(icam).f_eff;
    calinitial(8,icam)=camParaCalib(icam).k1;
end

%%

%calopt=calarray(1:6,2:ncams);
% calopt=calinitial([1:5,8],:);
% fixpara=calinitial(6:7,:);
calopt=calinitial;

%% fix cameras?

calall = calopt;

if isempty(fixcamera)==0
    calfix = calall(:,fixcamera);
    left = setdiff(1:ncams,fixcamera);
    calnofix = calall(:,left);
else
    calfix = [];
    calnofix = calall;
end


%% remove incorrect ones

ray3mismatch=ray_mismatch(calnofix, cam2d,  ncams);
cam2d(isnan(ray3mismatch),:,:)=[];

ray3mismatch=ray_mismatch(calnofix, cam2d_check,  ncams);
cam2d_check(isnan(ray3mismatch),:,:)=[];
%% key step: nonlinear search for the best parameters

calout = fminsearch(@(x) fitfunc(x,calfix,cam2d,ncams,fixcamera), calnofix, fmin_options);
calarray=calall;

if isempty(fixcamera)==0
    left = setdiff(1:ncams,fixcamera);
    calarray(:,left) = calout;
else
    calarray = calout;
end



%% Check the quality of the final calibration
[dist3, dist1, pall]=ray_mismatch(calarray,cam2d,ncams);

figure(5);
hist(dist3,50);
title('mismatch distribution after optimization on good matches');
xlabel('mismatch (mm)')
allcams=mean(dist3)
cammismatch2=zeros(ncams);
for n1=1:ncams
cammismatch2(n1)=mean(dist1(n1,:));
end

[dist3, dist1, pall]=ray_mismatch(calarray,cam2d_check,ncams);

figure(6);
hist(dist3,50);
title('final mismatch distribution of data not used for the optimization');
xlabel('mismatch (mm)')
allcams_check_with_mismatches=mean(dist3)


% Refill the camParaCalib structure and write it to a .cfg file.
%  (There turns out to be a very small change in the first camera even though it was not
%    dynamically calibrated since the rotation matrix is projected onto a matrix with
%     determinant exactly -1, so it changes just a bit.  The new R needs to be kept since the
%     dynamic calibration was done for this rotation matrix)
for icam = 1:ncams
    camParaCalib(icam).R=eul2rotm(calarray(1:3,icam));
    camParaCalib(icam).Rinv=inv(camParaCalib(icam).R);
    camParaCalib(icam).T=calarray(4:6,icam);
    camParaCalib(icam).Tinv=camParaCalib(icam).Rinv * (-1* camParaCalib(icam).T);
    camParaCalib(icam).f_eff = calarray(7,icam);
    camParaCalib(icam).k1 = calarray(8,icam);
    camParaCalib(icam).err_x=cammismatch2(icam);
    camParaCalib(icam).err_y=cammismatch2(icam);
end

beep
beep 
beep
%fname_cfg=strcat(dist3D_path,'PTVSetup_optimized_',dist3D_stem,'.cfg');
%gv_write_calib_cfg(camParaCalib, ncams, fname_cfg);

%% save the result


save ([direc 'VSC_calib.mat'] , 'camParaCalib');

