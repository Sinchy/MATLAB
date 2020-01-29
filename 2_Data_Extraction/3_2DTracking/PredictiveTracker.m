function [vtracks,ntracks,meanlength,rmslength] = PredictiveTracker(inputnames,threshold,max_disp,bground_name,minarea,invert,noisy)
% Usage: [vtracks,ntracks,meanlength,rmslength] = PredictiveTracker(inputnames,threshold,max_disp,[bground_name],[minarea],[invert],[noisy])
% Given a movie of particle motions, PredictiveTracker produces Lagrangian
% particle tracks using a predictive three-frame best-estimate algorithm.
% The movie must be saved as a series of image files, an image stack in
% .tif or .gif format, or an uncompressed .avi file; specify the movie in
% "inputnames" (e.g., '0*.png' or 'stack.tif', or 'movie.avi'). To be
% identified as a particle, a part of the image must have brightness that
% differs from the background by at least "threshold". If invert==0,
% PredictiveTracker seeks particles brighter than the background; if
% invert==1, PredictiveTracker seeks particles darker than the background;
% and if invert==-1, PredictiveTracker seeks any sort of contrast. The
% background is read from the file "bground_name"; see BackgroundImage. If
% minarea==1, PredictiveTracker seeks single-pixel particles by comparing
% brightness to adjacent pixels (fast and good for small particles);
% otherwise PredictiveTracker seeks particles having areas larger than
% "minarea" (in square pixels; this method is better for tracking large
% particles). Once identified, each particle is tracked using a kinematic
% prediction, and a track is broken when no particle lies within "max_disp"
% pixels of the predicted location. The results are returned in the
% structure "vtracks", whose fields "len", "X", "Y", "T", "U", and "V"
% contain the length, horizontal coordinates, vertical coordinates, times,
% horizontal velocities, and vertical velocities of each track,
% respectively. If minarea~=1, "vtracks" is returned with an additonal
% field, "Theta", giving the orientation of the major axis of the particle
% with respect to the x-axis, in radians. The total number of tracks is
% returned as "ntracks"; the mean and root-mean-square track lengths are
% returned in "meanlength" and "rmslength", respectively. If noisy~=0, the
% movie is repeated with overlaid velocity quivers and the tracks are
% plotted. If noisy==2, each movie frame is also saved to disk as an image.
% Requires ParticleFinder.m; also requires read_uncompressed_avi.m for use
% with .avi movies. This file can be downloaded from
% http://leviathan.eng.yale.edu/software.

% Written by Nicholas T. Ouellette September 2010. 
% Updated by Douglas H. Kelley 13 April 2011 to plot tracks. 
% Fixed bug in accounting active tracks 14 April 2011. 
% Allowed for inputnames and/or bground_name in other directory, 4 May 
% 2011. 
% Fixed minor bug providing default input parameters 27 May 2011. 
% Added movie with overlaid velocity quivers 17 August 2011. 
% Added "finder" option 18 August 2011. 
% Changed "finder" to "minarea", added "invert" option, and combined two
% plots into one 1 September 2011. 
% Enabled noisy>1 for saving a movie 2 September 2011. 
% Added "Theta" field (if minarea~=1) 7 September 2011. 
% Made compatible with uncompressed avi movies (using 
% read_uncompressed_avi.m) 19 October 2011. 
% Changed plotting method to use color and show only active tracks, 9 
% January 2012. 
% Improved compatibility with images having more than 255 grays, 10 
% January 2012. 
% Made compatible with tiff and gif stacks 13 February 2012. 
% Fixed bugs associated with frames in which no particles are found,
% 6 March 2012.
% Offloaded particle finding to ParticleFinder.m, 7 March 2012.

% -=- Set defaults -=-----------------------------------------------------
bground_name_default = 'background.tif';
noisy_default=0; % don't plot unless requested
minarea_default=1; % by default seek small particles quickly
invert_default=-1; % by default, use absolute contrast
pausetime=1/33; % seconds to pause between frames when plotting
savedirname='tracksmovie';
figsize=[101 101]; % figure width and height, in pixels
framerange=[1 inf]; % Could allow framerange as an input... 
filterwidth = 1; fitwidth = 3; % parameters for the differentiation kernel

% -=- Parse inputs -=-----------------------------------------------------
if nargin<1
    error(['Usage: [vtracks,ntracks,meanlength,rmslength] = ' mfilename ...
        '(inputnames,threshold,max_disp,[bground_name],[minarea],[invert],[noisy])'])
end
if ~exist('bground_name','var') || isempty(bground_name)
    bground_name=bground_name_default;
end
if ~exist('minarea','var') || isempty(minarea)
    minarea=minarea_default;
end
if ~exist('invert','var') || isempty(invert)
    invert=invert_default;
end
if ~exist('noisy','var') || isempty(noisy)
    noisy=noisy_default;
end

% -=- Find particles in all frames -=-------------------------------------
[x,y,t,ang]=ParticleFinder(inputnames,threshold,framerange,[], ...
    bground_name,minarea,invert,0);
[tt,ends]=unique(t);
begins=circshift(ends,[1 0])+1;
begins(1)=1;
Nf=numel(tt);
if Nf < (2*fitwidth+1)
    error(['Sorry, found too few files named ' inputnames '.'])
end

% -=- Set up struct array for tracks -=-----------------------------------
ind=begins(1):ends(1);
nparticles = numel(ind);
if minarea==1
    tracks = repmat(struct('len',[],'X',[],'Y',[],'T',[]),nparticles,1);
    for ii = 1:nparticles
        tracks(ii) = struct('len',1,'X',x(ind(ii)),'Y',y(ind(ii)),'T',1);
    end
else
    tracks = repmat(struct('len',[],'X',[],'Y',[],'T',[],'Theta',[]), ...
        nparticles,1);
    for ii = 1:nparticles
        tracks(ii) = struct('len',1,'X',x(ind(ii)),'Y',y(ind(ii)),'T',1, ...
            'Theta',ang(ind(ii)));
    end
end

% -=- Keep track of which tracks are active -=----------------------------
active = 1:nparticles;
n_active = numel(active);
disp(['Processed frame 1 of ' num2str(Nf) '.'])
disp(['    Number of particles found: ' num2str(nparticles,'%.0f')])
disp(['    Number of active tracks: ' num2str(n_active,'%.0f')])
disp(['    Total number of tracks: ' num2str(numel(tracks),'%.0f')])

% -=- Loop over frames -=-------------------------------------------------
for t = 2:Nf
    ind=begins(t):ends(t);
    nfr1 = numel(ind);
    if nfr1==0
        warning('MATLAB:PredictiveTracker:noParticles', ...
            ['Found no particles in frame ' num2str(t) '.']);
    end % if nfr1==0
    fr1=[x(ind) y(ind)];
    if minarea~=1
        ang1=ang(ind);
    end

% -=- Match the tracks with kinematic predictions -=----------------------

    % for convenience, we'll grab the relevant positions from the tracks
    now = zeros(n_active,2);
    prior = zeros(n_active,2);
    for ii = 1:n_active
        tr = tracks(active(ii));
        now(ii,1) = tr.X(end);
        now(ii,2) = tr.Y(end);
        if tr.len > 1
            prior(ii,1) = tr.X(end-1);
            prior(ii,2) = tr.Y(end-1);
        else
            prior(ii,:) = now(ii,:);
        end
    end

    % estimate a velocity for each particle in fr0
    velocity = now - prior;
    % and use kinematics to estimate a future position
    estimate = now + velocity;

    % define cost and link arrays
    costs = zeros(n_active,1);
    links = zeros(n_active,1);

    if nfr1>0
        % loop over active tracks
        for ii = 1:n_active
            % now, compare this estimated positions with particles in fr1
            dist_fr1 = (estimate(ii,1)-fr1(:,1)).^2 + (estimate(ii,2)-fr1(:,2)).^2;
            % save its cost and best match
            costs(ii) = min(dist_fr1);
            if costs(ii) > max_disp^2
                continue;
            end
            bestmatch = find(dist_fr1 == costs(ii));
            % if there is more than one best match, we are confused; stop
            if numel(bestmatch) ~= 1
                continue;
            end
            % has another track already matched to this particle?
            ind = links == bestmatch;
            if sum(ind) ~= 0
                if costs(ind) > costs(ii)
                    % this match is better
                    links(ind) = 0;
                else
                    continue;
                end
            end
            links(ii) = bestmatch;
        end

        % now attach the matched particles to their tracks
        matched = zeros(nfr1,1);
        for ii = 1:n_active
            if links(ii) ~= 0 
                % this track found a match
                tracks(active(ii)).X(end+1) = fr1(links(ii),1);
                tracks(active(ii)).Y(end+1) = fr1(links(ii),2);
                tracks(active(ii)).len = tracks(active(ii)).len + 1;
                tracks(active(ii)).T(end+1) = t;
                if minarea~=1
                    tracks(active(ii)).Theta(end+1) = ang1(links(ii));
                end
                matched(links(ii)) = 1;
            end
        end
        active = active(links~=0);

        % and start new tracks with the particles in fr1 that found no match
        unmatched = find(matched == 0);
        if minarea==1
            newtracks = repmat(struct('len',[],'X',[],'Y',[],'T',[]), ...
                numel(unmatched),1);
            for ii = 1:numel(unmatched)
                newtracks(ii) = struct('len',1,'X',fr1(unmatched(ii),1),...
                    'Y',fr1(unmatched(ii),2),'T',t);
            end
        else
            newtracks = repmat(struct('len',[],'X',[],'Y',[],'T',[], ...
                'Theta',[]),numel(unmatched),1);
            for ii = 1:numel(unmatched)
                newtracks(ii) = struct('len',1,'X',fr1(unmatched(ii),1),...
                    'Y',fr1(unmatched(ii),2),'T',t,'Theta',ang1(unmatched(ii)));
            end
        end
    else % if nfr1>0
        active=[];
        newtracks=[];
        unmatched=[];
    end
    active = [active (numel(tracks)+1):(numel(tracks)+numel(newtracks))];
    tracks = [tracks ; newtracks];
    n_active = numel(active);

    disp(['Processed frame ' num2str(t) ' of ' num2str(Nf) '.'])
    disp(['    Number of particles found: ' num2str(nfr1,'%.0f')])
    disp(['    Number of active tracks: ' num2str(n_active,'%.0f')])
    disp(['    Number of new tracks started here: ' ...
        num2str(numel(unmatched),'%.0f')])
    disp(['    Number of tracks that found no match: ' ...
        num2str(sum(links==0),'%.0f')])
    disp(['    Total number of tracks: ' num2str(numel(tracks),'%.0f')])

end

% -=- Prune tracks that are too short -=----------------------------------
disp('Pruning...');
tracks = tracks([tracks.len] >= (2*fitwidth+1));
ntracks = numel(tracks);
meanlength = mean([tracks.len]);
rmslength = sqrt(mean([tracks.len].^2));

% -=- Compute velocities -=-----------------------------------------------
disp('Differentiating...');

% define the convolution kernel
Av = 1.0/(0.5*filterwidth^2 * ...
    (sqrt(pi)*filterwidth*erf(fitwidth/filterwidth) - ...
    2*fitwidth*exp(-fitwidth^2/filterwidth^2)));
vkernel = -fitwidth:fitwidth;
vkernel = Av.*vkernel.*exp(-vkernel.^2./filterwidth^2);

% loop over tracks
if minarea==1
    vtracks = repmat(struct('len',[],'X',[],'Y',[],'T',[],'U',[],'V',[]),ntracks,1);
else
    vtracks = repmat(struct('len',[],'X',[],'Y',[],'T',[],'U',[], ...
        'V',[],'Theta',[]),ntracks,1);
end
for ii = 1:ntracks
    u = -conv(tracks(ii).X,vkernel,'valid');
    v = -conv(tracks(ii).Y,vkernel,'valid');
    if minarea==1
        vtracks(ii) = struct('len',tracks(ii).len - 2*fitwidth, ...
            'X',tracks(ii).X(fitwidth+1:end-fitwidth), ...
            'Y',tracks(ii).Y(fitwidth+1:end-fitwidth), ...
            'T',tracks(ii).T(fitwidth+1:end-fitwidth), ...
            'U',u, ...
            'V',v);
    else
        vtracks(ii) = struct('len',tracks(ii).len - 2*fitwidth, ...
            'X',tracks(ii).X(fitwidth+1:end-fitwidth), ...
            'Y',tracks(ii).Y(fitwidth+1:end-fitwidth), ...
            'T',tracks(ii).T(fitwidth+1:end-fitwidth), ...
            'U',u, ...
            'V',v, ...
            'Theta',tracks(ii).Theta(fitwidth+1:end-fitwidth));
    end
end

% -=- Plot if requested -=------------------------------------------------
if noisy
    if isnumeric(noisy) && noisy>1
        disp(['Plotting and saving frames. ' ...
            'Plese do not cover the figure window!'])
        if exist(savedirname,'file')~=7
            mkdir(savedirname)
        end
    else
        disp('Plotting...')
    end
    defaultpos=get(0,'DefaultFigurePosition');
    figure('units','pixels','position',[defaultpos(1:2) figsize]);
    axes('nextplot','add','dataaspectratio',[1 1 1],'ydir','reverse');
    title([num2str(ntracks) ' particle tracks: mean length ' ...
        num2str(meanlength) ' frames, rms length ' num2str(rmslength) ...
        ' frames'])
    xlabel([inputnames ', threshold = ' num2str(threshold) ...
        ', max_disp = ' num2str(max_disp) ', ' bground_name ...
        ', minarea = ' num2str(minarea) ', invert = ' num2str(invert)], ...
        'interpreter','none');
    [filepath,junk,ext]=fileparts(inputnames);
    names=dir(inputnames);
    if strcmpi(ext,'.avi')
        [im,mark] = read_uncompressed_avi(fullfile(filepath,names.name),1); % use mark just to keep it quiet
        im = im.cdata;
        mark=[]; % but discard mark to start over
    elseif numel(names)==1 && ( strcmpi(ext,'.tif') || ...
            strcmpi(ext,'.tiff') || strcmpi(ext,'.gif') ) % single file, looks like an image stack
        im = imread(fullfile(filepath,names.name),1);
    else
        for ii=1:Nf
            if strcmp(fullfile(filepath,names(ii).name),bground_name)
                names(ii)=[]; % don't try to track the background file
                break
            end
        end
            im = imread(fullfile(filepath,names(1).name));
    end % if strcmpi(ext,'.avi')
    hi=imagesc(im);
    xlim(0.5+[0 size(im,2)]);
    ylim(0.5+[0 size(im,1)]);
    colormap(gray); % has no effect if image is color b/c RGB values override
    colorlist=get(gca,'colororder');
    Ncolors=size(colorlist,1);
    framerange=NaN(ntracks,2);
    for jj=1:ntracks
        framerange(jj,1)=vtracks(jj).T(1);
        framerange(jj,2)=vtracks(jj).T(end);
    end
    for ii=1:Nf-fitwidth
        np=0;
        delete(findobj(gca,'type','line'))
        ind = find( (framerange(:,1)<=ii) & (framerange(:,2)>=ii) );
        for jj=1:numel(ind)
            col=colorlist(mod(ind(jj)-1,Ncolors)+1,:);
            indt=1:(ii-framerange(ind(jj),1)+1); % plot from beginning of track to current frame
            plot(vtracks(ind(jj)).X(indt),vtracks(ind(jj)).Y(indt), ...
                '-','color',col);
            np=np+1;
        end
        if strcmpi(ext,'.avi')
            [im,mark] = read_uncompressed_avi( ...
                fullfile(filepath,names.name),ii,mark);
            set(hi,'cdata',im.cdata);
            set(gcf,'name',[num2str(np) ' particles in ' names.name ...
                ' (' num2str(ii) ' of ' num2str(Nf) ')']); 
        elseif numel(names)==1 && ( strcmpi(ext,'.tif') || ...
                strcmpi(ext,'.tiff') || strcmpi(ext,'.gif') ) % single file, looks like an image stack
            set(hi,'cdata',imread(fullfile(filepath,names.name),ii)); 
            set(gcf,'name',[num2str(np) ' particles in ' names.name ...
                ' (' num2str(ii) ' of ' num2str(Nf) ')']); 
        else
            set(hi,'cdata',imread(fullfile(filepath,names(ii).name))); 
            set(gcf,'name',[num2str(np) ' particles in ' names(ii).name ...
                ' (' num2str(ii) ' of ' num2str(Nf) ')']); 
        end % if strcmpi(ext,'.avi')
        drawnow
        pause(pausetime); 
        if isnumeric(noisy) && noisy>1
            snap=getframe(gca);
            imwrite(snap.cdata, ...
                fullfile(filepath,savedirname,names(ii).name)); 
        end 
    end
end
disp('Done.')

end

