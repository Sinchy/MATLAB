function img = ParticleFilter(img, position)
% Creat filter
[h, w] =  size(img);
filter = zeros(h, w);

num_part = size(position, 1);

particle_rad = 2;

for i =  1 : num_part
    for x = max(1,floor(position(i, 1)-particle_rad)):min(w,floor(position(i, 1)+particle_rad))
       for y = max(1,floor(position(i, 2)-particle_rad)):min(h,floor(position(i, 2)+particle_rad))
            if x < 1 || y < 1 || x > w  ||y > h
                continue;
            end

            filter(y,x) = 1;
       end
   end
end 

img = uint16(double(img) .* filter);

end

