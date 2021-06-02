function [histogram axes] = histnw(data, weights, lims, delta, bNorm, bSmooth)
% Make a D dimensional histogram from D columns of data.  Bin size can (must)
% be specified, but non-uniform bins are not supported
% Data in a particular bin is all data strictly greater than the values of
% the left bin edge. The right bin edge of the highest bin will be the
% upper limit value
%
% signature:
%[histogram axes] = histn(data, lims, delta, bNorm, bSmooth)
%
% usage:
%[histogram axes] = histn([dataX dataY ...], {[minX maxX], [minY maxY], ...}, {dX, dY,...}, bNorm, bSmooth);
%
% @param[in] data - an N by D array containing the data to histogram.
%
% @param[in] lims - a D element cell array where each element is a 2 element vector
% with the min and max values (or empty)
%
% @param[in] delta - a D element cell array where each element is a scalar
% indicating the size of the bin (or empty)
%
% @parm[in] bNorm - normalize the sum of the histogram to 1.0
% (empty is false)
%
% @param[in] bSmooth - whether or not to smooth the histogram 
%                      if a scalar logical, smoothed afterward with a Gaussian
%                      if a vector the length of the dimensionality of the
%                      data, used as covariance for kernel density
%                      estimation
%
% @return histogram - the data of the histogram
%
% @return axes - a cell array containing the values for each bin on each axis.
% Can be passed to imagesc, or surf to make the axes do the right thing.
%
% example:
% data = randn(1000000,3);
% [H ax]= histn(data, {[-3 3], [-3 3], [-3, 3]}, {.05, .05, .05}, true, false);
% figure; imagesc(ax{1}, ax{2}, squeeze(H(:,:,60))')
% figure; plot4(H, ax);
%

dim = size(data,2);

if isempty(weights)
    weights = ones(size(data,1),1);
end

idx = ~isnan(data) & ~isinf(data);
idxvec = idx(:,1);
for d = 2:dim
    idxvec = idxvec & idx(:,d);
end
idx = idxvec;
data = data(idx,:);
weights = weights(idx);
numPoints = size(data, 1);

%make sure all the limits are set up properly. Fill in any that are empty
if ~exist('lims', 'var') || isempty(lims)
    lims = cell(1,dim);
    if any(cellempty(lims))
        for d=1:dim
            if isempty(lims{d})
                lims{d} = minmax(data(:,d));
            end
        end
    end
end
if length(lims) ~= dim
    error('histn: dimensionality of limits and data does not match');
end

%make sure all the delta are set up properly. Fill in any that are empty
if ~exist('delta') || isempty(delta)
    delta = cell(1,dim);
    if any(cellempty(delta))
        for d=1:dim
            if isempty(delta{d}) || delta{d} <= 0
                delta{d} = (lims{d}(2)-lims{d}(1))/100;
            end
        end
    end
end
if length(delta) ~= dim
    error('histn: dimensionality of delta and data does not match');
end

histsize = zeros(1, dim);
for d=1:dim
    minLims{d} = lims{d}(1);
    maxIdx{d} = ceil( (lims{d}(2)-lims{d}(1))/delta{d});
    axes{d} = lims{d}(1):delta{d}:lims{d}(2);
    if numel(axes{d}) < 2
        warning('histn: one axis only has one element');
    end
    histsize(d) = maxIdx{d}; %number of bins for each dimension
    if length(axes{d}) ~= histsize(d)
        axes{d} = axes{d}(1:histsize(d));
    end
end

%convert from cell array to numerical array
delta = util.cellcat(delta)';
minLims = util.cellcat(minLims)';

% compute the stride needed for each dimension 
histstride = ones(1,dim);
for d=2:dim
    histstride(d) = histstride(d-1)*histsize(d-1);
end

% allocate the histogram
if dim == 1
    histogram = zeros(histsize,1);
    histcount = zeros(histsize,1);
else
    histogram = zeros(histsize);
    histcount = zeros(histsize);
end
% get the bin indexes, based on the data, limits, and deltas
% this is zero based, not one based

eps=1e-6;
coords = floor( (data - repmat(minLims, numPoints,1)) ./ repmat(delta, numPoints, 1) + eps);

% make sure all the coordinates are inside the histogram
good = coords >= 0 & coords < repmat(histsize, numPoints, 1);
goodvec = good(:,1);
for d = 2:dim
    goodvec = goodvec & good(:,d);
end
good = goodvec;

data = data(good,:);
coords = coords(good, :);
weights = weights(good,:);
numPoints = size(coords, 1);

% convert the indexes into a single index 
idx = sum(coords .* repmat(histstride, numPoints, 1),2)+1;
for ii = 1:length(idx)
    histogram(idx(ii)) = histogram(idx(ii))+weights(ii);
    histcount(idx(ii)) = histcount(idx(ii))+1;
end
totalWeight = sum(histogram(:));

if exist('bSmooth', 'var') && ~isempty(bSmooth) &&  ((isa(bSmooth, 'logical') && bSmooth) || isa(bSmooth, 'double'))
    if isa(bSmooth, 'logical') && bSmooth % Gaussian smooth 
        smoothkernel = geometry_algorithm.gausskerneln(dim, 9, .33);
        histogram = convn(histogram, smoothkernel, 'same');
    elseif length(bSmooth)==length(delta) % Gaussian kernal / Parzen window / Kernel estimation        
        bins = geometry_algorithm.makeIndexCube(histsize)-1;
        numBins = size(bins,1);
        centers = bins.*repmat(delta, numBins,1)+repmat(minLims+delta/2, numBins,1);
        centeridx = sum(bins .* repmat(histstride, numBins, 1),2)+1;

        if length(centeridx)/length(idx) > .25
            %if there are not a lot of points with respect to the number of
            %bins, use some thresholds on the distance between the points
            %and the centers of the bin
            dThresh = repmat(sqrt(bSmooth)*4, size(data,1),1);
            for ii = 1:length(centeridx)
                X = util.rowsub(data, centers(ii,:));
                toUse = all(abs(X)<dThresh,2);
                histogram(centeridx(ii)) = sum (mvnpdf(centers(ii,:), data(toUse,:), bSmooth).*weights(toUse,:));
            end
        else
            %if there are a lot of points, keep track of the indexes
            %belonging to each bin and collect the indexes for each bin
            ptIdx = cell(size(histogram));
            ptCount = ones(size(histogram));
            for ii=1:numel(histogram)
                ptIdx{ii} = zeros(histcount(ii),1);
            end
            for ii = 1:length(idx)
                ptIdx{idx(ii)}(ptCount(idx(ii))) = ii;
                ptCount(idx(ii)) = ptCount(idx(ii))+1;
            end
            
            dThresh = repmat(sqrt(bSmooth)*4, size(centers,1),1);
            tic
            for ii = 1:length(centeridx)
                closeCenters = all(util.between(centers, util.rowadd(-dThresh, centers(ii,:)), util.rowadd(dThresh, centers(ii,:))),2);
                toUse = util.cellcat(ptIdx(closeCenters));
                
                histogram(centeridx(ii)) = sum (mvnpdf(centers(ii,:), data(toUse,:), bSmooth).*weights(toUse,:));
                if mod(ii, 1000) == 0
                    disp(sprintf('%0.2f minutes. %d out of %d bins\n', toc/60, ii, length(centeridx)));
                    drawnow;
                end
            end
        end
        histogram = histogram / sum(histogram(:)) * totalWeight;
    end
end

%normalize to sum to one
if exist('bNorm', 'var') && ~isempty(bNorm) && bNorm
    histogram = histogram / sum(histogram(:));
end

end
