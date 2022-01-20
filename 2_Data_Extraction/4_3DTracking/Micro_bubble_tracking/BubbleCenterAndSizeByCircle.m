function [centers,radii]  = BubbleCenterAndSizeByCircle(img, rmin, rmax, sense)
%     s = regionprops(img,'Centroid','MajorAxisLength','MinorAxisLength');
 [centers,radii] = imfindcircles(img, [ rmin, rmax], 'Method', 'TwoStage','Sensitivity',  sense,'ObjectPolarity', 'bright');
end

