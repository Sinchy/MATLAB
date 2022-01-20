function GenerateBubbleImage(tracks, radii, dir, camParaCalib, vibration)

total_frame = max(tracks(:,4));
if exist([dir 'pro.txt'], 'file')
    fileID = fopen([dir 'pro.txt']);
    start_frame = fscanf(fileID, '%f');
    fclose(fileID);
else
    start_frame = 1;
end

if ~exist('vibration', 'var')
    vibration = zeros(total_frame, 2);
end

for k = start_frame :  total_frame
    I = zeros(800,1280,4);
    
    particle_frame = tracks(tracks(:,4) == k, :);

    shift_vibration = vibration(k, :);
    
    for p = 1 : size(particle_frame, 1)

        Pos3D = particle_frame(p, 1:3);
        radius = radii(particle_frame(p, 5));
        Pos3D = [Pos3D, radius];
        [I, ~] =  Proj2d_IntV2(I, Pos3D, camParaCalib, shift_vibration);
    end
    
    
%     I = imnoise(I,'gaussian');  
    for i = 1:4
%         % add noise to image
        if ~exist([dir 'cam' num2str(i)], 'dir') 
            mkdir([dir 'cam' num2str(i)]); 
        end
        I = uint8(I);
        imwrite(I(:,:,i),[dir 'cam' num2str(i) '/' 'cam' num2str(i) 'frame' num2str(k, '%06.0f') '.tif']);
%           imwrite(I(:,:,i),['temprs' num2str(i) '.tif']);
    end
    fileID = fopen([dir 'pro.txt'], 'w');
    fprintf(fileID, num2str(k));
    fclose(fileID);
    k
end
end

function [I, particle_info] = Proj2d_IntV2(I, Pos3D, camParaCalib, shift_vibration)

% Xp = Pos3D(1); Yp = Pos3D(2); Zp = Pos3D(3); 
radius = Pos3D(4) / 0.02; % mm to pixel

n_cam = size(camParaCalib, 1);
xc = zeros(size(Pos3D,1),n_cam);
yc = zeros(size(Pos3D,1),n_cam);

for i = 1:n_cam
    X2D = calibProj_Tsai(camParaCalib(i),Pos3D(1:3));
    xc(:,i) = X2D(:,1) + shift_vibration(1) ; yc(:,i) = X2D(:,2) + shift_vibration(2);
end
pos2D = [xc' yc'];
pos2D = reshape(pos2D, [1 n_cam * 2]);
particle_info = [Pos3D, pos2D, 1];
[pixh, pixw,~] = size(I);
for i = 1:n_cam

   % Gaussian projection

   for x = max(1,floor(xc(i)-radius - 2)):min(pixw,floor(xc(i) + radius + 2))
       for y = max(1,floor(yc(i)-radius - 2)):min(pixh,floor(yc(i)+radius + 2))
            if x < 1 || y < 1 || x > pixw  ||y > pixh
                particle_info(end) = 0;
                continue;
            end
%             xx = (x-xc(i))*cos(alpha) + (y-yc(i))*sin(alpha);
%             yy = -(x-xc(i))*sin(alpha) + (y-yc(i))*cos(alpha);
%             I(y,x,i) = max(I(y,x,i), a*exp(-(b*(xx)^2 + c*(yy)^2))); % not sure if max is the right thing to use for overlapping particles
%             %I(y,x,i) = I(y,x,i) + a*exp(-(b*(xx)^2 + c*(yy)^2));
            if (x - xc(i)) ^ 2 + ( y - yc(i)) ^ 2 <= radius ^ 2
                I(y, x, i) = 255;
            end
       end
   end
end

end

function x = bound(X) 
    x = X;
    if (X > 2 * pi)
        x = X - 2 * pi;
    elseif (X < 0)
        x = X + 2 * pi;
    end
end
