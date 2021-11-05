function p = filterkernel(D,r)
p = 15 * ( (D/2)^2 - r.^2)/(8*pi*(D/2)^5);
end

