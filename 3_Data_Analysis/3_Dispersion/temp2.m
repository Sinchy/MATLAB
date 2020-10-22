for i = 1 : 20
%     du_dx_field = VG.Cal_CGVG_field2(particles, i * 0.08);
%     s(i) = VG.MeanStrain(du_dx_field); w(i) = VG.Entrophy(du_dx_field);
[meanstrain(i), enstrophy(i)] = CoarsGrainStrainEnstrophyModel(0.103, 1.364, 0.0028, i * 0.08);
end