function particles_info = ParticleInfo(img, inten_thred)
img_bw = img > inten_thred;
stats = regionprops('table',img_bw,'Centroid',...
'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = [stats.MajorAxisLength stats.MinorAxisLength];
particles_info = [centers, diameters];
end

