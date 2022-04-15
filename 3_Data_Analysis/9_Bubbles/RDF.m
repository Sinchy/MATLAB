function [g, g_f, r] = RDF(tracks, xbins, sample_frame)
% get the dimension of volume
dim_min = min(tracks(:,1:3)); dim_max = max(tracks(:, 1:3));
center = (dim_max + dim_min) / 2;
r0 = (min(dim_max) - max(dim_min)) / 10;
R = InscribedCircleRadius(tracks, center, r0);
V = 4 / 3 * pi * R^3;
% sample_frame = 2000;
frame_no= unique(tracks(:,4),'first');
frame_select = frame_no(randperm(numel(frame_no), sample_frame)); % randomly select frames
% xbins = 0:dr:2 * R;
% delete bins that is larger than R
xbins(xbins > 2 *R) = [];
g_f = zeros(sample_frame, length(xbins) - 1);
h = waitbar(0, 'Processing');
for i = 1 : sample_frame
    waitbar(i/sample_frame,h)
    % consider particles within a sphere with radius R
    frame = tracks(tracks(:,4) == frame_select(i), 1:3);
    dist = vecnorm(frame - center, 2, 2);
    frame = frame(dist < R, :);
    dist = dist(dist<R);
    
    N = size(frame, 1); % number of particles
    rho = N / V; % the number density
    g_p = zeros(N, length(xbins) - 1);
    for j = 1 : N % loop over all particles
        particle = frame(j, :) ;
        dist_p = vecnorm(particle - frame, 2, 2); 
        dist_p(j) = []; % neglect the particle itself
        dn = histcounts(dist_p, xbins);
        max_dist = norm(particle - center) + R; % the maximum distance particle can be found
        % for each bins, dn needs to be normalized
        V1 = 0;
        for k = 2 : length(xbins)
            if xbins(k) < max_dist
                M = volume_intersect_sphere_analytical([center R; particle xbins(k)]);
                V2 = M(1,2);
                dV = V2 - V1;
                g_p(j, k - 1) = dn(k - 1) / rho / dV;
                V1 = V2;
            else
                g_p(j, k-1) = nan;
            end
        end
    end
    g_f(i, :) = mean(g_p, 'omitnan');
   
%     frame = tracks(tracks(:,4) == frame_select(i), 1:3);
%     dist = vecnorm(frame - center, 2, 2);
%     frame = frame(dist < R, :);
%     dist = dist(dist<R);
%     ind_center = dist == min(dist);
%     particle_center = frame(ind_center, :);
%     dist_p = vecnorm(particle_center - frame, 2, 2);
%     dist_p(ind_center) = [];
%     dn = histcounts(dist_p, xbins);
%     N = size(frame, 1);
%     g(i, :) = dn / (N/V) ./ (4/3 * pi * (xbins(2:end).^3 - xbins(1:end-1).^3));
    
    
%     pair_dist=pdist(frame); % calculate distance between particles
% %     pair_dist = pair_dist(pair_dist < R); % only consider pairs within the sphere of radius R
% %     N = (1 + (1 + 8 * length(pair_dist)) ^ .5) / 2; % number of particles within the sphere
%     N = size(frame, 1);
%     dn = histcounts(pair_dist, xbins);
%     g(i, :) = dn / (N/V) ./ (4 * pi * xbins(2:end).^2 * dr) / N;
%     N = size(frame, 1);
%     g_p = zeros(N, length(xbins) - 1);
%     for j = 1 : N
%         dist_p = vecnorm(frame(i, :) - frame, 2, 2);
%         dist_p(i) = []; % remove the distance from the particle itself
%         dn = histcounts(dist_p, xbins);
%         g_p(j, :) = dn / (N/V) ./ (4/3 * pi * (xbins(2:end).^3 - xbins(1:end-1).^3));
%     end
%     g(i, :) = mean(g_p);
end
g = mean(g_f, 'omitnan');
% g_m = g;
r = (xbins(1:end-1) + xbins(2:end)) / 2;
end

