function [VCF, velcor_matrix] = VelocistyCorrealteFun(tracks,pairs)

num_pair = size(pairs, 1);

len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
velcor_matrix = zeros(num_pair, len - 19);
for i = 1 : num_pair
    i
    track1 = tracks(tracks(:,5) == pairs(i, 1), :);
    track2 = tracks(tracks(:,5) == pairs(i, 2), :);
    track1 = track1(track1(:,4) >= pairs(i, 3), :);
    track2 = track2(track2(:,4) >= pairs(i, 3), :);
    len1 = size(track1, 1);
    len2 = size(track2, 1);
    len = min(len1, len2);
    if len < 19 
        continue;
    end
    r = zeros(3, len - 19);
    for j = 1 : 3
        c = xcorr(track1(1 : len, 5 + j), track2(1 : len, 5 + j), len - 19, 'coeff');
        r(j, :) = c(end - (len - 19) + 1:end);
    end
    velcor_matrix(i, 1 : len - 19) = mean(r);
%     vel_cor = zeros(len - 19, 1);
%     for j = 0 : len - 20
%         cor = zeros(len - j, 1);
%         for k = 1 : len - j
%             cor(k) = dot(track1(k, 6:8), track2(k + j, 6:8)) / (norm(track1(k, 6:8)) * norm(track2(k + j, 6:8)));
%         end
%         vel_cor(j + 1) = mean(cor);
%     end
%     velcor_matrix(i, 1 : len - 19) = vel_cor;
end
len = max(tracks(:,4)) - min(tracks(:,4)) + 1;
VCF = zeros(len - 19, 1);
for i = 1 : len - 19
    disp = nonzeros(velcor_matrix(:, i));
    if ~isempty(disp)
        VCF(i) = mean(disp);
    end
end
VCF = nonzeros(VCF);
end

