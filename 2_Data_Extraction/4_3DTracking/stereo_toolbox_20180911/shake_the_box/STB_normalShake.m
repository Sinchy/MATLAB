function [ tracks ] = STB_normalShake( STB_params, cameraSystem, tracks, I_rec , holdFlag)
% this is the implementation of the normal shake from D.Schanz Exp Fluids
% (2016)
%
%
if nargin == 4
    holdFlag = 0;
end

window2d_full.xmin = 1;
window2d_full.xmax = cameraSystem.cameraCalibrations(1).camera.width;
window2d_full.ymin = 1;
window2d_full.ymax = cameraSystem.cameraCalibrations(1).camera.height;
allIntensities = STB_getIntensities(tracks);

for camNo = 1:cameraSystem.nCameras
    I_rec{camNo} =  double(I_rec{camNo})./256;
    % compute projected image outside of loop for perfomance
    % improvement
    
    % do not use the positions from freshly triangulated points
    notFreshIdx = ~(STB_isFresh(tracks));
    
    % only used not-converged positions
    notConvergedIdx = ~[tracks(:).converged];
    
    %I_proj{camNo}  = STB_projectImage(STB_params, allPositions, P(camNo).projectionMatrix , window2d_full, allIntensities(  :  , camNo) );
    I_proj{camNo}  = STB_projectImage(camNo, STB_params, STB_get3DPositions(tracks( notFreshIdx & notConvergedIdx  ) ), cameraSystem , window2d_full, allIntensities(  notFreshIdx & notConvergedIdx, camNo ) );
end

for partNum = find(~[tracks(:).converged])
    %fprintf(1,'part: %05d/%05d',partNum, size(predictions,1));
    p3d = tracks(partNum).position(end,:);
    intensity = tracks(partNum).intensities(end,:);
    
    % shake in x-direction
    [ ~, x_new, isConvergedx, isLostX ] = STB_getResidual(   p3d, STB_params, intensity, I_rec , I_proj, cameraSystem, 1);
    % shake in y-direction
    
    [ ~, y_new, isConvergedy, isLostY ] = STB_getResidual( x_new, STB_params, intensity, I_rec, I_proj , cameraSystem, 2);
    % shake in x-direction
    
    [ ~, z_new, isConvergedz, isLostZ ] = STB_getResidual( y_new, STB_params, intensity, I_rec, I_proj , cameraSystem, 3);
    
    if ~(isLostX || isLostY || isLostZ)
        % update particle projection intensity
        tracks(partNum).intensities(end,1:4) = STB_updateIntensity(z_new, STB_params, tracks(partNum).intensities(end,1:4), I_rec , I_proj, cameraSystem);
    end
    
    % update optimized particle data
    tracks(partNum).position(end, :) = z_new;
    
    % look if shaking is converged
    if (isConvergedx && isConvergedy && isConvergedz)
        if ~(any(holdFlag))
            tracks(partNum).converged = true;
        end
    end
    
    % check, if particle was lost (left the FoV)
    if (isLostX || isLostY || isLostZ)
        tracks(partNum).converged = false;
        % set intensity to 0, then the track will be discontinued
        tracks(partNum).intensities(end,:) = 0;
    end
    
    
    
    %fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
end %partNum

end

