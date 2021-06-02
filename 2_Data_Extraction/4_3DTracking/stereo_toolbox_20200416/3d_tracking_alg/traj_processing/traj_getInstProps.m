function [ inst_props, total_mean, total_median, inst_means, inst_medians ] = traj_getInstProps( hilbert_result, doShow )
% This function uses the result of traj_hilbert.m and extracts the instantaneous 
% frequencies and amplitudes
%
% hilbert_result:     output of traj_hilbert.m
% doShow:           if not empty, show a plot of the frequencies and
%                   amplitudes

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

% inputs
if nargin < 2; doShow = 0; end

%#ok<*AGROW>


% collect (all) hilbert_data
for k = 1:size(hilbert_result,1)
    inst_props(k).inst_freq = hilbert_result{k}(:,7);
    inst_props(k).inst_ampl = hilbert_result{k}(:,4);
    inst_props(k).inst_phase = hilbert_result{k}(:,5);
    inst_props(k).inst_phaseConv = hilbert_result{k}(:,6);
end

% compute mean resp. median for each trajectory
for k = 1:size(hilbert_result,1)
    inst_means(k) = structfun(@mean, inst_props(k), 'UniformOutput', 0);
    inst_medians(k) = structfun(@median, inst_props(k), 'UniformOutput', 0);
end

% compute total means (over all trajectories)
total_mean.freq = mean([inst_means(:).inst_freq]);
total_mean.ampl = mean([inst_means(:).inst_ampl]);

total_median.freq = median([inst_medians(:).inst_freq]);
total_median.ampl = median([inst_medians(:).inst_ampl]);

% plot if desired
if doShow
    figure; title('Hilbert Transform Properties')
    subplot(2,1,1); hold on;
    plot([inst_means(:).inst_freq],'-b', 'LineWidth', 2); grid on; box on;
    plot([inst_medians(:).inst_freq],'-.b', 'LineWidth', 2);
    legend('Mean Frequency', 'Median Frequency');
    subplot(2,1,2); hold on;
    plot([inst_means(:).inst_ampl],'-r', 'LineWidth', 2); grid on; box on;
    plot([inst_medians(:).inst_ampl],'-.r', 'LineWidth', 2);
    legend('Mean Amplitude', 'Median Amplitude');
end
    
    
end
