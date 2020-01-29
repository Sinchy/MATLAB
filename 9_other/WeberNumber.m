len = size(bubb_track_filter, 1);

for i = 1 : len
    % bubble velocity:
    vel_b = bubb_track_filter(i, 6:8)/ 1000;
    
    % flow velocity
    position_b = bubb_track_filter(i, 1:3);
    radius_b = bubb_track(i, 7);
    
    % search tracer within 2*D_b
    ind = vecnorm(data(:,1 : 3) - position_b, 2, 2) <= 2 * radius_b;
    
    vel_f = mean(data(ind, 6 : 8)) / 1000;
    
    we(i) = 1e3 * norm(vel_b - vel_f) ^ 2 * radius_b/1000 * 2 / 7.2e-2;
    
end