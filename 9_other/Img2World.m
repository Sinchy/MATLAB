function X3D = Img2World(camParaCalib,X2D)

    s = [size(X2D,1);size(X2D,2)];
%     X2D = [X2D zeros(s(1),1)];
    tmp = X2D.*(camParaCalib.T(3)/camParaCalib.f_eff);
    proj = [tmp(:,1) tmp(:,2) repmat(camParaCalib.T(3),[s(1) 1])]';
    X3D = camParaCalib.Rinv*(proj - camParaCalib.T);

end