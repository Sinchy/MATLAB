function track_std = ConvertToStandardTrack(track) 
step = 3;
last_frame = 450;
[~, num_track, ~] = size(track);
track_std = zeros(num_track, last_frame / step, 3);
x3Dmin = -25; y3Dmin = -25; z3Dmin = -25;
x3Dmax = 25;  y3Dmax = 25;  z3Dmax = 25;
for  i = 1 : num_track
    for j = 1 : last_frame / step
        X = bound(track(1,i,j * step)) * (x3Dmax - x3Dmin) / (2*pi)  + x3Dmin;
        Y = bound(track(2,i,j * step)) * (y3Dmax - y3Dmin) / (2*pi)  + y3Dmin;
        Z = bound(track(3,i,j * step)) * (z3Dmax - z3Dmin) / (2*pi)  + z3Dmin;
        track_std(i, j, :) = [X, Y, Z];
    end
end
end


function x = bound(X) 
    x = X;
    if (X > 2 * pi)
        x = X - 2 * pi;
    elseif (X < 0)
        x = X + 2 * pi;
    end
end
