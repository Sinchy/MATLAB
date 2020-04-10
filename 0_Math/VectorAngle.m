function angle = VectorAngle(u,v)
c = cross(u,v);
if c(3) < 0
    angle = -atan2(norm(c),dot(u,v));
else
    angle = atan2(norm(c),dot(u,v));
end
end

