% dir = 'C:\MyProjects\11.02.17-Run1-ParticlesOnly\Properties\4cams\ImgPreproc\AddCameraAttributes\ShakeTheBox_01\';
fid = ['/home/sut210/Documents/MATLAB/Particle/Code improvement/10.31.17-ParticlesOnly.txt'];
text = fopen(fid);

d = textscan(text, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f', 'HeaderLines',2, 'Delimiter','\n', 'CollectOutput',1);

LaVision_tracks = d{1};

%%

LaVision_tracks = LaVision_tracks(:,:);