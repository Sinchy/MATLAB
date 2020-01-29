function [ isFresh ] = STB_isFresh( tracks )
% checks, what tracks are freshly created (only 1 frame old)

for k = 1:length(tracks)
    numOfPositions = size(tracks(k).position,1);
    isFresh(k) = logical( numOfPositions == 1 );
end

end

