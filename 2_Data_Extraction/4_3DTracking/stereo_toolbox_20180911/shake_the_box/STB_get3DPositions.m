function [positions] = STB_get3DPositions( tracks, frameNo )
% outputs array with 3d positions

if nargin == 1
    frameNo = [];
end

positions = [];
for k = 1:size(tracks,2)
    if ~ isempty(frameNo)
        positions = [ positions ; tracks(k).position( tracks(k).frames == frameNo   ,:) ];
    else
        positions = [ positions ; tracks(k).position(end,:) ];
    end
end

