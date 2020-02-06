function DynamicPlotTracks(tracks, frame_rate, slice)
%num_track = size(tracks, 1);
num_frame = max(tracks(:, 4));
start_frame = min(tracks(:,4));
X = 0; Y = 0; Z = 0;
% frame_no = num2str(0);
%color = [0, 0, 0];
% figure
h = plot3(X, Y, Z, 'r.', 'XDataSource', 'X', 'YDataSource', 'Y', 'ZDataSource', 'Z', 'markers', 10);
x_limit_up = ceil(max(tracks(:,1))); x_limit_lo = floor(min(tracks(:,1)));
y_limit_up = ceil(max(tracks(:,2))); y_limit_lo = floor(min(tracks(:,2)));
z_limit_up = ceil(max(tracks(:,3))); z_limit_lo = floor(min(tracks(:,3)));
xlim([x_limit_lo, x_limit_up]);
ylim([y_limit_lo, y_limit_up]);
zlim([z_limit_lo, z_limit_up]);
 tracks = sortrows(tracks, 4);
num_particle = size(tracks, 1);
while(1)
    start = 1;
for i = start_frame : num_frame
    for j = start : num_particle
        if tracks(j,4) == i
            continue;
        else
            ed = j - 1;
            break;
        end
    end
    data = tracks(start : ed, 1 : 3);
    if exist('slice', 'var')
        slice_thick = 1;
        if slice == 'XY' 
            data(abs(data(:,3)) > slice_thick, :) = 0;
        elseif slice == 'XZ'
            data(abs(data(:,2)) > slice_thick, :) = 0;
        else
            data(abs(data(:,1)) > slice_thick, :) = 0;
        end
    end
    %data( ~any(data,2), : ) = []; % delete zeros point
    X = data(:, 1); Y = data(:, 2); Z = data(:, 3);
    
%     frame_no = num2str(i);
%     if exist('delay','var')
%         if i > delay
%             data = reshape(tracks(:, i - delay, :), num_track, 3);
%             data( ~any(data,2), : ) = []; % delete zeros point
%             X = [X; data(:,1)]; Y = [Y; data(:,2)]; Z = [Z; data(:,3)];
%         end
%     end
    refreshdata(h,'caller');
    title(['Elapse time: ' num2str(i / frame_rate, '%0.3f') 's' ]);
    start = ed + 1;
%     drawnow;
    pause_time = 1 / frame_rate;
    pause(pause_time);
end

end
end
