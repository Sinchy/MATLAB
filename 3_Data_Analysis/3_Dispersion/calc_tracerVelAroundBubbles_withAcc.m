% OUTPUT:
% tracer_data: 
    % each cell (bubble size) -
        % Format:
        % BID,tracer(x,y,z,fr,trID,vx,vy,vz,ax,ay,az),dataset,tracer(vx',vy',vz')

load('combined_bubbleTrackDataV4.mat');
% load('combined_bubbleTrackDataV2.mat');
load('mean_data_particles.mat');
% load('mean_data_flowmeter.mat', 'mean_vel_z');

%% Adding the rising vel to col 22 (by removing mean z vel)
tracks_all(:,22) = NaN(size(tracks_all,1),1);
for i = 1:size(mean_vel_z,1)
    dataset = mean_vel_z(i,2);
    dummy = (tracks_all(:,21) == dataset);
    tracks_all(dummy,22) = Bdata_all(dummy,8) - mean_vel_z(i,1);%(-153.75); %mean_vel_z(i,1);
end
   
Bdata_all(sum(isnan(tracks_all), 2) == 1, :) = [];
tracks_all(sum(isnan(tracks_all), 2) == 1, :) = [];

% Removing bad bubbles 
% w/ high aspect ratio
Bdata_all(tracks_all(:,9) > 5,:) = [];
tracks_all(tracks_all(:,9) > 5,:) = [];
% bubbles on the boundary
Bdata_all(tracks_all(:,12) == 0,:) = [];
tracks_all(tracks_all(:,12) == 0,:) = [];

%% conditioning of Void Fraction
Bdata_all = Bdata_all(ismember(tracks_all(:,21), datasets_highVF),:);
tracks_all = tracks_all(ismember(tracks_all(:,21), datasets_highVF),:);

%%
bins_edges = 10.^(-0.6:0.04:0.71);
% bins_edges = 10.^(log10(min(tracks_all(:,7))):0.05:log10(max(tracks_all(:,7))+0.5));
bins_AR = 1:1:5;
bubble_size = discretize(tracks_all(:,7),bins_edges);
bubble_aspectRatio = discretize(tracks_all(:,9),bins_AR);
bins_centers = (bins_edges(1:end-1) + bins_edges(2:end))./2;

% bins_centers = bins_centers(8:end);

%%
Nbubbles = 100000;
tracks = zeros(Nbubbles,22,numel(bins_centers));
Bdata = zeros(Nbubbles,11,numel(bins_centers));

for i = 4:numel(bins_centers)
    dummy = (bubble_size == i);
    tracks_dummy = tracks_all(dummy,:);
    Bdata_dummy = Bdata_all(dummy,:);
    % randomly choosing N bubbles
    if size(tracks_dummy,1) > Nbubbles
        choose = randperm(size(tracks_dummy,1),Nbubbles);
        tracks(:,:,i) = tracks_dummy(choose,:);
        Bdata(:,:,i) = Bdata_dummy(choose,:);
    else
        tracks(1:size(tracks_dummy,1),:,i) = tracks_dummy;
        Bdata(1:size(tracks_dummy,1),:,i) = Bdata_dummy;
    end
    
end
%%
datasets = unique(reshape(squeeze(tracks(:,21,:)),[Nbubbles*numel(bins_centers) 1]));
datasets(datasets == 0) = [];
tracer_data = cell(numel(bins_centers),1);
for i = 1:numel(bins_centers)
    tracer_data{i} = zeros(1,13);
end
%%
min_searchRadius = 0;
max_Particles = 1000;
% XD_searchRadius = 1.5;
path = 'C:\Users\ash4u\Desktop\Research\Bubble_Velocity\';
for d = 1:numel(datasets)
    fid = fopen([path 'particleTracks_Dir.txt']);
    linenum = datasets(d);
    C = textscan(fid,'%s',1,'delimiter','\n', 'headerlines',linenum-1);
    try
        p = load(C{1}{1});
    catch
        continue;
    end
    
    if datasets(d) < 35
        data = p.vel_acc_data;
    else
        data = p.filter_data;
    end
    
    for i = 4:numel(bins_centers)
        bub_tracks = tracks(tracks(:,21,i) == datasets(d),:,i);
        bub_Bdata = Bdata(tracks(:,21,i) == datasets(d),:,i);
        for b = 1:size(bub_tracks,1)
            tracers = data(data(:,4) == bub_Bdata(b,4),:);
            dist = vecnorm(tracers(:,1:3)-bub_tracks(b,4:6),2,2);
            
            max_dist = max(2*XD_searchRadius(i)*bub_tracks(b,7),min_searchRadius); % atleast 4mm radius (or 2*D)
            [B,I] = mink(dist,max_Particles); % get the closest 20 tracers
            if max(B) < max_dist % if they are all within max_dist from center, keep them               
                tracer_to_keep = tracers(I,:);
            else                          % else keep all particles within max_dist
                tracer_to_keep = tracers(dist<max_dist,:);
            end
            n = size(tracer_to_keep,1);
            tracer_data{i} = [tracer_data{i};[repmat(bub_tracks(b,1),[n 1]) tracer_to_keep(:,1:11) repmat(bub_tracks(b,21),[n 1])]];
        end
    end
            
end

for d = 1:numel(bins_centers)
    tracer_data{d}(sum(tracer_data{d},2)==0,:) = [];
end
    
% remove mean Vel using the velocity grid data

load('mean_data_particlesGridWise_dataWise.mat','mean_info','mean_data');
load('mean_data_flowmeter.mat','mean_vel_z');
mean_vel_z(mean_vel_z(:,2) == 0,:) = NaN;
mean_vel_z(:,2) = 1:193;
for d = 1:numel(bins_centers)
    for p = 1:size(tracer_data{d},1)
        dist = vecnorm(tracer_data{d}(p,2:4)-mean_info(:,1:3),2,2);
        [B,I] = min(dist);
        tracer_data{d}(p,14:16) = tracer_data{d}(p,7:9)-mean_info(I,4:6);
        tracer_data{d}(p,17:19) = tracer_data{d}(p,7:9)-mean_data(I,4:6,tracer_data{d}(p,13));
%         tracer_data{d}(p,17) = tracer_data{d}(p,9)-mean_vel_z(mean_vel_z(:,2) == tracer_data{d}(p,10),1);
    end
    tracer_data{d}(isnan(sum(tracer_data{d},2)),:) = [];
end
% 
% %% remove mean Vel using flowmeter
% load('mean_data_flowmeter','mean_vel_z');
% mean_vel_z(mean_vel_z(:,2) == 0,:) = NaN;
% mean_vel_z(:,2) = 1:193;
% for bin = 1:numel(bins_centers)
% %     for p = 1:size(tracer_data{d},1)
%     for d = 1:193
%        tracer_data{bin}(tracer_data{bin}(:,10) == d,17) = tracer_data{bin}(tracer_data{bin}(:,10) == d,9)-mean_vel_z(mean_vel_z(:,2) == d,1);
%     end
%     tracer_data{bin}(isnan(sum(tracer_data{bin},2)),:) = [];
% end
 %%
for d = 4:numel(bins_centers)
    M(d,1:9) = mean(tracer_data{d}(:,[7:9 14:19]));
end

% %%
% figure
% for d = 1:numel(bins_centers)
%     [h,f]=hist(tracer_data{d}(:,13),100);
%     plot(f,h./trapz(f./std(tracer_data{d}(:,13)),h),'o');
%     hold on 
%     plot([M(d,6) M(d,6)],[0 0.6],'r--','LineWidth',2.0)
%     xlim([-1500 1500])
%     pause(2)
%     hold off
% end



