function [disp_matrix, pairs] = RemoveWrongSlowPairs(disp_matrix, data_map, pairs)
% NOTE: this code can only be applied to pairs with small initial
% separation. 


%     disp_dif = disp_matrix(:, 2:end) - disp_matrix(:, 1:end-1);
%     
%     for i = 1 : size(disp_dif, 1)
%         d = disp_dif(i, :);
%         d(isnan(d)) = [];
%         dif_mean(i) = mean(abs(nonzeros(d)));
%         dif_std(i) = std(nonzeros(d));
%         
%     end
%     for i = 1 : size(disp_matrix, 1)
%         d = disp_matrix(i, :);
%         d(isnan(d)) = [];
%         dif_mean(i) = mean(abs(nonzeros(d)));
%         dif_std(i) = std(nonzeros(d));
%         
%     end
%     ind = dif_std >0.01 | dif_mean > 0.01;

% for i = 1 : size(disp_matrix, 1)
%         d = nonzeros(disp_matrix(i, :));
%         d(isnan(d)) = [];
%         dd = d - d(1);
%         if sum(dd > .01)
%             ind(i) = true;
%         else
%             ind(i) = false;
% %             tr_ID = pairs(i, 1:2);
% % tracks = GetSpecificTracksFromData(data_map, tr_ID);
% % PlotTracks(tracks)
%         end
% %         dif_mean(i) = mean(abs(nonzeros(d)));
% %         dif_std(i) = std(nonzeros(d));
%         
% end

    tr_ID_r = pairs(:, 1:2);
%     tr_ID = unique(tr_ID(:));
    
    % delete high-frequently-used track
    % usually there is very low possibility that a particle can find more
    % than 3 pairs in very short separation， otherwise it should be wrong
    % pairs.
    tr_ID_r = unique(tr_ID_r, 'rows');
    [tr_ID,~,ic] = unique(tr_ID_r);
    a_counts = accumarray(ic,1);
    value_counts = [tr_ID, a_counts];
    tr_ID_high = value_counts(value_counts(:,2)>3, 1);
    
    
    tracks = GetSpecificTracksFromData(data_map, tr_ID);
    tic
    for i = 1 : size(pairs, 1)
        if ismember(pairs(i, 1), tr_ID_high) || ismember(pairs(i, 2), tr_ID_high)
            ind(i) = false;
            continue;
        end
        track1 = tracks(tracks(:,5) == pairs(i, 1), :);
        track2 = tracks(tracks(:,5) == pairs(i, 2), :);
        frames = intersect(track1(:,4), track2(:,4));
        track1 = track1(track1(:,4) >= min(frames) & track1(:,4) <= max(frames), :);
        track2 = track2(track2(:,4) >= min(frames) & track2(:,4) <= max(frames), :);
        disp_vec = track1(:, 1:3) - track2(:, 1:3);
        disp_sca = vecnorm(disp_vec, 2, 2) ;
        dd = abs(disp_sca - disp_sca(1));
        if sum(dd > .25) % 5 \eta
            ind(i) = true;
        else
            ind(i) = false;
%             track1 = tracks(tracks(:,5) == pairs(i, 1), :);
%             track2 = tracks(tracks(:,5) == pairs(i, 2), :);
%             PlotTracks([track1;track2])
        end
        
    end
    toc
    disp_matrix = disp_matrix(ind, :);
    pairs = pairs(ind, :);

end

