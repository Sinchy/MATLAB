function [ I_rec ] = STB_loadCameraImages( STB_params, frameNo )
% this function loads the camera images and does some basic processing,
% e.g. sobel filtering, ROI,...

for k = 1:STB_params.nCameras
    I_rec{k} = imread(sprintf(STB_params.imagePaths, k, frameNo));    
end

% remove background
for k = 1:STB_params.nCameras
    h = fspecial('average',30);
    I_av = imfilter(I_rec{k}, h);
    thresh = mean(I_av(:));
    I_rec{k} = I_rec{k}-round(thresh);
end

end

