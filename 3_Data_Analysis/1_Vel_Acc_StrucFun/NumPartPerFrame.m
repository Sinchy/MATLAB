function num_particle = NumPartPerFrame(data)
or3d = sortrows(data,4);
[~,~,ic] = unique(data(:, 4));
num_particle = accumarray(ic,1);
end

