function theta = angleBtwNDVectors(u,v)
% angle in radians between two sets of N-D vectors (between 2D, 3D, 4D...
% vectors)

% INPUT:
%     vec1 = M x N [ i j k ...] each row is a vector
%     vec2 = P x N [ i j k ...] each row is a vector
    
% OUTPUT:
%     ThetaInRadians = M x P matrix comparing each vector (row) in vec1 to vec2
%     ThetaInRadians = M x M matrix if only one input

dotUV = dot(u, v);
normU = norm(u);
normV = norm(v);

theta = acos(dotUV/(normU * normV));
end