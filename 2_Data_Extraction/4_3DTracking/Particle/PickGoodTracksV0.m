function [track_good] = PickGoodTracksV0(tracks, view_size, num_good)
    [num_tracks,~,~] =size(tracks);
    error = zeros(1, num_tracks);
    for i = 1 :  num_tracks
        X = tracks(i, :, 1);
        Y = tracks(i, :, 2);
        Z = tracks(i, :, 3);
        %% delete zero points
       while(~isempty(X) && X(1) == 0 && Y(1) == 0 && Z(1) == 0)
           X(1) = []; Y(1) =[]; Z(1) = [];
       end
       while(~isempty(X) && X(end) == 0 && Y(end) == 0 && Z(end) == 0)
           X(end) = []; Y(end) =[]; Z(end) = [];
       end
        if length(X) < 20 
            error(i) = inf;
            continue; 
        end
        track = [X; Y; Z];
        error0 = zeros(1, 3);
        num_fit = 10;
        for j = 1 : 3
            p = polyfit(1:num_fit, track(j, end - num_fit + 1:end), 3);
            track_est = polyval(p, 1:num_fit);
            error0(j) = std(track_est - track(j,  end - num_fit + 1:end));
        end
        error(i) = norm(error0);
        if ~(mod(i, 1000))
            i
        end
         %%
    %     plot3(X, Y, Z, marker);
    %     hold on
    end
    std_error = view_size / 1024;
    index_good = find(error < std_error);
    if exist('num_good', 'var')
        if length(index_good) > num_good
            [~,index_good] = mink(error, num_good);
        end
    end
    track_good = tracks(index_good, :, :);
%     PlotTracks(figure, track_good, 'b.');
end

