function [avgReconstructionUncertainty, histAxis] = computeAverageReconstructionUncertainty(worldExtent, sampleModel, noiseModel, DLT, imageSize, histDX, histSmooth, numSamples, targetSize)

if isempty(sampleModel) || strcmp(sampleModel, 'uniform')
    worldPoints = sampleSpace(numSamples, worldExtent{1}, worldExtent{2}, worldExtent{3});
elseif strcmp(sampleModel, 'voxels')
    worldPoints = sampleVoxels(worldExtent{1}, worldExtent{2}, worldExtent{3}, histDX);
end

[uncertainty reconstructedPoints] = estimateReconstructionUncertainty(worldPoints, DLT, imageSize, noiseModel, targetSize);
good = ~isnan(uncertainty);
worldPoints = worldPoints(good,:);
uncertainty = uncertainty(good);

pointDeltas = {histDX histDX histDX};
[errorPoints, histAxis] = util.histnw(worldPoints, ones(size(worldPoints,1),1), worldExtent, pointDeltas, false, histSmooth);
[reconstructionUncertainty, histAxis] = util.histnw(worldPoints, uncertainty, worldExtent, pointDeltas, false, histSmooth);

avgReconstructionUncertainty = reconstructionUncertainty./errorPoints;
avgReconstructionUncertainty(isnan(avgReconstructionUncertainty))=0;

if any(histSmooth)
    [existence, histAxis] = util.histnw(worldPoints, ones(size(worldPoints,1),1), worldExtent, pointDeltas, false, false);
    avgReconstructionUncertainty(~existence) = 0;
end


end
