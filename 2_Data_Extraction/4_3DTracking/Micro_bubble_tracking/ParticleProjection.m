function [img, I] = ParticleProjection(img, cam, pos3D, dp, x, y)
% Reference: Rossi, et al, Exp Fluids, 2012

camParaCalib = cam.camParaCalib;
% Camera position
cam_pos = (camParaCalib.R \ ( - camParaCalib.T))' ; %unit: mm

% distant from focus plane to lens
s0 = norm(cam_pos);

% M
M = camParaCalib.f_eff / s0;

% wavelength of green LED
lambda = 550/1e6; %unit: mm

% focal number
f_n = 32;
f = 180;
% aperture size
Da = f / f_n;

% diffration diameter
ds = 2.44 * (M + 1) * lambda * f_n;

% defocus diameter
% distance from the focus plane
z = abs(dot(pos3D, -cam_pos ./ norm(cam_pos)));
df = M * z * Da / (s0 + z);

% particle image diameter
de = ((M * dp) ^2 + ds^2 + df^2) ^.5;

% beta
beta2 = 3.67;
% assume that for focus particle, the pixel intensity at the edge is 250
% this assumption is reasonable for large particle, the intensity is
% satuated.
% Jp is the light from a particle, thus Jp should be a function of particle
% size
Jp = 250 * 4 * pi * ((M * dp) ^2 + ds^2) * s0^2/exp(-beta2) * .05 ;

% particle center on image (pixel value)
pos2D_mm =cam.WorldToImage(pos3D');
pos2D = cam.Distort(pos2D_mm);
[npixh, npixw] = size(img);
if pos2D(1) > 1 && pos2D(1) < npixw && pos2D(2) > 1 && pos2D(2) <  npixh
    % set projection area 
%     de_pix = norm(cam.Distort([de, 0, 0] + pos2D_mm) - pos2D);
    de_pix = norm(cam.Distort([de, 0, 0]) - cam.Distort([0, 0, 0]));
    project_range = de_pix * 1.5;
    x_min = floor(max(1, pos2D(1) - project_range/2));
    x_max = ceil(min(npixw, pos2D(1) + project_range/2));
    y_min = floor(max(1, pos2D(2) - project_range/2));
    y_max = ceil(min(npixh, pos2D(2) + project_range/2));
    
    for i = x_min:x_max
        for j = y_min:y_max
            img(j, i) = max(img(j, i), uint8(round(Jp / ( 4 * pi * de^2 * (s0 + z)^2) * exp(-4 * beta2 * norm([i, j, 0] - pos2D) ^ 2 / de_pix^2))));
        end
    end
end
if exist('x', 'var')
    I = Jp / ( 4 * pi * de^2 * (s0 + z)^2) * exp(-4 * beta2 * norm([x, y, 0]' - pos2D) ^ 2 / de^2);
end
end

