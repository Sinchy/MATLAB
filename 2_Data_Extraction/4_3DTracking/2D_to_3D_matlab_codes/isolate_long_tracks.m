[a,b]=hist(tr1(:,1),unique(tr1(:,1)));
a = a';

%%
long_trackIDs =[0 0];
for i = 200:-1:1
    ind = find(a == i);
    long_trackIDs = [long_trackIDs; a(ind) b(ind)];
end
long_trackIDs(1,:) = [];


%%

addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\';
addpath 'C:\Users\aks5577\Desktop\For_2D_tracking_test\test_2D_to_3D_lines\splinefit\';
% load_filename = {'pos3D_2D0.05_3D0.05_123_200frames_withShortTracks.mat', 'pos3D_2D0.05_3D0.05_124_200frames_withShortTracks.mat'...
%     'pos3D_2D0.05_3D0.05_134_200frames_withShortTracks.mat', 'pos3D_2D0.05_3D0.05_1234_200frames_withShortTracks.mat'};

load_filename = {'allcams_3D0.1_2D0.1_new.mat', '123cams_3D0.03_2D0.03_new.mat'...
    '124cams_3D0.03_2D0.03_new.mat', '134cams_3D0.03_2D0.03_new.mat'};

figure;

for trak = 161:200
    track3D_isolated = zeros(1,8);
    for i = 1:4
        load(load_filename{i});
        for frame = 5:196
            eval(['fr = frame' num2str(frame) ';']);
            ind = find(fr(:,4) == long_trackIDs(trak,2));
            track3D_isolated = [track3D_isolated;[fr(ind,1:7) repmat(frame,[numel(ind), 1])]];
            siz(frame-4) = sum(ind);
        end
    end
    track3D_isolated(1,:) = [];
    subplot(1,2,1)
    robustSpline_3DTrackFit(track3D_isolated, tr_images, tr1, tr2, tr3, tr4,camParaCalib, 0);
    subplot(1,2,2)
    robustSpline_3DTrackFit(track3D_isolated, tr_images, tr1, tr2, tr3, tr4,camParaCalib, 5);
    M(trak) = getframe;

end
%%
figure;
hold on
for i = 1:size(track3D_isolated,1)
    b = track3D_isolated(i,5)/max(track3D_isolated(:,5));
    c = 0;%track3D_isolated(i,6)/max(track3D_isolated(:,6));
    a = 0;
    col = [a b c];
    plot3(track3D_isolated(i,1), track3D_isolated(i,2),track3D_isolated(i,3), 'Color', col, 'Marker', '.', 'LineStyle', 'none')
end