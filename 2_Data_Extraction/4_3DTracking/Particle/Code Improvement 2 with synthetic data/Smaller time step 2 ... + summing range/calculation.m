
active_long_tracks = ReadTracks('/home/sut210/Documents/Experiment/EXP10/Tracks/ConvergedTracks/ActiveLongTracks150.txt');
inactive_long_tracks = ReadTracks('/home/sut210/Documents/Experiment/EXP10/Tracks/ConvergedTracks/InactiveLongTracks150.txt');
exit_tracks = ReadTracks('/home/sut210/Documents/Experiment/EXP10/Tracks/ConvergedTracks/exitTracks150.txt');
track_code = [active_long_tracks; inactive_long_tracks; exit_tracks];
[fit, correctness] = CompareTracks(track_org, track_code, 0, 'compareresult.mat');