function particle3D = ReadParticles(filepath)
% particles = frame1Loop0New;
fileID = fopen(filepath,'r');
formatspec = '%f,';
particles = fscanf(fileID, formatspec);
l = length(particles);
for i = 1 : l/12
    particle3D(i, :) = particles(((i - 1) * 12 + 1) : ((i - 1) * 12 + 3)); 
end
% particles = reshape(particles, [3 l/3]);
% particles = particles';
end