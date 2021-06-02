function Y = normalizeVectors(X)
% normalizes a set of vectors to be of length 1
% vectors of length 0 are unmodified
%
% usage: output = normalizeVectors(input);
%
% @param[in] input - a 2D array where the vectors are the rows of the
% matrix
%
% @return a 2D array with the rows of the matrix as the normalized vectors
%
Y = zeros(size(X));

width = size(X,2);
denom = util.magnitude(X);

if size(X,1) == 1
    if denom == 0
        return
    end
    Y = X/denom;
else
    idx = denom ~= 0;
    if(~any(idx))
        return;
    end
    denom = repmat(denom,[1 width]);
    Y(idx,:) = X(idx,:) ./ denom(idx,:);
end
end
