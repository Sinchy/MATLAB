function [ intensities ] = STB_getInitialParticleIntensity( STB_params, predictions, I_rec , cameraSystem)
% gets initial intensity from known 3d points

%data2d = STB_get2DPositions( predictions, cameraSystem ); % without distortion

data2d = projectPoints2d_distortion(predictions, cameraSystem); % with distortion

% cut out particles too close to the border (no "window" possible there)
%for camNo = 1:cameraSystem.nCameras
%    data2d{camNo}( data2d{camNo}(:,1) < 1 + 2*STB_params.particleSize | data2d{camNo}(:,1) > size(I_rec{camNo},2) - 2*STB_params.particleSize ) = [];
%    data2d{camNo}( data2d{camNo}(:,2) < 1 + 2*STB_params.particleSize | data2d{camNo}(:,2) > size(I_rec{camNo},1) - 2*STB_params.particleSize ) = [];
%end

intensities = zeros(size(predictions,1),cameraSystem.nCameras);
P = cameraSystem.getProjectionMatrices;
for camNo = 1:cameraSystem.nCameras
    I_rec{camNo} =  double(I_rec{camNo})./255;
end

for camNo = 1:cameraSystem.nCameras
    for partNo = 1:size(predictions,1)
        window2d.xmin = round(data2d{camNo}(partNo,1))-round(STB_params.particleSize /2);
        window2d.xmax = round(data2d{camNo}(partNo,1))+round(STB_params.particleSize /2);
        window2d.ymin = round(data2d{camNo}(partNo,2))-round(STB_params.particleSize /2);
        window2d.ymax = round(data2d{camNo}(partNo,2))+round(STB_params.particleSize /2);
        try
            I_rec_window = I_rec{camNo}( window2d.ymin:window2d.ymax, window2d.xmin:window2d.xmax);
            % project with intensity 1:
            I_Part = STB_projectImage(camNo, STB_params, predictions(partNo,:), cameraSystem , window2d, 1);
            
            % correct intensity, so that projected particle intenisty is just
            % below the original one
            intensities(partNo, camNo) = max(I_rec_window(:));
        catch
            intensities(partNo, camNo) = 0;
        end
    end
end
% post-processing if particles have not been covered by the window
intclean = intensities(intensities>0.05);
intensities(intensities<0.05) = mean(intclean(:));


%intensities = 0.25*ones(length(predictions), cameraSystem.nCameras);


end

