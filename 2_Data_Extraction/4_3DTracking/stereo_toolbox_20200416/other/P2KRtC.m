% [K,R,t,C] = P2KRtC(P)
% decompose the euclidean 3x4 projection matrix P into the
% 
% K ... 3x3 upper triangular calibration matrix
% R ... 3x3 rotation matrix
% t ... 3x1 translation vector
% C ... 3x1 position od the camera center
%
% $Id: P2KRtC.m,v 2.0 2003/06/19 12:07:08 svoboda Exp $

function [K,R,t,C] = P2KRtC(P)

%P = P./norm(P(3,1:3));

% [K,R] = rq(P(:,1:3));
% t = inv(K)*P(:,4);
% C = -R'*t;

% testing an alternative method...
p1 = P(:,1);
p2 = P(:,2);
p3 = P(:,3);
p4 = P(:,4);

C = [det([p2 p3 p4]) ; -det([p1 p3 p4]) ; det([p1 p2 p4]) ; -det([p1 p2 p3])];
C = C./C(4); C = C(1:3);

[K,R] = rq_decompose(P(:,1:3));

t = -R*C;
end
