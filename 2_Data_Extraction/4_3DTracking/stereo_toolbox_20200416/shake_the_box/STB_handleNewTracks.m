function [ tracks ] = STB_handleNewTracks( tracks, frameCtr, STB_params )
% This function handles the triangPredictions, which incorporates:
% - clean orphaned older triangulated positions
% - look for two found positions in two consecutive frames and create a new
%   track from them
% - do not touch triangPredictions that are just 1 frame old

% clean orphaned single positions (older than 2 frames)
for k = 1:size(tracks,2)
    isOld(k) = tracks(k).frames(end) < frameCtr-2 ;
    % This should not affect established tracks, as they have the
    % "current-1"-frame assignet at this moment.
end
tracks(isOld) = [];

% get all particle positions of newly found particles in the current frame
% -1:
for k = 1:size(tracks,2)
    frames2(k) = tracks(k).frames(end) == frameCtr-2;
    frames1(k) = tracks(k).frames(end) == frameCtr-1;
end

idxFminus2 = (frames2 == frameCtr-2);
idxFminus1 = (frames1 == frameCtr-1);

posMinus2 = STB_get3DPositions(tracks(idxFminus2));
posMinus1 = STB_get3DPositions(tracks(idxFminus1));

if ( ~isempty(posMinus2) && ~isempty(posMinus1) )
    for k = 1:length(idxFminus2)
        dist = distance3d( posMinus2(k,:) , posMinus1 );
        minDistIdx = find(dist==min(dist));
        if dist(minDistIdx) < STB_params.newTrackDistanceAllowed
            % then append the newer particle to the older one
            tracks(idxFminus2(k)).positions(end+1,:) = posMinus1(minDistIdx,:);
            tracks(idxFminus2(k)).intensities(end+1,:) = tracks(idxFminus2(k)).intensities(1,:);
            tracks(idxFminus2(k)).frames(end+1,:) = frameCtr-1;
            % initialize the KalmanFilter for this
            tracks(idxFminus2(k)).kalFilter.correct(posMinus1(minDistIdx,:));
            % remove associated (successor)-particle from tracks
            tracks(idxFminus1(minDistIdx)) = [];
        end
    end
end




end

