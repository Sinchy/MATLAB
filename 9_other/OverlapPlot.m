figure;
for  i = 1 : 9
    subplot(3,3,i);
    Overlapandcheck('/home/tanshiyong/Documents/Data/Single-Phase/11.03.17/SyntheticData_HighVel/',data_lost_cd, 4, '/home/tanshiyong/Documents/Data/Single-Phase/11.03.17/SyntheticData/VSC_Calib_11.03.17.mat', [i*200 i*200 + 100]);
end
