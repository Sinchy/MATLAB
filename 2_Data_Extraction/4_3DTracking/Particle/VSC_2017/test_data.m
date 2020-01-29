load data.mat;
load camParaCalib_VSC.mat;
load calout.mat

calarray=calout;
p2d1=calibProj_Tsai(camParaCalib(1),data(:,1:3));
p2d2=calibProj_Tsai(camParaCalib(2),data(:,1:3));
p2d3=calibProj_Tsai(camParaCalib(3),data(:,1:3));
p2d4=calibProj_Tsai(camParaCalib(4),data(:,1:3));

p2d=[p2d1,p2d2,p2d3,p2d4];


for icam=1:ncams
cam2d(:,:,icam)=p2d(:,(icam-1)*2+1:(icam-1)*2+2);
cam2d(:,1,icam)=(cam2d(:,1,icam)-camParaCalib(icam).Npixw/2-camParaCalib(icam).Noffw)*camParaCalib(icam).wpix;
cam2d(:,2,icam)=(-cam2d(:,2,icam)+camParaCalib(icam).Npixh/2-camParaCalib(icam).Noffh)*camParaCalib(icam).hpix;  %vertical coordinate needed to be switched in sign to make it work--I thought the relection in the rotation matrix took care of this--but it doesn't work without this sign negative
end


[ray3mismatch,h,pall] = ray_mismatch(calarray, cam2d, ncams);

pp2d1=calibProj_Tsai(camParaCalib(1),pall');

diff=p2d1(:,1:2)-pp2d1(:,1:2);
diff3 = pall'-data(:,1:3);