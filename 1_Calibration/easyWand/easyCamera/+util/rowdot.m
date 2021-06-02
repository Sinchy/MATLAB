function out = rowdot(in1, in2)
% calculates the dot products of two sets of vectors
%
% @param[in] input - a 2D array where the vectors whose length should be calculated
% are the rows of the matrix
%
% @return a 1D column vector containing the magnitude of each row of the
% matrix.
%

if any(size(in1) ~= size(in2))
    error('rowdot: incompatible input dimensions');
end

out = sum(in1 .* in2, 2);

end