n_point = size(common, 1);

for i = 3 : n_point
    if common(i, 5) ~= common(i - 1, 5) || common(i - 1, 5) ~= common(i - 2, 5)
        continue;
    end
    vel_s1 = (norm(common(i, 1:3) - common(i - 1, 1:3))) * 125 / 1000;
    vel_s2 = (norm(common(i - 1, 1:3) - common(i - 2, 1:3))) * 125 / 1000;
    a_s = (vel_s1 - vel_s2) * 125;
    common(i, 12) = a_s;
    
    vel_1 = (norm(common(i, 6:8) - common(i - 1, 6:8))) * 125 / 1000;
    vel_2 = (norm(common(i - 1, 6:8) - common(i - 2, 6:8))) * 125 / 1000;
    a = (vel_1 - vel_2) * 125;
    common(i, 13) = a;
end