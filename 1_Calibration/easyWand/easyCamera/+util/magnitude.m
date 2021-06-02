function m = magnitude(input)
% calculates the magnitude of a set of vectors
%
% @param[in] input - a 2D array where the vectors whose length should be calculated
% are the rows of the matrix
%
% @return a 1D column vector containing the magnitude of each row of the
% matrix.
%
    if size(input,1) == 1
        m = norm(input);
    else
        m = sqrt(sum(input.^2, 2));
    end
end