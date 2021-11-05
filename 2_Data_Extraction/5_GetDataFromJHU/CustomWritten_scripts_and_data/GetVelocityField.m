%%
addpath('./parfor_progress');
addpath D:\0.Code\MATLAB\2_Data_Extraction\5_GetDataFromJHU\JohnsHopkins_database_matlab_codes;

% authkey =  'edu.psu.aks5577-18c0fbc1';
authkey = 'edu.yale.nicholas.ouellette-b0c68942';
dataset = 'isotropic1024coarse';
Lag4 = 'Lag4';
PCHIPInt = 'PCHIP';
FD4Lag4 = 'FD4Lag4';

%%
npoints = 60;
% spacing = 0 : 2 * pi / npoints : 2 * pi;
spacing = 0 : pi / 2 / npoints : pi / 2;
[X, Y, Z] = meshgrid(spacing, spacing, spacing);
X = X(:);
Y = Y(:);
Z = Z(:);
points = [X Y Z]';
n_grids = length(X);
clear X Y Z

start_time = 0.005;
end_time = 4;
dt = 0.02;

n_t = ceil((end_time - start_time) / dt) ;

u = zeros(n_grids, n_t);
v = u;
w = u;
i = 1;
for time = start_time:dt:end_time
    vel = getVelocity(authkey, dataset, time, Lag4, ...
                              PCHIPInt, n_grids, points);
    vel = vel';
    u(:, i) = vel(:, 1);
    v(:, i) = vel(:, 2);
    w(:, i) = vel(:, 3);
    i = i + 1
end
