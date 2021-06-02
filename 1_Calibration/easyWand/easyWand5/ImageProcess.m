img = imread('D:\1.Projects\2.Bubble-Particle\Experiment setup\Wand.png');
figure;
imshow(img)
hold on
img = rgb2gray(img);

img = uint8(255) - img;
img = img>40;
%% find circle
[centers, radii, metric] = imfindcircles(img, [100 200], 'Sensitivity', .9);

%% plot circle
viscircles(centers, radii,'Color','r');



