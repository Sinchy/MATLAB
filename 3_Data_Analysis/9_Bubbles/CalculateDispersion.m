%% 
addpath D:\0.Code\MATLAB\3_Data_Analysis\3_Dispersion

%%  get the tracks with radius within 0.1~0.2mm
trID = r_mm(r_mm(:,2) >= 0.1 & r_mm(:, 2) <= .2, :);
tracks = tracks(ismember(tracks(:,5), trID), :);

%% other parameters
disp_rate = 0.09;
r_mean = mean(r_mm(r_mm(:,2) > 0.1 & r_mm(:,2) < 0.2 , 2));
bin = [1 5; 5 10; 10 20; 40 50; 90 100] * r_mean / 1e3; 
%%
save('C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\results\Dispersion\tracks_0.1_0.2mm.mat', 'tracks');

%% search pairs
CSearchPairs('C:\Users\ShiyongTan\Documents\Data_processing\20220204\T3\results\Dispersion\tracks_0.1_0.2mm.mat', bin, disp_rate, 5000, 1000);

%% 
[R_f, pairs_f, disp_matrix_f, IS_f, veldiff_matrix_f, veldiff_pl_matrix_f, sep_matrix_f] = PairDispersionCalculation(tracks, pairs, 50, 0);