function R = FindBubbleByCrossCorrelation(img, img_bubble, r)

img_ref = imresize(img_bubble, [r r] * 2 + 1);
[H, W] = size(img);
R = zeros(H, W);
X = zeros(H, W);
Y =  zeros(H, W);
for i = 1 : H
    for j = 1 : W
        X(i, j) = i;
        Y(i, j) = j;
        R(i, j) = ImageCrossCorrelation(img, img_ref, i, j, r);
    end
end
R(R<0) = 0;
% [X,Y] = meshgrid(1:H, 1:W);
% pcolor(X,Y, R');
figure
surf(Y,X,R, 'EdgeColor', 'none');
set(gca,  'Ydir', 'reverse');

axis equal
view(0, 90)
end

