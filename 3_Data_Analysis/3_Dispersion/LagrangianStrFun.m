function [L_S, L_disp_matrix] = LagrangianStrFun(data_map, pairs)
% TL = 0.45 ;
if ~exist('pairs', 'var')
    [trID, ~, ic] = unique(data_map.Data.tracks(:,5));
    trLen = accumarray(ic,1);
    
    trLen_sort = sort(trLen,'descend');
    
    num_sample = 100000;
    trLen_min = trLen_sort(num_sample);
    trLen_max = trLen_sort(1);
    
    trID_sample = trID(trLen >= trLen_min);
    num_sample = length(trID_sample);
    
%     trID_long = trID(trLen > 1 * round(TL*4000));
%     trID_sample = trID_long;
%     num_sample = length(trID_long);
%     if num_sample > 3000
%         num_sample = 3000;
%         trID_sample = randsample(trID_long, num_sample);
%     end
else
    trID_sample = unique([pairs(:,1), pairs(:,2)]);
    num_sample = length(trID_sample);
end

tracks = GetSpecificTracksFromData(data_map, trID_sample);
L_disp_matrix = zeros(num_sample, trLen_max);
f = waitbar(0,'Please wait...');
for i = 1 : num_sample
   track1 = tracks(tracks(:, 5) == trID_sample(i), :);
   trlen = size(track1,1);
%    if trlen > 10 * round(TL*4000)
%        trlen = 10 * round(TL*4000);
%    end
   L_disp_matrix(i, 1:trlen-1 ) = (vecnorm(track1(2:trlen, 6:8) - track1(1, 6:8), 2, 2) / 1e3) .^ 2;
   waitbar(i/num_sample, f, 'processing...');
   
end

L_S = mean(L_disp_matrix);

end

