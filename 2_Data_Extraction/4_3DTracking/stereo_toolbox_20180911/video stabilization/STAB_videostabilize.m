function[ motion, stable ] = STAB_videostabilize( roi, L, image_in, use_frames,  videos_out, show_plot, image_out )
% This function stabilizes a given video-sequence and creates two videos.
%
%  roi:        Region-of-Interest given as binary image. e.g.: ones(480,640)
%  L:          Level of Gaussian-Pyramides (approx allowed jump-length). Recommended is 2.
%  image_in:   sprint-readable image names.
%  use_frames: Specifies frames to be used. e.g.: [1:200].
%  videos_out: avi filename (sprintf redable) string to output videos.
%              a '%s' argument is needed to add 'SUM' and 'NEXT' to the filename.
%  show_plot:  1 enables plot, others disable graphical output
%  image_out:  sprint-readable image output path. All input parameters have
%              to be given to enable image output. 
%
%  All involved functions (STAB_*) are taken from: "Video Stabilization and
%  Enhancement" by Hany Farid and Feffrey B. Woodward
%
%  Example Usage:
%  [ motion, stable ] = STAB_videostabilize( ones(480,640), 2, './CAM2/stream10/image_%05d.bmp' , [2445: 3000], './stream10_%s.avi', 1, './CAM2/stream10/stab/image_%05d.bmp );

if nargin<7, image_out = [];  end
if nargin<5, videos_out = []; end
if nargin<6
    if ischar(videos_out)
        show_plot=0;
    else
        show_plot=videos_out;
        videos_out=[];
    end
end

%% load image sequence
% fprintf(1,'\nLoading image sequence...');
% 
% for k = use_frames
%     frames(k-use_frames(1)+1).im = imread(sprintf(image_in,k));
%     frames(k-use_frames(1)+1).im = double(  frames(k-use_frames(1)+1).im(:,:,1)  );
% end
% 
% N = length( frames );
% roiorig = roi;
% fprintf(1,'                 [ done ]\n');
roiorig = roi;
N = length(use_frames);

%% ESTIMATE PAIRWISE MOTION
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
T_collection = zeros(2,N-1);
stable(1).roi = roiorig;
fprintf(1,'Optical flow estimation Im.no. ');
for k = use_frames(1:end-1)
    fprintf(1,'%05d',k);
    
    frame_k = imread(sprintf(image_in,k));
    frame_k = double(frame_k(:,:,1));
    frame_kp1 = imread(sprintf(image_in,k+1));
    frame_kp1 = double(frame_kp1(:,:,1));
    
    [A,T] = STAB_opticalflow( frame_kp1, frame_k, roi, L );
    motion(k).A = A;
    motion(k).T = T;
    [Acum,Tcum] = STAB_accumulatewarp( Acum, Tcum, A, T );
    T_collection(:,k) = Tcum;
    roi = STAB_warp( roiorig, Acum, Tcum );
    fprintf(1,'\b\b\b\b\b');
end
fprintf(1,'...        [ done ]\n');

%% Analyze overall object movement and filter for shakers 
fprintf(1,'Filtering optical flow movement...');

T_collection_savgol = sgolayfilt(T_collection', 2, 71); % Check empirically!!!!!

% show plot if demanded
if show_plot
    figure; hold on;
    title('Cummulated Detected Image Movement');
    xlabel('Image No.');
    ylabel('Image Movement [Pixels]');
    plot(T_collection(1,use_frames(1:end-1))','-b','LineWidth',1); hold on;
    plot(T_collection(2,use_frames(1:end-1))','-r','LineWidth',1)
    plot(T_collection_savgol(use_frames(1:end-1),1),'--b','LineWidth',1);
    plot(T_collection_savgol(use_frames(1:end-1),2),'--r','LineWidth',1);
    legend('x-Motion unfiltered','y-Motion unfiltered','x-Motion Savitzky-Golay filtered','y-Motion Savitzky-Golay filtered', 'Location','Best');
end

% let the warps follow only the differences to sav-gol-filtered movement
T_corrected(1,:) = T_collection(1,:) - T_collection_savgol(:,1)' ;
T_corrected(2,:) = T_collection(2,:) - T_collection_savgol(:,2)' ;
fprintf(1,'        [ done ]\n');


%% STABILIZE TO LAST FRAME
%stable(N).im = frames(N).im;
frame_N = imread(sprintf(image_in,use_frames(end)));
frame_N = double(frame_N(:,:,1));
stable(N).im = frame_N;
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
fprintf(1, 'Stabilize to last frames no. ');
for k = use_frames(end-1) : -1 : use_frames(1)
    motion(k).T = T_corrected(:,k); % comment for original use
    fprintf(1,'%05d',k);
    [Acum,Tcum] = STAB_accumulatewarp( Acum, Tcum, motion(k).A, motion(k).T );
    
    %stable(k).im = STAB_warp( frames(k).im, Acum, Tcum );
    frame_k = imread(sprintf(image_in,k));
    frame_k = double(frame_k(:,:,1));
    %stable(k).im = STAB_warp( frame_k, Acum, Tcum );
    stable = STAB_warp( frame_k, Acum, Tcum );
    
    %write to image if demanded
    if image_out
        stable  = uint8(stable) ;
        stable(stable<0)=0;
        stable(stable>255)=255;
        stable(:,:,2)=stable(:,:,1);
        stable(:,:,3)=stable(:,:,1);
        imwrite(stable , sprintf(image_out,k),'bmp');
    end
    
    fprintf(1,'\b\b\b\b\b');
end
fprintf(1,'...          [ done ]\n');


if image_out
    fprintf(1,'Saving stabilized images as *.bmp...');
    fprintf(1,'      [ done ]\n\n');
else
    fprintf(1,'      [  off ]\n\n');
end



%% AVI-Video creation
fprintf(1,'Creating AVI-Movies...');
if ~(isempty(videos_out))

    for k = use_frames(1:end-1)
        orig = imread(sprintf(image_in,k));
        orig = double(orig(:,:,1)) ./255;
        stable = imread(sprintf(image_out,k));
        stable = double(stable(:,:,1));
        stable(stable<0)=0;
        stable(stable>255)=255;
        stable = stable ./255;

        % create alligned image frame (next to eachother) 
        merged = [orig stable];
        merged(:,:,2) = merged(:,:,1);
        merged(:,:,3) = merged(:,:,1);
        mov(k-use_frames(1)+1) = im2frame(merged);
        
        % create overlayed image frame to detect erroneous shift
        added = orig + stable;
        added = added ./2;
        added(:,:,2) = added(:,:,1);
        added(:,:,3) = added(:,:,1);
        mov_added(k-use_frames(1)+1) = im2frame(added);
    end
    
    % create (unkompressed) avimovies from frames
    movie2avi(mov,sprintf(videos_out,'NEXT'));
    movie2avi(mov_added,sprintf(videos_out,'ADD'));
    fprintf(1,'                    [ done ]\n');
else
    fprintf(1,'                    [  off ]\n');
end
