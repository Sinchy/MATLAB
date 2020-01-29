ncams = 4;
num_grid = 10;
a = zeros(ncams,num_grid, num_grid, num_grid);
b = zeros(ncams,num_grid, num_grid, num_grid);
c = zeros(ncams,num_grid, num_grid, num_grid);
alpha = zeros(ncams,num_grid, num_grid, num_grid);
a_std = zeros(ncams,num_grid, num_grid, num_grid);
b_std = zeros(ncams,num_grid, num_grid, num_grid);
c_std = zeros(ncams,num_grid, num_grid, num_grid);
alpha_std = zeros(ncams,num_grid, num_grid, num_grid);
dir = '/home/tanshiyong/Documents/Data/Single-Phase/11.03.17/Run1/OTFfiles/';
for i = 1 : num_grid
    for j = 1 : num_grid
        for k = 1 : num_grid
            load([dir 'Grid_' num2str(i) '_' num2str(j) '_' num2str(k) '.mat']);
            for m = 1 : ncams
                if ~isempty(nonzeros(OTFParam_array(m, :, :))) 
                    a(m, i, j , k) = mean(nonzeros(OTFParam_array(m, :, 1)));
                    alpha(m, i, j , k) = mean(nonzeros(OTFParam_array(m, :, 2)));
                    b(m, i, j , k) = mean(nonzeros(OTFParam_array(m, :, 3)));
                    c(m, i, j , k) = mean(nonzeros(OTFParam_array(m, :, 4)));
                    a_std(m, i, j , k) = std(nonzeros(OTFParam_array(m, :, 1)));
                    alpha_std(m, i, j , k) = std(nonzeros(OTFParam_array(m, :, 2)));
                    b_std(m, i, j , k) = std(nonzeros(OTFParam_array(m, :, 3)));
                    c_std(m, i, j , k) = std(nonzeros(OTFParam_array(m, :, 4)));
                end
            end
        end
    end
end
