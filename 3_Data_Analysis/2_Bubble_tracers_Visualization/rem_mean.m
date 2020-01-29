% plot_basics.m
% VARIABLES = "x [mm]" "y [mm]" "z [mm]" "u [m/s]" "v [m/s]" "w [m/s]" "|V| [m/s]" "I" "time step" "track id" "ax [m/s�]" "ay [m/s�]" "az [m/s�]" "|a| [m/s�]"

% %% load file
% 
% fid = ['Particles.txt'];
% text = fopen(fid);
% 
% d = textscan(text, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f', 'HeaderLines',2, 'Delimiter','\n', 'CollectOutput',1);
% 
% data = d{1};
% 

function [vel_fluct, mean_info] = rem_mean(filter_data, xmin,xmax,ymin,ymax,zmin,zmax,gridpts)

    addpath 1-Basics/;
    addpath 2-EStruct/;

    data = filter_data;
  
    x_edge = linspace(xmin, xmax, gridpts);
    y_edge = linspace(ymin, ymax, gridpts);
    z_edge = linspace(zmin, zmax, gridpts);


%% average velocity field
      
  %meanu
  
  [meanu edge mid loc]= histcn([data(:,1) data(:,2) data(:,3)], x_edge, y_edge, z_edge, 'AccumData', data(:,6), 'Fun', @mean);
  [meanv edge mid loc] = histcn([data(:,1) data(:,2) data(:,3)], x_edge, y_edge, z_edge, 'AccumData', data(:,7), 'Fun', @mean);
  [meanw edge mid loc] = histcn([data(:,1) data(:,2) data(:,3)], x_edge, y_edge, z_edge, 'AccumData', data(:,8), 'Fun', @mean);

  loc(find(loc(:,1)==0),1)=loc(find(loc(:,1)==0),1)+1;
  loc(find(loc(:,2)==0),2)=loc(find(loc(:,2)==0),2)+1;
  loc(find(loc(:,3)==0),3)=loc(find(loc(:,3)==0),3)+1;
  
  linearInd = sub2ind(size(meanu),loc(:,1),loc(:,2),loc(:,3));
  
%% subtract mean
  
  vel_fluct(:,1) = data(:,6)-meanu(linearInd);
  vel_fluct(:,2) = data(:,7)-meanv(linearInd);
  vel_fluct(:,3) = data(:,8)-meanw(linearInd);
  
  
%% Saving the mean velocity
  xGridSize = x_edge(2) - x_edge(1);   yGridSize = y_edge(2) - y_edge(1);   zGridSize = z_edge(2) - z_edge(1);
  XGrid = x_edge(1:end-1) + xGridSize/2;
  YGrid = y_edge(1:end-1) + yGridSize/2;
  ZGrid = z_edge(1:end-1) + zGridSize/2;
  
  [X,Y,Z] = meshgrid(XGrid,YGrid,ZGrid);
  X = reshape(X,[(gridpts-1)^3 1]);
  Y = reshape(Y,[(gridpts-1)^3 1]);
  Z = reshape(Z,[(gridpts-1)^3 1]);
  
  U = reshape(meanu,[(gridpts-1)^3 1]);
  V = reshape(meanv,[(gridpts-1)^3 1]);
  W = reshape(meanw,[(gridpts-1)^3 1]);

  mean_info = [X,Y,Z,U,V,W];


end