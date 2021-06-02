function [ tracks ] = STB_correctPositions( tracks )
% Check which particles' predicitons has been proven and correct the
% Kalmann-filter accordingly. Keep record of the intensity that was found.


for k = find([tracks.converged]) % cycle through converged particles
    tracks(k).kalFilter.correct( tracks(k).position(end,:) );
end

end

