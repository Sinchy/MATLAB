tic
send = 0;
% while (~exist('/home/sut210/Documents/Experiment/EXP11/Tracks/ConvergedTracks/ActiveLongTracks200.txt', 'file')) 
%     t = toc;
%     if t > 2300
%         if ~send 
%             sendemail('Message from Matlab', 'The code may possibly fail!');
%             send = 1;
%         end
%     end
% end
% sendemail('Message from Matlab', 'We got the data and start to calculate!');
active_long_tracks = ReadTracks('/home/shiyongtan/Documents/Experiment/EXP13/Tracks/ConvergedTracks/ActiveLongTracks1000.txt');
inactive_long_tracks = ReadTracks('/home/shiyongtan/Documents/Experiment/EXP13/Tracks/ConvergedTracks/InactiveLongTracks1000.txt');
exit_tracks = ReadTracks('/home/shiyongtan/Documents/Experiment/EXP11/Tracks/ConvergedTracks/exitTracks1000.txt');
tracks = [active_long_tracks; inactive_long_tracks; exit_tracks];
% [fit, correctness] = CompareTracks(LaVision_tracks, track_code, 0, 'compareresult.mat');
% meanvalue = mean(fit);
% sendemail('Message from Matlab', ['Done! The coverage percent is', num2str(meanvalue(1)) , '.']);
sendemail('Message from Matlab', 'Done!');
tracks_good = PickGoodTracks(tracks);
save('trackdata.mat', 'active_long_tracks', 'inactive_long_tracks', 'exit_tracks', 'tracks_good');