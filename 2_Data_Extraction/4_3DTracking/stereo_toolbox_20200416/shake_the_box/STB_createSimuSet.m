function [ predictions, I_rec ] = STB_createSimuSet( nParts, cameraSystem, STB_params )

P = cameraSystem.getProjectionMatrices;

predictions(:,1) = 5.5 .*(rand(nParts,1)-0.5);
predictions(:,2) = 6.5 .*(rand(nParts,1)-0.5);
predictions(:,3) = 5.5 .*(rand(nParts,1)-0.5);

% set window to full image
window.ymin = 1;
window.ymax = 1024;
window.xmin = 1;
window.xmax = 1280;

% create artifical camera images
for nCam = 1:cameraSystem.nCameras
    I_rec{nCam} = zeros(1024,1280)';
    projectionMatrix = P(nCam).projectionMatrix;
    for k = 1:nParts
        I_rec{nCam} = I_rec{nCam} + STB_projectImage( STB_params, predictions(k,:), projectionMatrix, window, 0.3 );
    end
    I_rec{nCam} = I_rec{nCam}';
end

end

