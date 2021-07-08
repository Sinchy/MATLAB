function outImg = LaVision_ImgProcessing(a)
%     for cam = 1:4
%         for I = 1:200
%             a = [cam_dir{cam} 'cam' num2str(cam) 'frame' num2str(I,'%04.0f') '.tif'];
%             a = double(imread(a));
            % subtrack sliding minimum
            a = double(a);
            b = imerode(a, true(3));
            c = a - b;
            b = imerode(a, true(3));
            c = c - b;

            % Gaussian smoothing filter
            d = imgaussfilt(c);

            % image normalization
            filt_size = 100;
            filt = 1/filt_size^2 .*true(filt_size);
            e = imfilter(d,filt);

            f = a - e;

            % sharpen the image
            outImg = uint8(imsharpen(f));
end