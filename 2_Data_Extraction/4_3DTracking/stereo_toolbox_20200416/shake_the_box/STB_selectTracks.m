function [ tracks_out ] = STB_selectTracks(tracks, discontinuedTracks, minLen, minIntensity)
% This function returns tracks, that are filtered according to:
% - minimum length
% - minimum intensity


if nargin == 2
    minLen = 1;
end

if nargin == 3
    minIntensity = [0 0 0 0];
end


tracks_out = [tracks , discontinuedTracks];

keepIdx = [];

for k = 1:length(tracks_out)
    len = size(tracks_out(k).frames,1);
        
     if (len>=minLen) 
         keepIdx(k) = 1;
     else
         keepIdx(k) = 0;
     end
    
end

tracks_out = tracks_out(logical(keepIdx));

end

