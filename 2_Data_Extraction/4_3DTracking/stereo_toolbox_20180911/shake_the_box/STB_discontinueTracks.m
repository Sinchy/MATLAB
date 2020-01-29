function [discontinuedTracks, tracks ] = STB_discontinueTracks( discontinuedTracks, tracks )
% This function looks for particle tracks, whose predicted position could
% not be confirmed by the STB-algorithm. Those discontinued tracks are
% collected in the discontinuedTracks-structure.

% look what predictions are not listed in the id-column
disIdx =  find(~[tracks.converged]);

% minimum-length of 10 frames?
len = traj_getLength(tracks(disIdx));

% append newly discontinued tracks
discontinuedTracks = [discontinuedTracks , tracks(disIdx(len>10)) ];

% delete from tracks
tracks(disIdx) = [];
end

