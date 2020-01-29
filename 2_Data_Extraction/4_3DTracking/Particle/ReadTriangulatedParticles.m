function particles = ReadTriangulatedParticles(filepath)
% particles = frame1Loop0New;
fileID = fopen(filepath,'r');
formatspec = '%f,';
particles = fscanf(fileID, formatspec);
l = length(particles);
particles = reshape(particles, [4 l/4]);
particles = particles';
end

