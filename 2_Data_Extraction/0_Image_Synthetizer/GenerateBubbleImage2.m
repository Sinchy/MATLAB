function num_bubble = GenerateBubbleImage2(dir, camParaCalib, tracks, radius, b_ref)
total_frame = max(tracks(:,4));
num_bubble = zeros(total_frame, 1);
ncam = size(camParaCalib, 1);
npixw = camParaCalib(1).Npixw;
npixh = camParaCalib(1).Npixh;
for i = 1 :  total_frame
    img = zeros(npixh, npixw, ncam);
    particle_frame = tracks(tracks(:,4) == i, :);
    for j = 1 :  size(particle_frame, 1)
        pos = particle_frame(j, 1:3);
        r = radius(radius(:, 1) == particle_frame(j, 5), 2);
        n_track = 0;
        for k = 1 : ncam
            pos2D = calibProj_Tsai(camParaCalib(k), pos);
            if (pos2D(:, 1) - r < npixw && pos2D(:, 1) + r > 1 && ...
                    pos2D(:, 2) - r < npixh && pos2D(:, 2) + r > 1 )
                n_track = n_track + 1;
                b_img = imresize(b_ref, [r r]*2 + 1);
                x_min = max(1, round(pos2D(:,1) - r)); x_max = min(npixw, round(pos2D(:,1) + r));
                y_min = max(1, round(pos2D(:,2) - r)); y_max = min(npixh, round(pos2D(:,2) + r));
                for x = x_min : x_max
                    for y = y_min : y_max
                        dx =  r + round(x - pos2D(:,1)) + 1;
                        dy =  r + round(y - pos2D(:,2)) + 1;
                        if (x - pos2D(:,1))^2 + (y - pos2D(:,2))^2 <= (r + 1)^2
                            if img(y, x, k) == 0
                                img(y, x, k) = b_img(dy, dx);
                            end
                        end
                    end
                end
            end
        end
        if n_track == ncam
            num_bubble(i, 1) = num_bubble(i, 1) + 1;
        end
    end
    for cam = 1:ncam
        %         % add noise to image
        if ~exist([dir '\cam' num2str(cam)], 'dir')
            mkdir([dir '\cam' num2str(cam)]);
        end
        img = uint8(img);
        imwrite(img(:,:,cam),[dir '\cam' num2str(cam) '/' 'cam' num2str(cam) 'frame' num2str(i, '%06.0f') '.tif']);
    end
end
end


