function [position3D, error] = Triangulation(camParaCalib, position2D) 
A = zeros(3, 3);
B = zeros(3, 1);
D = 0;
n_cam = size(camParaCalib, 1);
for i = 1 : n_cam
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
