function robustSpline_3DTrackFit_V2(track3D_isolated, tr_images, tr1, tr2, tr3, tr4, camParaCalib, trck_minSize, cam)
clear Fit3D

    [a,b] = histc(track3D_isolated(:,5),unique(track3D_isolated(:,5)));
    y = a(b)>=trck_minSize;
    track3D_isolated = track3D_isolated(y,:);
    [a,b] = histc(track3D_isolated(:,6),unique(track3D_isolated(:,6)));
    y = a(b)>=trck_minSize;
    track3D_isolated = track3D_isolated(y,:);
    [a,b] = histc(track3D_isolated(:,7),unique(track3D_isolated(:,7)));
    y = a(b)>=trck_minSize;
    track3D_isolated = track3D_isolated(y,:);
    
%     [a,b] = histc(track3D_isolated(:,5),unique(track3D_isolated(:,5)));
%     y = a(b)>=trck_minSize;
%     track3D_isolated = track3D_isolated(y,:);
%     [a,b] = histc(track3D_isolated(:,6),unique(track3D_isolated(:,6)));
%     y = a(b)>=trck_minSize;
%     track3D_isolated = track3D_isolated(y,:);
%     [a,b] = histc(track3D_isolated(:,7),unique(track3D_isolated(:,7)));
%     y = a(b)>=trck_minSize;
%     track3D_isolated = track3D_isolated(y,:);
    
rep = 1;
while (rep <=2)
    f = isoutlier(track3D_isolated(:,1:3),'movmedian',15);
    ind1 = find(f(:,1) == 1); ind2 = find(f(:,2) == 1); ind3 = find(f(:,3) == 1);
    ind = unique(reshape([ind1;ind2;ind3],1,[]),'stable');
    track3D_isolated_rob = track3D_isolated;
    track3D_isolated_rob(ind,:) = [];

    track3D_isolated_rob = sortrows(track3D_isolated_rob,8);
    
    [a,b] = histc(track3D_isolated_rob(:,4),unique(track3D_isolated_rob(:,4)));
    y = a(b)>=trck_minSize;
    track3D_isolated_rob = track3D_isolated_rob(y,:);
    [a,b] = histc(track3D_isolated_rob(:,5),unique(track3D_isolated_rob(:,5)));
    y = a(b)>=trck_minSize;
    track3D_isolated_rob = track3D_isolated_rob(y,:);
    [a,b] = histc(track3D_isolated_rob(:,6),unique(track3D_isolated_rob(:,6)));
    y = a(b)>=trck_minSize;
    track3D_isolated_rob = track3D_isolated_rob(y,:);
    [a,b] = histc(track3D_isolated_rob(:,7),unique(track3D_isolated_rob(:,7)));
    y = a(b)>=trck_minSize;
    track3D_isolated_rob = track3D_isolated_rob(y,:);
    rep = rep + 1;
end   
    
    tReal = track3D_isolated_rob(:,8);
    xReal = track3D_isolated_rob(:,1);
    yReal = track3D_isolated_rob(:,2);
    zReal = track3D_isolated_rob(:,3);

    tFill = min(tReal):max(tReal);

    % xSpline = fit(xReal,tReal,'smoothingspline','SmoothingParam',0.8);
    % ySpline = fit(yReal,tReal,'smoothingspline');
    % zSpline = fit(zReal,tReal,'smoothingspline');
    
    if (numel(tReal > 0))
        xSpline = splinefit(tReal,xReal,8,4,'r', 0.9);
        ySpline = splinefit(tReal,yReal,8,4,'r', 0.9);
        zSpline = splinefit(tReal,zReal,8,4,'r', 0.9);

        Fit3D(:,1) = ppval(xSpline,tFill);
        Fit3D(:,2) = ppval(ySpline,tFill);
        Fit3D(:,3) = ppval(zSpline,tFill);

    %     plot3(track3D_isolated(:,1),track3D_isolated(:,2),track3D_isolated(:,3),'b.')
        plot3(track3D_isolated_rob(:,1),track3D_isolated_rob(:,2),track3D_isolated_rob(:,3),'b.',...
        Fit3D(:,1), Fit3D(:,2), Fit3D(:,3), 'r.-' )
        view([-110,20]);
        hold on; plot3(Fit3D(:,1),Fit3D(:,2),Fit3D(:,3),'r.-')
        
        [X2D,Y2D] = Proj2d_Int(Fit3D(:,1),Fit3D(:,2),Fit3D(:,3),camParaCalib);
        figure(2)
        for cams = 1:4
            subplot(2,2,cams)
            imshow(uint8(tr_images(:,:,cams)));
            eval(['tr = tr' num2str(cams) ';']);
            hold on; 
    %         plot(tr(:,2),tr(:,3),'g.');
            plot(X2D(:,cams),Y2D(:,cams),'r.');
        end
        hold off
    end
            
    

end
    
    
    
    