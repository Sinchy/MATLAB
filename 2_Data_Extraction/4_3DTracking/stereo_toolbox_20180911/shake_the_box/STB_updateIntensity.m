function [ intensities_out ] = STB_updateIntensity( p3d, STB_params, intensities, I_rec, I_projected, cameraSystem)
% updates particle image intensity
intensities_out = intensities;

%data2d = STB_get2DPositions(p3d, cameraSystem);
data2d = projectPoints2d_distortion(p3d, cameraSystem); %with distortion

for camNo = 1:cameraSystem.nCameras
    
    window2d.xmin = round(data2d{camNo}(1))-STB_params.evalWindowSize;
    window2d.xmax = round(data2d{camNo}(1))+STB_params.evalWindowSize;
    window2d.ymin = round(data2d{camNo}(2))-STB_params.evalWindowSize;
    window2d.ymax = round(data2d{camNo}(2))+STB_params.evalWindowSize;
try
    I_rec_window = I_rec{camNo}( window2d.ymin:window2d.ymax, window2d.xmin:window2d.xmax);
catch
    disp('projection Outside in STB_updateIntensity');
    intensities_out = [0 0 0 0];
    return;
end

    I_proj   = I_projected{camNo}( window2d.ymin:window2d.ymax, window2d.xmin:window2d.xmax);
    IPart    = STB_projectImage(camNo, STB_params,         p3d, cameraSystem , window2d, intensities(camNo) );
    
    intensities_out(camNo) = intensities(camNo) * sqrt( sum(sum(I_rec_window-I_proj+IPart))/sum(IPart(:)) );
    %intensities(partNum, camNo) = sqrt( sum(I_rec_window-I_proj+IPart)/sum(IPart) );
    
end

% cap intensity ratio at 120% resp. 80% to damp oscillations
upper_cap = 1.3;
lower_cap = 0.33;

intensities_out(intensities_out > upper_cap .*intensities) = upper_cap .*intensities(intensities_out > upper_cap .*intensities);
intensities_out(intensities_out < lower_cap .*intensities) = lower_cap .*intensities(intensities_out < lower_cap .*intensities);

end

