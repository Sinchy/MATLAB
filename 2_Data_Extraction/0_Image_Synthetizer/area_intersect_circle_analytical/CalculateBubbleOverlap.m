function overlap = CalculateBubbleOverlap(tracks, radius, camParaCalib)
addpath D:\0.Code\MATLAB\2_Data_Extraction\0_Image_Synthetizer
frame_no = unique(tracks(:,4));
n_frame = length(frame_no);
overlap = cell(n_frame, 1);
ncam = size(camParaCalib, 1);
for i = 1 : n_frame
    frame = tracks(tracks(:, 4) == frame_no(i), :);
    n_particle = size(frame, 1);
    pos2D = zeros(n_particle, ncam * 2);
    r = zeros(n_particle, 1);
    for j = 1 : n_particle
        r(j) = radius(radius(:,1) == frame(j, 5), 2);
    end
    for j = 1 : ncam
        pos2D(:, (j - 1) * 2 + 1: j * 2 ) = calibProj_Tsai(camParaCalib(j), frame(:, 1:3));
    end
    frame_overlap = zeros(n_particle, ncam);
    for j = 1 : ncam
        ind = pos2D(:, (j - 1) * 2 + 1) < 1 | pos2D(:, (j - 1) * 2 + 1)  > camParaCalib(j).Npixw ...
            | pos2D(:, j * 2) < 1 | pos2D(:, j * 2)  > camParaCalib(j).Npixh;
        frame_overlap(ind, j) = -1; % out of image
        pos2D_img = pos2D(~ind, (j - 1) * 2 + 1: j * 2);
        r_img = r(~ind);
        G = [pos2D_img r_img];
        M = area_intersect_circle_analytical(G);
        frame_overlap(~ind, j) = (sum(M, 2) - diag(M)) ./ diag(M);
    end
    overlap{i} = [frame_overlap frame(:, 5)];
end

end

