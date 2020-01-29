function I = Proj2d_IntV2(I, Pos3D,cali_path)
% global I a0 a1 a2 a3 b0 b1 b2 b3 c0 c1 c2 c3 alpha1 alpha2 alpha3 alpha0 x0 x1 x2 x3 y0 y1 y2 y3 z0 z1 z2 z3;
load(cali_path);
Xp = Pos3D(1); Yp = Pos3D(2); Zp = Pos3D(3); 
particle_rad = 2;

% Rotation Matrix
% R0 = zeros(3,3);R1 = zeros(3,3);R2 = zeros(3,3); R3 = zeros(3,3);
% R0(:,1) = Cam0(10:12); R0(:,2) = Cam0(13:15); R0(:,3) = Cam0(16:18);
% R1(:,1) = Cam1(10:12); R1(:,2) = Cam1(13:15); R1(:,3) = Cam1(16:18);
% R2(:,1) = Cam2(10:12); R2(:,2) = Cam2(13:15); R2(:,3) = Cam2(16:18);
% R3(:,1) = Cam3(10:12); R3(:,2) = Cam3(13:15); R3(:,3) = Cam3(16:18);
% 
% % Translation Matrix
% T0 = Cam0(19:21); T1 = Cam1(19:21); T2 = Cam2(19:21); T3 = Cam3(19:21);
% 
% % 2D positions in pixels for each cam
% temp0 = Pos3D * R0 + T0'; 
% xc(1) = temp0(1)*(Cam0(7)/temp0(3)); yc(1) = temp0(2)*(Cam0(7)/temp0(3));
% [xc(1),yc(1)] = Distort(xc(1),yc(1),Cam0(8));
% 
% temp1 = Pos3D * R1 + T1'; 
% xc(2) = temp1(1)*(Cam1(7)/temp1(3)); yc(2) = temp1(2)*(Cam1(7)/temp1(3));
% 
% [xc(2),yc(2)] = Distort(xc(2),yc(2),Cam1(8));
% 
% temp2 = Pos3D * R2 + T2'; 
% xc(3) = temp2(1)*(Cam2(7)/temp2(3)); yc(3) = temp2(2)*(Cam2(7)/temp2(3));
% [xc(3),yc(3)] = Distort(xc(3),yc(3),Cam2(8));
% 
% temp3 = Pos3D * R3 + T3'; 
% xc(4) = temp3(1)*(Cam3(7)/temp3(3)); yc(4) = temp3(2)*(Cam3(7)/temp3(3));
% [xc(4),yc(4)] = Distort(xc(4),yc(4),Cam3(8));

xc = zeros(size(Pos3D,1),4);
yc = zeros(size(Pos3D,1),4);

for i = 1:4
    X2D = calibProj_Tsai(camParaCalib(i),Pos3D);
    xc(:,i) = X2D(:,1); yc(:,i) = X2D(:,2);
end

% for i = 1:4
%     if (xc(i) < 6 || xc(i) > 1018 || yc(i) < 6 || yc(i) > 1018) 
%         fprintf(['wrong particle (' num2str(xc(i)) ',' num2str(yc(i)) ')']);
%     end
% end
%2D Intensity projection 

[pixh, pixw,~] = size(I);
for i = 1:4
    % 3D Interpolation of the OTF parameters
%     if (i==1)
%        alpha = interp3(x0,y0,z0,alpha0,Xp,Yp,Zp);
%        a = interp3(x0,y0,z0,a0,Xp,Yp,Zp);
%        b = interp3(x0,y0,z0,b0,Xp,Yp,Zp);
%        c = interp3(x0,y0,z0,c0,Xp,Yp,Zp);
%    elseif (i==2)
%        alpha = interp3(x1,y1,z1,alpha1,Xp,Yp,Zp);
%        a = interp3(x1,y1,z1,a1,Xp,Yp,Zp);
%        b = interp3(x1,y1,z1,b1,Xp,Yp,Zp);
%        c = interp3(x1,y1,z1,c1,Xp,Yp,Zp);                
%    elseif (i==3)
%        alpha = interp3(x2,y2,z2,alpha2,Xp,Yp,Zp);
%        a = interp3(x2,y2,z2,a2,Xp,Yp,Zp);
%        b = interp3(x2,y2,z2,b2,Xp,Yp,Zp);
%        c = interp3(x2,y2,z2,c2,Xp,Yp,Zp);
%    elseif (i==4)
%        alpha = interp3(x3,y3,z3,alpha3,Xp,Yp,Zp);
%        a = interp3(x3,y3,z3,a3,Xp,Yp,Zp);
%        b = interp3(x3,y3,z3,b3,Xp,Yp,Zp);
%        c = interp3(x3,y3,z3,c3,Xp,Yp,Zp);
%     end
           alpha = 0;
       a = 125;
       b = 1.5;
       c = 1.5;
   % Gaussian projection

   for x = max(1,floor(xc(i)-particle_rad)):min(1024,floor(xc(i)+particle_rad))
       for y = max(1,floor(yc(i)-particle_rad)):min(1024,floor(yc(i)+particle_rad))
            if x < 1 || y < 1 || x > pixw  ||y > pixh
                continue;
            end
            xx = (x-xc(i))*cos(alpha) + (y-yc(i))*sin(alpha);
            yy = -(x-xc(i))*sin(alpha) + (y-yc(i))*cos(alpha);
            I(y,x,i) = max(I(y,x,i), a*exp(-(b*(xx)^2 + c*(yy)^2))); % not sure if max is the right thing to use for overlapping particles
            %I(y,x,i) = I(y,x,i) + a*exp(-(b*(xx)^2 + c*(yy)^2));
       end
   end
end

end