function [ verifiedPositions, declinedPositions, verifiedIntensities, declinedIntensities, I_res] = STB_verifyCoordinates(positions, cameraSystem, STB_params)
% This function uses the STB-algorithm to verify (or decline) a set of
% given positions using recorded images.

P = cameraSystem.getProjectionMatrices;
intensities = 0.2.*ones(size(positions,1), 4);

window2d_full.xmin = 1;
window2d_full.xmax = cameraSystem.cameraCalibrations(1).camera.width;
window2d_full.ymin = 1;
window2d_full.ymax = cameraSystem.cameraCalibrations(1).camera.height;

I_rec = STB_loadCameraImages(STB_params, STB_params.framesToProcess);


for camNo = 1:cameraSystem.nCameras
    I_rec{camNo} =  double(I_rec{camNo})./256;
    %I_proj{camNo}  = STB_projectImage(STB_params, positions, P(camNo).projectionMatrix , window2d_full, intensities );
end

converged = false(size(positions,1),1);
verifiedPositions = [];
declinedPositions = [];
verifiedIntensities = [];
declinedIntensities = [];

for nIter = 1:STB_params.maxShakingIter
    
    for camNo = 1:cameraSystem.nCameras
        I_proj{camNo} = STB_projectImage(STB_params, [positions ; verifiedPositions], P(camNo).projectionMatrix , window2d_full, intensities(:,camNo) );
    end
    
    for partNum = 1:size(positions,1)

            %fprintf(1,'part: %05d/%05d',partNum, size(predictions,1));
            p3d = positions(partNum,1:3);
            
            intensity = intensities(partNum,:);

            
            % shake in x-direction
            [ ~, x_new, isConvergedx, isLostX ] = STB_getResidual(   p3d, STB_params, intensity, I_rec , I_proj, cameraSystem, 1);
            % shake in y-direction
            
            
            [ ~, y_new, isConvergedy, isLostY ] = STB_getResidual( x_new, STB_params, intensity, I_rec, I_proj , cameraSystem, 2);
            % shake in x-direction
            
            
            [ ~, z_new, isConvergedz, isLostZ ] = STB_getResidual( y_new, STB_params, intensity, I_rec, I_proj , cameraSystem, 3);
            
            
            if ~(isLostX || isLostY || isLostZ)
                % update particle projection intensity
                intensities(partNum,1:4) = STB_updateIntensity(z_new, STB_params, intensities(partNum,1:4), I_rec , I_proj, cameraSystem);
            end
            
            % update optimized particle data
            positions(partNum, :) = z_new;
            
            % look if shaking is converged
            if (isConvergedx && isConvergedy && isConvergedz)
                converged(partNum) = true;
            end
            
            % check, if particle was lost (left the FoV)
            if (isLostX || isLostY || isLostZ)
                converged(partNum) = false;
                % set intensity to 0, then the track will be discontinued
                intensities(partNum,:) = 0;
            end
            
            %fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
    end %partNum
    % check, if particle is not visible in one camera
    [X, ~] = find(intensities<[0.1 0.1 0.1 0.1]);
    intensities(unique(X),1) = 0;
    
    verifiedPositions = [verifiedPositions ; positions(converged==true, :)];
    verifiedIntensities = [ verifiedIntensities ; intensities(converged==true, :) ];
    declinedPositions = [ declinedPositions ;  positions(intensities(:,1)==0, :) ];
    declinedIntensities = [ declinedIntensities ; intensities(intensities(:,1)==0, :)];
    toTakeOut = converged==true | intensities(:,1)==0;
    positions(toTakeOut, :) = [];
    converged(toTakeOut) = [];
    intensities(toTakeOut, :) = [];
end

for camNo = 1:cameraSystem.nCameras
    I_res{camNo} = STB_projectImage(STB_params, verifiedPositions, P(camNo).projectionMatrix , window2d_full, 2*verifiedIntensities(:,camNo) );
end


end

