function DynamicPlotBubbleTracks(tracks, radius, frame_rate, slice)
%num_track = size(tracks, 1);
num_frame = max(tracks(:, 4));
start_frame = min(tracks(:,4));
X = 0; Y = 0; Z = 0; S = 1; C = [0 0 1];
% frame_no = num2str(0);
%color = [0, 0, 0];
figure
h = scatter3(X, Y, Z, S, C, 'XDataSource', 'X', 'YDataSource', 'Y', 'ZDataSource', 'Z', ...
     'SizeDataSource', 'S', 'CDataSource', 'C');
x_limit_up = ceil(max(tracks(:,1))); x_limit_lo = floor(min(tracks(:,1)));
y_limit_up = ceil(max(tracks(:,2))); y_limit_lo = floor(min(tracks(:,2)));
z_limit_up = ceil(max(tracks(:,3))); z_limit_lo = floor(min(tracks(:,3)));
xlim([x_limit_lo, x_limit_up]);
ylim([y_limit_lo, y_limit_up]);
zlim([z_limit_lo, z_limit_up]);
tracks = sortrows(tracks, 5);
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
    r = radius(ismember(radius(:,1), tracks(start:ed, 5)), 2) ;
    S = r * 2 ;
    C = ColorCollision(data, r);
    
    
    if exist('slice', 'var')
        slice_thick = 5;
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

function C = ColorCollision(data, r)
    n_p = size(data, 1);
    C = ones(n_p, 1) * [0 0 1];
    ind = zeros(n_p, 1);
    for i = 1 : n_p
        dist = vecnorm(data(i, :) - data(i + 1 : end, :), 2, 2);
        s_r = (r(i) + r( i + 1 : end)) * 0.02;
        c = dist <= s_r + 0.5;
        if sum(c) > 0
            ind(i, 1) = 1;
            ind(i + 1 : end, 1) = ind(i + 1: end, 1) | c;
        end
    end
    C(logical(ind), :) = ones(sum(ind), 1) * [1 0 0];
end
