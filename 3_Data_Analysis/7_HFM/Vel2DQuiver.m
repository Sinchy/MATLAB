function Vel2DQuiver(x, y, z, u, v, w, plane, location, time)
if plane == 'XY'
    ind = abs(z - location) < 1e-2;
    X = x(ind);
    Y = y(ind);
    U = u(ind, time);
    V = v(ind, time);
elseif plane == 'XZ'
    ind = abs(y - location) < 1e-2;
    X = x(ind);
    Y = z(ind);
    U = u(ind, time);
    V = w(ind, time);    
else 
    ind = abs(x - location) < 1e-2;
    X = y(ind);
    Y = z(ind);
    U = v(ind, time);
    V = w(ind, time);
end
figure;
    quiver(X, Y, U, V);
end

