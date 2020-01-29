
clear all
close all
clc

%%%%%%%%%%%%%%%
% USER INPUTS %
%%%%%%%%%%%%%%%

if ispc == 1
    slash = '\';
else
    slash = '/';
end

path = uigetdir('','Select the directory where the images are');
% path = 'F:\DustyTBL_PIV\PIV_Multiphase\TBL_3000_90us_TestA\Analysis\PhaseSeprataion';
files_LA = dir([path slash '*.LA.TIF']);
files_LB = dir([path slash '*.LB.TIF']);

FolResults_tracer = [path slash 'tracer'];
FolResults_inertial = [path slash 'inertial'];
mkdir(FolResults_tracer);
mkdir(FolResults_inertial);

%%
n = length(files_LA);

tstart_p = tic; % Start computing Time
wb = waitbar(0, '','Name','Removing inertial particles');

for i = 151 : 450%n

    waitbar(i/n,wb,[num2str(i),'/',num2str(n)])
    
    ImgName_LA = files_LA(i).name;
    ImgName_LB = files_LB(i).name;
    
    ImgTemp_LA = double(imread([path slash ImgName_LA]));
    ImgTemp_LB = double(imread([path slash ImgName_LB]));
    
    Med_LAa = medfilt2(ImgTemp_LA,[10 10],'zeros');
    Med_LAb = medfilt2(ImgTemp_LA,[5 5],'zeros');
    Med_LAa = Med_LAa*2;
%     Med_LAa(Med_LAa>0)=2^12;
    
    Med_LBa = medfilt2(ImgTemp_LB,[10 10],'zeros');
    Med_LBb = medfilt2(ImgTemp_LB,[5 5],'zeros');
    Med_LBa = Med_LBa*2;
%     Med_LBa(Med_LBa>0)=2^12;
    
    Edge_LA = edge(Med_LAa,'Canny');
    Edge_LA = double(Edge_LA);
    Edge_LA = uint8(Edge_LA);
    Edge_LA = imdilate(Edge_LA,strel('disk',1));
    Edge_LA = double(Edge_LA);
    Edge_LA(Edge_LA>0) = 2^12;
    
    Edge_LB = edge(Med_LBa,'Canny');
    Edge_LB = double(Edge_LB);
    Edge_LB = uint8(Edge_LB);
    Edge_LB = imdilate(Edge_LB,strel('disk',1));
    Edge_LB = double(Edge_LB);
    Edge_LB(Edge_LB>0) = 2^12;
    
    Med_LAa(Med_LAa < 30) = 0;
    Med_LAb(Med_LAb < 30) = 0; % simply remove background blurred particle caused by median filter
    Med_LBa(Med_LBa < 30) = 0;
    Med_LBb(Med_LBb < 30) = 0;
    
    Final_LA = ImgTemp_LA - Med_LAa - Med_LAb - Edge_LA;
    Final_LB = ImgTemp_LB - Med_LBa - Med_LBb - Edge_LB;
    
    Final_LA_large = Med_LAa + Med_LAb + Edge_LA;
    Final_LB_large = Med_LBa + Med_LBb + Edge_LB;
    
    Final_LA = uint8(Final_LA);
    Final_LB = uint8(Final_LB);
    Final_LB = imhistmatch(Final_LB,Final_LA); % match the brightness
    
    Final_LA_large = uint8(Final_LA_large);
    Final_LB_large = uint8(Final_LB_large);
    Final_LB_large = imhistmatch(Final_LB_large,Final_LA_large);
    
    imwrite(Final_LA,[FolResults_tracer slash 'Tracer_' ImgName_LA],'TIFF')
    imwrite(Final_LB,[FolResults_tracer slash 'Tracer_' ImgName_LB],'TIFF')
    
    imwrite(Final_LA_large,[FolResults_inertial slash 'Inertial_' ImgName_LA],'TIFF')
    imwrite(Final_LB_large,[FolResults_inertial slash 'Inertial_' ImgName_LB],'TIFF')
    
    %     figure;pcolor(Final_LA); shading interp; colormap gray; caxis([0 100])
end
close(wb)
tstop_p = toc(tstart_p);
disp('DONE')
disp([num2str(tstop_p/60) ' minutes taken'])
