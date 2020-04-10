function PlotDisp(disp_matrix)

num_pair = size(disp_matrix, 1);
figure;
for i = 1 : num_pair
dt=1/4000;
disp = nonzeros(disp_matrix(i, :));
if isempty(disp)
    continue;
end
h=plot(dt:dt:dt*length(disp), disp, 'b-'); h.Color(4) = 0.1;
hold on
end

end

