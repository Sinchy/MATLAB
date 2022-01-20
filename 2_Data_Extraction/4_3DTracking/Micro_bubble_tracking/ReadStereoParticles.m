function particles = ReadStereoParticles(filepath)

fileID = fopen(filepath,'r');
formatspec = '%f,';
particles = fscanf(fileID, formatspec);
n = length(particles);
particles = reshape(particles, 13, n / 13 )';
particles = particles(:, [1:6 8:9 11:12 7 10 13]);

end

