function veldiff_matrix = CombineVeldiffMatrix(veldiff_matrix1, veldiff_matrix2)
[num_pairs1, len_time1] = size(veldiff_matrix1);
[num_pairs2, len_time2] = size(veldiff_matrix2);
len_time = max(len_time1, len_time2);
veldiff_matrix = zeros(num_pairs1 + num_pairs2, len_time);
veldiff_matrix(1:num_pairs1, 1:len_time1) = veldiff_matrix1;
veldiff_matrix(num_pairs1 + 1 : num_pairs1 + num_pairs2, 1:len_time2) = veldiff_matrix2;
end

