function predictive_field = PredictiveField(particleinfo_f1, particleinfo_f2, settings)
% this predictive field use two kinds of information: 1: displacement, 2:
% correlation of the size.
grid_number = settings.grid_number;
img_size = settings.image_size;
grid_length = img_size / grid_number;
search_radius = settings.search_radius;
predictive_field = zeros(grid_number + 1, grid_number + 1, 2);

for i = 1 : grid_number + 1
    for j = 1 : grid_number + 1
        particle_ingrid = particleinfo_f1(particleinfo_f1(:,1) > -grid_length/2 + (i - 1) * grid_length & particleinfo_f1(:,1) < -grid_length/2 + i * grid_length ...
            & particleinfo_f1(:,2) > -grid_length/2 + (j - 1) * grid_length & particleinfo_f1(:,2) < -grid_length/2 + j * grid_length, :);
        disp = ParticleSpaceCorrelation(particle_ingrid, particleinfo_f2, search_radius);
        if ~isnan(disp)
            predictive_field(i, j, :) = disp;
        end
    end
end
figure
quiver(predictive_field(:,:,1), predictive_field(:,:,2));
end

