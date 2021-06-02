function [positions, trajIdx] = STB_get3DPositions( tracks, frameNo )
% outputs array with 3d positions

if nargin == 1
    frameNo = [];
end

if nargout ==2
    doIdx = 1;
else
    doIdx = 0;
end

trajIdx = [];
positions = [];
for k = 1:size(tracks,2)
    if ~ isempty(frameNo)
        positions = [ positions ; tracks(k).position( tracks(k).frames == frameNo   ,:) ];
        if doIdx
            if any(tracks(k).frames == frameNo)
                trajIdx = [trajIdx ; k];
            end
        end
    else
        positions = [ positions ; tracks(k).position(end,:) ];
    end
end

