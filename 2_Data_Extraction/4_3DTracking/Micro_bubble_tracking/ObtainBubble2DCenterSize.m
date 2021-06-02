function [pos2D, radii_bubble] = ObtainBubble2DCenterSize(img)
    img0 = img > 100; % change it to binary image
    stats = regionprops('table',img0,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    ratio = stats.MajorAxisLength ./ stats.MinorAxisLength;
    radii = diameters/2;
    bubble_label = radii > 3 & ratio < 1.2; 
    pos2D = centers(bubble_label == 1, :);
    radii_bubble = radii(bubble_label == 1);
end

