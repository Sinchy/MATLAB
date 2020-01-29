function [ coord3D, repError] = triangulateFrom3Cameras(p_c1, p_c2, p_c3, P1, P2, P3)

X1 = triangulateFrom2Cameras(p_c1, p_c2, P1, P2, getFundamental(P1,P2), 0);
X2 = triangulateFrom2Cameras(p_c1, p_c3, P1, P3, getFundamental(P1,P3), 0);
X3 = triangulateFrom2Cameras(p_c2, p_c3, P2, P3, getFundamental(P2,P3), 0);

coord3D = [mean([X1(1),X2(1),X3(1)]) mean([X1(2),X2(2),X3(2)]) mean([X1(3),X2(3),X3(3)])  ];

if nargout>1
    % get the reprojection error vectors to compute disparity map
    p_c1_re = P1*[coord3D 1]'; p_c1_re = p_c1_re./p_c1_re(3);
    p_c2_re = P2*[coord3D 1]'; p_c2_re = p_c2_re./p_c2_re(3);
    p_c3_re = P3*[coord3D 1]'; p_c3_re = p_c3_re./p_c3_re(3);
    repError.cam1.x = p_c1_re(1)-p_c1(1);
    repError.cam1.y = p_c1_re(2)-p_c1(2);
    repError.cam2.x = p_c2_re(1)-p_c2(1);
    repError.cam2.y = p_c2_re(2)-p_c2(2);
    repError.cam3.x = p_c3_re(1)-p_c3(1);
    repError.cam3.y = p_c3_re(2)-p_c3(2);
end

end

