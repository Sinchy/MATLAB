function  PlotParticles(fig, particles, mark )
%PLOTPARTICLES Summary of this function goes here
%   Detailed explanation goes here
figure(fig);
plot3(particles(:,1), particles(:,2), particles(:,3),mark);

end

