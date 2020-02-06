function [R, disp_matrix] = BubbleTracerPairDispersion(bubble_info, bubble_tracks, bubble_tracer_pair, tracer_tracks, initial_separation)
num_bb = size(bubble_tracer_pair, 1);

[~, ~, ic] = unique(bubble_info(:,1));
bb_tr_len = accumarray(ic, 1);
max_bb_len = max(bb_tr_len);

disp_matrix = cell(num_bb, 1);
for i = 1 : num_bb
   bb_tr_pair = bubble_tracer_pair{i};
   bb_id = bb_tr_pair(1, 2); 
   bb_tr = bubble_tracks(bubble_info(:, 1) == bb_id, :);
   len_bb = size(bb_tr, 1);
   frame_st = bb_tr(1, 4);
   frame_end = bb_tr(end, 4);
   
   tracer_id = unique(bb_tr_pair(:, 3));
   data_id = bb_tr_pair(1, 1);
   tracer_tr = tracer_tracks{i};
   tracer_tr(tracer_tr(:,4) < frame_st | tracer_tr(:,4) > frame_end, :) = [];
   num_tr = size(tracer_id, 1);
   disp = zeros(num_tr, max_bb_len);
   for j = 1 : num_tr
      tr_tr = tracer_tr(tracer_tr(:, 5) == tracer_id(j), :);
      if exist('initial_separation', 'var')
          %check the initial separation
          IS = norm(tr_tr(1, 1:3) - bb_tr(1, 1:3), 2);
          if IS < initial_separation(1) || IS > initial_separation(2)
             continue; 
          end
      end
      len_tr = size(tr_tr, 1);
      len = min(len_tr, len_bb);
      dp = tr_tr(1:len, 1:3) - bb_tr(1:len, 1:3);
      dp = dp - dp(1, 1:3);
      disp(j, 1:len - 1) = vecnorm(dp(2:end, :), 2, 2);
   end
   disp_matrix{i} = disp;
end
disp_matrix = disp_matrix(~cellfun('isempty',disp_matrix)); % delete empty disp
disp_matrix = cell2mat(disp_matrix);
R = zeros(max_bb_len, 1);
for i = 1 : max_bb_len
    disp = nonzeros(disp_matrix(:, i));
    if ~isempty(disp)
        R(i) = mean(disp);
    end
end
R = nonzeros(R);
end

