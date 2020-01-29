% find particles whose velocity is between -3.9 ~ -4.1
adjust = 0; % For lavision: 1
comp_index = 6;
idx = ~isnan(data(:,4));
[~,f]=hist(data(:,comp_index),100);
% w = f./std(data(idx,14));
fl = -4.1 * std(data(idx,comp_index));
fu = -3.9 * std(data(idx,comp_index));
ind = data(:,comp_index) > fl & data(:,comp_index) < fu;
data_interest = data(ind, :);
% get the velocity and acceleration before the point and after the point
index = [8 11 14] -adjust;
ind1 = [false; ind(1:end-1)];
data_interest(:, 15 : 17) = data(ind1, index);
ind2 = [ind(2:end); false];
data_interest(:, 18 : 20) = data(ind2, index);

% data_strange = data_interest( data_interest(:,8) > -1150 & data_interest(:,8) < -1050, :);
% track_id = unique(data_strange(:,5));
tracks_interest = tracks(ismember(tracks(:, 5), unique(data_interest(:,5))), :);
fig = figure;
PlotTracks(tracks_interest, fig);
hold on
PlotTracks(data_interest, fig, 'g^');
data_strange = data_interest( data_interest(:,8) > -1150 & data_interest(:,8) < -1050, :);
PlotTracks(data_strange, fig, 'r*');