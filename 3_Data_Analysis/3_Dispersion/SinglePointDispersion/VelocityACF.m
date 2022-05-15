function [ACF, ACF_m] = VelocityACF(tracks, numlags)
[trID, ~, ic] = unique(tracks(:, 5));
tr_length = accumarray(ic, 1);
trID = trID(tr_length > numlags + 20);
num_track = length(trID);
if num_track > 10000
    ind = randperm(num_track, 10000);
    trID = trID(ind);
    num_track = 10000;
end
ACF = zeros(num_track, numlags, 3);
for i = 1 : num_track
    track = tracks(tracks(:, 5) == trID(i), :);
    for j = 1 : 3
        ACF(i, :, j) = autocorr(track(:, j), NumLags=numlags-1);
    end
end
ACF_m = zeros(numlags, 6);
for i = 1 : 3
    for j = 1 : numlags
        acf = ACF(:, j, i);
        ACF_m(j, i) = mean(acf);
        ACF_m(j, i + 3) = 1.96 *  std(acf) / (size(acf, 1)) ^.5; % 95% CI;
    end
end
end

