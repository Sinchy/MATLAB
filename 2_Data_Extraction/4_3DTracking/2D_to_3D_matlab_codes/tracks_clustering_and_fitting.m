function tracks_cluster = tracks_clustering_and_fitting(track3D)
    
% clustering the tracks into 
if numel(track3D > 0)
    tr = unique(track3D(:,4:7),'rows');
    tracks_cluster = cell(1,size(tr,1));
    for i = 1:size(tr,1)
        ind1 = find(ismember(track3D(:,4:7),tr(i,:),'rows'));
        tracks_cluster{i} = track3D(ind1,:);
    end
end

temp_cluster = tracks_cluster;

for i = 1:numel(temp_cluster)
    frame(i) = min(temp_cluster{i}(:,8));
end
[~,ind1] = min(frame);
track1 = temp_cluster{ind1};

for count = 1:numel(frame)-1
    frame(ind1) = max(frame) + 1;
    [~,ind2] = min(frame);
    frame(ind2) = max(frame) + 1;
    track2 = temp_cluster{ind2};
    clear real
    real(:,1:4) = [track1(:,[1:3 8]);track2(:,[1:3 8])];
    RobustSplineFit(real)
end

end


function RobustSplineFit(real)
        xSpline = splinefit(real(:,4),real(:,1),8,4,'r', 0.9);
        ySpline = splinefit(real(:,4),real(:,2),8,4,'r', 0.9);
        zSpline = splinefit(real(:,4),real(:,3),8,4,'r', 0.9);

        tFill = min(real(:,4)):max(real(:,4));
        
        Fit3D(:,1) = ppval(xSpline,tFill);
        Fit3D(:,2) = ppval(ySpline,tFill);
        Fit3D(:,3) = ppval(zSpline,tFill);
        
        vel(:,1:3) = Fit3D(2:end,1:3) - Fit3D(1:end-1,1:3);
        acc(:,1:3) = vel(2:end,1:3) - vel(1:end-1,1:3);
        jerk(:,1:3) = acc(2:end,1:3) - acc(1:end-1,1:3);
        
        velx = linspace(0,1,size(vel,1)); accx = linspace(0,1,size(acc,1)); jerkx = linspace(0,1,size(jerk,1));
         
%         figure(100)
%         hold on;plot(velx, sqrt(sum(vel.^2,2))./max(sqrt(sum(vel.^2,2))),'r.-');
%         
%         figure(101)
%         hold on;plot(accx, sqrt(sum(acc.^2,2))./max(sqrt(sum(acc.^2,2))),'r.-');
%         
%         figure(102)
%         hold on;plot(jerkx, sqrt(sum(jerk.^2,2))./max(sqrt(sum(jerk.^2,2))),'r.-');
end
        
