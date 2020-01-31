
ntime = itmax + 1;

xpar = zeros(ntime,npoints);
ypar = zeros(ntime,npoints);
zpar = zeros(ntime,npoints);

input_position = load('Particles.txt');

% Adjust format
for i = 1:ntime
for j = 1:npoints
    xpar(i,j) = input_position((i-1)*npoints+j,1);
    ypar(i,j) = input_position((i-1)*npoints+j,2);
    zpar(i,j) = input_position((i-1)*npoints+j,3);
end
end

%---------------------------------------------------
%----------------- Plot Trajectory -----------------
%---------------------------------------------------
for i = 1:ntime
    for j = 1:npoints
    scatter3(xpar(i,j),ypar(i,j),zpar(i,j));
    hold on;
    end
end % for i = 1:ntime