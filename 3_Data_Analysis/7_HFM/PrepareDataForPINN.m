function PrepareDataForPINN(tdim, xdim, ydim, zdim, u, v, w, Re, save_path)
[Y, X, Z] = meshgrid(ydim, xdim, zdim);
t_star = double(tdim);
x_star =  double(reshape(X, [], 1));
y_star =  double(reshape(Y, [], 1));
z_star =  double(reshape(Z, [], 1));
U_star =  double(reshape(u, [], length(tdim)));
V_star =  double(reshape(v, [], length(tdim)));
W_star =  double(reshape(w, [], length(tdim)));
ind = 1:50:size(x_star, 1);
x_star = x_star(ind, :);
y_star = y_star(ind, :);
z_star = z_star(ind, :);
U_star = U_star(ind, :);
V_star = V_star(ind, :);
W_star = W_star(ind, :);
save(save_path, 't_star', 'x_star', 'y_star', 'z_star', 'U_star', 'V_star', 'W_star', 'Re', '-v7.3');
end

