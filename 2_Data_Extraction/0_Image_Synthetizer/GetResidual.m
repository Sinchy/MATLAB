function residual = GetResidual(img, calib_path, tracked)

    I = zeros(1024,1024,4);
    % load('synthetic_data3D_frame_wise.mat');

%     x3Dmin = -25; y3Dmin = -25; z3Dmin = -25;
%     x3Dmax = 25; y3Dmax = 25; z3Dmax = 25; %dimension of 3D volume in mm
    % m = 3; % number of subvolumes

    %OTF Parameters for each camera
%     [a0,b0,c0,alpha0,x0,y0,z0] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,0);
%     [a1,b1,c1,alpha1,x1,y1,z1] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,1);
%     [a2,b2,c2,alpha2,x2,y2,z2] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,2);
%     [a3,b3,c3,alpha3,x3,y3,z3] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,3);
    
    particle_frame = tracked;

    for p = 1 : size(particle_frame, 1)
%     X = frame(p,1);
%     Y = frame(p,2);
%     Z = frame(p,3);
    
%     X = bound(new_points(1,p,k)) * (x3Dmax - x3Dmin) / (2*pi)  + x3Dmin;
%     Y = bound(new_points(2,p,k)) * (y3Dmax - y3Dmin)  / (2*pi)  + y3Dmin;
%     Z = bound(new_points(3,p,k)) * (z3Dmax - z3Dmin)  / (2*pi)  + z3Dmin;
    Pos3D = particle_frame(p, 1:3);
    I =  Proj2d_IntV2(I, Pos3D, calib_path); %'/media/Share2/Public/Shiyong_Backup/Synthetic_data/VSC_Calib_11.03.17.mat');
    end
    
    residual = double(img) - I;
    residual(residual(:) < 0) = 0;
    residual = uint8(residual);
end

