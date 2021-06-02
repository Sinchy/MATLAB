function data = rowsub(data, row)
% subtracts a given row to every row of a data matrix
% @param[in] data - an N x M matrix
% @param[in] row - a 1 x M vector
% @return data = data - repmat(row, size(data,1), 1);

for c = 1:size(data,2)
    data(:,c) = data(:,c)-row(c);
end
end