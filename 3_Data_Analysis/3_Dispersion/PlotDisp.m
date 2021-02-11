function PlotDisp(disp_matrix, veldiff_matrix)

num_pair = size(disp_matrix, 1);
if num_pair > 5000, num_pair = 5000; end
figure;
for i = 1 : num_pair
dt=1/4000;
disp = nonzeros(disp_matrix(i, :)).^.5/1000;
vel = nonzeros(veldiff_matrix(i,:)).^.5;
if isempty(disp)
    continue;
end
t = dt:dt:dt*length(disp);
z = zeros(size(t));
h = surface([t;t], [disp'; disp'], [z;z], [vel(2:end)'; vel(2:end)'], ...
    'facecol','no',...
'edgecol','interp',...
'linew',1);
% h.EdgeAlpha = 0.2;
% h=plot(dt:dt:dt*length(disp), disp, 'b-'); h.Color(4) = 0.1;
hold on
end
 colormap(jet)
colorbar
% set(gca,'ColorScale','log')
end

