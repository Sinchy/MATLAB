function [ part3d, clusDat ] = triangulationToCluster( settings, frameNumber, minParticlesPerCluster, clusterSize, doShow, writeToDisk )
% This function employs the clusterFromMultiset-function. By default, all
% of the differend cameraSystem permutations are given with their standard
% naming, i.e. cam123, cam132 ...
%
% This function should be used, to identify ghost-particles and get rid of
% them.
%
% doShow==1 gives a graph indicating the found particles.
% doShow==2 gives a 3d plot of the particles.
%
% implemented by: M. Himpel 2016-07-29
if doShow
    fprintf(1,'Clustering multiset-triangulation data: ');
end
%% preferences
% turn off the 'directory already exists' warning message
warning off MATLAB:MKDIR:DirectoryExists
if ~isfield(settings.triangulation, 'output3Dcoords')
    settings.triangulation.output3Dcoords = settings.output3Dcoords;
end

[pathstr,~,~] = fileparts(settings.triangulation.output3Dcoords);
if writeToDisk
    mkdir([pathstr '/clustered']);
end


% prepare the graphical output
if doShow
    figure;
    ax_hnd = axes;
    ax_hnd.XLabel.String = 'frame';
    ax_hnd.YLabel.String = 'no. of detected particles';
    ax_hnd.FontSize = 14;
    part_stats = [];
    hold on
end
%% generate cluster(-data)
partCtr = [];
for fNum = frameNumber
    %try
    if doShow
        fprintf(1,'%05d/%05d',fNum,frameNumber(end));
    end
    for k = 1:length(settings.triangulation.outputPaths)
        try
            dat{k} = dlmread(sprintf([ settings.triangulation.outputPaths{k} '/coords3d_%05d.dat'], fNum) );
            dat{k} = dat{k}(:,1:3);
        catch
            dat{k} = [];
        end
    end
        
        clusDat = vertcat(dat{:});
        
        if doShow==1 || doShow==2
            figure;
            plot3(clusDat(:,1),clusDat(:,2),clusDat(:,3),'b.'); hold on;
        end
        %% clusterize data
        clusteredData = clusterFromMultiset(clusDat, clusterSize);
        
        %% filter results
        
        % a minimum number of minParticlesPerCluster particles must belong to a cluster to form a "real"
        % particle
        existingClusterNums = unique(clusteredData(:,1));
        part3d = [];
        for idx = existingClusterNums'
            if numel(find(clusteredData(:,1)==idx)) >= minParticlesPerCluster
                % then output the mean coordinate of the custer as a particle
                part3d = [part3d ; mean( clusteredData(clusteredData(:,1)==idx , 2:4), 1  )];
            end
        end
        if doShow==2
            plot3(part3d(:,1), part3d(:,2),part3d(:,3),'ko');
            plot3(part3d(:,1), part3d(:,2),part3d(:,3),'kx');axis equal
        end
        
        
        if doShow==1
            % plot the number of detected particles
            plot_colors = parula(1);
            try delete(plot_hnd1); end
            part_stats = [part_stats size(part3d,1)];
            plot_hnd1 = plot(ax_hnd,part_stats,'Linewidth',2,'Color',plot_colors); hold on;
            ylim auto;
            ax_hnd.YLim(1) = 0;
            drawnow;
        end
        
        if writeToDisk
            dlmwrite(sprintf([pathstr '/clustered/coords3d_%05d.dat'],fNum),part3d);
        end
        partCtr = [partCtr ; fNum size(part3d,1)];
        
        if doShow
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b');
        end
   % catch
   %     warning('Error occured. Probably no particles found');
    %end
end
if doShow
    fprintf(' [ done ]\n');
end
