function points = sampleVoxels(xlims, ylims, zlims, dX)
    xAx = xlims(1):dX:(xlims(2)-dX);
    yAx = ylims(1):dX:(ylims(2)-dX);
    zAx = zlims(1):dX:(zlims(2)-dX);

    % corners
    points0 = geometry_algorithm.cube3D(xAx, yAx, zAx);

    % edges
    points1 = util.rowadd(points0, [dX/2 0 0]);
    points2 = util.rowadd(points0, [0 dX/2 0]);
    points3 = util.rowadd(points0, [0 0 dX/2]);

    % faces
    points4 = util.rowadd(points0, [dX dX 0]/2);
    points5 = util.rowadd(points0, [dX 0 dX]/2);
    points6 = util.rowadd(points0, [0 dX dX]/2);

    % centers
    points7 = util.rowadd(points0, [dX dX dX]/2);
    
    points = [points0; points1; points2; points3; points4; points5; points6; points7];
    points = points+randn(size(points))*dX/6;
