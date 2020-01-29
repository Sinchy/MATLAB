% load('view_volume.mat')
figure
% a=read_gdf('tracks_0.1thresh.gdf');
% ind = find(a(:,6) == 0);
% a(ind,:) = [];
% scatter3(a(:,2),a(:,3),a(:,4),'b.')
% hold on
scatter3(vertices(1:100:end,1),vertices(1:100:end,2),vertices(1:100:end,3),'r*')
axis equal