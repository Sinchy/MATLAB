function [data_Lav, data_cd] = FindMatch(data_Lav, data_cd)
no_tracks = unique(data_Lav(:,5));
num_tracks = length(no_tracks);
fprintf('\n');
f = waitbar(0,'Please wait...');
for i = 1:num_tracks
    track = data_Lav(data_Lav(:,5) == no_tracks(i), :);
    j = min(track(:,4));
   while j < max(track(:,4))
        % find tracks that are near this track
        particles = data_cd(data_cd(:,4) == j, :);
        dist = vecnorm(particles(:, 1:3) -  track(track(:,4) == j, 1:3), 2, 2);
        candidate_index = particles(dist < 0.5, 5);
        if ~isempty(candidate_index)
            num_candidates = length(candidate_index);
            for k = 1 : num_candidates
                track_candidate = data_cd(data_cd(:,5) == candidate_index(k), :);
                % compare the velocity
                max_frame = min(max(track(:,4)), max(track_candidate(:,4)));
                min_frame = max(min(track(:,4)), min(track_candidate(:,4)));
                if sum(track_candidate(:,4) >= min_frame & track_candidate(:,4) <= max_frame) == max_frame - min_frame + 1
                    track_common_Lav = track(track(:,4) >= min_frame & track(:,4) <= max_frame, 1:3);
                    track_common_cd = track_candidate(track_candidate(:,4) >= min_frame & track_candidate(:,4) <= max_frame, 1:3);
%                     vel_Lav = track_common_Lav(1:end - 1) - track_common_Lav(2:end);
%                     vel_cd = track_common_cd(1:end - 1) - track_common_cd(2:end);
%                     vel_diff = track(track(:,4) >= min_frame & track(:,4) <= max_frame, 6) - ...
%                         track_candidate(track_candidate(:,4) >= min_frame & track_candidate(:,4) <= max_frame, 6);
%                     vel_diff = vel_Lav - vel_cd;
                    diff = vecnorm(track_common_Lav(:,1:3) - track_common_cd(:, 1:3), 2, 2);
                    mean_diff = mean(abs(diff));
                    if mean_diff < 0.5
                        % accept this candidate
                        data_Lav(data_Lav(:,5) == track(1,5) & data_Lav(:, 4) >=  min_frame & data_Lav(:, 4) <=  max_frame, 6:10) = ...
                            track_candidate(track_candidate(:,4) >= min_frame & track_candidate(:,4) <= max_frame, :);
                        data_Lav(data_Lav(:,5) == track(1,5) & data_Lav(:, 4) >=  min_frame & data_Lav(:, 4) <=  max_frame, 11) =...
                            diff;
                        data_cd(data_cd(:,5) == track_candidate(1,5) & data_cd(:, 4) >=  min_frame & data_cd(:, 4) <=  max_frame, :) = [];
                        j = max_frame;
                        break;
                    end
                end
            end
        end
        j = j + 1;
   end
   if ~mod(i, 5)
    waitbar(i/num_tracks ,f,['Processing your data: ' num2str(i/num_tracks * 100) '%']);
   end
   if ~mod(i, 1000)
       save match.mat data_Lav data_cd -v7.3;
   end
end
end