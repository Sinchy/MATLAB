% save all data files

%load filter_data.mat
function GetVTK(filter_data, skip_frame_num, save_path)
% allframes=[1501:8:2000];
start_frame = min(filter_data(:, 4));
frame_num = max(filter_data(:, 4));
mkdir([save_path 'VTK/']);

for i= start_frame : skip_frame_num : frame_num
    data_output=filter_data(filter_data(:,4) == i,:);
        vtkwrite([save_path 'VTK/particle_' num2str(i,'%03.0f') '.vtk'], ...
        'unstructured_grid',data_output(:,1),data_output(:,2),data_output(:,3), ...
        'scalars', 'velmag', vecnorm(data_output(:,6:8), 2, 2), ...
        'scalars', 'track', data_output(:,5));
%     vtkwrite([save_path 'VTK/particle_' num2str(i,'%03.0f') '.vtk'], ...
%         'unstructured_grid',data_output(:,1),data_output(:,2),data_output(:,3), ...
%         'vectors','velocity',data_output(:,6),data_output(:,7),data_output(:,8), ...
%         'vectors','acc',data_output(:,9),data_output(:,10),data_output(:,11), ...
%         'scalars', 'velmag', sqrt(mean(data_output(:,6:8).^2,2)), ...
%         'scalars', 'accmag', sqrt(mean(data_output(:,9:11).^2,2)), ...
%         'scalars', 'track', data_output(:,5));
%             'vectors','velocityfluc',data_output(:,12),data_output(:,13),data_output(:,14), ...
%                 'scalars', 'velfluc', sqrt(mean(data_output(:,12:14).^2,2)), ...
    %         'scalars', 'Ufluc', data_output(:,12), ...
%         'scalars', 'Vfluc', data_output(:,13), ...
%         'scalars', 'Wfluc', data_output(:,14), ...
end
end