function[A,B,C,Alpha,xq,yq,zq] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,camid)
% 3D volume dimensions (mm)
% x3D x y3D x z3D

% Dividing the volume into m x m x m subvolumes
xstep = (x3Dmax-x3Dmin)/2;
ystep = (y3Dmax-y3Dmin)/2;
zstep = (z3Dmax-z3Dmin)/2;

% assigning OTF parameters for the corners, edge and face centers (origin is the center)
Xc = [x3Dmin 0 x3Dmax];
Yc = [y3Dmin 0 y3Dmax];
Zc = [z3Dmin 0 z3Dmax];
[x,y,z] = meshgrid(Xc,Yc,Zc);
% a1 = 135; a2 = 255; a3 = 200; 
% b1 = 1.5*1.5; b2 = 1.0*1.5; b3 = .6*1.5; 
% c1 = .6*1.5; c2 = 1.0*1.5; c3 = 1.5*1.5; 
% alpha1 = pi/2; alpha2 = 0 ; alpha3 = pi/2;
a1 = 255; a2 = 255; a3 = 255;
b1 = 0.4; b2 = 0.4; b3 = 0.4;
c1 = 0.4; c2 = 0.4; c3 = 0.4;
alpha1 = 0; alpha2 = 0; alpha3 = 0;
if (camid == 0 )
    for i = 1:3
        for j = 1:3
            a(i,j,1) = a1; b(i,j,1) = b1; c(i,j,1) = c1; alpha(i,j,1) = alpha1;
            a(i,j,2) = a2; b(i,j,2) = b2; c(i,j,2) = c2; alpha(i,j,2) = alpha2;
            a(i,j,3) = a3; b(i,j,3) = b3; c(i,j,3) = c3; alpha(i,j,3) = alpha3;
        end
    end
elseif (camid == 1)
    for i = 1:3
        for j = 1:3
            a(i,1,j) = a1; b(i,1,j) = b1; c(i,1,j) = c1; alpha(i,1,j) = alpha1;
            a(i,2,j) = a2; b(i,2,j) = b2; c(i,2,j) = c2; alpha(i,2,j) = alpha2;
            a(i,3,j) = a3; b(i,3,j) = b3; c(i,3,j) = c3; alpha(i,3,j) = alpha3;
        end
    end
elseif (camid == 2)
    for i = 1:3
        for j = 1:3
            a(1,i,j) = a1; b(1,i,j) = b1; c(1,i,j) = c1; alpha(1,i,j) = alpha1;
            a(2,i,j) = a2; b(2,i,j) = b2; c(2,i,j) = c2; alpha(2,i,j) = alpha2;
            a(3,i,j) = a3; b(3,i,j) = b3; c(3,i,j) = c3; alpha(3,i,j) = alpha3;
        end
    end
elseif (camid == 3)
    for i = 1:3
        for j = 1:3
            a(i,j,1) = a3; b(i,j,1) = b3; c(i,j,1) = c3; alpha(i,j,1) = alpha3;
            a(i,j,2) = a2; b(i,j,2) = b2; c(i,j,2) = c2; alpha(i,j,2) = alpha2;
            a(i,j,3) = a1; b(i,j,3) = b1; c(i,j,3) = c1; alpha(i,j,3) = alpha1;
        end
    end
else
    fprint('camid should be between 0 to 4');
end

    
    [xq,yq,zq] = meshgrid(x3Dmin:xstep:x3Dmax,y3Dmin:ystep:y3Dmax,z3Dmin:zstep:z3Dmax);
    
    A = interp3(x,y,z,a,xq,yq,zq);
    B = interp3(x,y,z,b,xq,yq,zq);
    C = interp3(x,y,z,c,xq,yq,zq);
    Alpha = interp3(x,y,z,alpha,xq,yq,zq);
end
