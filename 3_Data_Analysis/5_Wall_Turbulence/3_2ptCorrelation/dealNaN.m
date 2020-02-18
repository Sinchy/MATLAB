function [data] = dealNaN(data)

for i=1:size(data,1)
    for j=1:size(data,2)
        
        if isnan(data(i,j)) == 1 || isinf(data(i,j)) == 1
            data(i,j) = 0;
        end
        
    end
end