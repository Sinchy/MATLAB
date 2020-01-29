function particles = GenerateCluster(pos3D, camParaCalib, overlapcam)

% get the pinhole of the camera
% cam_pos = zeros(4, 3);
% co = [0, 0, 0]';
% for i = 1 : 4
%     cam_pos(i,:) = (camParaCalib(i).R \ (co - camParaCalib(i).T))';
% end

%get the 2D centers of pos3D
X2D = zeros(4,2);
particles = zeros(9, 3);
for n = 1 : 3
    i = overlapcam(n);
    X2D(4,:) = calibProj_Tsai(camParaCalib(i), pos3D);
    % particle around the 2D center
    X2D(1,1) = X2D(4, 1) + 1; X2D(1,2) = X2D(4, 2);
    X2D(2,1) = X2D(4, 1) - 1; X2D(2,2) = X2D(4, 2) + 1;
    X2D(3,1) = X2D(4, 1) - 1; X2D(3,2) = X2D(4, 2) - 1;
    % fix the x
    x = rand(1, 3) * 10 -5;
    for j = 1 : 3
        SIpos = Img2World(camParaCalib(i), UnDistort(X2D(j,:), camParaCalib(i))); 
        % slope
        v = SIpos - camParaCalib(i).Tinv;
        %v = SIpos - cam_pos(i, :);
        t = (x(j) - SIpos(1)) / v(1);
        y = SIpos(2) + t * v(2);
        z = SIpos(3) + t * v(3);
        particles((n-1) * 3  + j, :) = [x(j) y z];
    end
end
particles = [pos3D; particles];
particles(:,4) = 1;
particles(:,5) = 1;
end

function X3D = Img2World(camParaCalib,X2D)

    s = [size(X2D,1);size(X2D,2)];
%     X2D = [X2D zeros(s(1),1)];
    tmp = X2D.*(camParaCalib.T(3)/camParaCalib.f_eff);
    proj = [tmp(:,1) tmp(:,2) repmat(camParaCalib.T(3),[s(1) 1])]';
    X3D = camParaCalib.Rinv*(proj - camParaCalib.T);

end

function x2D = UnDistort(X2D,camParaCalib) 
    
    kr = camParaCalib.k1;
    X = (X2D(:,1) - 512)*0.02;
    Y = (-X2D(:,2) + 512)*0.02;

    if (kr ~= 0)
        a = X ./ Y;

        Y = (1 - sqrt(1 - 4 .* Y.^2 .* kr.*(a.^2 + 1))) / (2.* Y.* kr.* (a.^2 + 1));
        X = a.*Y;
    end
    
    x2D = [X Y];
end