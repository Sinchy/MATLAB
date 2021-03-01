clear all
close all
clc

%%%%%%%%%%%%%%%
% USER INPUTS %
%%%%%%%%%%%%%%%

if ispc == 1
    slash = '\';
else
    slash = '/';
end

path = uigetdir('','Select the folder where the files to be rearranged');
files = dir([path slash 'ProcessedData' slash '*.mat']);
% files_CamB = dir([path slash 'ProcessedData' slash 'CamB' slash '*.mat']);
% files_CamC = dir([path slash 'ProcessedData' slash 'CamC' slash '*.mat']);

FolResults = [path slash 'FilteredData'];
mkdir(FolResults);

% FolResults_CamA = [FolResults slash 'CamA'];
% mkdir(FolResults_CamA);
% FolResults_CamB = [FolResults slash 'CamB'];
% mkdir(FolResults_CamB);
% FolResults_CamC = [FolResults slash 'CamC'];
% mkdir(FolResults_CamC);

N = length(files);
fps = 8300;
mag = 10e-3/86; dt = 1/fps;

y_wall = 309; % in pix
yrelocate = 1.5*25.4e-3; % dots at 1.5 inch away from the bottom wall
% xpositionA = 67; % in pix corresponding to 40 mm in the calibration img
% xpositionB = 98; % in pix corresponding to 130 mm 
% xpositionC = 138; % in pix corresponding to 260 mm

% for the trajectory filter
mark = 0;
k = 1;
kk = 1;
threshold_tracj = 5;
threshold_acc = 1800;
filterwidth = 5;
fitwidth = 10;
%%

tstart_p = tic; % Start computing Time
wb = waitbar(0, '','Name','Filtering trajectories');

for i = 1 : N
    
    File = files(i).name;
    y_wall = 312; % in pix
    xposition = 67; % in pix corresponding to 40 mm in the calibration img
    xrelocate = 0; % 40 mm as a zero in x-axis
     
    waitbar(i/N,wb,[num2str(i),'/',num2str(N)])
    
    path2 = [path slash 'ProcessedData'];
    load([path2 slash File],'tracks');
    tracks2 = zeros(length(tracks),5);
    tracks2(:,1) = (tracks(:,2)-xposition)*mag+xrelocate;
    tracks2(:,2) = -((tracks(:,3)-y_wall)*mag-yrelocate);
    tracks2(:,4) = tracks(:,4);
    tracks2(:,5) = tracks(:,1);
    % tracks2(:,6) = tracks(:,2); tracks2(:,7) = tracks(:,3);
    
    filter_data=ashwanth_rni_vel_acc(tracks2, filterwidth, fitwidth, fps);
    [trac_filt, filter_data] = traject_filt(filter_data, threshold_tracj);
    
    [C, ia, ic] = unique(filter_data(:,5));
    filter_data2 = filter_data;
    filter_outlier = zeros(size(filter_data));
    temp = zeros(length(filter_data),1);
    
    for ii = 1 : length(ia)
        if rem(ii,kk)~=0
            mark = C(ii);
        end
        
        for j = ii : length(filter_data)
            if filter_data(j,5) == mark
                filter_data2(j,:) = nan;
            end
        end
        
    end
    
    for jj = 1 : length(filter_data2)
        if filter_data2(jj,9)>threshold_acc || filter_data2(jj,9)<-threshold_acc && filter_data2(jj,2) > 0.005
            temp(jj)=filter_data2(jj,5);
        end
    end
    
    B = unique(temp,'rows');
    
    for j = 2 : length(B)
        for jj = 1 : length(filter_data)
            if filter_data(jj,5)==B(j)
                filter_outlier(jj,:) = filter_data(jj,:);
            end
        end
    end
    filter_outlier(filter_outlier==0) = nan;
    
    filter_data3 = filter_data2;
    for j = 2 : length(B)
        for jj = 1 : length(filter_data)
            if filter_data(jj,5)==B(j)
                filter_data3(jj,:) = nan;
            end
        end
    end
    
    filter_data3(any(isnan(filter_data3),2),:) = [];
  
    save([FolResults slash 'Filtered_' File],'tracks','filter_data','filter_data3');
    
end
close(wb)

tstop_p = toc(tstart_p);
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])



%%
figure;scatter(filter_data(1:end,1),filter_data(1:end,2),40,filter_data(1:end,9),'filled');colormap jet; caxis([-100 100])

%%
figure;scatter(filter_data3(1:end,1),filter_data3(1:end,2),40,filter_data3(1:end,9),'filled');colormap jet; caxis([-100 100])