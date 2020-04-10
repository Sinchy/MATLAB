function len = LengthOfPairs(disp_matrix)

num_pairs = size(disp_matrix, 1);
len = zeros(num_pairs, 1);
for i = 1 : num_pairs
    disp = nonzeros(disp_matrix(i, :));
    len(i) = length(disp);
end

end

