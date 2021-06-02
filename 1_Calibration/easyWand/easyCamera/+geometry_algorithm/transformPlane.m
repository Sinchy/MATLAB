function [X, Y, Z] = transformPlane(X,Y,Z, transformationMatrix)

originalSize = size(X);

X = X(:);
Y = Y(:);
Z = Z(:);
XYZ = geometry_algorithm.transformPoints([X Y Z], transformationMatrix);
X = XYZ(:,1);
Y = XYZ(:,2);
Z = XYZ(:,3);

X = reshape(X, originalSize);
Y = reshape(Y, originalSize);
Z = reshape(Z, originalSize);

end