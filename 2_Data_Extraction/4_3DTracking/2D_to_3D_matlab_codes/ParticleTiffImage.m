global I a0 a1 a2 a3 b0 b1 b2 b3 c0 c1 c2 c3 alpha1 alpha2 alpha3 alpha0 x0 x1 x2 x3 y0 y1 y2 y3 z0 z1 z2 z3;

frame = track_3D;

for k = 1:30
    I = zeros(1024,1024,4);
    % load('synthetic_data3D_frame_wise.mat');

    x3Dmin = -30; y3Dmin = -30; z3Dmin = -30;
    x3Dmax = 30; y3Dmax = 30; z3Dmax = 30; %dimension of 3D volume in mm
    % m = 3; % number of subvolumes

    %OTF Parameters for each camera
    [a0,b0,c0,alpha0,x0,y0,z0] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,0);
    [a1,b1,c1,alpha1,x1,y1,z1] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,1);
    [a2,b2,c2,alpha2,x2,y2,z2] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,2);
    [a3,b3,c3,alpha3,x3,y3,z3] = OTFParam(x3Dmin,x3Dmax,y3Dmin,y3Dmax,z3Dmin,z3Dmax,3);
    for p = 1
%     X = frame1(p,1);
%     Y = frame1(p,2);
%     Z = frame1(p,3);
        X = frame(k,1);
        Y = frame(k,2);
        Z = frame(k,3);
        [frame_1x(p,:),frame_1y(p,:)] = Proj2d_Int(X,Y,Z);
    end

    for i = 1:4
        I = uint8(I);
        imwrite(I(:,:,i),[ 'cam' num2str(i) 'frame' num2str(k,'%04.0f') '.tif']);
%           imwrite(I(:,:,i),['temprs' num2str(i) '.tif']);
    end
end

%% 
% A0 = transpose_reshape(a0);
% A1 = transpose_reshape(a1);
% A2 = transpose_reshape(a2);
% A3 = transpose_reshape(a3);
% B0 = transpose_reshape(b0);
% B1 = transpose_reshape(b1);
% B2 = transpose_reshape(b2);
% B3 = transpose_reshape(b3);
% C0 = transpose_reshape(c0);
% C1 = transpose_reshape(c1);
% C2 = transpose_reshape(c2);
% C3 = transpose_reshape(c3);
% Alpha0 = transpose_reshape(alpha0);
% Alpha1 = transpose_reshape(alpha1);
% Alpha2 = transpose_reshape(alpha2);
% Alpha3 = transpose_reshape(alpha3);
%% Save Specific Variables to MAT-File
% save('OTFParameters.mat','A0','A1','A2','A3','Alpha0','Alpha1','Alpha2','Alpha3','B0','B1','B2','B3','C0','C1','C2','C3','-mat')