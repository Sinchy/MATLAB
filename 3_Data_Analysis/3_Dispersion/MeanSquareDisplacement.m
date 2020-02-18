function [MSD, ci, datapoints, disp_matrix] = MeanSquareDisplacement(tracks, tao)
% For current version, tao is suggested to be the integer multiples of
% frame
% step 1: calculate delta_tao_x = x(t + tao) -x(t) for all the tracks
tracks = sortrows(tracks, 5);
track_ID = unique(tracks(:,5));
num_track = length(track_ID);
datatracks = [tracks(:, 1:11), inf * ones(size(tracks, 1), 3) ]; % create three more columns for storing delta_tao_x

% MSD_eachTr = zeros(num_track, 3); % for each track, calculate the MSD
MSD_eachTr = [0 0 0];
for i = 1 : num_track
%     track = tracks(tracks(:,5) == track_ID(i), :);
%     duration = size(track, 1);
    index = find(tracks(:, 5) == track_ID(i));
    duration = index(end) - index(1) + 1;
    if duration >= tao
        tracks(index(1) : index(end) - tao, 12 : 14) = tracks(index(1) : index(end) - tao, 1 : 3) - ...
            tracks(index(1) + tao : index(end), 1 : 3);
        tracks(index(1) : index(end) - tao, 15 : 17) = tracks(index(1) : index(end) - tao, 12 : 14) - ...
            mean(tracks(index(1) : index(end) - tao, 12 : 14));
        if size(tracks(index(1) : index(end) - tao, 12 : 14), 1) > 20 % minimum data point for statistics
            MSD_eachTr = [MSD_eachTr; var(tracks(index(1) : index(end) - tao, 12 : 14))];
        end
    end
end

% step 2: take the variance of delta_tao_x
% point-wise average ABANDON due to the effect of jumping track on the
% average
% tracks(tracks(:, 6) == inf, :) = [];
% datapoints = size(tracks, 1);
% for i = 1 : 3
%     del_tao_x = nonzeros(tracks(:, 5 + i));
%     if ~isempty(del_tao_x) && size(del_tao_x, 1) >= 20 
%     %     MSD(i) = var(del_tao_x);
%         pd = fitdist(del_tao_x,'Normal');
%         MSD(i) = pd.var;
%         stdci = pd.paramci;
%         ci(:, i) = stdci(:, 2) .^ 2; % the confidence interval for variance.
%     else
%         MSD = [];
%         ci = [];
%     end
% end

% subtracting the mean individually
% tracks(tracks(:, 12) == inf, :) = [];
% datapoints = size(tracks, 1);
% % disp_matrix = tracks(:, 9 : 11);
% disp_matrix = tracks;
% for i = 1 : 3
%     del_tao_x = tracks(:, 14 + i);
%     if ~isempty(del_tao_x) && size(del_tao_x, 1) >= 20 
%     %     MSD(i) = var(del_tao_x);
%         pd = fitdist(del_tao_x.^2,'Normal');
%         MSD(i) = pd.mean;
%         stdci = pd.std;
%         ci(:, i) = [MSD(i) - stdci; MSD(i) + stdci]; % the confidence interval for variance.
%     else
%         MSD = [];
%         ci = [];
%     end
% end

% subtracting the global mean
if size(tracks, 2) > 11
    tracks(tracks(:, 12) == inf, :) = [];
    datapoints = size(tracks, 1);
    % disp_matrix = tracks(:, 9 : 11);
    disp_matrix = tracks;
    for i = 1 : 3
        del_tao_x = tracks(:, 11 + i);
        if ~isempty(del_tao_x) && size(del_tao_x, 1) >= 20 
        %     MSD(i) = var(del_tao_x);
            pd = fitdist(del_tao_x,'Normal');
            MSD(i) = pd.var;
            stdci = pd.paramci;
            ci(:, i) = stdci(:, 2) .^ 2; % the confidence interval for variance.
        else
            MSD = [];
            ci = [];
            datapoints = [];
            disp_matrix = [];
        end
    end
else
   MSD = [];
   ci = [];
   datapoints = [];
   disp_matrix = [];
end 

% track-wise average
% tracks(tracks(:, 6) == inf, :) = [];
% datapoints = size(tracks, 1);
% MSD_eachTr(1, :) = [];
% for i = 1 : 3
%     if ~isempty(MSD_eachTr) 
%     %     MSD(i) = var(del_tao_x);
%         % remove outlier
%         data = MSD_eachTr(MSD_eachTr(:,i) < 6 * mean(MSD_eachTr(:,i)), i);
%         pd = fitdist(data,'Normal');
%         MSD(i) = pd.mean;
%         stdci = pd.paramci;
%         ci(:, i) = stdci(:, 1) .^ 2; % the confidence interval for variance.
%     else
%         MSD = [];
%         ci = [];
%     end
% end

end

