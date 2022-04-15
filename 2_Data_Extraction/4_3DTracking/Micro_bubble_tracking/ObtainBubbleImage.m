function b_i_m = ObtainBubbleImage(centers, radii, img)
[H, W] = size(img);
d_b =  round(max(radii) * 2);
ind = centers(:, 1) - d_b / 2 > 0 & centers(:, 1) + d_b / 2 < W & centers(:, 2) - d_b / 2 > 0 & centers(:, 2) + d_b / 2 < H;
centers = centers(ind, :);
radii = radii(ind, :);
n_b = size(centers, 1);
bubble_images = zeros(n_b, d_b, d_b);
for i = 1 : n_b
    r_bb = radii(i) ;
    
%     if (round(centers(i, 2) + r_bb )> H  || round(centers(i, 1) + r_bb) > W) 
%         bubble_images(i, :,:) = [];
%         continue;
%      end
%     
    b_i = img(round([centers(i, 2) - r_bb  : centers(i, 2) + r_bb] ) , round([centers(i, 1) - r_bb : centers(i, 1) + r_bb] ));
    b_i = imresize(b_i, round([r_bb, r_bb]*2));
    for j = 1 : size(b_i, 1)
        for k = 1 : size(b_i, 2)
           if (j - r_bb)^2 + (k - r_bb)^2 > r_bb^2
               b_i(j, k) = 0;
           end
        end
    end
    b_i = uint8(b_i);
    b_i = imresize(b_i, [d_b, d_b]);
    bubble_images(i, :,:) = b_i;
end
b_i_m = zeros(d_b, d_b);
for i = 1 : d_b
    for j = 1 : d_b
        b_i_m(i, j) = mean(bubble_images(:, i, j), 'all');
    end
end
b_i_m = uint8(b_i_m);
end

