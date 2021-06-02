function [avgReconstructionUncertainty, histAxis] = plotReconstructionError(DLT, imageSize, worldExtent, noiseModel, targetSize, histDX, histSmooth, transformationMatrix, uncertaintyColormap, bDropPlane, precomputedH, precomputedAx)

sampleMultiplier = 25;
numSamples = ceil(diff(worldExtent{1})*diff(worldExtent{2})*diff(worldExtent{3})/(histDX^3)*sampleMultiplier);

if exist('precomputedH', 'var') && ~isempty(precomputedH) && exist('precomputedAx', 'var') && ~isempty(precomputedAx)
    avgReconstructionUncertainty = precomputedH;
    histAxis = precomputedAx;
else
    if isempty(noiseModel)
        noiseModel = 'target';
    end
    [avgReconstructionUncertainty, histAxis] = computeAverageReconstructionUncertainty(worldExtent, 'voxels', noiseModel, DLT, imageSize, histDX, histSmooth, numSamples, targetSize);
end

positive = avgReconstructionUncertainty(:)>0;

view([30 30]);
Axis = axis;
view([0 90]);

xtick = get(gca, 'xtick');
ytick = get(gca, 'ytick');
ztick = get(gca, 'ztick');

if exist('bDropPlane', 'var') && bDropPlane
histAxis{2} = histAxis{2}+1;
end

for x=1:3
axLen(x) = numel(histAxis{x});
end
[dummy plotDir] = min(axLen);

plot_tools.plotHistogramStack3(avgReconstructionUncertainty*100, histAxis, plotDir, 1, transformationMatrix);
caxis([0 prctile(avgReconstructionUncertainty(positive),99)*100]);
axis(Axis);
set(gca, 'xtick',  xtick)
set(gca, 'ytick',  ytick)
set(gca, 'ztick',  ztick)
colormap(uncertaintyColormap);

cbar = findobj(gcf,'tag','Colorbar');
y = get(cbar, 'ylabel');
set(y, 'string', 'Reconstruction Uncertainty (cm)', 'rotation', -90, 'verticalAlignment', 'bottom', 'fontsize', 12, 'fontweight', 'bold');


if exist('bDropPlane', 'var') && bDropPlane
histAxis{2} = histAxis{2}-1;
end

end
