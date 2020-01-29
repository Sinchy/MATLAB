function DynamicPlotTracks(tracks)
num_track = size(tracks, 1);
num_frame = size(tracks, 2);
X = 0; Y = 0; Z = 0;
%color = [0, 0, 0];
h = plot3(X, Y, Z, 'r.', 'XDataSource', 'X', 'YDataSource', 'Y', 'ZDataSource', 'Z', 'markers', 4);
x_limit_up = ceil(max(max(tracks(:, :, 1)))); x_limit_lo = floor(min(min(tracks(:, :, 1))));
y_limit_up = ceil(max(max(tracks(:, :, 2)))); y_limit_lo = floor(min(min(tracks(:, :, 2))));
z_limit_up = ceil(max(max(tracks(:, :, 3)))); z_limit_lo = floor(min(min(tracks(:, :, 3))));
xlim([x_limit_lo, x_limit_up]);
ylim([y_limit_lo, y_limit_up]);
zlim([x_limit_lo, z_limit_up]);
for i = 1 : num_frame
    data = reshape(tracks(:, i, :), num_track, 3);
    data( ~any(data,2), : ) = []; % delete zeros point
    X = data(:, 1); Y = data(:, 2); Z = data(:, 3);
%     if exist('delay','var')
%         if i > delay
%             data = reshape(tracks(:, i - delay, :), num_track, 3);
%             data( ~any(data,2), : ) = []; % delete zeros point
%             X = [X; data(:,1)]; Y = [Y; data(:,2)]; Z = [Z; data(:,3)];
%         end
%     end
    refreshdata(h,'caller');
%     drawnow;
    pause(.01);
end

end
