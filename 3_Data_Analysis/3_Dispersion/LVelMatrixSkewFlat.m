function [peakvel, S, F] = LVelMatrixSkewFlat(veldiff_matrix, t)
num_t = length(t);

for i = 1 : num_t

% get most probable value
    [peakDensity,xi] = ksdensity(nonzeros(veldiff_matrix(:, t(i))));
    [~,peakIndex] = max(peakDensity);
    peakvel(i) = xi(peakIndex);


    S(i) = skewness(nonzeros(veldiff_matrix(:, t(i))), 0);
    F(i) = kurtosis(nonzeros(veldiff_matrix(:, t(i))), 0);
end
end

