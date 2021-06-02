function [uncertainty, reconstructedPoints] = estimateReconstructionUncertainty(worldPoints, DLT, imageSize, noiseModel, targetSize)

imagePoints = cell(1,3);
for c=1:size(DLT,2)
    
    %project the points onto each camera
    imagePoints{c} = reconstruction.dlt_inverse(DLT(:,c), worldPoints);
    
    %(optional) add gaussian noise to image points
    if exist('noiseModel', 'var') && ~isempty(noiseModel) && exist('targetSize', 'var') && targetSize > eps
        if ~strcmp(noiseModel, 'none')
            if strcmp(noiseModel, 'target')
                %(optional) compute apparent size of the targets
                auxImagePoints1 = reconstruction.dlt_inverse(DLT(:,c), util.rowadd(worldPoints, [0 targetSize 0]));
                auxImagePoints2 = reconstruction.dlt_inverse(DLT(:,c), util.rowadd(worldPoints, [targetSize 0 0]));
                auxImagePoints3 = reconstruction.dlt_inverse(DLT(:,c), util.rowadd(worldPoints, [0 0 targetSize]));
                
                apparentTargetSize = max([util.magnitude(imagePoints{c}-auxImagePoints1), util.magnitude(imagePoints{c}-auxImagePoints2), util.magnitude(imagePoints{c}-auxImagePoints3)], [], 2);
                noiseSigma = [apparentTargetSize apparentTargetSize] / 6;
            elseif strcmp(noiseModel, 'pixels')
                noiseSigma = repmat([targetSize targetSize], size(worldPoints,1), 1);
            end
            
            noise = randn(size(worldPoints,1),2).*noiseSigma;
            imagePoints{c} = imagePoints{c} + noise;
        end
    end
    
    % quantize the image points
    imagePoints{c} = floor(imagePoints{c});
    
    % only keep points inside the image
    good = util.between(imagePoints{c}(:,1), [0 imageSize(1)]) & util.between(imagePoints{c}(:,2), [0 imageSize(2)]);
    imagePoints{c}(~good,:) = nan;
    imagePoints{c} = imagePoints{c}';
    
end

imagePoints = util.cellcat(imagePoints)';

% reconstruct the world points
reconstructedPoints = reconstruction.dlt_reconstruct(DLT, imagePoints);

% compute error
uncertainty = util.magnitude(worldPoints - reconstructedPoints);

end