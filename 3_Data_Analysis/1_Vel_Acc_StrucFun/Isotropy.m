function [Im, Ii] = Isotropy(tracks)
Im = 0;
Ii = 0;
ii = zeros(3,3);
for dir1 = 1:3
    max_l = max(tracks(:, dir1));
    min_l = min(tracks(:, dir1));
    dl = (max_l - min_l) / 10;
    [~, ~, uidx] = histcounts(tracks(:,dir1), min_l : dl : max_l);
%     uxy = (uxy(1:end - 1) + uxy(2:end)) / 2;
    % [~, ~, uidx] = unique(idx, 'rows');
    avgv1 = (accumarray(uidx, tracks(:,12).^2, [], @nanmean)).^.5;
    avgv2 = (accumarray(uidx, tracks(:,13).^2, [], @nanmean)).^.5;
    avgv3 = (accumarray(uidx, tracks(:,14).^2, [], @nanmean)).^.5;
%     mean_map = [uxy', avgv1, avgv2, avgv3];
    im = 1/3 * (std(avgv1)/mean(avgv1) + std(avgv2)/mean(avgv2) + std(avgv3)/mean(avgv3));
    ii(dir1, :) = [mean(avgv1) mean(avgv2) mean(avgv3)];
    
    Im = Im + im;
end
Im = Im/3;
ii_t = vecnorm(ii, 2, 1);
Ii = std(ii_t)/mean(ii_t);
end

