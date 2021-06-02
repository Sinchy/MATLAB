function [  ] = STB_checkProjectionWidth(  )
% This function gives you the possibility to manually choose the correct
% size of the "projection-width"-parameter for every camera.
[file, fpath] = uigetfile('*.*','Select a typical camera image');

if file~=0 % check if dialog box has been canceled
    try
        original_image = imread(fullfile(fpath, file)); % try to open image
    catch
        error('Image file could not be read.');
    end
else
    error('No file selected.');
end

%% let the user specify a particle-region that should be analyzed
disp('Specify rectangle and double-click on it..');
fig_orig = imshow(original_image);
drag_rect = imrect();
rect_position = wait(drag_rect);
fig_orig.delete;
drag_rect.delete;
% crop image to the desired rectangle
image_cropped = imcrop(original_image, rect_position);
fig_cropped = imshow(image_cropped, 'border', 'tight','InitialMagnification',1000);

%% open GUI and let the user try suitable settings
FWHM = 5;
intensity = 100;
fig_projected = figure;
while ~isempty(FWHM) && ~isempty(intensity)
    try
       im_projected.delete; 
    end
    sz_x = rect_position(3);
    sz_y = rect_position(4);
    
    pos2D = [ round(sz_x/2) , round(sz_y/2) ];
    [ X, Y ] = meshgrid(1:round(sz_x), 1:round(sz_y));

    I_projected = intensity * exp( - ( (X-pos2D(1)).^2 + (Y-pos2D(2)).^2 )./FWHM );
    set(0, 'currentfigure', fig_projected);
    im_projected = imshow(uint8(I_projected), 'border', 'tight','InitialMagnification',1000);
    
    FWHM      = input('Enter FWHM: ');
    intensity = input('Enter intensity: ');
end




end
