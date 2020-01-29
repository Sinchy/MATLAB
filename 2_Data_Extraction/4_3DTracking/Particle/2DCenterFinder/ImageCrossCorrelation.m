function R = ImageCrossCorrelation(img, ic, jc, ni, nj, Am, rm)
% summing window:
[Npixw, Npixh] = size(img);
i_min = max(1, round(ic - ni / 2)); i_max = min(Npixw, round(ic + ni / 2));
j_min = max(1, round(jc - nj / 2)); j_max = min(Npixh, round(jc + nj / 2));

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
        Im = Im + Gaussian(j - jc, i - ic, Am, rm); % img(y,x)?
    end
end
Im = Im / (i_max - i_min + 1) / (j_max - j_min + 1);

% cross correlation between image and Gaussian mask
Ic = 0;
for i = i_min : i_max
    for j = j_min : j_max
        Ic = Ic + (img(i, j) - I) * (Gaussian(j - jc, i - ic, Am, rm) - Im);
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
        Iam = Iam + (Gaussian( j - jc, i - ic, Am, rm) - Im) ^ 2;
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

function I = Gaussian(dx, dy, A, r)
I = A * exp(- 1 * (dx ^ 2 + dy ^ 2) / (2 * r^2));
end

