function [ hnd1 ] = plotDisparityMap( disparityMap, camNo, indZ )

NvoxPerAx = size(disparityMap{1},1);
% concatenate final images
final_image = zeros(NvoxPerAx*51,NvoxPerAx*51);  % +Nvox...to add line

hnd1 = figure; hold on;
for indY = 1:NvoxPerAx
    for indX = 1:NvoxPerAx
        final_image(indX*51-50:indX*51,indY*51-50:indY*51) = squeeze(disparityMap{camNo}(indX, indY, indZ,:,:));
    end
    
end
imagesc(final_image); axis tight;
% add grid:
line( [0 0 ; 51 51; 102 102 ; 153 153 ; 204 204]', ...
    [0 NvoxPerAx*51 ;0 NvoxPerAx*51 ;0 NvoxPerAx*51 ;0 NvoxPerAx*51; 0 NvoxPerAx*51 ]' , 'Color', [1 1 1], 'Linewidth',2);
line( [0 NvoxPerAx*51 ;0 NvoxPerAx*51 ;0 NvoxPerAx*51 ;0 NvoxPerAx*51; 0 NvoxPerAx*51 ]', ...
    [0 0 ; 51 51; 102 102 ; 153 153 ; 204 204]', 'Color', [1 1 1], 'Linewidth',2);

[X, Y] = meshgrid(25:51:250,25:51:250);
plot( X, Y, 'rx', 'MarkerSize', 6);
plot( X, Y, 'ro', 'MarkerSize', 6); 
end

