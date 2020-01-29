function [tracks] = STB_postProcessTracks(tracks)
% This function removes zeros (if any) at the end of tracks

for k = 1:length(tracks)
    pos = tracks(k).position;
    zer = tracks(k).position(:,1) == 0 | tracks(k).position(:,2) == 0 | tracks(k).position(:,3) == 0 ;
    
    if any(zer)
        tracks(k).position(zer,:) = [];
        tracks(k).frames(zer) = [];
        tracks(k).predictions(zer,:) = [];
        tracks(k).intensities(zer,:) = [];
    end
    
end

end

