function centers = BubbleCenterAndSize(img)
     s = regionprops(img,'Centroid','MajorAxisLength','MinorAxisLength');
     centers =  cat(1,s.Centroid);
     majorlength = cat(1, s.MajorAxisLength);
     minorlength = cat(1, s.MinorAxisLength);
     radius = (majorlength + minorlength) / 4;
     ind = radius > 2 & radius < 5;
     centers = centers(ind, :);
end

