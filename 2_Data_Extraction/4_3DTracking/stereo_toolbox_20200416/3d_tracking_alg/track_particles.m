function [ tracks ] = track_particles( coords3d_string, tracking_params )
% This function tracks particle motion and links them to trajectories. The
% matlab functions given by the computer-vision toolbox are used.
% Basically, this is a modified example from mathworks.

%--------------------------------------------------------------------------
%     Copyright (C) 2016 Michael Himpel (himpel@physik.uni-greifswald.de)
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

% if no param_Set given, promt the user to give the parameters
if nargin<2
    tracking_params.maxInvisible = input('Trajectory may be invisible for max XXX frames: ');
    tracking_params.maxCost = input('Assignment to tracks allowed max cost: ');
    tracking_params.startFrame = input('Start at frame: ');
    tracking_params.endFrame = input('End at frame: ');
end

if ~isfield(tracking_params,'doShow')
    tracking_params.doShow = 0;
end

% go through frames, follow trajectories, create new ones if desired
nextId = 1; % counter for the id of tracks
tracks = initializeTracks(); % Create an empty array of tracks.
lost_tracks = initializeTracks(); % This one will keep the lost tracks
cost = [];
predicted_meas = [];

if tracking_params.doShow
    figure;
    ax_hnd = axes; hold on;
end


fprintf(1,'Start particle tracking\n');
disp('*************************************');

for frameNo = tracking_params.startFrame:tracking_params.endFrame
    fprintf(1,'Frame %05d/%05d: ',frameNo,tracking_params.endFrame);
    
    % load particles
    parts3d = loadParticleData(coords3d_string, frameNo);
    if size(parts3d,2) < 3
        parts3d = [ parts3d, zeros(size(parts3d,1),1) ];
    end

    updateParticlePlot(); % uses parts3d
    
    % let the kalman-filter predict the new location of the particles
    predictNewLocationsOfTracks();
    updatePredictionsPlot(); % uses predicted_meas
    
    % check for the possible assignments
    if tracking_params.doRangeSearch
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignmentNearestNeighbor();
    else
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment();
    end
    
%     if frameNo == 100
%         
%         [assignments, unassignedTracks, unassignedDetections] = ...
%             detectionToTrackAssignmentNearestNeighbor();
%         
%         [assignments2, unassignedTracks2, unassignedDetections2] = ...
%             detectionToTrackAssignment();
%         keyboard
%     end
    
    updateAssignedTracks();
    updateAssignmentPlot(); % uses assignments, unassignedDetections
    
    
    % get mean cost of assigned positions
    cost_array = [];
    for k = 1:numel(assignments(:,1))
        cost_array(k) = tracks(assignments(k,1)).cost(end);
    end
    
    updateUnassignedTracks();
    deleteLostTracks();
    createNewTracks();
    
    
    fprintf(1,'Assigned: %04d, Unassigned: %04d, MeanCost: %5.2f\n',length(assignments),length(unassignedDetections),nanmean(cost_array(:)));
end

%% nested functions (DO share variables with main function)

    function createNewTracks()
        centroids = parts3d(unassignedDetections, 1:3);
        
        for i = 1:size(centroids, 1)
            
            centroid = centroids(i,:);
            
            % Create a Kalman filter object.
            kalmanFilter = configureKalmanFilter(tracking_params.Model, ...
                centroid, tracking_params.InitialEstimateError, tracking_params.MotionNoise, tracking_params.MeasurementNoise);
            
            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0, ...
                'frames',frameNo, ...
                'cost',nan,...
                'prediction',[nan nan nan],...
                'position', centroid);
            
            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            
            % Increment the next id.
            nextId = nextId + 1;
        end
    end

    function predictNewLocationsOfTracks()
        for i = 1:length(tracks)
            % Predict the current location of the track.
            [predicted_meas(i,1:3), ~, ~] = predict(tracks(i).kalmanFilter);
            
            %update the preditions field of the tracks
            tracks(i).prediction = [tracks(i).prediction ; predicted_meas(i,1:3)];
        end
    end

    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()
        
        nTracks = length(tracks);
        nDetections = size(parts3d, 1);
        
        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            %cost(i, :) = distance(tracks(i).kalmanFilter, parts3d(:,1:3));
            if length(tracks(i).kalmanFilter.State) == 9
                predInd = [1 4 7];
            elseif length(tracks(i).kalmanFilter.State) == 6
                predInd = [1 3 5];
            else
                error('Wrong KalmanFilterState');
            end
            % the "usual" cost function will be the euclidean distance
            cost(i, :) = distance3d(parts3d(:,1:3), tracks(i).kalmanFilter.State(predInd));
            
            % particles, that just have opened a new track are allowed to
            % have a larger cost - so that they can propably make the first
            % link. This is implemented by reducing the costs of these
            % particles to all others by a scalar.
            
            %cost([tracks.age]==1,:) = cost([tracks.age]==1,:)./1.2;
            %cost([tracks.age]==2,:) = cost([tracks.age]==2,:)./1.1;
        end
        
        % Solve the assignment problem.
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks( cost, tracking_params.maxCost);
    end


    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignmentNearestNeighbor()
        
        
        if isempty(predicted_meas)
            unassignedDetections = (1:size(parts3d,1))' ;
            assignments = uint32(zeros(0,2));
            unassignedTracks = uint32(zeros(0,1));
        else
            predicted_meas = [];
            for kk = 1:length(tracks)
                if length(tracks(kk).kalmanFilter.State) == 9
                    predInd = [1 4 7];
                elseif length(tracks(kk).kalmanFilter.State) == 6
                    predInd = [1 3 5];
                else
                    error('Wrong KalmanFilterState');
                end
                % the "usual" cost function will be the euclidean distance
                predicted_meas(kk,:) = tracks(kk).kalmanFilter.State(predInd);
            end
            
            
            assignments = zeros(size(predicted_meas,1),1);
            [ idxNN, D]= rangesearch(parts3d, predicted_meas, tracking_params.maxCost,'distance', 'euclidean', 'NSMethod', 'exhaustive');
            for kk = 1:length(idxNN)
                assignments(kk) = any(idxNN{kk});
                if ~isempty(idxNN{kk}) % ensure that only the nearest is kept
                    idxNN{kk} = idxNN{kk}(1);
                    D{kk}     = D{kk}(1);
                end
            end
            
            unassignedTracks = find(~logical(assignments));
            assignments = find(assignments);
            assignments(:,2) = [idxNN{assignments(:,1)}];
            
            % look if a detection was used by multiple tracks and keep the
            % assignment with minimal distance
            
            [un, I, J] = unique(assignments(:,2));
            Ncount = histc(assignments(:,2), un);
            
            if any(Ncount>1)
                toBeDeleted = [];
                % for all multiple occurences of detection-assignments...
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % ÄNDERUNG   "find"->"un"
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                for multIdx = find( Ncount > 1 )'     
                    % cycle thorugh all multiple occurences and keep
                    % the one with least distance
                    occurences = assignments(:,2)==multIdx;
                    
                    [~, idxMin] = min( [D{occurences}] );
                    
                    % keep only the assignment with minimum distance, store
                    % others to be deleted
                    toKeep = find(occurences);
                    toKeep = toKeep(idxMin);
                    
                    toBeDeleted = [toBeDeleted ; setdiff(find(occurences), toKeep)];
                    
                end
                assignments(toBeDeleted,:) = [];
            end
            
            unassignedDetections = setdiff( 1:size(parts3d,1) , assignments(:,2) );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % auch die unassigned Tracks nochmal updaten!!
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cost = sparse(assignments(:,1), assignments(:,2), [D{assignments(:,1)}]);
            
            %             plot(predicted_meas(:,1), predicted_meas(:,2),'bo'); hold on
            %             for ll = 1:size(assignments,1)
            %                 text(predicted_meas(assignments(ll,1),1), predicted_meas(assignments(ll,1),2), sprintf('%d',assignments(ll,1)) );
            %             end
            %             plot(parts3d(:,1), parts3d(:,2), 'ro');
            %             plot(parts3d(unassignedDetections,1), parts3d(unassignedDetections,2), 'rs');
            %             plot(parts3d(assignments(:,2),1), parts3d(assignments(:,2),2), 'r+');
            %             pause;
            %             close all
            
        end
    end

    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
            tracks(ind).cost = [tracks(ind).cost ; nan];
            tracks(ind).frames = [tracks(ind).frames ; frameNo];
            tracks(ind).position = [tracks(ind).position ; predicted_meas(ind,1:3)];
        end
    end

    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = parts3d(detectionIdx, 1:3);
            
            
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);
            
            % update the tracks frame-field
            tracks(trackIdx).frames = [tracks(trackIdx).frames ; frameNo];
            
            % update the tracks position-field
            tracks(trackIdx).position = [tracks(trackIdx).position ; parts3d(detectionIdx, :)];
            
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % update the tracks cost-array
            tracks(trackIdx).cost = [tracks(trackIdx).cost ; cost(trackIdx, detectionIdx)];
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
    end

    function deleteLostTracks()
        if isempty(tracks) % when no tracks exist at the very first run
            return;
        end
        
        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;
        
        % Find the indices of 'lost' tracks.
        lostInds = ((ages < 3) & (visibility < 1)) | ...
            [tracks(:).consecutiveInvisibleCount] > tracking_params.maxInvisible;
        
        if any(lostInds)
            % store the lost tracks in a temporary container
            lost_tracks(length(lost_tracks)+1:length(lost_tracks)+numel(find(lostInds))) = tracks(lostInds);
            
            % delete lost tracks from current structure
            tracks = tracks(~lostInds);
        end
        
        
    end

    function updateParticlePlot()
        if tracking_params.doShow
            % remove the existing particle positions from axes
            exParts = findobj(ax_hnd,'Color','b','MarkerStyle','.');
            delete(exParts);
            
            % plot new ones
            plot3(parts3d(:,1),parts3d(:,2),parts3d(:,3),'.b');
            drawnow;
        end
    end

    function updatePredictionsPlot()
        if tracking_params.doShow
            % remove the existing predictions from axes
            exPreds = findobj(ax_hnd,'Color','r');
            %delete(exPreds);
            
            % plot new ones
            try
                plot3(predicted_meas(:,1),predicted_meas(:,2),predicted_meas(:,3),'dr');
            end
            drawnow
        end
    end

    function updateAssignmentPlot()
        if tracking_params.doShow
            % delete existing lines
            exLines = findobj(ax_hnd,'LineStyle','-');
            delete(exLines);
            
            plot3(parts3d(unassignedDetections,1),parts3d(unassignedDetections,2),parts3d(unassignedDetections,3),'b+');
            
            % plot "current" tracks
            for k = 1:numel(assignments)
                try
                    plot3(tracks(k).position(:,1),tracks(k).position(:,2),tracks(k).position(:,3),'-y');
                end
            end
            for k = 1:numel(unassignedTracks)
                % plot3(tracks(k).position(:,1),tracks(k).position(:,2),tracks(k).position(:,3),'-y');
            end
            drawnow
        end
    end


% all lost tracks could not be continued after the last
% "tracking_params.maxInvisible" number of frames. These last frames must
% be deleted from each lost track
for k = 1:numel(lost_tracks)
    lost_tracks(k).cost = lost_tracks(k).cost(1 : end-tracking_params.maxInvisible-1);
    lost_tracks(k).position = lost_tracks(k).position(1 : end-tracking_params.maxInvisible-1,:);
    lost_tracks(k).prediction = lost_tracks(k).prediction(1 : end-tracking_params.maxInvisible-1,:);
    lost_tracks(k).frames = lost_tracks(k).frames(1 : end-tracking_params.maxInvisible-1);
end

% compose final output array to include all tracks
tracks(length(tracks)+1:length(tracks)+length(lost_tracks)) = lost_tracks;

%delete the kalmanFilter field (no stereo-vision toolbox needed to open)
tracks = rmfield(tracks,'kalmanFilter');

end




%% local functions (do not share variables)
function tracks = initializeTracks()
% create an empty array of tracks
tracks = struct(...
    'id', {}, ...
    'kalmanFilter', {}, ...
    'age', {}, ...
    'totalVisibleCount', {}, ...
    'consecutiveInvisibleCount', {}, ...
    'frames',{}, ...
    'cost',{},...
    'prediction',{},...
    'position', {});
end

function parts3d = loadParticleData(coords3d_string, frameNo)
parts3d = dlmread(sprintf(coords3d_string,frameNo));
if size(parts3d,2) > 3
    parts3d = parts3d(:,1:3);
end
end
