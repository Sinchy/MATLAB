function s = BubbleCenterAndSize(img)
     s = regionprops(img,'Centroid','MajorAxisLength','MinorAxisLength');
 %[centers,radii] = imfindcircles(img, [ rmin, rmax], 'Method', 'TwoStage','Sensitivity', .95);
end

