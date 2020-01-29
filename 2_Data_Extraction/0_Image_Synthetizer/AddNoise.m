function AddNoise
%ADDNOISE Summary of this function goes here
%   Detailed explanation goes here
S = 10;
for i = 1 : 4
    for j = 1 : 150 
        I = imread(['./Images/' 'cam' num2str(i) 'frame' num2str(j) '.tif']);
        J = double(I) + S.*randn(size(I));
        J = uint8(J);
        imwrite(J,['./NoiseImages/' 'cam' num2str(i) 'frame' num2str(j) '.tif']);
    end
end
end

