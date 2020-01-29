function img = GenerateImage(position, w, h)

img = zeros(h, w);

num_part = size(position, 1);

particle_rad = 2;

for i =  1 : num_part
    for x = max(1,floor(position(i, 1)-particle_rad)):min(w,floor(position(i, 1)+particle_rad))
       for y = max(1,floor(position(i, 2)-particle_rad)):min(h,floor(position(i, 2)+particle_rad))
            if x < 1 || y < 1 || x > w  ||y > h
                continue;
            end

            img(y,x) = max(img(y,x), Gaussian(x - position(i, 1), y - position(i, 2), 250, 0.7)); % not sure if max is the right thing to use for overlapping particles
       end
   end
end

img = uint8(img);
end

function I = Gaussian(dx, dy, A, r)
I = A * exp(- 1 * (dx ^ 2 + dy ^ 2) / (2 * r^2));
end