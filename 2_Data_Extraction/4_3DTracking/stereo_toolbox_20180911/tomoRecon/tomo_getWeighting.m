function wij = tomo_getWeighting(basisFunction, X, Y, Z, cameraSystem, noOfNeighborPixels, cameraNo)
% This function finds the weights neccessary to get the correct projective
% relations from the integrated intensity originating from a voxel.
%
% According to G.E. Elsinga et al., Exp Fluids (2006) 41:933-947
fprintf('tomoRecon:: Computing weighting coefficients: ');

Proj = cameraSystem.getProjectionMatrices;



% get array of pixel-centers
for camNo = cameraNo%= 1:cameraSystem.nCameras
    sensWidth  = cameraSystem.cameraCalibrations(camNo).camera.width;
    sensHeight = cameraSystem.cameraCalibrations(camNo).camera.height;
    
    %pxCntX{camNo} = 0.5:sensWidth-0.5;
    pxCntX{camNo} = 1:sensWidth;
    %pxCntY{camNo} = 0.5:sensHeight-0.5;
    pxCntY{camNo} = 1:sensHeight;
end

wij = struct('voxels',[],'coeffs', []);

% cycle through every's camera...

for camNo = cameraNo%= 1:cameraSystem.nCameras
    fprintf(1,sprintf('Camera %02d:',camNo));
    indVoxelArray = zeros(numel(basisFunction),1,'uint32');
    indPixelArray = zeros(numel(basisFunction),1,'uint32');
    coeffArray    = zeros(numel(basisFunction),1, 'single');
    indPixelCounter = 1;
    indVoxelCounter = 1;
    
    P = Proj(camNo).projectionMatrix;
    
    for xVox = 1:size(basisFunction,1)
        fprintf(1,sprintf(' Voxel %08d/%08d',(xVox-1)*size(basisFunction,2)*size(basisFunction,3), numel(basisFunction)));
        for yVox = 1:size(basisFunction,2)
            for zVox = 1:size(basisFunction,3)
                voxCenter = [X(xVox, yVox, zVox), Y(xVox, yVox, zVox), Z(xVox, yVox, zVox)]';
                indVoxel = sub2ind(size(basisFunction), xVox, yVox, zVox);
                
                % project voxel on sensor plane
                imagePoint = P*[voxCenter ; 1];
                imagePoint = imagePoint(1:2)./imagePoint(3);
                
                % find surrounding pixels in which to determine the weighting function
                cntPixel = round(imagePoint);
                pxToProcess = [cntPixel(1)-noOfNeighborPixels : cntPixel(1)+noOfNeighborPixels; cntPixel(2)-noOfNeighborPixels : cntPixel(2)+noOfNeighborPixels ];
                
                for npx = pxToProcess(1,:)
                    for npy = pxToProcess(2,:)
                        % get distance from projection to pixel
                        try
                            currentPixel = [ pxCntX{camNo}(npx) ; pxCntY{camNo}(npy)];
                        catch
                            npx
                            npy
                            xVox
                            yVox
                            zVox
                            error('The projected position lies outside of the sensor plane. Readjust Volume.')
                        end

                        d = norm(imagePoint-currentPixel);
                        coeff = exp(-d^2);
                        
                        % store this event
                        indPixelArray(indPixelCounter)  = sub2ind([sensWidth,sensHeight],npx,npy);
                        coeffArray(indPixelCounter) = coeff;
                        indPixelCounter = indPixelCounter+1;
                        indVoxelArray(indVoxelCounter) = indVoxel;
                        indVoxelCounter = indVoxelCounter+1;
                    end
                end
            end
        end
        fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
    end
    %     tmp = sparse(indVoxelArray, indPixelArray, coeffArray);
    %     [~,pixIdx] = find(tmp);
    %     pixIdx = unique(pixIdx);
    %     pixNum_out{camNo} = pixIdx;
    %     for pixNum = reshape(pixIdx, 1, [])
    %         %idxLog = indPixelArray==pixNum;
    %         [contributingVoxels, ~] = find(tmp(:,pixNum));
    %         wij(camNo,pixNum).pixel  = pixNum;
    %         wij(camNo,pixNum).voxels = contributingVoxels;
    %         wij(camNo,pixNum).coeffs = coeffArray(indPixelArray==pixNum);
    %     end
    [indPixelArray, howtoSort] = sort(indPixelArray);
    indVoxelArray = indVoxelArray(howtoSort);
    coeffArray    = coeffArray(howtoSort);
    [counterPixel, startsOfNext] = unique(indPixelArray);
    % to allow the last iteration:
    startsOfNext(end+1) = numel(indVoxelArray);
    loopCounter = 1;
    for pixNum = reshape(counterPixel, 1, [])
        thisVoxelNo  = startsOfNext(loopCounter);
        nextVoxelNo  = startsOfNext(loopCounter+1);
%         wij(camNo,loopCounter).pixel  = pixNum;
%         wij(camNo,loopCounter).voxels = indVoxelArray(thisVoxelNo:nextVoxelNo);
%         wij(camNo,loopCounter).coeffs = coeffArray(thisVoxelNo:nextVoxelNo);
        wij(loopCounter).pixel  = pixNum;
        wij(loopCounter).voxels = indVoxelArray(thisVoxelNo:nextVoxelNo);
        wij(loopCounter).coeffs = coeffArray(thisVoxelNo:nextVoxelNo);
        loopCounter = loopCounter+1;
    end
    
    clear indVoxelArray indPixelArray coeffArray
    % wij(camNo).voxelArray = uint32(indVoxelArray);
    % wij(camNo).pixelArray = uint32(indPixelArray);
    % wij(camNo).coeffArray = single(coeffArray);
    fprintf('\b\b\b\b\b\b\b\b\b\b');
end
fprintf(' [ done ]\n');
end

