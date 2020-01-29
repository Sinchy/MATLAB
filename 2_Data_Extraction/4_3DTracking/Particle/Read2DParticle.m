function particle2D = Read2DParticle(filepath)
fileID = fopen(filepath,'r');
formatspec = '%f,';
particles = fscanf(fileID, formatspec);
l = length(particles);
for i = 1 : l / 2
    particle2D(i, :) = particles((i - 1) * 2 + 1: (i - 1) * 2 + 2);
end
end

