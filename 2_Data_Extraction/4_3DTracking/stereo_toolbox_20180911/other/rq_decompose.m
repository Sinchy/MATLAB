function [K, R] = rq_decompose( P )
% implementation of the rq_decomposition algorithm H/Z p.579

Qx = eye(3);
Qy = eye(3);
Qz = eye(3);
%P = P./norm(P(3,1:3));

%(i) find Qx so that P(3,2) => 0
c = -P(3,3)/sqrt(P(3,2)^2 + P(3,3)^2) ;
s =  P(3,2)/sqrt(P(3,2)^2 + P(3,3)^2) ;
Qx(2,2) = c; Qx(3,3) = c; 
Qx(3,2) = s; Qx(2,3) = -s;

P_test = P*Qx;
%check if diagonal entries remain/get positive.
if P_test(2,2)<0
    Qx(2,2) = -c; Qx(3,3) = -c; 
    Qx(3,2) = -s; Qx(2,3) = +s;
    P_test = P*Qx;
end
P = P_test;


%(ii) find Qy, so that P(3,1) => 0
c = P(3,3)/sqrt(P(3,1)^2 + P(3,3)^2) ;
s = P(3,1)/sqrt(P(3,1)^2 + P(3,3)^2) ;
Qy(1,1) = c; Qy(3,3) = c;
Qy(1,3) = s; Qy(3,1) = -s;

P_test = P*Qy;
%K is required to have positive diagonal entries
if P_test(1,1)<0
    Qy(1,1) = -c; Qy(3,3) = -c;
    Qy(1,3) = -s; Qy(3,1) = +s;
    P_test = P*Qy;
end
P = P_test;

%(iii) find Qz, so that P(2,1) = 0
c = -P(2,2)/sqrt(P(2,2)^2 + P(2,1)^2) ;
s =  P(2,1)/sqrt(P(2,2)^2 + P(2,1)^2) ;
Qz(1,1) = c; Qz(2,2) = c;
Qz(2,1) = s; Qz(1,2) = -s;

P_test = P*Qz;

if c<0
    Qz(1,1) = -c; Qz(2,2) = -c;
    Qz(2,1) = -s; Qz(1,2) = +s;
    P_test = P*Qz;
end
P = P_test;
    

K = P;

R = Qz'*Qy'*Qx';




end

