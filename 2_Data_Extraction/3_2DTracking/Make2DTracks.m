function tracks2D = Make2DTracks(x_star, y_star, U_star, V_star)
x_min = min(x_star); x_max = max(x_star);
y_min = min(y_star); y_max = max(y_star);

n_pts = 10000;
x = rand(n_pts, 1) * (x_max - x_min) + x_min;
y = rand(n_pts, 1) * (y_max - y_min) + y_min;

num_frame = length(t_star);
tracks2D = zeros(n_pts * num_frame, 6);
tracks2D(1:n_pts, 1:2) = [x y];
tracks2D(1:n_pts, 3) = 1;
tracks2D(1:n_pts, 4) = 1:n_pts;
for i = 1 : num_frame
     
end

end

