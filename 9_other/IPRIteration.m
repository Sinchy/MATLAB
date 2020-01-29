path = '/home/tanshiyong/Documents/Data/SinglePhase/NSD27500_DoF20/ParticlePositions/frame1Loop';
for i = 1 : 6
    particles = ReadParticles([path num2str(i) '.txt']);
    [ghost_percent, ghost_mark] = GhostCheck(particles1, particles);
    particles_real = RemovRepeatedPart(particles(ghost_mark == 0, :));
    particle_info(i, :) = [ghost_percent, sum(ghost_mark) size(particles_real, 1)];
end
particles = [];
for i = 1 : 6
    particles = [particles; ReadParticles([path num2str(i) '.txt'])];
end
    [ghost_percent, ghost_mark] = GhostCheck(particles1, particles);
    particles_real = RemovRepeatedPart(particles(ghost_mark == 0, :));
    
    particle_info(7, :) = [ghost_percent, sum(ghost_mark) size(particles_real, 1)];