function JetFlowVisualization(tracks, camParaCalib, open_jet_id, jet_height, save_path)
%% Get jet map
[jet_location, jet_label] = JetLocation();
jet_location = [jet_location(:, 2), ones(88, 1) * jet_height, -jet_location(:, 1)];
% jet location rotation
jet_location = JetRotation(camParaCalib, jet_location);
hold on
plot3(jet_location(:,1), jet_location(:,2), jet_location(:,3), 'bo')
for i = 1 : 88
    text(jet_location(i, 1), jet_location(i, 2), jet_location(i, 3), num2str(jet_label(i)));
end
 jet_location = [jet_location, zeros(88, 1) ones(88,2), zeros(88, 3)];
 GetVTK(jet_location, 1, [save_path '\Jet_location']);
 jet_open = jet_location(ismember(jet_label, open_jet_id), :);
 GetVTK(jet_open, 1, [save_path '\Jet_open']);
 
GetVTK(tracks, 1, [save_path '\Tracks']);
end

function [jet_location, jet_label] = JetLocation(center_number)
%%
if ~exist('center_number', 'var')
    center_number = 47;
end
jet_spacing = 30; % 30 mm
% number of jets per row jet_perrow = [3 4 5 6 7 8 7 8 7 8 7 6 5 4 3];
x_jet = [-1 : 1 : 1, -1.5 : 1 : 1.5, -2 : 1 : 2, -2.5 : 1 : 2.5, -3 : 1 :3, -3.5 : 1 : 3.5, -3 : 1 : 3, ...
    -3.5 : 1 : 3.5, -3 : 1 :3, -3.5 : 1 : 3.5, -3 : 1 : 3, -2.5 : 1 : 2.5, -2 : 1 : 2, -1.5 : 1 : 1.5, -1 : 1 : 1]';
y_jet = -[0 * ones(1,3), 0.5 * ones(1,4), 1 * ones(1, 5), 1.5 * ones(1, 6), 2 * ones(1, 7), ...
    2.5 * ones(1, 8), 3 * ones(1,7), 3.5 * ones(1,8), 4 * ones(1,7), 4.5 * ones(1, 8), 5 * ones(1, 7) ...
    5.5 * ones(1, 6), 6 * ones(1, 5), 6.5 * ones(1, 4), 7 * ones(1, 3)]';
jet_location = [x_jet, y_jet] * jet_spacing;
jet_label = [54 50 46 76 75 3 2 72 53 49 45 42 79 78 77 6 5 4 74 71 52 48 44 41 30 83 82 81 80 15 16 17 18 ...
    73 70 51 47 43 29 1 87 86 85 84 11 12 13 14 68 55 32 36 40 26 24 88 59 60 61 7 8 9 10 67 56 31 35 39 27 25 ...
    62 63 64 19 20 21 69 58 34 38 28 65 66 22 23 57 33 37];
center_ind = jet_label == center_number;
jet_location = jet_location - jet_location(center_ind, :);
viscircles(jet_location, 2.5 * ones(88, 1));
axis equal
for i = 1 : 88
    text(jet_location(i, 1), jet_location(i, 2), num2str(jet_label(i)));
end
end

function [jet_location] = JetRotation(camParaCalib, jet_location)
CameraDistribution(camParaCalib);

cam_id = str2double(inputdlg('Which camera does X axis point to?', 'Axis direction'));

% position of the camera
cow=camParaCalib(cam_id).R\([0 0 0]' - camParaCalib(cam_id).T);
% angle in XZ plane
angleXZ = Angle([0, 0, 1], [cow(1), 0, cow(3)]);
rot_XZ = angleXZ;

% rotation adjust
rot_matrix = eul2rotm([0 rot_XZ 0]); % sequence: Z, Y, X

jet_location = rot_matrix * jet_location';
jet_location = jet_location';
end

function angle = Angle(u, v)
CosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
angle = real(acos(CosTheta));
end