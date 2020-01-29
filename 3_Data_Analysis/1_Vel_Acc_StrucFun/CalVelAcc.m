function [vel_acc_data, mean_data] = CalVelAcc(datapath)
datapath = [datapath 'Tracks/ConvergedTracks/'];
tracks_raw = ReadAllTracks(datapath);
tracks_raw = tracks_raw(:,[3 4 5 2 1]);
filterwidth = 3;
fitwidth = 9;
framerate = 4000;
[vel_acc_data, mean_data] = ashwanth_rni_vel_acc(tracks_raw, filterwidth, fitwidth, framerate);
end

