function [data, mean_data] = ashwanth_rni_vel_acc_with_pick_tracks(datapath, filterwidth, fitwidth, framerate, frame_range)
    %filterwidth = 1.5; fitwidth = 2; % parameters for the differentiation kernel
    % data format or3d: x,y,z,frame,id
    % output filter_data: x,y,z,frame,id,u,v,w,ax,ay,az
    or3d = ReadAllTracks(datapath);

    if exist('frame_range', 'var')
        or3d = or3d(ismember(or3d(:, 5),or3d(or3d(:, 4) > frame_range(1) & or3d(:,4) < frame_range(2), 5)), :);
    end
    
    or3d(:, 5) = or3d(:, 5) + 1; % make the index of tracks start from 1
    [c,~,~]=unique(or3d(:,5));
    num_tracks = length(c);
    view_size = max(or3d(:,1)) - min(or3d(:,1));
    std_error = view_size / 1000;
   
    fileID = fopen([datapath 'data_raw.mat'], 'w');
    fwrite(fileID, or3d, 'double'); % save the data
    fclose(fileID); 
    [row, col] = size(or3d);
    or3d = []; % clear the data
    % map a variable is to save memory and enable to get more workers for
    % parallelization
     or3d_map = memmapfile([datapath 'data_raw.mat'], 'Format',{'double',[row, col],'tracks'}); 
%     pointer=1;
%     filter_data=zeros(length(or3d),11);
%         or3d_constant = parallel.pool.Constant(or3d);
       
       % display progress of loop
     addpath SoundZone_Tools-master;
     fprintf('\t Completion for calculating the velocity and acceleration: ');
     showTimeToCompletion; startTime=tic;
     percent = parfor_progress(num_tracks);
     error = zeros(1, num_tracks);

    delete_index = zeros(1, num_tracks);
    filter_data_package = cell(num_tracks, 1);
    if num_tracks > 1000, num_good = 1000; else num_good = ceil(num_tracks * .1); end
    no_good = floor(num_good * .8);
    error_good = zeros(1, no_good); % use the error from good tracks to calculate the standard error to pick good tracks
    % usually tracks from the beginning are good tracks (active long tracks)
    good_no = 0;
    %% get the std_error
    for i=1 : num_good   
        % display progress of loop

%         percent = parfor_progress;
%         showTimeToCompletion( percent/100, [], [], startTime );

        tracks = or3d_map.Data.tracks(or3d_map.Data.tracks(:,5) == c(i),:);
%          tracks = GetTracks(datapath, c(i));
        
        % get the track data for the ith track
        
        if size(tracks,1)<=(2*fitwidth+1)
            delete_index(1, i) = 1;
            error(i) = inf;
            continue;
        end
        
        % define the convolution kernel
%         Av = 1.0/(0.5*filterwidth^2 * ...
%             (sqrt(pi)*filterwidth*erf(fitwidth/filterwidth) - ...
%             2*fitwidth*exp(-fitwidth^2/filterwidth^2)));


        % position kernel
        fitl = 1:fitwidth;
        Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
        rkernel = -fitwidth:fitwidth;
        rkernel = Av.*exp(-rkernel.^2./filterwidth^2);

        
        % velocity kernel


        fitl = 1:fitwidth;
        Av = 1./(2.*sum((fitl.*fitl).*exp(-(fitl.*fitl)./filterwidth^2)));
        vkernel = -fitwidth:fitwidth;
        vkernel = Av.*vkernel.*exp(-vkernel.^2./filterwidth^2);
        
        
        % acceleration kernel
        w = filterwidth;
        rwsq = 1./(w^2);
        coef = 2.*rwsq./(sqrt(pi).*w);
        
        fitl = -fitwidth:fitwidth;
        sumtsq = sum(fitl.*fitl);
        sumk = sum(coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));
        sumktsq = sum(fitl.*fitl.*coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));

        A = 2./(sumktsq - sumk.*sumtsq./(2*fitwidth));
        B = -A.*sumk./(2*fitwidth);
        
        
        akernel = -fitwidth:fitwidth;
        akernel = A.*coef.*(2.*akernel.^2.*rwsq-1)./exp(akernel.^2.*rwsq)+B;
        
        
                % loop over tracks
                
        x1 = conv(tracks(:,1),rkernel,'valid');
        y1 = conv(tracks(:,2),rkernel,'valid');
        z1 = conv(tracks(:,3),rkernel,'valid');
        xtmp = [x1,y1,z1];
        
        error0 = zeros(1, 3);
        for j = 1 : 3
            error0(j) = mean(abs(xtmp(:, j) - tracks(fitwidth + 1:end-fitwidth, j)));
        end
        error(i) = norm(error0);
        
        if error(i) > std_error 
            delete_index(1, i) = 1;
            error(i) = inf;
            continue;
        end
        
        good_no = good_no + 1;
        error_good(good_no) = error(i);
        
        if good_no > no_good
            average_error = mean(error_good);
            deviate_error = std(error_good);
            std_error = average_error + 3 * deviate_error;
        end
        
        u1 = -conv(tracks(:,1),vkernel,'valid');
        v1 = -conv(tracks(:,2),vkernel,'valid');
        w1 = -conv(tracks(:,3),vkernel,'valid');
        utmp = [u1,v1,w1];
        
        ax = conv(tracks(:,1),akernel,'valid');
        ay = conv(tracks(:,2),akernel,'valid');
        az = conv(tracks(:,3),akernel,'valid');
        atmp = [ax,ay,az];
               
%         
%         x(pointer:pointer+size(xtmp,1)-1,:)=xtmp;
%         u(pointer:pointer+size(xtmp,1)-1,:)=utmp.*framerate;
%         a(pointer:pointer+size(xtmp,1)-1,:)=atmp.*framerate.*framerate;
%         
        
%         filter_data(pointer:pointer+size(u1,1)-1,:)=[xtmp,tracks(fitwidth+1:end-fitwidth,4:5),utmp.*framerate,atmp.*framerate.*framerate];
     
%         pointer=pointer+size(xtmp,1);

% use struct variable to make data sliced and processible by parfor
        filter_data_package{i, 1} = [xtmp,tracks(fitwidth+1:end-fitwidth,4:5),utmp.*framerate,atmp.*framerate.*framerate];
         
    end
    
    %%
        parfor i= num_good + 1 : num_tracks   
        % display progress of loop

        percent = parfor_progress;
        showTimeToCompletion( percent/100, [], [], startTime );

        tracks = or3d_map.Data.tracks(or3d_map.Data.tracks(:,5) == c(i),:);
%          tracks = GetTracks(datapath, c(i));
        
        % get the track data for the ith track
        
        if size(tracks,1)<=(2*fitwidth+1)
            delete_index(1, i) = 1;
            error(i) = inf;
            continue;
        end
        
        % define the convolution kernel
%         Av = 1.0/(0.5*filterwidth^2 * ...
%             (sqrt(pi)*filterwidth*erf(fitwidth/filterwidth) - ...
%             2*fitwidth*exp(-fitwidth^2/filterwidth^2)));


        % position kernel
        fitl = 1:fitwidth;
        Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
        rkernel = -fitwidth:fitwidth;
        rkernel = Av.*exp(-rkernel.^2./filterwidth^2);

        
        % velocity kernel


        fitl = 1:fitwidth;
        Av = 1./(2.*sum((fitl.*fitl).*exp(-(fitl.*fitl)./filterwidth^2)));
        vkernel = -fitwidth:fitwidth;
        vkernel = Av.*vkernel.*exp(-vkernel.^2./filterwidth^2);
        
        
        % acceleration kernel
        w = filterwidth;
        rwsq = 1./(w^2);
        coef = 2.*rwsq./(sqrt(pi).*w);
        
        fitl = -fitwidth:fitwidth;
        sumtsq = sum(fitl.*fitl);
        sumk = sum(coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));
        sumktsq = sum(fitl.*fitl.*coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));

        A = 2./(sumktsq - sumk.*sumtsq./(2*fitwidth));
        B = -A.*sumk./(2*fitwidth);
        
        
        akernel = -fitwidth:fitwidth;
        akernel = A.*coef.*(2.*akernel.^2.*rwsq-1)./exp(akernel.^2.*rwsq)+B;
        
        
                % loop over tracks
                
        x1 = conv(tracks(:,1),rkernel,'valid');
        y1 = conv(tracks(:,2),rkernel,'valid');
        z1 = conv(tracks(:,3),rkernel,'valid');
        xtmp = [x1,y1,z1];
        
        error0 = zeros(1, 3);
        for j = 1 : 3
            error0(j) = mean(abs(xtmp(:, j) - tracks(fitwidth + 1:end-fitwidth, j)));
        end
        error(i) = norm(error0);
        
        if error(i) > std_error 
            delete_index(1, i) = 1;
            error(i) = inf;
            continue;
        end
        
        u1 = -conv(tracks(:,1),vkernel,'valid');
        v1 = -conv(tracks(:,2),vkernel,'valid');
        w1 = -conv(tracks(:,3),vkernel,'valid');
        utmp = [u1,v1,w1];
        
        ax = conv(tracks(:,1),akernel,'valid');
        ay = conv(tracks(:,2),akernel,'valid');
        az = conv(tracks(:,3),akernel,'valid');
        atmp = [ax,ay,az];
               
%         
%         x(pointer:pointer+size(xtmp,1)-1,:)=xtmp;
%         u(pointer:pointer+size(xtmp,1)-1,:)=utmp.*framerate;
%         a(pointer:pointer+size(xtmp,1)-1,:)=atmp.*framerate.*framerate;
%         
        
%         filter_data(pointer:pointer+size(u1,1)-1,:)=[xtmp,tracks(fitwidth+1:end-fitwidth,4:5),utmp.*framerate,atmp.*framerate.*framerate];
     
%         pointer=pointer+size(xtmp,1);

% use struct variable to make data sliced and processible by parfor
        filter_data_package{i, 1} = [xtmp,tracks(fitwidth+1:end-fitwidth,4:5),utmp.*framerate,atmp.*framerate.*framerate];
         
        end
    
        save([datapath 'error.mat'], 'error', '-v7.3')
    parfor_progress(0);
   
    data = cell2mat(filter_data_package);
    clear filter_data_parckage;
    or3d = or3d_map.Data.tracks;
    or3d(ismember(or3d(:, 5), c(delete_index(1, :) == 1)), :) = []; % delete bad tracks
    
    save([datapath 'tracks.mat'], 'or3d', '-v7.3');
    
    data(isnan(data(:,4)),:)=[];
    
    data = sortrows(data,4);
%     save('filter_data.mat', 'filter_data');

    % filter_data: x,y,z,frame,trID,vx,vy,vz,ax,ay,az,vx',vy',vz'
    x_lo = floor(min(or3d(:,1))); x_up = ceil(max(or3d(:,1)));
    y_lo = floor(min(or3d(:,2))); y_up = ceil(max(or3d(:,2)));
    z_lo = floor(min(or3d(:,3))); z_up = ceil(max(or3d(:,3)));
    [data(:,12:14), mean_data] = rem_mean(data, x_lo, x_up, y_lo, y_up, z_lo, z_up, 10);
    
    save([datapath 'filter_data.mat'], 'data', '-v7.3');
    save([datapath 'mean_data.mat'], 'mean_data', '-v7.3');
end

function track = GetTracks(tracks, track_no)
num_particles = length(tracks);
% get the track data for the ith track
    for j = 1 : num_particles
        start = j;
        num_element = 0;
        while start + num_element <= num_particles && tracks(start + num_element, 5) == track_no
            num_element = num_element + 1;
        end
        if num_element > 0 
            track = tracks(start : start + num_element - 1, :);
            break;
        end
    end
end
