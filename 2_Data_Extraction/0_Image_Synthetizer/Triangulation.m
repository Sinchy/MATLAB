function [position3D, error] = Triangulation(camParaCalib, position2D) 
A = zeros(3, 3);
B = zeros(3, 1);
D = 0;
for i = 1 : 4
    % get the world position of the point on the image
    SIpos = Img2World(camParaCalib(i), UnDistort(position2D((i - 1) * 2 + 1 : (i - 1) * 2 + 2), camParaCalib(i))); 
    % get the vector 
    sight = SIpos - camParaCalib(i).Tinv;
    sight = sight / norm(sight); 
    C = eye(3) - sight *  sight';
    A = A + C;
    B = B + C * camParaCalib(i).Tinv;
    D = D + camParaCalib(i).Tinv' * C * camParaCalib(i).Tinv;
end
position3D = A \ B;
error = (position3D' * A * position3D - 2 * position3D' * B + D) ^ .5 / 4;
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

function X3D = Img2World(camParaCalib,X2D)

    s = [size(X2D,1);size(X2D,2)];
%     X2D = [X2D zeros(s(1),1)];
    tmp = X2D.*(camParaCalib.T(3)/camParaCalib.f_eff);
    proj = [tmp(:,1) tmp(:,2) repmat(camParaCalib.T(3),[s(1) 1])]';
    X3D = camParaCalib.Rinv*(proj - camParaCalib.T);

end