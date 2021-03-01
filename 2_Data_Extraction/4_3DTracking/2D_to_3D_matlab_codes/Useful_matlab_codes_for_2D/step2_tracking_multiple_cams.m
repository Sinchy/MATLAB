%% This code takes the processed images and performs 2D tracking on the images from each camera.

% function step2_tracking_multiple_cams(dirr, totFrames, min_tracksize, thresh_2D, max_shift)

    dirr = '/home/tanshiyong/Documents/Data/Bubble/08.01.18/Run1_Bubbles/Bubbles2/Bubbles2/';
    % cam_dir = {dirr, dirr, dirr, dirr};
    cam_dir = {[dirr 'cam1/'], [dirr 'cam2/'], [dirr 'cam3/'], [dirr 'cam4/'], [dirr 'cam5/'], [dirr 'cam6/']}; 
    start_frame = 2380; end_frame = 2819;
    totFrames = end_frame - start_frame;
    min_tracksize = 6;
    thresh_2D = 5;
    max_shift = 5;

    for i = [1 2 3 4]
        [vtracks,ntracks,meanlength,rmslength] = PredictiveTracker([cam_dir{i} 'cam' num2str(i) '_' num2str(totFrames) 'frames.tif'], thresh_2D, max_shift, [dirr 'dummy_bak.tif'], 1, -1);
    %     load(['tracks_cam' num2str(i) '.mat']);
        tracks = restructure_2Dtracks(vtracks, min_tracksize);
        mkdir([dirr '/2Dtracks']);
        save([dirr '/2Dtracks/tracks_cam' num2str(i) '.mat'],'vtracks','ntracks','meanlength','rmslength','tracks'); 
        eval(['tr' num2str(i) '=tracks;']);
    end
    save( [ dirr 'all2Dtracks.mat'], 'tr1', 'tr2', 'tr3', 'tr4')

% end