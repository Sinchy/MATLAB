function [points2d] = projectPoints2d_distortion(points3d, cameraSystem, camNumber)

if nargin==3
    camRange = camNumber;
else
    camRange = 1:cameraSystem.nCameras;
end

if ~isempty(points3d)
    
    for camNo = camRange
        
        extr = cameraSystem.vertexList(camNo).pose;
        R = extr(1:3,1:3);
        t = extr(1:3,4);
        
        %  [R ] = rodrigues(rvec);
        %             t = tvec;
        
        gamma1 = cameraSystem.cameraCalibrations(camNo).camera.gamma1;
        gamma2 = cameraSystem.cameraCalibrations(camNo).camera.gamma2;
        s = cameraSystem.cameraCalibrations(camNo).camera.s;
        u0 = cameraSystem.cameraCalibrations(camNo).camera.u0;
        v0 = cameraSystem.cameraCalibrations(camNo).camera.v0;
        k1 = cameraSystem.cameraCalibrations(camNo).camera.k1;
        k2 = cameraSystem.cameraCalibrations(camNo).camera.k2;
        p1 = cameraSystem.cameraCalibrations(camNo).camera.p1;
        p2 = cameraSystem.cameraCalibrations(camNo).camera.p2;
        
        X = points3d';
        Xc = R * X + repmat(t, 1, size(X, 2));
        
        u = Xc ./ repmat(Xc(3, :), 3, 1);
        u = u(1:2, :);
        
        sqr_rho = u(1, :).^2 + u(2, :).^2;
        qua_rho = sqr_rho .* sqr_rho;
        
        radial_k = k1 .* sqr_rho + k2 .* qua_rho;
        du_radial = u .* repmat(radial_k, 2, 1) ;
        du_tangent = [2 .* p1 .* u(1, :) .* u(2, :) + p2 .* (sqr_rho + 2 * u(1, :).^2);
            p1 .* (sqr_rho + 2 * u(2, :).^2) + 2 * p2 .* u(1, :) .* u(2, :)];
        
        ud = u + du_radial + du_tangent;
        
        K = [gamma1, s, u0; 0, gamma2, v0; 0, 0, 1];
        ud(3, :) = 1;
        x = K * ud;
        x = x(1:2, :);
        
        points2d{camNo} = x';
    end
   
else
    for camNo = camRange
        points2d{camNo} = [];
    end
end
end

