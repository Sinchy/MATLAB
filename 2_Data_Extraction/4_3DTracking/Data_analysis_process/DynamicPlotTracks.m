function DynamicPlotTracks(tracks)
%num_track = size(tracks, 1);
num_frame = max(tracks(:, 2));
X = 0; Y = 0; Z = 0;
%color = [0, 0, 0];
h = plot3(X, Y, Z, 'r.', 'XDataSource', 'X', 'YDataSource', 'Y', 'ZDataSource', 'Z', 'markers', 4);
x_limit_up = ceil(max(tracks(:,3))); x_limit_lo = floor(min(tracks(:,3)));
y_limit_up = ceil(max(tracks(:,4))); y_limit_lo = floor(min(tracks(:,4)));
z_limit_up = ceil(max(tracks(:,5))); z_limit_lo = floor(min(tracks(:,5)));
xlim([x_limit_lo, x_limit_up]);
ylim([y_limit_lo, y_limit_up]);
zlim([z_limit_lo, z_limit_up]);
tracks = sortrows(tracks, 2);
num_particle = size(tracks, 1);
start = 1;
for i = 1 : num_frame
    for j = start : num_particle
        if tracks(j,2) == i
            continue;
        else
            ed = j - 1;
            break;
        end
    end
    data = tracks(start : ed, 3 : 5);
    %data( ~any(data,2), : ) = []; % delete zeros point
    X = data(:, 1); Y = data(:, 2); Z = data(:, 3);
%     if exist('delay','var')
%         if i > delay
%             data = reshape(tracks(:, i - delay, :), num_track, 3);
%             data( ~any(data,2), : ) = []; % delete zeros point
%             X = [X; data(:,1)]; Y = [Y; data(:,2)]; Z = [Z; data(:,3)];
%         end
%     end
    refreshdata(h,'caller');
    start = ed + 1;
%     drawnow;
    pause(.005);
end

end
