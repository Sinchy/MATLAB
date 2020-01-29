%% finding the LaVision track missing in the 2Dto3D track
find(LaVision_tracks_long(:,3)<23.1 & LaVision_tracks_long(:,3) > 23.08 &...
    LaVision_tracks_long(:,2) < 11.67 & LaVision_tracks_long(:,2) > 11.65)


%%
tr_no = [49; 7366; 15025; 15028; 24741;];
tr_no = [23764];
tr_no = [29526];
tr_no = [254];
tr_no = [6510];
test_track = zeros(1,4);
for i = 1
    test_track = [test_track;LaVision_tracks_long(LaVision_tracks_long(:,10) == tr_no(i),[1:3 9])];
end
test_track(1,:) = [];

test_track(:,1:3) = test_track(:,[3 1 2]);
test_track(:,2) = -test_track(:,2);
test_track(:,5:6) = calibProj_Tsai(camParaCalib(1),test_track(:,1:3));
test_track(:,7:8) = calibProj_Tsai(camParaCalib(2),test_track(:,1:3));
test_track(:,9:10) = calibProj_Tsai(camParaCalib(3),test_track(:,1:3));
test_track(:,11:12) = calibProj_Tsai(camParaCalib(4),test_track(:,1:3));
%% finding the 2D tracks close to the LaVision track
test_tr2D_ID = cell(4,1);
for cam = 1:4
    test_tr2D_ID{cam} = zeros(size(test_track,1),1);
    for i = 1:size(test_track,1)
        eval(['tr = tr' num2str(cam) ';']);
        dist = pdist2(tr(:,2:3), test_track(i,2*cam+3:2*cam+4), 'euclidean');
        [~,ind] = min(dist);
        if (min(dist) < 0.2)
            test_tr2D_ID{cam}(i) = tr(ind,1);
        end
    end

    test_tr2D_ID{cam} = unique(test_tr2D_ID{cam});
end

%%
figure;
for cam = 1:4
    subplot(2,2,cam)
    eval(['tr = tr' num2str(cam) ';']);

    imshow(uint8(tr_images(:,:,cam)));
    hold on
    plot(test_track(:,2*cam+3),test_track(:,2*cam+4),'r.')


    for i = 1:size(test_tr2D_ID{cam},1)
        plot(tr(tr(:,1) == test_tr2D_ID{cam}(i),2),tr(tr(:,1) == test_tr2D_ID{cam}(i),3),'g.')
    end
end