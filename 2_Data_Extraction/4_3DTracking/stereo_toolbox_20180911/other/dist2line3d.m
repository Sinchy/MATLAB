function d = dist2line3d(p ,l )
% computes the (shortest) distance of a point in 3d-space p to the line l.
% l should be given in parameterform with l = [x0, y0, z0] + t* [u, v, w].
% l then denotes [x0, y0, z0, u, v, w]


% be sure that everything is a column-vector:
p = reshape(p,[],1);


% two points x1, x2 are needed from the line
x1 = reshape(   l(1:3)  , [],1);
x2 = reshape(   l(1:3)+1.5*l(4:6)   , [],1);

d = norm( cross(p-x1, p-x2) ) / norm(x2-x1);

end 

