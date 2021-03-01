function vel_acc_VersionMARCC(track_dir, track)

    load([track_dir '/' track '.mat']);
    
    filterwidth = 3;
    fitwidth = 9;
    framerate = 5000;
    vel_acc_data = ashwanth_rni_vel_acc(tracks, filterwidth, fitwidth, framerate);
    clear tracks
    vel_acc_data = sortrows(vel_acc_data,4);

    vel_acc_data(:,12:14) = rem_mean(vel_acc_data, -40, 40, -40, 40, -30, 30, 10);

    % vel_acc_data: x,y,z,frame,trID,vx,vy,vz,ax,ay,az,vx',vy',vz'
    save([track_dir '/' track '_withVelAcc.mat'], 'vel_acc_data', '-v7.3');

    clear vel_acc_data
    
end

