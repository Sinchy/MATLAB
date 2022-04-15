function [centers,radii,metrics]  = BubbleCenterAndSizeByCircle(img, rmin, rmax, sense)
 [centers,radii,metrics] = imfindcircles(img, [ rmin, rmax], 'Sensitivity',  sense);

end

