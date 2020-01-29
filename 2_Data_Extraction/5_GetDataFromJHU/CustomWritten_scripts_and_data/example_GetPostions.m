% clear all
addpath('./parfor_progress');
addpath /home/tanshiyong/Documents/Code/MATLAB/GetDataFromJHU/JohnsHopkins_database_matlab_codes;

% authkey =  'edu.psu.aks5577-18c0fbc1';
authkey = 'edu.yale.nicholas.ouellette-b0c68942';
dataset = 'isotropic1024coarse';
Lag4 = 'Lag4';
PCHIPInt = 'PCHIP';
FD4Lag4 = 'FD4Lag4';


% nx = 30;
% ny = nx;
% xoff = 2*pi*rand; 
% yoff = 2*pi*rand;
% zoff = 2*pi*rand;
npoints = 125000;

clear points;

points(1,:) = 2*pi*rand(npoints,1);
points(2,:) = 2*pi*rand(npoints,1);
points(3,:) = 2*pi*rand(npoints,1);
% points(1,:) = newpoints(newpoints(:,4) == 798, 1)';
% points(2,:) = newpoints(newpoints(:,4) == 798, 2)';
% points(3,:) = newpoints(newpoints(:,4) == 798, 3)';

start_time = 0.005;
end_time = 11;
dt = 1;
j = 1;
% new_points = zeros(3,npoints,ceil((end_time - start_time)/dt) - 1);
 newpoints = zeros(npoints * (ceil((end_time - start_time)/dt) -1 ), 8); % 6-8 for velocity
 
 %frame 1
newpoints(npoints * (j - 1) + 1 : npoints * j, 1 : 3) = points';
newpoints(npoints * (j - 1) + 1 : npoints * j, 4) = j;
newpoints(npoints * (j - 1) + 1 : npoints * j, 5) = 1 : npoints;
current_max_track_no = npoints;
%newpoints(npoints * (j - 1) + 1 : npoints * j, 6 : 8) = vel';
j = j + 1;
 
% newpoints = [newpoints;  zeros(npoints * (ceil((end_time - start_time)/dt) -1 ), 8)];
% parfor_progress(ceil((end_time - start_time)/dt) - 1);
% current_max_track_no = max(newpoints(:,5));
for time = start_time + dt:dt:end_time
%     parfor_progress(j);
    points = getPosition(authkey, dataset, time - dt, time, dt, Lag4, npoints, points);

    new_track_no = points(1, :) < 0 | points(1, :) > 2 * pi | ...
            points(2, :) < 0 | points(2, :) > 2 * pi | ...
            points(3, :) < 0 | points(3, :) > 2 * pi;
    num_exit = sum(new_track_no);
    points(:, new_track_no) = 2 * pi * rand(3, num_exit); % delete points that are outside the view area.
    
    vel = getVelocity(authkey, dataset, time, Lag4, ...
                              PCHIPInt, npoints, points);
%     velgrad = getVelocityGradient(authkey, dataset, time, FD4Lag4, ...
%                                       'None', npoints, points);
    
    newpoints(npoints * (j - 1) + 1 : npoints * j, 1 : 3) = points';
    newpoints(npoints * (j - 1) + 1 : npoints * j, 4) = j;
    newpoints(npoints * (j - 1) + 1 : npoints * j, 6 : 8) = vel';
%     if j == 1 
%         newpoints(npoints * (j - 1) + 1 : npoints * j, 5) = 1 : npoints;
%         current_max_track_no = npoints;
%     else
        for i = 1 : npoints
            if new_track_no(i)
                newpoints(npoints * (j - 1) + i, 5) = current_max_track_no + 1;
                current_max_track_no = current_max_track_no + 1;
            else
                newpoints(npoints * (j - 1) + i, 5) = newpoints(npoints * (j - 2) + i, 5);
            end
        end
%         newpoints(npoints * (j - 1) + 1 : npoints * j, 5) = newpoints(npoints * (j - 2) + 1 : npoints * (j - 1), 5) + new_track_no';
        
%     end
    j = j + 1
    if ~mod(j, 10)
        save('simulation_data.mat', 'newpoints', '-v7.3');
    end
end
