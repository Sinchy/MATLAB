function PlotTracks(tracks,  fig, marker, color, frame_rate )
if ~exist('fig', 'var') fig = 1;  end
if ~exist('marker', 'var') marker = 'b.';  end
if ~exist('color', 'var') color = 0;end
figure(fig);
if color
    if size(tracks,2) < 8
        %create velocity
        tracks(1:end-1,6:8) = (tracks(2:end, 1:3) - tracks(1:end -1, 1:3)) * frame_rate / 1000;
        len = 1;
        for i = 1 : size(tracks,1) - 1
            if tracks(i, 5) ~= tracks(i + 1, 5)
                if (len > 2)
                    tracks(i, 6:8) = tracks(i - 1, 6:8);
                else
                    tracks(i, 6:8) = 0;
                end
                len = 1;
            end
            len = len + 1;
        end
    end
%     col = (tracks(:,6).^2 + tracks(:,7).^2 + tracks(:,8).^2).^.5;
     col = vecnorm(tracks(:,6:8),2,2);
% col = tracks(:,8);
%  col = abs(tracks(:,14));
     col_st = nonzeros(col);
%      col_st(isoutlier(col_st,'gesd')) = [];
    col_m = mean(nonzeros(col_st));
    col_e = std(nonzeros(col_st));
    col((col - col_m) > 2 * col_e) = col_m + 2 * col_e;
    col((col - col_m) < -2 * col_e) = col_m - 2 * col_e;
    scatter3(tracks(:,1),tracks(:,2),tracks(:,3),2,col,'filled');
    colormap(jet);
    colorbar;
% Create zlabel
zlabel({'$Z$(mm)'},'Interpreter','latex');

% Create ylabel
ylabel({'$Y$(mm)'},'Interpreter','latex');

% Create xlabel
xlabel({'$X$(mm)'},'Interpreter','latex');

else
    plot3(tracks(:, 1), tracks(:, 2), tracks(:, 3), marker);
end

end

