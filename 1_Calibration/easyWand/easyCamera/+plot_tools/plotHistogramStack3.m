function plotHistogramStack3(data, axes, stackdim, sliceIncrement, transformationMatrix)

hold on;
dims = size(data);
if length(dims) == 2
    dims(3)=1;
end
xaxis = axes{1};
yaxis = axes{2};
zaxis = axes{3};
if ~exist('sliceIncrement', 'var') || isempty(sliceIncrement)
    sliceIncrement=1;
end

if ~exist('transformationMatrix', 'var')
    transformationMatrix = [];
end

if stackdim == 'x' || stackdim == 1
    for x=1:sliceIncrement:dims(1)
        X = ones(dims(2), dims(3))*xaxis(x);
        Y = repmat(yaxis', 1, dims(3));
        Z = repmat(zaxis, dims(2), 1);
        if ~isempty(transformationMatrix)
            [X, Y, Z] = geometry_algorithm.transformPlane(X, Y, Z, transformationMatrix);
        end
        C = squeeze(data(x,:,:));
        surf(X,Y,Z,C);
    end
elseif stackdim == 'y' || stackdim == 2
    for y=1:sliceIncrement:dims(2)
        X = repmat(xaxis', 1, dims(3));
        Y = ones(dims(1), dims(3))*yaxis(y);
        Z = repmat(zaxis, dims(1), 1);
        if ~isempty(transformationMatrix)
            [X, Y, Z] = geometry_algorithm.transformPlane(X, Y, Z, transformationMatrix);
        end
        C = squeeze(data(:, y, :));
        surf(X,Y,Z,C);
    end
elseif stackdim=='z' || stackdim == 3
    for z=1:sliceIncrement:dims(3)
        X = repmat(xaxis, dims(2), 1);
        Y = repmat(yaxis', 1, dims(1)); 
        Z = ones(dims(2), dims(1))*zaxis(z);
        if ~isempty(transformationMatrix)
            [X, Y, Z] = geometry_algorithm.transformPlane(X, Y, Z, transformationMatrix);
        end
        C = squeeze(data(:,:,z))';
        surf(X,Y,Z,C);
    end
end
    set(gca, 'xtick', xaxis(1:sliceIncrement:end));
    set(gca, 'ytick', yaxis(1:sliceIncrement:end));
    set(gca, 'ztick', zaxis(1:sliceIncrement:end));


    shading flat;
    hidden off;
    alpha(.8);
axis equal;
    
colorbar;

end

