% clear all
% addpath('../parfor_progress');

authkey =  'edu.psu.aks5577-18c0fbc1';
dataset = 'isotropic1024coarse';
Lag4 = 'Lag4';
FD4Lag4  = 'Fd4Lag4'  ; % 4th order finite differential scheme for grid values, 4th order Lagrangian interpolation in space

% nx = 30;
% ny = nx;
% xoff = 2*pi*rand; 
% yoff = 2*pi*rand;
% zoff = 2*pi*rand;
npoints = 50000;

clear points;

start_time = 0.0002;
end_time = 0.0198;
dt = 0.0002;

VG = zeros(9,npoints,round((end_time - start_time)/dt));
j = 1;
% parfor_progress(ceil((end_time - start_time)/dt) - 1);
time_stamp = zeros(round((end_time - start_time)/dt,2));
for time = start_time+dt:dt:end_time
    points = new_points(:,1:npoints,j);
    VG(:,:,j) = getVelocityGradient (authkey, dataset, time,  FD4Lag4, 'None', npoints, points);
    time_stamp(j,1) = j;
    time_stamp(j,2) = time;
    j = j + 1;
end
% parfor_progress(0);
%%
