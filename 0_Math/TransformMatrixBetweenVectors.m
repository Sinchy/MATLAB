function U = TransformMatrixBetweenVectors(a,b)
GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;...
              norm(cross(A,B)) dot(A,B)  0;...
              0              0           1];

FFi = @(A,B) [ A' ((B-dot(A,B)*A)/norm(B-dot(A,B)*A))' (cross(B,A))' ];

UU = @(Fi,G) Fi*G*inv(Fi);

U = UU(FFi(a,b), GG(a,b));

% v = cross(a, b);
% 
% s = norm(v);
% 
% c = dot(a, b);
% 
% v_cross = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
% 
% if c ~= -1
%     U = eye(3) + v_cross + v_cross^2 * (1 - c) / s^2;
% else
%     U = -eye(3);
% end

end

