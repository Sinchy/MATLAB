function R = ImageCrossCorrelation(img, img_ref, ic, jc, r)
% img: the image to find bubble
% img_ref: a bubble image for reference
% ic, jc, the center 
% r: the size of the bubble
% summing window:
[Npixw, Npixh] = size(img);
img = double(img);
img_ref = double(img_ref);
i_min = max(1, round(ic - r )); i_max = min(Npixw, round(ic + r - 1));
j_min = max(1, round(jc - r )); j_max = min(Npixh, round(jc + r - 1));
center_ref = r + 1;

% spatial average of intensity on image
I = 0;
for i = i_min : i_max
    for j = j_min : j_max
        I = I + img(i, j); % img(y,x)?
    end
end
I = I / (i_max - i_min + 1) / (j_max - j_min + 1);

% spatial average of Gaussian particle mask
Im = 0;
for i = i_min : i_max
    for j = j_min : j_max
        di = center_ref + i - ic;
        dj = center_ref + j - jc;
        Im = Im + img_ref(di, dj);
    end
end
Im = Im / (i_max - i_min + 1) / (j_max - j_min + 1);

% cross correlation between image and Gaussian mask
Ic = 0;
for i = i_min : i_max
    for j = j_min : j_max
        di = center_ref + i - ic;
        dj = center_ref + j - jc;
        Ic = Ic + (img(i, j) - I) * (img_ref(di, dj) - Im);
    end
end

% auto correlation of image
Iai = 0;
for i = i_min : i_max
    for j = j_min : j_max
        Iai = Iai + (img(i, j) - I) ^ 2;
    end
end
Iai = Iai ^ 0.5;

% auto correlation of Gaussian particle mask
Iam = 0;
for i = i_min : i_max
    for j = j_min : j_max 
        di = center_ref + i - ic;
        dj = center_ref + j - jc;
        Iam = Iam + (img_ref(di, dj) - Im) ^ 2;
    end
end
Iam = Iam ^ 0.5;

% image cross correlation
if Iai ~= 0
    R = Ic / Iai / Iam;
else
    R = 0;
end

end


