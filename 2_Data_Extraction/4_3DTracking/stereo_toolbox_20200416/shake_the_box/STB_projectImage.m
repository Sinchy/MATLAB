function [ I_tmp, isLost ] = STB_projectImage(camNo, STB_params, particle_positions, cameraSystem, window2d, I_p )
% this function projects the particles onto the camera sensor plane

I_tmp = transpose(zeros(length(window2d.xmin:window2d.xmax), length(window2d.ymin:window2d.ymax) ));

% when the window is large ("whole image"), then create windows for each
% particle to speed up the algorithm.
doWindow = abs(window2d.xmax - window2d.xmin) > 100;
genWindowSize = 2*STB_params.evalWindowSize;
idxY = window2d.ymin:window2d.ymax;
idxX = window2d.xmin:window2d.xmax;
isLost = zeros(size(particle_positions,1), 1);

try
points2d = projectPoints2d_distortion(particle_positions, cameraSystem, camNo);
catch
    keyboard
end
points2d = points2d{camNo};

for partNo = 1:size(particle_positions,1)
%     pos2D = projectionMatrix*[particle_positions(partNo,:)' ; 1];
%     pos2D = pos2D(1:2)./pos2D(3);
      pos2D = points2d(partNo,:);
    
    if doWindow
        window2d.xmin = round(pos2D(1))-genWindowSize;
        window2d.xmax = round(pos2D(1))+genWindowSize;
        window2d.ymin = round(pos2D(2))-genWindowSize;
        window2d.ymax = round(pos2D(2))+genWindowSize;
        idxY = window2d.ymin:window2d.ymax;
        idxX = window2d.xmin:window2d.xmax;
    end
    
    [ X, Y ] = meshgrid(window2d.xmin:window2d.xmax, window2d.ymin:window2d.ymax);
    try
    if doWindow
        I_tmp(idxY, idxX)  = I_tmp(idxY, idxX) + I_p(partNo) * exp( - ( (X-pos2D(1)).^2 + (Y-pos2D(2)).^2 )./STB_params.projection.width );
    else
        I_tmp  = I_tmp + I_p(partNo) * exp( - ( (X-pos2D(1)).^2 + (Y-pos2D(2)).^2 )./STB_params.projection.width );
    end
    catch
       %disp('Particle projection failed. Outside of image boundaries?');
       % discard this particle
       isLost(partNo) = 1;
    end
end

%I_tmp = I_tmp';
end

