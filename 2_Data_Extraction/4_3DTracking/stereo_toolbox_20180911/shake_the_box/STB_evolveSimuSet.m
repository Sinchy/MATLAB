function [ I_rec ] = STB_evolveSimuSet( predictions, P , STB_params)
% This function uses the initial particle distribution given by
% STB_createSimuSet.m . Then, depending on some given parameters, a
% time-evolution of the simulated particles will be done. Everything will
% be stored on the disc just in a format that can be used by the
% reconstruction toolbox.

%% preferences
totalFrames      = 1;
fps              = 200;
outputFileMask3d   = './coords3dTruth/coords3d_%05d.dat';
outputImagesFileMask = './CAM%d/image_%05d.bmp';
stochasticFactor   = 0;
oscillationAmplitude  = 1; % [mm]
oscillationFrequency  = 10;  % [Hz]
oscillationWaveVektor = 0.5; % [1/mm]


%% evolve simulation
initialPositions = predictions;
nParts = size(predictions,1);

fprintf(1,'\nEvolveSimuSet:: Frame: ');
for kFrame = 1:totalFrames
    fprintf(1,'%05d/%05d',kFrame,totalFrames);
    
    currentTime = (kFrame-1)./fps;
    
    for kParticle = 1:size(predictions,1)
        particlePositions(kParticle,1) = predictions(kParticle,1);
        particlePositions(kParticle,2) = predictions(kParticle,2);
        particlePositions(kParticle,3) = initialPositions(kParticle,3) + oscillationAmplitude*sin(2*pi*oscillationFrequency*currentTime);
    end
    
    % create artifical camera images
    % set window to full image
 % set window to full image
window.ymin = 1;
window.ymax = 1024;
window.xmin = 1;
window.xmax = 1280;

% create artifical camera images
for nCam = 1:4
    I_rec{nCam} = zeros(1024,1280)';
    projectionMatrix = P(nCam).projectionMatrix;
    for k = 1:nParts
        I_rec{nCam} = I_rec{nCam} + STB_projectImage( STB_params, predictions(k,:), projectionMatrix, window, 0.75 );
    end
    I_rec{nCam} = I_rec{nCam}';
    imwrite(I_rec{nCam},sprintf(outputImagesFileMask,nCam, kFrame));
end
    
    
    dlmwrite(sprintf(outputFileMask3d,kFrame),particlePositions);
    predictions = particlePositions;
    fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b');
end
fprintf(1,'[ done ]\n');




end

