


converged = zeros(size(predictions,1),1);


STB_params.normalShakeWidth = 2e-3;
STB_params.evalWindowSize   = 20;
STB_params.particleSize     = 5;
STB_params.projection.width = 5;
STB_params.detect2d.threshold = 20;
STB_params.detect2d.lObject = 7;
STB_params.detect2d.output2dFilemask = 'coords2dTemp_%05d.dat';
STB_params.triang3d.output3dFilemask = 'coords2dTemp_%05d.dat';

positionsConverged = [];
intensitiesConverged = [];

for kk = 1:5
    fprintf(1,'shake-the-box:: ');
    for k = 1:20
        fprintf(1,'iter: %03d ',k);
        
        if k == 1
            intensities = STB_getInitialParticleIntensity(STB_params, predictions, I , cameraSystem);
            [ correctedPositions, converged, intensities ] = STB_normalShake( STB_params, cameraSystem, predictions, intensities, I );
        else
            [ correctedPositions, converged, intensities ] = STB_normalShake( STB_params, cameraSystem, correctedPositions, intensities, I );
        end
        
        % if particles are converged to a stable position, store them
        if any(converged)
            positionsConverged = [positionsConverged ; correctedPositions(logical(converged),:)];
            intensitiesConverged = [ intensitiesConverged ; intensities(logical(converged),:) ];
        end
        
        % decide if intensity falls below a certain threshold and delete the
        % particle
        idx_delete = sum(intensities,2) < 0.05*mean(sum(intensities,2));
        
        % delete particles (intensity or already converged)
        toBeDeleted = idx_delete | logical(converged);
        intensities(toBeDeleted,:) = [];
        correctedPositions(toBeDeleted,:) = [];
        
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b');
    end
    fprintf(1,' [ DONE ]\n');
    
    % find new particles in residual images:
    I_res = STB_getResidualImage(STB_params, cameraSystem, real(positionsConverged), real(intensitiesConverged), I);
    pos2d = STB_detect2d(STB_params, I_res, 1);
    I = I_res;
    
    % correspondence analysis
    settings.output3Dcoords = STB_params.triang3d.output3dFilemask;
    settings.im_range       = 1;
    settings.triangulation.sets = [2 3 4 ];
    settings.output2Dcoords = STB_params.detect2d.output2dFilemask;
    settings.triangulation.epipolarDistanceAllowed = 3.5;
    [ settings ] = nCam3dMultiset( settings, cameraSystem, 1, 0 );
    
    % read the results from the correspondence analysis
    predictions = dlmread([ settings.triangulation.outputPaths{1} '/coords3d_00001.dat']);
    predictions = predictions(:,1:3);
    
    if isempty(predictions)
        disp('No more 3D ppositions found');
        return
    end
    
end
