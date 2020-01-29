[C,ia,ic] = unique(data_Lav(:,1));
a_counts = accumarray(ic,1);
a_counts = [C a_counts];
repeated_element = a_counts(a_counts(:,2) > 1, :);
n_repeat = size(repeated_element, 1);

for i = 1 : n_repeat
    element_repeated = data_Lav(data_Lav(:,1) == repeated_element(i, 1), :);
    n_element = size(element_repeated, 1);
    for j = 2 : n_element
        if (element_repeated(j, 2) == element_repeated(1, 2) && element_repeated(j, 3) == element_repeated(1, 3))
            data_Lav(data_Lav(:, 4) == element_repeated(j, 4) & data_Lav(:, 5) == element_repeated(j, 5), :) =[];
        end
    end
    
end