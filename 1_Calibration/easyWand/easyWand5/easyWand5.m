function []=easyWand5()

% function [] = easyWand5()
%
% Easy wand calibration tool for using a sparse bundle adjustment back-end
%
% See the documentation PDF for full usage information.
%
% Ty Hedrick & Evan Bluhm
% Version 5 - Published with JEB Methods manuscript
% Theriault et al. (2014) A protocol and calibration method for accurate
% multi-camera field videography. J. Exp. Biol.

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

fprintf('\n')
disp('Welcome to easyWand version 5.7.7 (Feb 11, 2021)')
disp('Please see the associated PDF documentation for complete usage information')
disp('Visit http://biomech.web.unc.edu/wand-calibration-tools/ for updates')
fprintf('\n')

% April 28, 2015 - fixed some bugs related to loading axis and background
% points together and to displaying gravity-calibration axis points

% May 6, 2015 - fixed display of residuals in the edit ouliers table;
% residuals had been calculated without adjusting for distortion

% May 12, 2015 - added some additional logic to the preliminary calibration
% process to try and better handle some unusual cases where the inputs or
% focal length estimates are not very good

% May 15, 2015 (v5.1) - removed an unnecessary check for NaN values prior to
% twoCamCal_v2

% May 26, 2016 (v5.2) - fixed the processing of optimized camera rotations in
% easySBA and enabled passing these and the SBA translation out as sba_tv
% and sba_R in the data bundle saved at the end of the routine. Note that
% these are NOT aligned to the external reference frame data provided in
% easyWand, instead they are (approximately) aligned with the last camera
% defined in the input data.

% June 10 & 14, 2016 (v5.3) - replaced the old decision tree for
% interpreting 8-point algorithm outputs in calibration initialization with
% a new, cleaner one that in testing produces correct outputs in a much
% wider range of cases. Also fixed a small bug in calculating the inverse
% perspective point positions in triangulate_v2() and updated the table
% handling somewhat to clear old optimized values for 2ndary points once a
% new calibration is available.

% July 28, 2016 - enhanced precision of values in csv export of dlt coefficients

% July 26, 2017 - added "second pass" bundle adjustment calibration for
% cameras that were initially calibrated as secondary

% October & November, 2017 - expanded 2nd pass to include calculating
% points that were not seen by the base camera.

% January 17-23, 2018 - Created an alternative gravity alignment routine using
% polyfit that does not depend on the existence of the spline or curve
% fitting toolbox; updated the lwm transform to use fitgeotrans if
% available

% Summer, 2018 - fixed the undistortion tforms exported for cameras with
% nonlinear lens coefficients to work with MATLAB r2017a & later

% version 5.7.1 October 2019 - changed the translation vector export to
% have all the original SBA information instead of subtracting the position
% of the last camera; helps with direct conversion to DLT.

% version 5.7.3 April 12 2020 - changed initial Fundamental matrix
% estimation to use data from wand point 1 and 2 (and background points)
% instead of just wand point 1 and background.

% version 5.7.4 May 7 2020 - changed translation vector export to have the
% rotation multiplied in to give the full relative camera positions instead
% of just the translation vector

% version 5.7.5 May 25 2020 - added in surface alignment as a fallback if
% the alignment points are a large arbitrary size and gravity calculation
% produces a really bad result

% version 5.7.6 June 23 2020 - put the dlt_computeCoefficients function in
% this file as some users on r2019b and later were reporting problems with
% MATLAB finding it in the +private directory

% version 5.7.7 Feb. 11 2021 - added the missing dlt_inverse.m function to
% the +private directory

% check to make sure another copy isn't already running
runningHandles=findall(0,'Type','figure');
if ~isempty(runningHandles)
  for i=1:size(runningHandles)
    da=get(runningHandles(i));
    if isfield(da,'Tag')&&strcmp(da.Tag,'easyWandMain')
      disp('Another copy of easyWand5 is already running - exiting.');
      return;
    end
  end
end

% check for easySBA
if exist('easySBA','file')~=2
  beep
  disp('easyWand requires easySBA.')
  disp('Please add it to your MATLAB path before running easyWand.')
  return
end

% initialize the userdata structure that easyWand will pass around and also
% save as output
uda.version=5.7;
uda.wandLen=0.01;
uda.pixelwidth = 0.02;
uda.backgroundPts=[];
uda.axisPts=[];
uda.wandPts=[];
uda.wandScore=[];
uda.rmpts=false(0,2);
uda.bkrmpts=false(0,1);
uda.installdir=mfilename('fullpath');
uda.justSaved=0;
uda.allShared=false; % false = use points that are seen in any 2 cameras
uda.camParaCalib = [];

% Determine system font size in pixels
f=charHeight();
uda.charWidth=f(1);
uda.charHeight=f(2);

% Get the main display resolution
res=get(0,'ScreenSize');

% Find how large display has to be to accomodate full table
minWidth=204*f(1);  % 204 characters wide

if res(3)>minWidth % Screen is big enough to accomodate figure w/o resizing
  width=330.0/f(1);  % Button panel is 330px wide
  screenwidth=minWidth/f(1);  % Make screen 204 characters wide
  screentop=705.0/f(2); % Make screen 705px tall
  top=705.0/f(2);
  tableheight=130/f(2);
else
  width=330.0/f(1);  % Button panel is 330px wide
  screenwidth=924.0/f(1); % Make screen 924px wide (30px of wiggle)
  screentop=668.0/f(2);  % Make screen 668px tall (100px of wiggle)
  top=668.0/f(2);
  tableheight=100/f(2);
end

% Try and fix width for poorly reported displays
width=max([width,40]);

y=0;
backColor=[0.831 0.815 0.784];
buttonColor = [0.75 0.75 0.75];

%Put display in the middle of the screen
posX=(res(3)/f(1) - screenwidth)/2;
posY=(res(4)/f(2) - screentop)/2;

%
% Create main GUI figure and all controls
%

% control figure
uda.handles.easyWandMain = figure('Units','characters',...
  'Color',backColor,'Doublebuffer','on', ...
  'IntegerHandle','off','MenuBar','none',...
  'Name','easyWand 5','NumberTitle','off',...
  'Position',[posX posY screenwidth-0.4 screentop],'Resize','off',...
  'HandleVisibility','callback','Tag','easyWandMain',...
  'UserData',[],'Visible','on','deletefcn','',...
  'interruptible','on','defaulttextfontsize',8);

if res(3)>924 && res(3)<1199  % Enable resizing on appropriate displays
  set(uda.handles.easyWandMain,'Resize','on','ResizeFcn',@figure_resizefcn);
end

% Main panel
uda.handles.easyWandMainPanel = uipanel('Units','characters',...
  'BackgroundColor',backColor,...
  'Position',[-0.4 -0.4 screenwidth+0.4 screentop+1],...
  'HandleVisibility','callback','Tag','easyWandMainPanel',...
  'UserData',[],'Visible','on','Parent',uda.handles.easyWandMain,...
  'interruptible','on','Clipping','on');

% Load wand points button
y=y+2;
uda.handles.loadButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Load wand points','fontsize',10,'tag','loadButton','callback',...
  @loadButton_callback);

% Load background points button
y=y+2.25;
uda.handles.loadBackgrndButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Load background points','fontsize',10,'tag','loadBackgrndButton',...
  'callback',@loadBackgrndButton_callback,'Enable','off');

% Load axis points button
y=y+2.25;
uda.handles.loadAxisButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Load axis points','fontsize',10,'tag','loadAxisButton',...
  'callback',@loadAxisButton_callback,'Enable','off');

% Load camera profile button
y=y+2.25;
uda.handles.loadCameraProfile = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Load camera profiles','fontsize',10,'tag','loadCameraProfile',...
  'callback',@loadProfileButton_callback,'Enable','off');

% Load previous results button
y=y+2.25;
uda.handles.loadResultsButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Load previous calibration','fontsize',10,'tag','loadResultsButton',...
  'callback',@loadResultsButton_callback,'Enable','on');

% Optimization Mode dropdown menu label
y=y+2.5;
uda.handles.optim_mode = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y 25 2],'Style',...
  'text','BackgroundColor',backColor,'string',...
  'Optim. Mode:','fontsize',10,'tag',...,
  'optim_mode','horizontalAlign','left');

% Optimization Mode dropdown menu
predMenu={'Focal length only','FL & principal point',...
  'No camera intrinsics'};
uda.handles.modeMenu = uicontrol('Parent',uda.handles.easyWandMainPanel,'Units','characters','Position',...
  [30 top-y+0.25 width-30 2],'String',predMenu,'Style','popupmenu',...
  'Value',1,'Tag','modeMenu','Callback',@modeMenu_callback,'enable','off',...
  'BackgroundColor','white');
uda.optimMode=1;

% Wand span label
y=y+2.25;
uda.handles.wandSpanLabel = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-20 2],'Style',...
  'text','BackgroundColor',backColor,'string',...
  'Wand span: (m) ','fontsize',10,'tag','wandSpanLabel',...
  'horizontalAlignment','left');

% Wand span edit
uda.handles.wandSpanEdit = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[30 top-y+0.5 width-30 1.9],'Style',...
  'edit','BackgroundColor',[1 1 1],'string',...
  '0.01','tag','wandSpanEdit','callback',...
  @wandSpanEdit_callback);

% senor pixel width label
y=y+2.25;
uda.handles.pixelwidthLabel = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-20 2],'Style',...
  'text','BackgroundColor',backColor,'string',...
  'Pixel width: (mm) ','fontsize',10,'tag','pixelwidthLabel',...
  'horizontalAlignment','left');

% senor pixel width edit
uda.handles.pixelwidthEdit = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[30 top-y+0.5 width-30 1.9],'Style',...
  'edit','BackgroundColor',[1 1 1],'string',...
  '0.02','tag','pixelwidthEdit','callback',...
  @pixelwidthEdit_callback);


% Distortion Mode label
y=y+2.25;
uda.handles.distModeLabel = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y 25 2],'Style',...
  'text','BackgroundColor',backColor,'string',...
  'Distortion coefs: ','fontsize',10,'tag','distModeLabel',...
  'horizontalAlignment','left');

% Distortion Mode dropdown menu
uda.handles.distModeMenu = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[30 top-y+0.25 width-30 2],'Style',...
  'popupmenu','BackgroundColor','white','string',...
  ['No distortion terms |', ' 2nd order radial |', ' +4th order radial |',...
  '  +kc(3) tangential term |', '   +kc(4) tangential term |',...
  'All dist. coefs '],'tag','distModeMenu',...
  'horizontalAlignment','center','Callback',@distModeMenu_callback);
uda.distortionMode=0;

% 2nd pass Mode label
y=y+2.25;
uda.handles.pass2ModeLabel = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y 25 2],'Style',...
  'text','BackgroundColor',backColor,'string',...
  '2ndary camera mode: ','fontsize',10,'tag','pass2ModeLabel',...
  'horizontalAlignment','left');

% 2nd pass Mode menu
uda.handles.pass2ModeMenu = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[30 top-y+0.25 width-30 2],'Style',...
  'popupmenu','BackgroundColor','white','string',...
  ['bundle adjustment |', 'direct linear trans.'],'tag','pass2ModeMenu',...
  'horizontalAlignment','center','Callback',@pass2ModeMenu_callback);
uda.pass2Mode=0; % default to SBA

% Compute calibration button
y=y+2.25;
uda.handles.computeCalibrationButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Compute calibration','fontsize',10,'tag','computeCalibrationButton',...
  'callback',@computeCalibrationButton_callback,'Enable','off');

% Wand score label
uda.handles.wandScoreLabel = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[width+25 screentop-6 width*2 5],'Style',...
  'text','BackgroundColor',backColor,'string',...
  '  ','fontsize',10,'tag','wandScoreLabel',...
  'horizontalAlignment','center');

% Set distortion coefs button
y=y+2.25;
uda.handles.setDistortionButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Set/view distortion coefs','fontsize',10,'tag','setDistortionButton',...
  'callback',@setDistortionButton_callback,'Enable','off');

% Edit outliers button
y=y+2.25;
uda.handles.editOutliersButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Edit outliers','fontsize',10,'tag','editOutliersButton',...
  'callback',@editOutliersButton_callback,'Enable','off');

% Save Results button
y=y+2.25;
uda.handles.saveResultsButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Save results','fontsize',10,'tag','saveResultsButton',...
  'callback',@saveResultsButton_callback,'Enable','off');

% Save camera profile button
y=y+2.25;
uda.handles.saveCameraProfile = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Save camera profiles','fontsize',10,'tag','saveCameraProfile',...
  'callback',@saveProfileButton_callback,'Enable','off');

% Initialize button
y=y+2.25;
uda.handles.initializeButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Re-Initialize','fontsize',10,'tag','initializeButton',...
  'callback',@initializeButton_callback,'Enable','on');

% Calibration conversion
y=y+2.25;
uda.handles.TsaiModelButton = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[5 top-y width-5 2],'Style',...
  'pushbutton','BackgroundColor',buttonColor,'string',...
  'Tsai model','fontsize',10,'tag','TsaiModelButton',...
  'callback',@TsaiModelButton_callback,'Enable','off');

% Required fields label
uda.handles.reqFieldsLabel = uicontrol('Parent',uda.handles.easyWandMainPanel,...
  'Units','characters','Position',[screenwidth-20 tableheight+0.3 16 1.5],'Style',...
  'text','BackgroundColor',backColor,'string',...
  '*required fields','fontsize',8,'ForegroundColor','b');

% Camera data table
uda.handles.camTable = uitable(...
  'Parent',uda.handles.easyWandMainPanel,...
  'Units','characters',...
  'BackgroundColor',[1 1 1;0.960 0.960 0.960],...
  'ColumnFormat',{  'numeric' 'logical' 'numeric' 'numeric' 'numeric',...
  'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric',...
  'numeric','numeric'},...
  'ColumnEditable',logical([0,1,1,1,1,1,1,0,0,0,0,0,0,0]),...
  'ColumnName',{  '<HTML><FONT size=10>Cam';...
  '<HTML><FONT color="blue" size=10><strong>Primary'; ...
  '<HTML><FONT color="blue" size=10><strong>Image Width (px)';...
  '<HTML><FONT color="blue" size=10><strong>Image Height (px)';...
  '<HTML><FONT color="blue" size=10><strong>FL Estimate (px)';...
  '<HTML><FONT size=10>Prin. Point X (px)'; ...
  '<HTML><FONT size=10>Prin. Point Y (px)';...
  '<HTML><FONT size=10>FL Calculated (px)';...
  '<HTML><FONT size=10>Prin. Pt. Calc. (X)';...
  '<HTML><FONT size=10>Prin. Pt. Calc. (Y)';...
  '<HTML><FONT size=10>DLT Reproj. Err. (px)';...
  '<HTML><FONT size=10>Pos. X (m)';...
  '<HTML><FONT size=10>Pos. Y (m)';...
  '<HTML><FONT size=10>Pos. Z (m)' },...
  'ColumnWidth',{8*f(1) 10*f(1) 18*f(1) 18*f(1) 16*f(1) 16*f(1) 16*f(1)...
  15*f(1) 16*f(1) 16*f(1) 15*f(1) 11*f(1) 11*f(1) 11*f(1) },...
  'Data',cell(1,12),...
  'RowName',[],...
  'Position',[-2 0 screenwidth+2 tableheight],...
  'RowName',blanks(0),...
  'UserData',[],...
  'fontsize',10,...
  'Tag','camTable', ...
  'CellEditCallback',@tableUpdate_callback);

% Display axes
uda.handles.axes1 = axes(...
  'Parent',uda.handles.easyWandMainPanel,...
  'Units','characters',...
  'Position',[width+10 tableheight+6 screenwidth-width-14 screentop-22],...
  'CameraPosition',[0.5 0.5 9.16],...
  'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
  'Color',get(0,'defaultaxesColor'),...
  'ColorOrder',get(0,'defaultaxesColorOrder'),...
  'XColor',get(0,'defaultaxesXColor'),...
  'YColor',get(0,'defaultaxesYColor'),...
  'ZColor',get(0,'defaultaxesZColor'),...
  'Tag','axes1');

% store userdata
set(uda.handles.easyWandMain,'userData',uda);

% Done with GUI initialization

return

function [] = loadButton_callback(varargin)

% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% clear the figure window
cla(uda.handles.axes1);

% clear the wand score string
set(uda.handles.wandScoreLabel,'string','')

currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end

% get the name and path to csv file with the wand points
[fname1,pname1] = uigetfile( ...
  {'*.csv','Comma-separated values (*.csv)'},...
  'Pick the digitized wand points file');

cd(currDir);
if fname1==0  % User cancelled the file ui
  disp('No wand points loaded');
  return
end

% load the data file, check # of rows and columns
wandPts=importdata([pname1,fname1]);
if isstruct(wandPts)
  wandPts=wandPts.data;
end
% wandPts header format:
% |cam1/pt1x | cam1/pt1y | cam2/pt1x | cam2/pt1y | cam1/pt2x | cam1/pt2y | cam2/pt2x | cam2/pt2y|

nPts=sum(isnan(sum(wandPts,2))==false);
nCams=size(wandPts,2)/4;

% data sanity check and user feedback
if mod(size(wandPts,2),4)~=0 || size(wandPts,2)<7
  mess='Error - incorrect number of wand point columns';
else
  mess=sprintf('Success - %.0f wand points shared across %.0f cameras were loaded',nPts,nCams);
  set(uda.handles.loadButton,'string',['Wand points file: ', fname1]);
end

% check for odd numbers of points in a row - indicative of bad inputs
odx=find(rem(sum(isfinite(wandPts),2),2)==1);
if numel(odx)>0
  mess=['The following rows in the wand points file have an odd ', ...
    'number of entries, possibly indicative of bad data: ',sprintf(...
    '%.0f ',odx)];
  warndlg(mess);
end

% Reset camera table if nCams different from number of rows
data=get(uda.handles.camTable,'Data');
if size(data,1)~=nCams
  data=cell(nCams,13);
   imageWidth=zeros(1,nCams); % Initialize outputs
   imageHeight=zeros(1,nCams);
   estFocalLengths = zeros(1,nCams);
   pp_est = zeros(1, 2 * nCams);
  for i=1:nCams
    data{i,1}=i;
    data{i,2}=true;
%     data(i,3:7)=num2cell(zeros(1,5)*NaN);
    data(i,3:7)=num2cell([1280 800 9000 NaN NaN]);
    imageWidth(i) = 1280;
    imageHeight(i) = 800;
    estFocalLengths(i) = 9000;
    pp_est(2 * i - 1: 2 * i)=[1280 800]/2;
  end
  % Bundle outputs and set userdata
uda.imageWidth=imageWidth;
uda.imageHeight=imageHeight;
uda.estFocalLengths=estFocalLengths;
uda.pp_est = pp_est;

  uda.calibrationMode(1:nCams)=1; % 1=primary, 0=secondary
  set(uda.handles.camTable,'Data',data);
end
msgbox(mess);
disp(mess);

% store data and set default focal length, resolution, etc.
uda.wandPtsFile=[pname1,fname1];
uda.addedFiles={uda.wandPtsFile};
uda.fPath=pname1;
uda.wandPts=wandPts;
uda.nPts=nPts;
uda.nCams=nCams;
uda.rmpts=false(size(wandPts,1),2);
uda.nlin_est = zeros(1,5*nCams);

% Enable gui buttons once wand points are loaded
enableButtonsHandles=[uda.handles.loadBackgrndButton, uda.handles.loadAxisButton,...
  uda.handles.loadCameraProfile, uda.handles.modeMenu, uda.handles.saveResultsButton,...
  uda.handles.computeCalibrationButton, uda.handles.saveCameraProfile,...
  uda.handles.setDistortionButton];
for i = 1:length(enableButtonsHandles)
  set(enableButtonsHandles(i),'Enable','on');
end

% pass back userdata
set(h1,'userdata',uda);
return

function [] = tableUpdate_callback(varargin)
% Callback for the main camera information table - gets called whenever the
% table is supposed to update or user enters data
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');  % Get userdata
tabData=get(uda.handles.camTable,'Data'); % Get table data
% imageWidth=zeros(1,uda.nCams); % Initialize outputs
% imageHeight=zeros(1,uda.nCams);
% estFocalLengths=zeros(1,uda.nCams);

imageWidth=uda.imageWidth;
imageHeight=uda.imageHeight;
estFocalLengths=uda.estFocalLengths;

if isfield(uda,'pp_est')
  pp_est=uda.pp_est;
else
  pp_est=[];
end
calibrationMode=zeros(1,uda.nCams);
% Auto-populate principal points if not already entered by user
if varargin{2}.Indices(2)==3 % image width entered
  if isnan(tabData{varargin{2}.Indices(1),6})
    pp_est(1,2*varargin{2}.Indices(1)-1)=round(varargin{2}.NewData/2);
  end
end
if varargin{2}.Indices(2)==4 % image height entered
  if isnan(tabData{varargin{2}.Indices(1),7})
    pp_est(1,2*varargin{2}.Indices(1))=round(varargin{2}.NewData/2);
  end
end
tabDataMat=cell2mat(tabData(:,3:7)); % Get the current camera intrinsics

% look for bad data
bdx=find(tabDataMat(:,1:5)<=0);
tabDataMat(bdx)=NaN;
if numel(bdx)>0
  mess=['Bad data removed from camera intrinsics table; focal length, ',...
    'image size, and principal point values must be positive.'];
  warndlg(mess)
end

% process table
for i=1:size(tabData,1)
  calibrationMode(i)=tabData{i,2};
  imageWidth(1,i)=tabDataMat(i,1);
  imageHeight(1,i)=tabDataMat(i,2);
  estFocalLengths(1,i)=tabDataMat(i,3);
  if ~isnan(tabDataMat(i,4))
    pp_est(1,2*i-1)=tabDataMat(i,4);
  end
  if ~isnan(tabDataMat(i,5))
    pp_est(1,2*i)=tabDataMat(i,5);
  end
end

% Bundle outputs and set userdata
uda.imageWidth=imageWidth;
uda.imageHeight=imageHeight;
uda.estFocalLengths=estFocalLengths;
uda.pp_est=pp_est;
uda.calibrationMode=calibrationMode;

% copy tabDatMat back to tabData
for i=1:numel(tabDataMat)
  tabData{i+2*size(tabDataMat,1)}=tabDataMat(i);
end

% redraw table with any updated / corrected data
set(uda.handles.camTable,'Data',tabData);


set(h1,'userdata',uda);

function [] = loadProfileButton_callback(varargin)
% Callback for loading in camera profiles from a text file
% Expected form of each row
% [ Camera#, Focal length, Image width, Image height, Prin. pt X, Prin. pt Y, Primary/secondary (logical)]

% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% clear the figure window
cla(uda.handles.axes1);

currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end
% get the name and path to txt file with the wand points
[fname1,pname1] = uigetfile( ...
  {'*.txt','Text file (*.txt)'},...
  'Choose a saved camera profile');
cd(currDir);
if fname1==0
  disp('No camera profiles loaded');
  return
end

% load the camera profile file
prof=importdata(strcat(pname1,fname1));
if size(prof,1)~=uda.nCams
  mess=sprintf('Error - Wand points loaded for %.0f camera(s), but profile contains %.0f camera(s)',...
    uda.nCams,size(prof,1));
else
  uda.nCams=size(prof,1);
  uda.estFocalLengths=prof(:,2)';
  uda.imageWidth=prof(:,3)';
  uda.imageHeight=prof(:,4)';
  uda.pp_est=reshape([prof(:,5)'; prof(:,6)'],1,2*uda.nCams);
  uda.calibrationMode=logical(prof(:,7)');
  if size(prof,2)==12
    uda.nlin_est = reshape(prof(:,8:12)',1,uda.nCams*5);
  elseif size(prof,2)~=7
    mess = sprintf('Error - camera profile contains an unexpected number of columns');
    msgbox(mess);
    return
  end
  mess=sprintf('Success - Loaded profile for %.0f camera(s)',uda.nCams);
  set(uda.handles.loadCameraProfile,'string',['Camera profile: ', fname1]);
  uda.camProfFile=[pname1,fname1];
  uda.fPath=pname1;
  data=get(uda.handles.camTable,'Data');
  if size(data{1},1)~=uda.nCams
    data=cell(uda.nCams,12);
  end
  for i=1:uda.nCams
    data{i,1}=i;
    data{i,2}=logical(uda.calibrationMode(i));
    data{i,3}=uda.imageWidth(i);
    data{i,4}=uda.imageHeight(i);
    data{i,5}=uda.estFocalLengths(i);
    data{i,6}=uda.pp_est(2*i-1);
    data{i,7}=uda.pp_est(2*i);
  end
  set(uda.handles.camTable,'Data',data);
end

msgbox(mess);
disp(mess);

% pass back userdata
set(h1,'userdata',uda);

return

function [] = loadBackgrndButton_callback(varargin)
% Callback to load background points from a .csv or .mat file
% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% clear the figure window
cla(uda.handles.axes1);

% clear the wand score string
set(uda.handles.wandScoreLabel,'string','');

currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end

% get the name and path to csv file with the wand points
[fname1,pname1] = uigetfile( ...
  {'*.csv','Comma-separated values (*.csv)'},...
  'Pick the digitized background points file');
cd(currDir);
if fname1==0
  disp('No background points loaded');
  return
end

% load the data file, check # of rows and columns
backgroundPts=importdata([pname1,fname1]);
if isstruct(backgroundPts)
  backgroundPts=backgroundPts.data;
end

nPts=sum(isnan(sum(backgroundPts,2))==false);
nCams=size(backgroundPts,2)/2;

mess=sprintf('Loaded %.0f background points shared across %.0f cameras',nPts,nCams);
set(uda.handles.loadBackgrndButton,'string',['Bkgd points file: ', fname1]);
msgbox(mess);

% check for odd numbers of points in a row - indicative of bad inputs
odx=find(rem(sum(isfinite(backgroundPts),2),2)==1);
if numel(odx)>0
  mess=['The following rows in the background points file have an odd ', ...
    'number of entries, possibly indicative of bad data: ',sprintf(...
    '%.0f ',odx)];
  warndlg(mess);
end

uda.backgroundPts=backgroundPts;
if isfield(uda,'addedFiles')
  uda.addedFiles{numel(uda.addedFiles)+1} = [pname1,fname1];
else
  uda.addedFiles = {[pname1,fname1]};
end
uda.backgroundPtsFile=[pname1,fname1];
uda.bkrmpts=false(size(backgroundPts,1),1);
uda.fPath=pname1;

% pass back userdata
set(h1,'userdata',uda);

function [] = loadAxisButton_callback(varargin)
% Callback to load axis points (2 to 4 pts in all cameras)
% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% clear the figure window
cla(uda.handles.axes1);

currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end

% get the name and path to csv file with the wand points
[fname1,pname1] = uigetfile( ...
  {'*.csv','Comma-separated values (*.csv)'},...
  'Pick the digitized axis points file');
cd(currDir);
if fname1==0
  disp('No axis points loaded');
  return
end

% load the data file, check # of rows and columns
axisPts=importdata([pname1,fname1]);
if isstruct(axisPts)
  axisPts=axisPts.data;
end
adx=find(sum(isfinite(axisPts),2)>0);
axisPts=axisPts(adx(1):adx(end),:);
if size(axisPts,2)~=uda.nCams*2 || size(axisPts,1)<2
  mess='Invalid axis points file detected!  Check inputs';
  disp(mess);
  msgbox(mess)
  return
end

% remove old axis points
uda.backgroundPts=uda.backgroundPts(1:end-size(uda.axisPts,1),:);
uda.bkrmpts=uda.bkrmpts(1:end-size(uda.axisPts,1),:);

% add new axis points
uda.axisPts=axisPts;
uda.backgroundPts=[uda.backgroundPts; axisPts];
uda.bkrmpts=[uda.bkrmpts; false(size(axisPts,1),1)];
uda.axisPtsFile=fname1;
uda.fPath=pname1;


% check for gravity and get additional inputs
goodRows=find(sum(isfinite(uda.axisPts),2)>3);
if numel(goodRows)>4
  
  % not needed anymore since we can use polyfit() instead
%   % check for spaps
%   if exist('spaps','file')~=2
%     mess=['Alignment to gravitational accleration requires the spaps() ',...
%       'function (not found), part of the spline or curve fitting ',...
%       'toolbox.  No axis points loaded.'];
%     errordlg(mess,'spaps not found')
%     return
%   end
  
  mess=['You appear to have loaded a gravitional acceleration axis file, ',...
    'please specify the camera recording frequency in Hz.'];
  answer=inputdlg(mess,'Gravity recording frequency');
  uda.gravityFreq=str2num(answer{1});
  if isempty(uda.gravityFreq)
    errdlg('Bad frequency input, try loading the axis points again.')
    return
  end
  
  % get gravity direction
  button=questdlg('Which way should +Z point?','Z direction?','Down','Up','Down');
  if strcmp(button,'Down')
    uda.gravityDir=1;
  else
    uda.gravityDir=-1;
  end
  
end

mess=sprintf('Loaded axis points file.');
set(uda.handles.loadAxisButton,'string',['Axis points file: ', fname1]);
msgbox(mess);

% pass back userdata
set(h1,'userdata',uda);

function [] = wandSpanEdit_callback(varargin)
% Callback to update the wand length when user enters a value in the gui
% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% get the string in the edit box
newStr=get(varargin{1},'string');

if numel(str2double(newStr))>0
  if str2double(newStr)>0
    uda.wandLen=str2double(newStr);
  else
    set(varargin{1},'String',num2str(uda.wandLen));
    disp('Wand length must be positive, previous value restored.')
  end
else
  set(varargin{1},'String',num2str(uda.wandLen));
  disp('Error setting wand length value, previous value restored.')
end

% pass back userdata
set(h1,'userdata',uda);

function [] = pixelwidthEdit_callback(varargin)
% Callback to update the wand length when user enters a value in the gui
% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% get the string in the edit box
newStr=get(varargin{1},'string');

if numel(str2double(newStr))>0
  if str2double(newStr)>0
    uda.pixelwidth=str2double(newStr);
  else
    set(varargin{1},'String',num2str(uda.wandLen));
    disp('Wand length must be positive, previous value restored.')
  end
else
  set(varargin{1},'String',num2str(uda.wandLen));
  disp('Error setting wand length value, previous value restored.')
end

% pass back userdata
set(h1,'userdata',uda);

function [] = distModeMenu_callback(varargin)
% Callback to keep track of what distortion mode is selected
% get userdata
h1 = findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% Get and store lens distortion mode
uda.distortionMode = get(uda.handles.distModeMenu,'value')-1;

% pass back userdata
set(h1,'userdata',uda);

function [] = pass2ModeMenu_callback(varargin)
% Callback to keep track of what second pass calibratoin mode is selected
% get userdata
h1 = findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% Get and store secondary calibration pass mode
uda.pass2Mode = get(uda.handles.pass2ModeMenu,'value')-1;

% pass back userdata
set(h1,'userdata',uda);

function [] = modeMenu_callback(varargin)
% Callback to keep track of what calibration mode is selected
% get userdata
h1 = findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% Get and store camera calibration mode
uda.optimMode = get(uda.handles.modeMenu,'value');

% pass back userdata
set(h1,'userdata',uda);

function [] = saveProfileButton_callback(varargin)
% Callback to save camera intrinsics information to a .txt profile.  See
% loadProfileButton for file formatting
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

camProf=zeros(uda.nCams,12);
for i=1:uda.nCams
  camProf(i,:)=[i uda.estFocalLengths(i) uda.imageWidth(i)...
    uda.imageHeight(i) uda.pp_est(2*i-1) uda.pp_est(2*i)...
    uda.calibrationMode(i) uda.nlin_est(5*i-4:5*i)];
end

currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end
% get save name and path
[f,p]=uiputfile({'*.txt','Text files (*.txt)'});
cd(currDir);

if f~=0
  if strcmpi(f(end-3:end),'.txt')
    f=f(1:end-4);
  end
  dlmwrite([p,f,'_profile.txt'],camProf,' ');
  mess=sprintf('Data saved to %s%s_profile.txt',p,f);
else
  mess='Data not saved';
end

msgbox(mess);
disp(mess);

return

function [] = setDistortionButton_callback(varargin)
% Callback to manually edit the initial lens distortion estimates
h1 = findobj('tag','easyWandMain');
uda = get(h1,'userdata');
% Current system font has 6-pixel wide and 13-pixel tall characters - not
% sure how to automatically determine this without pulling up a figure
if ~isfield(uda,'charWidth')
  f=charHeight();
  uda.charWidth=f(1);
  uda.charHeight=f(2);
else
  f=[uda.charWidth uda.charHeight];
end

%Put display in the middle of the screen
res=get(0,'ScreenSize');
width = 500.0/f(1);
height = 472.0/f(2);
tableHeight = 200/f(2);
posX = (res(3)/f(1)-width)/2;
posY = (res(4)/f(2) - height)/2;
uda.handles.editDist = figure('Units','characters',...
  'Color',[1 1 1],'MenuBar','none',...
  'Position',[posX posY width height],'Resize','off',...
  'Tag','editDist','UserData',uda,'Visible','on','WindowStyle','modal',...
  'interruptible','on','Name','Lens Distortion','NumberTitle','off');
%get(uda.handles.editDist)
% Dist. estimation table label
y = 3;
uda.handles.editDistLabel = uicontrol('Parent',uda.handles.editDist,...
  'Units','characters','Position',[1.6 height-y 50 2],'Style',...
  'text','BackgroundColor',[1 1 1],'string',...
  'User-specified distortion estimates','fontsize',12,'tag',...,
  'editDistLabel','horizontalAlign','left');

% Apply changes button
uda.handles.applyDistCoefsButton = uicontrol('Parent',uda.handles.editDist,...
  'Units','characters','Position',[width-30 height-y 30 3],'Style',...
  'pushbutton','BackgroundColor',[0.96 0.96 0.96],'string',...
  'Apply changes','fontsize',12,'tag','removeOutliersButton',...
  'callback',@applyDistCoefs_callback,'Enable','on');

% Dist. estimation table
y = y+tableHeight;
uda.handles.editDistTable = uitable(...
  'Parent',uda.handles.editDist,...
  'Units','characters',...
  'BackgroundColor',[1 1 1;0.960 0.960 0.960],...
  'ColumnFormat',{  'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric' },...
  'ColumnEditable',logical([0,1,1,1,1,1]),...
  'ColumnName',{  'Camera'; 'r2'; 'r4'; 'tan 1'; 'tan 2'; 'r6' },...
  'ColumnWidth',{'auto','auto','auto','auto','auto','auto'},...
  'Data',[(1:uda.nCams)', zeros(uda.nCams,5)],...
  'Position',[0 height-y width tableHeight],...
  'RowName',blanks(0),...
  'UserData',[],...
  'FontSize',10,...
  'Tag','editDistTable');

if ~isfield(uda,'nlin_est')
  uda.nlin_est = zeros(1,uda.nCams*5);
end
dataTable = [(1:uda.nCams)',reshape(uda.nlin_est,5,uda.nCams)'];
set(uda.handles.editDistTable,'Data',dataTable);

% Dist. results display label
y = y+3;
uda.handles.dispDistLabel = uicontrol('Parent',uda.handles.editDist,...
  'Units','characters','Position',[1.6 height-y 60 2],'Style',...
  'text','BackgroundColor',[1 1 1],'string',...
  'Lens distortion estimates from calibration','fontsize',12,'tag',...,
  'dispDistLabel','horizontalAlign','left');

% Display calib results table
y = y+tableHeight;
uda.handles.dispDistTable = uitable(...
  'Parent',uda.handles.editDist,...
  'Units','characters',...
  'BackgroundColor',[0.8 0.8 0.8;0.8 0.8 0.8],...
  'ColumnFormat',{  'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'numeric' },...
  'ColumnEditable',logical([0,0,0,0,0,0]),...
  'ColumnName',{  'Camera'; 'r2'; 'r4'; 'tan 1'; 'tan 2'; 'r6' },...
  'ColumnWidth',{'auto','auto','auto','auto','auto','auto'},...
  'Data',zeros(uda.nCams,6),...
  'Position',[0 height-y width tableHeight],...
  'RowName',blanks(0),...
  'UserData',[],...
  'FontSize',10,...
  'Tag','dispDistTable');
if ~isfield(uda,'nlin')
  nlin = zeros(1,uda.nCams*5)*NaN;
else
  nlin = uda.nlin;
end
dataTable = [(1:uda.nCams)',reshape(nlin,5,uda.nCams)'];
set(uda.handles.dispDistTable,'Data',dataTable);
set(h1,'UserData',uda);

function [] = applyDistCoefs_callback(varargin)
h1 = findobj('tag','easyWandMain');
uda = get(h1,'UserData');
tab = get(uda.handles.editDistTable,'Data');

% check for bad inputs
if sum(sum(isnan(tab)))>0
  mess='All distortion values must be numeric.';
  warndlg(mess)
  return
end

nlinNew = reshape(tab(:,2:6)',1,5*uda.nCams);
uda.nlin_est = nlinNew;
set(h1,'UserData',uda);
mess = 'Distortion coefficients set';
msgbox(mess);
disp(mess);
close(uda.handles.editDist);

function [] = editOutliersButton_callback(varargin)
% Callback to create the outlier-editor window, called from the main gui
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% Determine system font size in pixels
if ~isfield(uda,'charWidth')
  f=charHeight();
  uda.charWidth=f(1);
  uda.charHeight=f(2);
else
  f=[uda.charWidth uda.charHeight];
end

%Put display in the middle of the screen
res=get(0,'ScreenSize');
% try to make editor 172 characters wide
minWidth=172*f(1);
if res(3)>minWidth % Screen is large enough to accomodate figure w/o resizing
  screenwidth=minWidth/f(1);
else
  screenwidth=924.0/f(1); % Make screen 924px wide (30px of wiggle)
end
width=440.0/f(1);  % Outliers table is 440px wide
screentop=668.0/f(2);  % Make screen 668px tall (100px of wiggle)
axesheight=30;
posX=(res(3)/f(1) - screenwidth)/2;
posY=(res(4)/f(2) - screentop)/2;
backColor=[0.831 0.815 0.784];

uda.handles.editMain= figure('Units','characters',... % control figure
  'Color',backColor,'Doublebuffer','on', ...
  'IntegerHandle','off','MenuBar','none',...
  'Name','Edit Wizard','NumberTitle','off',...
  'Position',[posX posY screenwidth screentop],'Resize','off',...
  'HandleVisibility','callback','Tag','editMain',...
  'UserData',uda,'Visible','on','deletefcn','',...
  'interruptible','on'); %,'WindowStyle','modal'

% Data points table
uda.handles.editTable = uitable(...
  'Parent',uda.handles.editMain,...
  'Units','characters',...
  'BackgroundColor',[1 1 1;0.960 0.960 0.960],...
  'ColumnFormat',{  'numeric' 'numeric' 'numeric' 'numeric' 'numeric' 'logical' },...
  'ColumnEditable',logical([0,0,0,0,0,1]),...
  'ColumnName',{  'Index'; 'u'; 'v'; 'Resid.'; 'Wand len.'; 'Remove?' },...
  'ColumnWidth',{11*f(1) 8*f(1) 8*f(1) 11*f(1) 11*f(1) 11*f(1) },...
  'Data',zeros(1,5),...
  'Position',[-1.5 0.6 width screentop-3.6],...
  'RowName',blanks(0),...
  'UserData',[],...
  'FontSize',10,...
  'Tag','editTable', ...
  'CellEditCallback',@editorTableUpdate_callback);

% 'Sort by' button group label
y=3;
uda.handles.sortButtonsLabel = uicontrol('Parent',uda.handles.editMain,...
  'Units','characters','Position',[1.6 screentop-y 10 2],'Style',...
  'text','BackgroundColor',[0.831 0.815 0.784],'string',...
  'Sort by: ','fontsize',10,'tag',...,
  'sortButtonsLabel','horizontalAlign','left');

% 'Sort by' button group
uda.handles.sortButtonGroup = uibuttongroup('parent',uda.handles.editMain,'units','characters', ...
  'visible','on', 'Position',[11.6 screentop-y 80 3],...
  'fontangle','italic','BackgroundColor',...
  [0.831 0.815 0.784],'selectionchangefcn',@cameraChoiceMenu_callback,...
  'Tag','sortButtonGroup');

% Sort by residuals
uda.handles.sortResidualsButton = uicontrol('Parent',uda.handles.sortButtonGroup,...
  'style','radio','String','Reproj. Err.',...
  'units','characters','pos',[44 0 16 2.7],'Tag','sortResidualsButton',...
  'BackgroundColor',[0.831 0.815 0.784],'Value',1);

% Sort by wand length
uda.handles.sortWandlenButton = uicontrol('Parent',uda.handles.sortButtonGroup,...
  'style','radio','String','Wand len.',...
  'units','characters','pos',[60 0 16 2.7],'tag','sortWandlenButton',...
  'BackgroundColor',[0.831 0.815 0.784],'Value',0);

% Sort by x
uda.handles.sortXButton = uicontrol('Parent',uda.handles.sortButtonGroup,...
  'style','radio','String','X (u pixel)',...
  'units','characters','pos',[12 0 16 2.7],'tag','sortXButton',...
  'BackgroundColor',[0.831 0.815 0.784],'value',0);

% Sort by y
uda.handles.sortYButton = uicontrol('Parent',uda.handles.sortButtonGroup,'style','radio','String','Y (v pixel)',...
  'units','characters','pos',[28 0 16 2.7],'tag','sortYButton',...
  'BackgroundColor',[0.831 0.815 0.784],'value',0);

% Sort by frame
uda.handles.sortFrameButton = uicontrol('Parent',uda.handles.sortButtonGroup,'style','radio','String','Index', ...
  'units','characters','pos',[0 0 12 2.7], 'tag','sortFrameButton',...
  'BackgroundColor',[0.831 0.815 0.784],'value',0);

% Camera choice label
y=y+6;
uda.handles.cameraEditLabel = uicontrol('Parent',uda.handles.editMain,...
  'Units','characters','Position',[width+10 screentop-y 40 3],'Style',...
  'text','BackgroundColor',backColor,'string',...
  'Camera Number','fontsize',10,'tag',...,
  'cameraEditLabel','horizontalAlign','left');

% Fore/back choice label
uda.handles.cameraEditLabel = uicontrol('Parent',uda.handles.editMain,...
  'Units','characters','Position',[width+50 screentop-y 40 3],'Style',...
  'text','BackgroundColor',backColor,'string',...
  'Wand Points/Bkgnd Points','fontsize',10,'tag',...,
  'cameraEditLabel','horizontalAlign','left');

% Camera choice menu
y=y+3;
predMenu=cell(uda.nCams,1);
for i = 1:uda.nCams
  predMenu{i}=['Camera ' num2str(i)];
end
uda.handles.cameraChoiceMenu = uicontrol('Parent',uda.handles.editMain,...
  'Units','characters','Position',[width+10 screentop-y 30 4],...
  'String',predMenu,'Style','popupmenu',...
  'Value',1,'Tag','cameraChoiceMenu','Callback',@cameraChoiceMenu_callback,...
  'enable','on', 'BackgroundColor','white','fontsize',14);

% Fore/back choice menu
fbMenu={'Wand points' 'Background points'};
uda.handles.fbChoiceMenu = uicontrol('Parent',uda.handles.editMain,'Units','characters','Position',...
  [width+50 screentop-y 30 4],'String',fbMenu,'Style','popupmenu',...
  'Value',1,'Tag','fbChoiceMenu','Callback',@cameraChoiceMenu_callback,...
  'enable','on', 'BackgroundColor','white','fontsize',14);


% Display axes
y=y+axesheight+1;
uda.handles.axes2 = axes(...
  'Units','characters',...
  'Position',[width+6 screentop-y screenwidth-width-8 axesheight],...
  'CameraPosition',[0.5 0.5 9.16],...
  'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
  'Color',get(0,'defaultaxesColor'),...
  'ColorOrder',get(0,'defaultaxesColorOrder'),...
  'XColor',get(0,'defaultaxesXColor'),...
  'YColor',get(0,'defaultaxesYColor'),...
  'ZColor',get(0,'defaultaxesZColor'),...
  'Tag','axes2', 'ButtonDownFcn',@editAxesButtonCallback,'NextPlot','add');
xlabel('u pixels');
ylabel('v pixels');

% Remove outliers button
uda.handles.removeOutliersButton = uicontrol('Parent',uda.handles.editMain,...
  'Units','characters','Position',[(screenwidth-width-35)/2+width 2 35 3],'Style',...
  'pushbutton','BackgroundColor',[0.75 .75 .75],'string',...
  'Remove selected','fontsize',14,'tag','removeOutliersButton',...
  'callback',@removeOutliersButton_callback,'Enable','on');


ptMat=uda.wandPts;
ptMat2=uda.backgroundPts;
% disable removal of background points if no background points were
% loaded from file
if isempty(ptMat2)
  set(uda.handles.fbChoiceMenu,'Enable','off');
end

% detect and remove rows with any NaNs if allShared == true, only rows with
% 1 or fewer cameras defined if allShared == false
allShared=uda.allShared;
if allShared
  notNaN=logical(sum(isnan(ptMat),2)==0);
  notNaN2=logical(sum(isnan(ptMat2),2)==0);
else
  notNaN=logical(sum(isfinite(ptMat),2)>=5);
  notNaN2=logical(sum(isfinite(ptMat2),2)>=3);
end

tmp=1:size(ptMat,1);
frames=(tmp(notNaN))';
uda.notNaN=notNaN;
uda.notNaN2=notNaN2;

% Check for points that have already been removed
rmpts=uda.rmpts;
ptOld=ptMat;
ptMat=ptOld((notNaN),:);
ptOld2=ptMat2;
ptMat2=ptOld2((notNaN2),:);
wandPts=[ptMat(:,1:size(ptMat,2)/2); ptMat(:,size(ptMat,2)/2+1:end)];
bkgndPts=ptMat2;

% Calculate the reprojection errors from calibration coefficients
coefs=uda.coefs;
dbkgnd=reprojErrorUD(coefs,bkgndPts,uda.focalLengths,uda.ppts,uda.nlin);
dwand=reprojErrorUD(coefs,wandPts,uda.focalLengths,uda.ppts,uda.nlin);

% Calculate the wand lengths for each point
w1xyz=uda.w1;
w2xyz=uda.w2;
dDLT=rnorm(w1xyz-w2xyz);
dDLT=dDLT(notNaN);
uda.dDLT=dDLT;

% Calculate the distances from camera to background points
bkgDistances=zeros(size(uda.bkgPts,1),uda.nCams);
for i=1:uda.nCams
  % Get camera positions
  xyz = DLTcameraPosition(uda.coefs(:,i));
  bkgDistances(:,i)=rnorm(uda.bkgPts-repmat(xyz',size(uda.bkgPts,1),1));
end
uda.bkgDistances=bkgDistances(notNaN2,:);

% Populate the table with wand points for camera 1
tabData=[num2cell([frames floor(ptMat(:,1:2)) dwand(1:size(ptMat,1),1) dDLT]) num2cell(rmpts(notNaN,1))];
tabData2=[num2cell([frames+0.2 floor(ptMat(:,1:2)+uda.nCams*2) dwand(size(ptMat,1)+1:end,1) dDLT]) num2cell(rmpts(notNaN,2))];
tabData=[tabData;tabData2];

% Sort rows in descending order by reprojection error
tabData=sortrows(tabData,-4);
set(uda.handles.editTable,'Data',tabData);

% plot in the GUI figure axes
rmptsNaN=repmat(rmpts(notNaN),2,1);
cla(uda.handles.axes2);
scatter(wandPts(:,1),wandPts(:,2),'b','ButtonDownFcn',@editAxesButtonCallback);
hold on;
for i=1:size(wandPts,1)
  if rmptsNaN(i)
    scatter(wandPts(i,1),wandPts(i,2),'r','ButtonDownFcn',@editAxesButtonCallback);
  end
end
xlim([0 uda.imageWidth(1)]);
ylim([0 uda.imageHeight(1)]);
hold off;

% keep the reprojection errors in uda
uda.dbkgnd=dbkgnd;
uda.dwand=dwand;

set(uda.handles.editMain,'UserData',uda);
return

function [] = editAxesButtonCallback(varargin)
% Detection callback for clickable wand points in the editor window - gets
% called when the user clicks within the figure axes
h1=findobj('Tag','editMain');
uda=get(h1,'UserData');
currPt=get(uda.handles.axes2,'CurrentPoint');
currPt=currPt(1,1:2);
fb=get(uda.handles.fbChoiceMenu,'Value');
cam=get(uda.handles.cameraChoiceMenu,'Value');
if fb == 1 % Wand points
  wandPts=uda.wandPts;
  nCams=size(wandPts,2)/2;
  wandPts=[wandPts(:,cam*2-1:cam*2); wandPts(:,cam*2-1+nCams:cam*2+nCams)];
elseif fb == 2 % background points
  wandPts=uda.backgroundPts(:,cam*2-1:cam*2);
end
% Find points within a square 1/20 the size of the axes
xRange=get(uda.handles.axes2,'XLim');
rHoriz=abs(xRange(2)-xRange(1))/20;
yRange=get(uda.handles.axes2,'YLim');
rVert=abs(yRange(2)-yRange(1))/20;
% Cut out all points that aren't in the square - keep the indices
newIdx=(1:size(wandPts,1))';
newIdx=newIdx(abs(wandPts(:,1)-currPt(1))<rHoriz);
goodPts=wandPts(abs(wandPts(:,1)-currPt(1))<rHoriz,:);
newIdx=newIdx(abs(goodPts(:,2)-currPt(2))<rVert);
goodPts=goodPts(abs(goodPts(:,2)-currPt(2))<rVert,:);
% Find the closest point
if isempty(goodPts)
  return
end
for i=1:size(goodPts,1)
  distances=rnorm(goodPts-repmat(currPt,size(goodPts,1),1));
  [~,idx]=min(distances);
  idx=newIdx(idx);
end
% Check which wand point was clicked
if fb == 1
  offset=0;
  if idx > size(wandPts,1)/2 % second wand point
    idx = idx-size(wandPts,1)/2;
    offset=0.2;
  end
end
% Update the table data and call the table update callback
data=get(uda.handles.editTable,'data');
row=find(cell2mat(data(:,1))==idx+offset);
data{row,6}=~data{row,6};
set(uda.handles.editTable,'data',data);
newargin.Indices=[row,6];
newargin.NewData=data{row,6};
cbk=get(uda.handles.editTable,'CellEditCallback'); % Get the table update callback
cbk(uda.handles.editTable,newargin); % Update table and axes

return

function [] = editorTableUpdate_callback(varargin)
% Table update callback for the editor window - called whenever user
% chooses a point for removal/re-addition
h1=findobj('tag','editMain');
uda=get(h1,'UserData');
% Get data from the table
data=get(uda.handles.editTable,'Data');
% Check which row was edited
idx=varargin{2}.Indices(1);
fb=get(uda.handles.fbChoiceMenu,'Value');
if fb==1 % wand points
  % Check which points were previously marked for removal -
  % stored as logical array
  rmpts=uda.rmpts;
  fr=data{idx,1};
  frame=floor(fr);
  col=ceil(fr-floor(fr))+1;
  rmpts(frame,col)=logical(data{idx,6});
  
  % store and return
  uda.rmpts=rmpts;
  % refresh the figure axes and update points for removal
  axes(uda.handles.axes2);
  cam=get(uda.handles.cameraChoiceMenu,'Value');
  hold on;
  % If point was removed
  if varargin{2}.NewData==1
    if col==1
      scatter(uda.wandPts(frame,cam*2-1),uda.wandPts(frame,cam*2),'r',...
        'ButtonDownFcn',@editAxesButtonCallback);
    else
      scatter(uda.wandPts(frame,size(uda.wandPts,2)/2+cam*2-1),...
        uda.wandPts(frame,size(uda.wandPts,2)/2+cam*2),'r',...
        'ButtonDownFcn',@editAxesButtonCallback);
    end
    % If point was un-removed
  elseif varargin{2}.NewData==0
    if col==1
      scatter(uda.wandPts(frame,cam*2-1),uda.wandPts(frame,cam*2),'b',...
        'ButtonDownFcn',@editAxesButtonCallback);
    else
      scatter(uda.wandPts(frame,size(uda.wandPts,2)/2+cam*2-1),...
        uda.wandPts(frame,size(uda.wandPts,2)/2+cam*2),'b',...
        'ButtonDownFcn',@editAxesButtonCallback);
    end
  else
    disp('Error in table update routine: unexpected user edit');
  end
  hold off;
elseif fb==2 % background points
  bkrmpts=uda.bkrmpts;
  frame=data{idx,1};
  bkrmpts(frame)=logical(data{idx,6});
  uda.bkrmpts=bkrmpts;
  % refresh the figure axes and update points for removal
  axes(uda.handles.axes2);
  cam=get(uda.handles.cameraChoiceMenu,'Value');
  hold on;
  % If point was removed
  if varargin{2}.NewData==1
    scatter(uda.backgroundPts(frame,cam*2-1),...
      uda.backgroundPts(frame,cam*2),'r',...
      'ButtonDownFcn',@editAxesButtonCallback);
    % If point was un-removed
  elseif varargin{2}.NewData==0
    scatter(uda.backgroundPts(frame,cam*2-1),...
      uda.backgroundPts(frame,cam*2),'b',...
      'ButtonDownFcn',@editAxesButtonCallback);
  else
    disp('Error in table update routine: unexpected user edit');
  end
  hold off;
end
set(h1,'UserData',uda);
set(uda.handles.editTable,'Data',data);

return

function [] = removeOutliersButton_callback(varargin)
mess1='Warning: this will flag the selected points as removed from the calibration.  ';
mess2='This does not overwrite the wand point files accordingly.  EasyWand will ';
mess3='recalibrate after removal of points. Continue?';
yesno=questdlg([mess1,mess2,mess3],'Continue?','Yes','No','Yes');
if strcmp(yesno,'Yes')
  h1=findobj('Tag','easyWandMain');
  h2=findobj('Tag','editMain');
  uda=get(h2,'UserData');
  set(h1,'UserData',uda);
  close(uda.handles.editMain);
  clbk=get(uda.handles.computeCalibrationButton,'Callback');  %Compute calibration callback
  clbk(uda.handles.computeCalibrationButton,[]);
  msgbox('Selected points were removed, recalibration complete');
else
  msgbox('Selected points were not removed');
end

return

function [] = cameraChoiceMenu_callback(varargin)
% General refresh function for the outlier-editor table
h1=findobj('Tag','editMain');
uda=get(h1,'UserData');
cam=get(uda.handles.cameraChoiceMenu,'Value');
frontBack=get(uda.handles.fbChoiceMenu,'Value');

if frontBack==1 % wand points
  ptMat=uda.wandPts;
  % Remove NaNs
  allShared=uda.allShared;
  if allShared
    notNaN=logical(sum(isnan(ptMat),2)==0);
  else
    notNaN=logical(sum(isfinite(ptMat),2)>=5);
  end
  ptOld=ptMat;
  ptMat=ptOld(notNaN,:);
  tmp=1:size(ptOld,1);
  frames=(tmp(notNaN))'; % Get the frame numbers
  rmpts=uda.rmpts;
  dwand=uda.dwand;
  
  dDLT=uda.dDLT;
  
  % Populate the table with wand points for selected camera
  tabData=[num2cell([frames floor(ptMat(:,2*cam-1:2*cam)) dwand(1:size(ptMat,1),cam) dDLT]) num2cell(rmpts(notNaN,1))];
  tabData2=[num2cell([frames+0.2 floor(ptMat(:,2*cam-1:2*cam)+uda.nCams*2) dwand(size(ptMat,1)+1:end,cam) dDLT]) num2cell(rmpts(notNaN,2))];
  tabData=[tabData;tabData2];
  
  % Change label of column 5 to wand length
  set(uda.handles.editTable,'ColumnName',{  'Index'; 'u'; 'v'; 'Resid.'; 'Wand len.'; 'Remove?' });
  % Change label of sort button to wand length
  set(uda.handles.sortWandlenButton,'String','Wand len.');
elseif frontBack==2 % background points
  ptMat2=uda.backgroundPts;
  % Remove NaNs
  allShared=uda.allShared;
  if allShared
    notNaN2=logical(sum(isnan(ptMat2),2)==0);
  else
    notNaN2=logical(sum(isfinite(ptMat2),2)>=3);
  end
  ptOld2=ptMat2;
  bkgndPts=ptOld2(notNaN2,:);
  tmp=1:size(ptOld2,1);
  frames=(tmp(notNaN2))'; % Get the frame numbers
  bkrmpts=uda.bkrmpts;
  dbkgnd=uda.dbkgnd;
  bkgDistances=uda.bkgDistances(:,cam);
  tabData=[num2cell([frames floor(bkgndPts(:,2*cam-1:2*cam)) dbkgnd(:,cam) bkgDistances]) num2cell(bkrmpts(notNaN2))];
  % Change label of column 5 to distances from camera
  set(uda.handles.editTable,'ColumnName',{  'Index'; 'u'; 'v'; 'Resid.'; 'Distance'; 'Remove?' });
  % Change label of sort button to wand length
  set(uda.handles.sortWandlenButton,'String','Distance');
else
  disp('Error in camera choice menu: unexpected value for front/back choice menu');
end

% Sort rows depending on which button is pressed
h5=uda.handles.sortResidualsButton;
h6=uda.handles.sortWandlenButton;
h7=uda.handles.sortXButton;
h8=uda.handles.sortYButton;
h9=uda.handles.sortFrameButton;
if get(h5,'Value')
  tabData=sortrows(tabData,-4);
elseif get(h6,'Value')
  tabData=sortrows(tabData,-5);
elseif get(h7, 'Value')
  tabData=sortrows(tabData,-2);
elseif get(h8,'Value')
  tabData=sortrows(tabData,-3);
elseif get(h9,'Value')
  tabData=sortrows(tabData,1);
else
  disp('Error in sorting routine');
end
set(uda.handles.editTable,'Data',tabData);

% plot in the GUI figure axes
cla(uda.handles.axes2);
if frontBack==1 % wand points
  rmpts2=rmpts(notNaN); % get rid of NaNs in removed pts list for plotting
  hold on;
  scatter(ptMat(~rmpts2,2*cam-1),ptMat(~rmpts2,2*cam),'b',...
    'ButtonDownFcn',@editAxesButtonCallback);
  scatter(ptMat(~rmpts2,2*cam-1+size(ptMat,2)/2),ptMat(~rmpts2,2*cam+size(ptMat,2)/2),...
    'b','ButtonDownFcn',@editAxesButtonCallback);
  scatter(ptMat(rmpts2,2*cam-1),ptMat(rmpts2,2*cam),'r',...
    'ButtonDownFcn',@editAxesButtonCallback);
  scatter(ptMat(rmpts2,2*cam-1+size(ptMat,2)/2),ptMat(rmpts2,2*cam+size(ptMat,2)/2),...
    'r','ButtonDownFcn',@editAxesButtonCallback);
elseif frontBack==2 % background points
  bkrmpts2=bkrmpts(notNaN2); % get rid of NaNs in removed pts list for plotting
  hold on;
  scatter(bkgndPts(~bkrmpts2,2*cam-1),bkgndPts(~bkrmpts2,2*cam),'b'...
    ,'ButtonDownFcn',@editAxesButtonCallback);
  scatter(bkgndPts(bkrmpts2,2*cam-1),bkgndPts(bkrmpts2,2*cam),'r'...
    ,'ButtonDownFcn',@editAxesButtonCallback);
  
end
xlim([0 uda.imageWidth(cam)]);
ylim([0 uda.imageHeight(cam)]);
hold off;

return

function [] = loadResultsButton_callback(varargin)
% Callback for loading a previous run from the .mat output userdata file
% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');
handles = uda.handles;

currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end
% get the name and path to saved easyWand data
[fname1,pname1] = uigetfile( ...
  {'*.mat','MATLAB data file (*.mat)'},...
  'Pick the saved easyWand data file');
cd(currDir);
if fname1==0  % User cancelled file-grabber gui
  return
end

tmp=load(strcat(pname1,fname1));
if ~isfield(tmp,'easyWandData')
  msgbox('Invalid data file: aborting');
  return;
end
uda=tmp.easyWandData;
uda.fPath=pname1;
uda.handles=handles;

% Check for defaults that may not have been set by previous versions of
% easyWand
if ~isfield(uda,'wandScore')
  uda.wandScore=[];
end
if ~isfield(uda,'allShared')
  uda.allShared=false;
end
if ~isfield(uda,'rmpts') || isa(uda.rmpts,'double')
  nPts=size(uda.wandPts,1);
  uda.rmpts=false(nPts,2);
else
  if size(uda.rmpts,2)==1
    uda.rmpts(:,2)=uda.rmpts(:,1);
  end
end
if ~isfield(uda,'bkrmpts') || isa(uda.bkrmpts,'double')
  if ~isfield(uda,'backgroundPts')
    uda.bkrmpts=[];
  else
    nbkPts=size(uda.backgroundPts,1);
    uda.bkrmpts=false(nbkPts,1);
  end
end
if ~isfield(uda,'installdir')
  uda.installdir=mfilename('fullpath');
end
if ~isfield(uda,'calibrationMode')
  uda.calibrationMode(1:nCams)=1;
end
if ~isfield(uda,'pass2Mode')
  uda.pass2Mode=1; % default to DLT (old way)
  set(handles.pass2ModeMenu,'value',2)
end

% Check for camera profiles
if isfield(uda,'camProfFile')
  camProfFile=filesplit(uda.camProfFile);
  fname=camProfFile{end};
  set(handles.loadCameraProfile,'string',['Camera profile: ', fname]);
else
  set(handles.loadCameraProfile,'String','Load camera profile');
  uda.camProfFile='';
end
% Check for a background points file
if isfield(uda,'backgroundPtsFile')
  backgroundPtsFile=filesplit(uda.backgroundPtsFile);
  fname=backgroundPtsFile{end};
  set(handles.loadBackgrndButton,'string',['Bkgd points file: ', fname]);
else
  set(handles.loadBackgrndButton,'String','Load background points');
  uda.backgroundPtsFile='';
end
% Check for an axis points file
if isfield(uda,'axisPtsFile')
  axisPtsFile=filesplit(uda.axisPtsFile);
  fname=axisPtsFile{end};
  set(handles.loadAxisButton,'String',['Axis points file: ',fname]);
else
  set(handles.loadAxisButton,'String','Load axis points');
  uda.axisPtsFile='';
end
% Set the wand length and file name
if ~isfield(uda,'wandLen')
  uda.wandLen=1.0;
end
set(handles.wandSpanEdit,'String',num2str(uda.wandLen));
if isfield(uda,'wandPtsFile')
  wandPtsFile=filesplit(uda.wandPtsFile);
  fname=wandPtsFile{end};
  set(handles.loadButton,'string',['Loaded wand points file: ',fname]);
else
  set(handles.loadButton,'String','No wand points loaded');
  uda.wandPtsFile='';
end

% Refresh table data
data=cell(uda.nCams,11);
for i=1:uda.nCams
  data{i,1}=i;
  data{i,2}=logical(uda.calibrationMode(i));
  data{i,3}=uda.imageWidth(i);
  data{i,4}=uda.imageHeight(i);
  data{i,5}=uda.estFocalLengths(i);
  if isfield(uda,'pp_est')
    data{i,6}=uda.pp_est(2*i-1);
    data{i,7}=uda.pp_est(2*i);
  else
    data{i,6}=uda.imageWidth(i)/2;
    data{i,7}=uda.imageHeight(i)/2;
  end
end
set(handles.camTable,'Data',data);
uda.tabData=data;
% Set lens distortion value
if isfield(uda,'distortionMode');
  set(handles.distModeMenu,'Value',uda.distortionMode+1);
else
  set(handles.distModeMenu,'Value',1);
  uda.distortionMode=0;
end

% Set calibration mode
if isfield(uda,'optimMode');
  set(handles.modeMenu,'Value',uda.optimMode);
else
  set(handles.modeMenu,'Value',1);
  uda.optimMode=1;
end
% Refresh wand score
if isfield(uda,'wandScore')
  set(handles.wandScoreLabel,'String',['Wand score:  ' num2str(uda.wandScore) ''] );
else
  set(handles.wandScoreLabel,'String',' ');
  uda.wandScore=NaN;
end

% bundle and pass out the user data
set(handles.easyWandMain,'UserData',uda);

% Refresh the GUI axes
plot3DReconstruct(uda);

% Enable gui buttons once previous calibration is loaded
enableButtons=[handles.loadCameraProfile, handles.saveCameraProfile,...
  handles.loadBackgrndButton, handles.loadAxisButton,...
  handles.computeCalibrationButton, handles.saveResultsButton,...
  handles.editOutliersButton, handles.modeMenu,...
  handles.setDistortionButton];
for i = 1:length(enableButtons)
  set(enableButtons(i),'Enable','on');
end
return

function [] = plot3DReconstruct(uda)
% plot in the GUI figure axes
if nargin<1
  h1=findobj('tag','easyWandMain');
  uda=get(h1,'userdata');
end
cla(uda.handles.axes1);  % Clear figure axes
meanpt=nanmean([uda.w1;uda.w2])';  % Get the centroid for scale
% Check for points marked for removal
rmpts=uda.rmpts;
bkrmpts=uda.bkrmpts;
w1=uda.w1;
w1(rmpts(:,1),:)=NaN;
w2=uda.w2;
w2(rmpts(:,2),:)=NaN;

% Plot the wand points in blue
plot3(w1(:,1),w1(:,2),w1(:,3),'b.');
hold on
plot3(w2(:,1),w2(:,2),w2(:,3),'b.')
idx=find(isnan(w1(:,1))==false & isnan(w2(:,1))==false);
for i=1:numel(idx)
  plot3([w1(idx(i),1);w2(idx(i),1)],[w1(idx(i),2);w2(idx(i),2)],...
    [w1(idx(i),3);w2(idx(i),3)],'b-')
end

% grab the background points and plot them in green
bkgPts=uda.bkgPts(~bkrmpts,:);
plot3(bkgPts(:,1),bkgPts(:,2),bkgPts(:,3),'g.')

% grab the axis points and plot them in red
if numel(uda.axisPts)>0 & numel(uda.axisXYZ5)>0
  axPts=uda.axisXYZ5;
  plot3(axPts(:,1),axPts(:,2),axPts(:,3),'r.')
  if sum(isfinite(axPts(:,1)))<5
    for i=2:size(axPts,1)
      plot3([axPts(1,1);axPts(i,1)],[axPts(1,2);axPts(i,2)],...
        [axPts(1,3);axPts(i,3)],'r-')
    end
  end
end

% get camera position and orientation
for i=1:uda.nCams
  [xyz,T] = DLTcameraPosition(uda.coefs(:,i));
  % Primary cameras in black, secondary cameras in red
  if uda.calibrationMode(i)
    plot3(xyz(1),xyz(2),xyz(3),'ks','markerFaceColor','k','markerSize',6)
    text(xyz(1),xyz(2),xyz(3),sprintf('    Camera %.0f',i),'Color','k')
    
    foo=T*[0;0;-(norm(xyz-meanpt)/2);0];
    plot3([xyz(1);xyz(1)+foo(1)],[xyz(2);xyz(2)+foo(2)],...
      [xyz(3);xyz(3)+foo(3)],'k-')
  else
    plot3(xyz(1),xyz(2),xyz(3),'rs','markerFaceColor','r','markerSize',6)
    text(xyz(1),xyz(2),xyz(3),sprintf('    Camera %.0f',i),'Color','r')
    
    foo=T*[0;0;-(norm(xyz-meanpt)/2);0];
    plot3([xyz(1);xyz(1)+foo(1)],[xyz(2);xyz(2)+foo(2)],...
      [xyz(3);xyz(3)+foo(3)],'r-')
  end
end
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
axis equal; rotate3d on; hold off;

if isfield(uda,'gravityDir')
  if uda.gravityDir==1
    set(gca,'zdir','reverse','ydir','reverse')
  else
    set(gca,'zdir','normal','ydir','normal')
  end
end

return

function [] = computeCalibrationButton_callback(varargin)
% Main calibration routine - performs complete calibration with given data
% and updates the main gui
% get userdata

h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% Clear the figure window
cla(uda.handles.axes1);

% Make sure we have all the necessary information for a calibration
mess='More information required for a calibration!  Check table inputs';
if ~isfield(uda,'wandPts') || ~isfield(uda,'backgroundPts') || ...
    ~isfield(uda,'wandLen') || ~isfield(uda,'estFocalLengths') || ...
    ~isfield(uda,'imageWidth') || ~isfield(uda,'imageHeight')
  disp(mess);
  msgbox(mess);
  return;
end

% Check validity of data table contents
dTab=get(uda.handles.camTable,'data');
dTabMat=cell2mat(dTab(:,3:5));
for i=1:size(dTab,1)
  dTabMat(i,4)=double(dTab{i,2});
end
dTabMat(dTabMat(:,end)==0,:)=[];
if sum(sum(isnan(dTabMat)))>0
  disp(mess);
  msgbox(mess);
  return;
end

% start gathering the inputs for calibration
ptMat=uda.wandPts;
ptMat2=uda.backgroundPts;
wandLen=uda.wandLen;
f_est=uda.estFocalLengths;
nCams=size(ptMat,2)/4;
if isfield(uda,'pp_est')
  pp_est=uda.pp_est;
else
  pp_est(1:2:nCams*2)=uda.imageWidth./2;
  pp_est(2:2:nCams*2)=uda.imageHeight./2;
end
distortionMode = uda.distortionMode;
optimMode = uda.optimMode;

% check that background points are the appropriate size
if numel(ptMat2)==0
  ptMat2=ones(0,nCams*2);
end

% get nonlinear distortion coefs
if ~isfield(uda,'nlin_est')
  nlin = zeros(1,5*nCams);
  uda.nlin_est = nlin;
else
  nlin = uda.nlin_est;
end

% identify primary vs secondary cameras
pCams=find(uda.calibrationMode==1);
nPCams = numel(pCams);
uda.nPCams=nPCams;
if numel(pCams)<2
  mess=('You must have at least two primary cameras. No calibration performed.');
  disp(mess)
  warndlg(mess)
  return
else
  fprintf('Wand calibration will proceed using the primary cameras: ( #s ')
  fprintf('%.0f ',pCams)
  fprintf(')\n')
end

% detect and remove rows with any NaNs if allShared == true, only rows with
% 1 or fewer cameras defined if allShared == false
allShared=uda.allShared;
if allShared
  notNaN=logical(sum(isnan(ptMat),2)==0);
  notNaN2=logical(sum(isnan(ptMat2),2)==0);
else
  notNaN=logical(sum(isfinite(ptMat),2)>=3); % FIX THIS - can leak NaNs and discard data rows ("was ,2)>=5")
  notNaN2=logical(sum(isfinite(ptMat2),2)>=3);
end
% Check for points marked for removal, treat as NaN's
rmpts=uda.rmpts; % wand points
bkrmpts=uda.bkrmpts; % background points
p_ptMatrm=ptMat;
p_ptMatrm(rmpts(:,1),1:uda.nCams*2)=NaN;
p_ptMatrm(rmpts(:,2),uda.nCams*2+1:end)=NaN;
p_ptMatrm=p_ptMatrm(notNaN,:);
%p_ptMatrm=p_ptMat((notNaN & ~rmpts),:);
p_ptMat2rm=ptMat2((notNaN2 & ~bkrmpts),:);

set(gcf,'pointer','watch')
ocolor=get(uda.handles.loadButton,'backgroundColor');
set(varargin{1},'backgroundColor',[1,0,0]);
set(varargin{1},'string','Computing the calibration...')
pause(0.05);

% start two-pass bundle-adjustment code
[c,xyzMat,R,tv,sf,xyzMat2,ptMatu,ptMat2u,f,UoVo,nlin]=sbaCalib_pass2(p_ptMatrm,pp_est,wandLen,p_ptMat2rm,f_est,nlin,optimMode,distortionMode,pCams,uda.pass2Mode);

% Make sure the calibration worked
if isnan(sum(sum(sum(R))))
  msgbox('Calibration Error: failed to find a set of camera positions for the given wand points. Exiting...','Error','error');
  set(gcf,'pointer','arrow')
  set(varargin{1},'string','Compute calibration')
  set(varargin{1},'backgroundColor',ocolor);
  return
end

% reshape UoVo back into easyWand format
UoVo=ceil(reshape(UoVo',1,numel(UoVo)));

% restore original point array size, including NaN rows, replacing removed
% points with NaNs
xyz=zeros(size(ptMat,1),6)*NaN;
%xyz(notNaN & ~uda.rmpts,:)=xyzMat;
%xyz(notNaN & sum(uda.rmpts,2)<2,:)=xyzMat;
xyz(notNaN,:)=xyzMat;
xyz2=zeros(size(ptMat2,1),3)*NaN;
if ~isempty(notNaN2)
  xyz2(notNaN2 & ~uda.bkrmpts,:)=xyzMat2;
else
  xyz2=xyzMat2;
end

set(gcf,'pointer','arrow')
set(varargin{1},'string','Compute calibration')
set(varargin{1},'backgroundColor',ocolor)
disp(' ')
disp('Got an estimate of the focal lengths, camera positions & orientations')
disp(sprintf('Quality: %.2f - smaller is better: [std(wandLen)/mean(wandLen)]*100',c)) %#ok<*DSPS>
disp('Focal lengths are:')
disp(sprintf('%d  ',round(f)))
disp(' ')
disp('Nonlinear distortion coefficients are:')
%disp(sprintf('  %.5f',reshape(nlin,5,numel(nlin)/5)))
disp(num2str(reshape(nlin,5,numel(nlin)/5),4))
disp(' ')
disp('Principal Point Coordinates are:')
%disp(sprintf('  %d', UoVo));
disp(num2str(reshape(UoVo,2,numel(UoVo)/2),6))
disp(' ')
disp('Bundle adjustment relative camera positions are:')
for j=1:size(tv,3) % apply rotation to translation vector to get actual positions
  tv2(:,:,j)=tv(:,:,j)*R(:,:,j);
end
disp(num2str(squeeze(tv2),4))
disp('column = camera, row = [X;Y;Z]')
disp(' ')

% start the conversion to DLT

% gather the calibration points
% Get undistorted points from principal cams and normal points from
% secondary cams
tmp=ptMat;
tmp(notNaN,:)=ptMatu;
tmp(rmpts(:,1),1:uda.nCams*2)=NaN;
tmp(rmpts(:,2),uda.nCams*2+1:end)=NaN;

if ~isempty(ptMat2)
  tmp2=ptMat2;
  tmp2(notNaN2 & ~bkrmpts,:)=ptMat2u;
else
  tmp2=ones(0,nCams*2);
end
ptMat = tmp;
ptMat2 = tmp2;

calPts=[ptMat(:,1:size(ptMat,2)/2); ...
  ptMat(:,size(ptMat,2)/2+1:end);ptMat2];

% assemble a calibration frame
frame1=[xyz(:,1:size(xyz,2)/2); ...
  xyz(:,size(xyz,2)/2+1:end);xyz2];

% normalize to the pre-recorded axes
if numel(uda.axisPts)==0
  disp('You do not have any axis points defined.')
  disp('The resulting calibration axes will be euclidean, scaled to the')
  disp('wand length and centered on the cloud of points collected from')
  disp('the wand.  However, they will not be aligned to any particular')
  disp('set of global axes.')
  
  frame5=frame1-repmat(nanmean(frame1),size(frame1,1),1);
  signFlip=NaN;
  axisXYZ5=[];
  nonOrth=[];
  nAxPts=[];
else
  % get number of axis points
  nAxPts=numel(uda.axisPts)/(2*nCams);
  
  % pull axis points from the back end of the background points array
  axisXYZ=xyz2(end-nAxPts+1:end,:);
  
  if size(uda.axisPts,1)<5 & sum(isfinite(axisXYZ(:,1)))~=size(uda.axisPts,1)
    disp('WARNING: One or more axis points were not defined, i.e. ')
    disp('reconstructed as NaN. They may have been removed as outliers.')
    disp('The axis will not be processed and the calibration will not be')
    disp('aligned to any particular set of global axes.')
    frame5=frame1-repmat(nanmean(frame1),size(frame1,1),1);
    signFlip=NaN;
    axisXYZ5=[];
    nonOrth=[];
  else % process the orientation axis
    
    % try and fix dropped rows
    if size(uda.axisPts,2)<nCams*2
      uda.axisPts(:,end+1:nCams*2)=NaN;
    end
    
    % reshape the axis points in to a column
    if size(uda.axisPts,1)==1
      uda.axisPts=reshape(uda.axisPts,numel(uda.axisPts)/nAxPts,nAxPts)';
    end
    
    if nAxPts==2
      mess=(['Identified a plumb-line axis, point 1 will be placed at ', ...
        'the origin, point 2 will be on the +Z axis.']);
      hmsg=msgbox(mess);
      uiwait(hmsg);
      frame2=frame1-repmat(axisXYZ(1,:),size(frame1,1),1);
      axisXYZ2=axisXYZ-repmat(axisXYZ(1,:),2,1);
      
      % rotate such that the axis Z point is on the global Z
      zvec=axisXYZ2(2,:)./rnorm(axisXYZ2(2,:));
      raxis1=cross(zvec,[0,0,1]);
      rang1=acos(dot(zvec,[0,0,1]));
      axisXYZ5=angleaxisRotation(axisXYZ2,repmat(raxis1,2,1),-rang1);
      frame5=angleaxisRotation(frame2,repmat(raxis1,size(frame2,1),1),-rang1);
      signFlip=NaN; % can't evaluate right versus left handed CS
      nonOrth=NaN; % can't evaluate x-y-z orthogonality
      
      % for adjustment of plumb-line origin
      %frame5=frame5-repmat([0.0316    1.9764   -0.0565],size(frame5,1),1); % offset actual value
      %frame5=angleaxisRotation(frame5,repmat([0,0,1],size(frame5,1),1),-1.5855); % ang actual value
      
    elseif nAxPts==4 || nAxPts==3
      
      if nAxPts==3
        mess=(['Identified a 3-point axis, point 1 will be placed at ', ...
          'the origin, point 2 will be on the +X axis and point 3 on the ', ...
          '+Y axis and +Z will follow the right-hand rule.']);
        hmsg=msgbox(mess);
        uiwait(hmsg);
        
        % create 4th axis point (+Z)
        ax2=axisXYZ-repmat(axisXYZ(1,:),3,1); % subtract origin
        v=cross(ax2(2,:)./norm(ax2(2,:)),ax2(3,:)./norm(ax2(3,:))); % cross product
        axisXYZ(4,:)=v+axisXYZ(1,:); % add origin back in
        
      else
        mess=(['Identified a 4 point axis, points 1-4 will correspond to ', ...
          'the origin, +X, +Y & +Z axes.']);
        hmsg=msgbox(mess);
        uiwait(hmsg);
        
        % compute a missing 1st point (origin) from the other three if necessary
        % or desired
        if isnan(axisXYZ(1,1))
          axisXYZ=findOrigin(axisXYZ);
          disp('Derived an axis origin from the [X,Y,Z] points - examine your data with care')
        else
          yesno=questdlg('Would you like to optimize the axis origin?', ...
            'Optimize origin?','Yes','No','No');
          if strcmp(yesno,'Yes')
            axisXYZ=findOrigin(axisXYZ);
            disp('Derived an axis origin from the [X,Y,Z] points - examine your data with care')
          end
        end
      end
      
      % center on the axis [0,0,0]
      frame2=frame1-repmat(axisXYZ(1,:),size(frame1,1),1);
      axisXYZ2=axisXYZ-repmat(axisXYZ(1,:),4,1);
      
      % gather axis points non-orthogonality
      axNorm=axisXYZ2./repmat(rnorm(axisXYZ2),1,3);
      nonOrth(1)=((pi/2)-acos(dot(axNorm(2,:),axNorm(3,:))));
      nonOrth(2)=((pi/2)-acos(dot(axNorm(2,:),axNorm(4,:))));
      nonOrth(3)=((pi/2)-acos(dot(axNorm(4,:),axNorm(3,:))));
      disp(sprintf('Maximum non-orthogonality in the reconstructed axis points was %.2f degrees', ...
        rad2deg(max(abs(nonOrth)))));
      
      % rotate such that the axis Z point is on the global Z
      zvec=axisXYZ2(4,:)./rnorm(axisXYZ2(4,:));
      raxis1=cross(zvec,[0,0,1]);
      rang1=acos(dot(zvec,[0,0,1]));
      axisXYZ3=angleaxisRotation(axisXYZ2,repmat(raxis1,4,1),-rang1);
      frame3=angleaxisRotation(frame2,repmat(raxis1,size(frame2,1),1),-rang1);
      
      % rotate so that the X-Y projection of the X axis point is on the global X
      xvec=[axisXYZ3(2,1:2),0];
      xvec=xvec./rnorm(xvec);
      raxis2=cross(xvec,[1,0,0]);
      rang2=acos(dot(xvec,[1,0,0]));
      axisXYZ4=angleaxisRotation(axisXYZ3,repmat(raxis2,4,1),-rang2);
      frame4=angleaxisRotation(frame3,repmat(raxis2,size(frame2,1),1),-rang2);
      
      % multiply by the sign of the Y axis to change a left-handed coordinate
      % system to right handed (or leave a right handed system alone)
      axisXYZ5=axisXYZ4;
      axisXYZ5(:,2)=axisXYZ4(:,2)*sign(axisXYZ4(3,2));
      frame5=frame4;
      frame5(:,2)=frame4(:,2)*sign(axisXYZ4(3,2));
      signFlip=sign(axisXYZ4(3,2));
      
      
    elseif nAxPts>4
      mess=(['Identified axis points for alignment to gravitational acceleration.']);
      hmsg=msgbox(mess);
      uiwait(hmsg);
      
      % calculate a highly smoothed 2nd derivative - should be constant!
      cnt=0;
      err=[0.1,0.1,0.1];
      keepSmoothing=true;
      if exist('spaps')~=0 % use spline smoothing if available
        while keepSmoothing & cnt<1000
          g=(splineDerivativeKE2(axisXYZ,err,axisXYZ*0+1,2)*uda.gravityFreq^2);
          v=nanstd(g);
          if max(v)>1e-8
            err=err+(v./max(v))*2;
          else
            keepSmoothing=false;
          end
          cnt=cnt+1;
        end
      else
        % polyfit method - get a best fit 2nd order polynomial - should
        % produce identical output in most (all?) cases to the above spline
        % method but does not require any toolboxes
        g=polyFitGravity(axisXYZ,uda.gravityFreq);
      end
      if cnt==1000 | abs(1-nanmean(rnorm(g))/9.81)>0.5
        disp(nanmean(rnorm(g)))
        %warndlg(['Failed to identify smooth gravitational acceleration, ',...
        %  'calibration left unaligned.']);
        disp('WARNING - got a bad gravitiational acceleration.')
        disp('Maybe this is really a surface calibration?...')
        [pc,ps]=pca(axisXYZ);
        frame2=frame1-repmat(nanmean(axisXYZ),size(frame1,1),1);
        frame5=frame2*pc;
        signFlip=true;
        
        %frame5(:,2)=frame5(:,2)*-1; % fix left-handedness
        
        % put +Z up
        fmean=nanmean(frame5);
        if fmean(3)<0
          frame5=frame5.*[0,-1,-1]; % flip, keep handedness
          signFlip=false;
        end
        nonOrth=NaN;
        
      else
        % get the zero point
        zeroXYZ=nanmean(axisXYZ);
        
        % get the average gravity vector
        gVec=nanmean(g)./rnorm(nanmean(g));
        
        % get the rotation axis to bring gravity onto [0,0,1]
        raxis1=cross(gVec,[0,0,uda.gravityDir]);
        
        % get the angle between gravity and [0,0,1]
        rang1=acos(dot(gVec,[0,0,uda.gravityDir]));
        
        % create a new virtual calibration frame that reflects a rotation about
        % raxis1 by the inverse of rang1
        frame5=angleaxisRotation(frame1, ...
          repmat(raxis1,size(frame1,1),1),-rang1);
        
        zeroXYZ2=angleaxisRotation(zeroXYZ,raxis1,-rang1);
        
        frame5=frame5-repmat(zeroXYZ2,size(frame1,1),1);
        
        % legacy
        signFlip=1;
        nonOrth=NaN;
      end
    end
  end
end

% get DLT coefficients and residuals for each camera
coefs = zeros(11,nCams);
rmse = zeros(1,nCams);
for i=1:nCams
  % camera position relative to axes
  [coefs(:,i),rmse(i)]=mdlt_computeCoefficients(frame5,calPts(:,i*2-1:i*2));
end

% reconstruct the two wand points and background points separately explicit
% DLT formulation doesn't support reconstruction of secondary cams
% reconstruct wand points and background points
[xyzR1,rmseR1]=dlt_reconstruct(coefs,ptMat(:,1:size(ptMat,2)/2));
[xyzR2,rmseR2]=dlt_reconstruct(coefs,ptMat(:,size(ptMat,2)/2+1:end));
[xyzR3,rmseR3]=dlt_reconstruct(coefs,ptMat2);

% % convert to real rmse
% rmseR1=rrmse(coefs,ptMat(:,1:size(ptMat,2)/2),xyzR1);
% rmseR2=rrmse(coefs,ptMat(:,size(ptMat,2)/2+1:end),xyzR2);
% rmseR3=rrmse(coefs,ptMat2,xyzR3);


rmseR1(rmpts(:,1),:) = rmseR1(rmpts(:,1),:)*NaN;
rmseR2(rmpts(:,2),:) = rmseR2(rmpts(:,2),:)*NaN;
rmseR3(bkrmpts,:) = rmseR3(bkrmpts,:)*NaN;
disp(' ')
disp('The DLT reprojection errors were:')
disp(sprintf('%.5f ',rmse))

% Compute camera positions based on coordinates
xyzDLT=zeros(3,1,nCams);
T=zeros(4,4,nCams);
for i=1:nCams
  [xyzDLT(:,:,i),T(:,:,i)] = DLTcameraPosition(coefs(:,i));
end

% compute a wand score from the DLT points
dDLT=rnorm(xyzR1-xyzR2);
wandScore=(nanstd(dDLT)./nanmean(dDLT))*100;
wandEndSTD=(nanstd(dDLT))/2^0.5; % estimated standard deviation of each end

fprintf('The DLT wand quality score was: %.2f\n',wandScore);

% Update wand score label
string1=['Wand score: ',num2str(wandScore)];
string2=['Wand end point standard deviation: ',...
  num2str(wandEndSTD),' m'];
string3=['Reprojection errors: ',sprintf('%.2f  ',rmse),' pixels'];
set(uda.handles.wandScoreLabel,'String',sprintf('%s\n',string1,string2,string3));

% Gravity alignment info if relevant
if nAxPts>4
  
  % grab the gravity values
  gxyz=xyzR3(end-nAxPts+1:end,:);
  
  % get a smoothed 2nd derivative (should be constant)
  if exist('spaps')~=0
    g=(splineDerivativeKE2(gxyz,err,gxyz*0+1,2)*uda.gravityFreq^2);
  else
    g=polyFitGravity(gxyz,uda.gravityFreq);
  end
  
  % check magnitude
  scaleFactor=nanmean(rnorm(g))./9.80665;
  
  
  disp('Final gravity vector:')
  disp(nanmean(g))
  fprintf('\n')
  disp(['You measured gravity as ',num2str(scaleFactor*100),' percent of its expected value.'])
  
  axisXYZ5=gxyz;
end

% look for bad or outlier points
edx1=find(rmseR1>10*nanmedian(rmseR1));
edx2=find(rmseR2>10*nanmedian(rmseR2));
edx3=find(rmseR3>10*nanmedian(rmseR3));

if numel(edx1>0)
  disp(' ')
  disp('Error analysis suggests that these wand-wave entries may have an')
  disp('incorrectly digitized point #1:')
  disp(sprintf('%.0f ',edx1))
  disp(' ')
end

if numel(edx2>0)
  disp(' ')
  disp('Error analysis suggests that these wand-wave entries may have an')
  disp('incorrectly digitized point #2:')
  disp(sprintf('%.0f ',edx2))
  disp(' ')
end

if numel(edx3>0)
  disp(' ')
  disp('Error analysis suggests that these background entries may have an')
  disp('incorrectly digitized point:')
  disp(sprintf('%.0f ',edx3))
  disp(' ')
end

% Restore principal points
ppts=UoVo;


% bundle & pass information back
uda.coefs=coefs;
uda.dltRMSE=rmse;
uda.signFlip=signFlip;
uda.preDLT_xyz=xyz;
uda.preDLT_xyz2=xyz2;
uda.frame5=frame5;
uda.frame1=frame1;
uda.axisXYZ5=axisXYZ5;
uda.nonOrth=nonOrth;
uda.focalGAScore=c;
uda.focalLengths=round(f);
uda.rotationMatrices=R;
uda.translationVector=tv;
uda.DLTtranslationVector=xyzDLT;
uda.DLTrotationMatrices=T;
uda.principalPoints=UoVo;
uda.w1 = xyzR1;
uda.w2 = xyzR2;
uda.w3 = xyz(:,1:3);
uda.w4 = xyz(:,4:6);
uda.bkgPts = xyzR3;
uda.bkgPts2 = xyz2;
uda.sba_tv = tv;
uda.sba_R = R;
uda.scaleFactor=sf;
uda.ptMatu=ptMatu;
uda.ptMat2u=ptMat2u;
uda.wandScore=wandScore;
uda.justSaved=0;
uda.nlin=nlin;
uda.ppts = ppts;
set(h1,'userdata',uda);

% Update data in the GUI table
data=get(uda.handles.camTable,'Data');
for i=1:nCams
  % preserve estimated principal points (could be user input)
  data{i,6}=pp_est(2*i-1);
  data{i,7}=pp_est(2*i);
  
  % replace computed DLT quantities
  data{i,11}=rmse(i);
  data{i,12}=xyzDLT(1,1,i);
  data{i,13}=xyzDLT(2,1,i);
  data{i,14}=xyzDLT(3,1,i);
end
for i=1:nCams
  data{i,8}=floor(f(i));
  data{i,9}=UoVo(2*i-1);
  data{i,10}=UoVo(2*i);
end
set(uda.handles.camTable,'Data',data);

% plot in the GUI figure axes
plot3DReconstruct();

% Enable save results button and editing button
set(uda.handles.saveResultsButton,'Enable','on');
set(uda.handles.editOutliersButton,'Enable','on');
set(uda.handles.TsaiModelButton,'Enable','on');
return

function [] = TsaiModelButton_callback(varargin)
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

% prepare calibration input
ptMat = uda.wandPts;
nCams = size(ptMat,2)/4;
wpix = uda.imageWidth;
hpix = uda.imageHeight;
pixel_width = uda.pixelwidth;



xyz1 = uda.w1; xyz2 = uda.w2;
outliers = isnan(xyz1(:,1)) | isnan(xyz2(:,1));
ptMat(outliers, :) = [];
xyz1(outliers, :) = [];
xyz2(outliers, :) = [];
xyz = [xyz1 ; xyz2] * 1000; % change to mm unit



for i = 1 : nCams
    cam = [[ptMat(:, 2 * i - 1 : 2 * i); ptMat(:, 2 * i - 1 + nCams * 2 : 2 * i + nCams * 2)] xyz]; 
    camParaCalib(i, :) = TsaiCalibration(hpix(i), wpix(i), pixel_width, pixel_width, cam);
end
uda.camParaCalib = camParaCalib;
 figure; CameraDistribution(camParaCalib);
  save( [uda.fPath, 'camParaCalib.mat'], 'camParaCalib');
   CalibMatToTXT(camParaCalib,  [uda.fPath, 'camParaCalib.txt']);


function [] = initializeButton_callback(varargin)

% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');

if  ~isfield(uda,'justSaved') || ~uda.justSaved
  mess='Last calibration run has not yet been saved.  Are you sure you want to clear the current data?';
  yesno=questdlg(mess,'Really?','Clear','Save','Cancel','Clear');
  if strcmp(yesno,'Cancel')
    return;
  elseif strcmp(yesno,'Save')
    easyWandData=uda;
    easyWandData.tabData=get(uda.handles.camTable,'Data');
    
    % get save name and path
    [f,p]=uiputfile({'*.csv','comma-separated value files (*.csv)'});
    
    if f~=0
      if strcmpi(f(end-3:end),'.csv')
        f=f(1:end-4);
      end
      dlmwrite([p,f,'_dltCoefs.csv'],uda.coefs,',','precision',32);
      save([p,f,'_easyWandData.mat'],'easyWandData');
      mess=sprintf('Data saved to %s%s_dltCoefs.csv',p,f);
    else
      mess='Data not saved';
      disp(mess);
      return;
    end
    msgbox(mess);
    disp(mess);
  end
end
hmain=findobj('Tag','easyWandMain');
hedit=findobj('Tag','editMain');
close(hmain);
close(hedit);
easyWand5;

function [] = saveResultsButton_callback(varargin)

% get userdata
h1=findobj('tag','easyWandMain');
uda=get(h1,'userdata');
easyWandData=uda;
easyWandData.tabData=get(uda.handles.camTable,'Data');
easyWandData.handles=[];
if ~isfield(uda,'coefs')
  mess='Must compute calibration before saving!';
  msgbox(mess);
  disp(mess)
  return;
end
currDir=pwd;
if isfield(uda,'fPath')
  cd(uda.fPath);
end
% get save name and path
[fname,pname]=uiputfile({'*.csv','comma-separated value files (*.csv)'});
if fname~=0
  if strcmpi(fname(end-3:end),'.csv')
    fname=fname(1:end-4);
  end
  dlmwrite([pname,fname,'_dltCoefs.csv'],uda.coefs,',');
  save([pname,fname,'_easyWandData.mat'],'easyWandData');
%   camParaCalib = uda.camParaCalib;
%   save( [pname, 'camParaCalib.mat'], 'camParaCalib');
%   cd(currDir);
%     CalibMatToTXT(camParaCalib,  [pname, 'camParaCalib.txt']);
  mess=sprintf('Data saved to %s%s_dltCoefs.csv',pname,fname);
  uda.justSaved=1;
  set(h1,'UserData',uda);
  % Save out undistortion Tforms for use with digitizing software
  if uda.distortionMode>=1 || nansum(abs(uda.nlin))>0
    pdx=1:uda.nCams;
    %pdx=pdx(logical(uda.calibrationMode));
    for i=pdx
      name=['_cam',num2str(pdx(i)),'Tforms'];
      fl=repmat(uda.focalLengths(i),1,2);
      kc=uda.nlin(5*pdx(i)-4:5*pdx(i));
      if sum(abs(kc))>0 %isfinite(kc(1))
        pp=uda.ppts(pdx(i)*2-1:pdx(i)*2);
        res=[uda.imageWidth(pdx(i)) uda.imageHeight(pdx(i))];
        create_Tforms(fl,pp,kc,res,[pname,fname,name]);
      end
    end
  end
else
  mess='Data not saved';
end
cd(currDir);
msgbox(mess);
disp(mess);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utility & computations functions not directly called by the GUI   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = figure_resizefcn(varargin)
% Resize function exclusively for displays that are larger than 920px wide
% but not large enough to display the entire data table onscreen
h1 = findobj('Tag','easyWandMain');
res = get(h1,'Position');
uda = get(h1,'UserData');
f = [uda.charWidth uda.charHeight];
screenwidth=924.0/f(1); % Make screen 924px wide (30px of wiggle)
screentop=668.0/f(2);  % Make screen 668px tall (100px of wiggle)
tableheight=100/f(2);
res2=get(0,'ScreenSize');
posX=(res2(3)/f(1) - screenwidth)/2;
posY=(res2(4)/f(2) - screentop)/2;
maxTableWidth=172; % Max table width in characters
% Check if vertical resolution too small
if res(4)*uda.charHeight <668
  set(h1,'Position',[res(1) posY res(3) screentop]);
  res(4) = 668.0/uda.charHeight;
end
if res(3)*uda.charWidth > 921 % Horiz resolution is higher than original
  set(uda.handles.easyWandMainPanel,'Position',[-0.4 -0.4 res(3)+0.8 res(4)+1]);
  if res(3)*uda.charWidth > maxTableWidth*f(1) % Larger than max table size
    htabpos = [-2 0 maxTableWidth+0.4 tableheight];
    set(uda.handles.camTable,'Position',htabpos);
  else
    htabpos = [-2 0 res(3)+2 tableheight];
    set(uda.handles.camTable,'Position',htabpos);
  end
else
  %Put display in the middle of the screen
  set(h1,'Position',[posX posY screenwidth-0.4 screentop]);
  % Reset table size as well
  set(uda.handles.camTable,'Position',[-2 0 screenwidth+2 tableheight]);
  % Reset panel size
  set(uda.handles.easyWandMainPanel,'Position',[-0.4 -0.4 screenwidth+0.4 screentop+1]);
end

function [xyz]=angleaxisRotation(xyz,uvw,theta)

% function [xyz]=angleaxisRotation(xyz,uvw,theta)
%
% Rotates xyz about axis uvw by angle theta
%
% Inputs: xyz - array of xyz coordinates to be rotated
%         uvw - axis to rotate about (must be same length as xyz)
%         theta - angle to rotate through (single value)
%
% Pure MATLAB implementation, no MEX involved

% vectorized method
uvw=uvw./repmat(rnorm(uvw),1,3); % make sure UVW is a matrix of unit vectors

if numel(theta)==1
  xyz=uvw.*(repmat(dot(uvw,xyz,2),1,3))+(xyz-uvw.*(repmat(dot(uvw,xyz,2),1,3))).* ...
    cos(theta)+cross(xyz,uvw,2).*sin(theta);
else
  xyz=uvw.*(repmat(dot(uvw,xyz,2),1,3))+(xyz-uvw.*(repmat(dot(uvw,xyz,2),1,3))).* ...
    repmat(cos(theta),1,3)+cross(xyz,uvw,2).*repmat(sin(theta),1,3);
end

function [xyz,T,ypr,Uo,Vo,Z] = DLTcameraPosition(coefs)

% function [xyz,T,ypr,Uo,Vo,Z] = DLTcameraPosition(coefs)
%
% Computes the camera position in the calibration frame coordinate system.
% This is useful because it allows you to recreate the scene perceived by
% the camera in a 3D modeling and animation program such as Maya.
%
% Inputs: coefs - the 11 DLT coefficients for the camera in question
%
% Outputs: xyz - the camera position in calibration frame XYZ space
%          T   - the 4x4 transformation matrix for camera position and
%                orientation
%          ypr - Yaw,Pitch,Roll angles in degrees (Maya compatible)
%          Uo - perceived image center along the camera width axis
%          Vo - perceived image center along the camera height axis
%          Z - distance from camera to image plane
%
% For detailed notes on recreating a scene in Maya see the accompanying
% file "DLTtoMaya.rtf"
%
% Note regarding Maya compatibility: The angles in ypr should be copied
% into the Maya Transform Attributes:Rotate cells in the order in which
% they appear in ypr.  The Rotate Order should be set to xyz.
%
% Ty Hedrick, Feb. 2nd, 2007

m1=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7); ...
  coefs(9),coefs(10),coefs(11)];
m2=[-coefs(4);-coefs(8);-1];

xyz=m1\m2;

D=(1/(coefs(9)^2+coefs(10)^2+coefs(11)^2))^0.5;
D=D(1); % + solution

Uo=(D^2)*(coefs(1)*coefs(9)+coefs(2)*coefs(10)+coefs(3)*coefs(11));
Vo=(D^2)*(coefs(5)*coefs(9)+coefs(6)*coefs(10)+coefs(7)*coefs(11));

du = (((Uo*coefs(9)-coefs(1))^2 + (Uo*coefs(10)-coefs(2))^2 + (Uo*coefs(11)-coefs(3))^2)*D^2)^0.5;
dv = (((Vo*coefs(9)-coefs(5))^2 + (Vo*coefs(10)-coefs(6))^2 + (Vo*coefs(11)-coefs(7))^2)*D^2)^0.5;

du=du(1); % + values
dv=dv(1);
Z=-1*mean([du,dv]); % there should be only a tiny difference between du & dv

T3=D*[(Uo*coefs(9)-coefs(1))/du ,(Uo*coefs(10)-coefs(2))/du ,(Uo*coefs(11)-coefs(3))/du ; ...
  (Vo*coefs(9)-coefs(5))/dv ,(Vo*coefs(10)-coefs(6))/dv ,(Vo*coefs(11)-coefs(7))/dv ; ...
  coefs(9) , coefs(10), coefs(11)];

dT3=det(T3);

if dT3 < 0
  T3=-1*T3;
end

T=inv(T3);
T(:,4)=[0;0;0];
T(4,:)=[xyz(1),xyz(2),xyz(3),1];

% compute YPR from T3
%
% Note that the axes of the DLT based transformation matrix are rarely
% orthogonal, so these angles are only an approximation of the correct
% transformation matrix
%  - Addendum: the nonlinear constraint used in mdlt_computeCoefficients below ensures the
%  orthogonality of the transformation matrix axes, so no problem here
alpha=atan2(T(2,1),T(1,1));
beta=atan2(-T(3,1), (T(3,2)^2+T(3,3)^2)^0.5);
gamma=atan2(T(3,2),T(3,3));

ypr=rad2deg([gamma,beta,alpha]);

function [c,xyzMat,R,tv,sf,xyzMat2,ptMatu,ptMat2u,f,UoVo,nlin]=sbaCalib(ptMat,...
  UoVo,wandLen,ptMat2,f,nlin,optimMode,distortionMode)

% The bundle-adjustment calibration subfunction for easyWand5.0 - 5.3,
% replaced by sbaCalib_pass2 in easyWand5.4

% function
% [c,xyzMat,R,tv,sf,xyzMat2,ptMatu,ptMat2u,f,UoVo,nlin]=sbaCalib(ptMat...
%    UoVo,wandLen,ptMat2,f,nlin,optimMode,distortionMode)
% Camera calibration function to estimate camera extrinsics and intrinsics
%   for C cameras from a set of shared wand points and background points.
%   Uses the accompanying MEX bundle adjustment code
%
% Inputs:
%   ptMat - an [n,C*4] array of [u,v] coordinates from two cameras and two
%     points [c1u1,c1v1,c2u1,c2v1,c1u2,c1v2,c2u2,c2v2] representing the two
%     ends of a wand of known length
%   UoVo_est - a [1,C*2] array of the (estimated) principal point
%     coordinates for the two cameras
%   wandLen - the known wand length (for scale)
%   ptMat2 (optional) - an [n2,C*2] array of [u,v] coordinates shared
%     between the cameras but not part of the wand
%   f_est - a [1,C] array with estimates of the focal length of each camera
%     (in pixels)
%   nlin (optional) - [1,C*5] array of nonlinear lens distortion
%     coefficients
%   optimMode - determines the number of parameters to optimize:
%     1: camera extrinsics only
%     2: camera extrinsics and focal lengths
%     3: camera extrinsics, focal lengths, and principal points
%   distortionMode - number of non-fixed distortion coefficients

% count number of cameras
nCams=size(ptMat,2)/4;
nPts=size(ptMat,1);
% initialize empty output functions
c=1e24;
xyzMat=ptMat(:,1:6)*NaN;
xyzMat2=zeros(size(ptMat2,1),3)*NaN;
R=repmat(ones(3,3)*NaN,[1 1 nCams-1]);
tv=repmat((1:3)*NaN,[1 1 nCams-1]);
sf=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin preliminary calibration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply undistortion for prelim cal
for i = 1:nCams
  ptMatu(:,2*i-1:2*i) = undistort(ptMat(:,2*i-1:2*i),f(i),UoVo(i*2-1:i*2), ...
    nlin(i*5-4:i*5),3);
  ptMatu(:,2*nCams+2*i-1:2*nCams+2*i) = undistort(ptMat(:,2*nCams+...
    2*i-1:2*nCams+2*i),f(i),UoVo(i*2-1:i*2),nlin(i*5-4:i*5),3);
  ptMat2u(:,2*i-1:2*i) = undistort(ptMat2(:,2*i-1:2*i),f(i),...
    UoVo(i*2-1:i*2),nlin(i*5-4:i*5),3);
end

%  subtract the principal point
ptMatrm=ptMatu-repmat([UoVo,UoVo],size(ptMatu,1),1);
ptMat2rm=ptMat2u-repmat(UoVo,size(ptMat2u,1),1);
% divide by the focal lengths
for i=1:numel(UoVo)/2
  fArray(1,i*2-1:i*2)=f(i);
end
ptNorm=ptMatrm./repmat(fArray,size(ptMatrm,1),2);
ptNorm2=ptMat2rm./repmat(fArray,size(ptMat2rm,1),1);

% get a Rotation matrix and Translation vector for each camera with respect
% to the last camera - 8-point algorithm
for i=1:nCams-1
  [R(:,:,i),tv(:,:,i)] = twoCamCal_v2([ptNorm(:,i*2-1:i*2), ...
    ptNorm(:,nCams*2-1:nCams*2);ptNorm2(:,[i*2-1,i*2,nCams*2-1,nCams*2])]);
end

if isnan(sum(sum(tv)))
  mess = 'Failed to find an initial estimate of camera params, exiting...';
  disp(mess);
  msgbox(mess);
  return
end
X1 = zeros(size(ptNorm,1),3,nCams-1)*NaN;
X2 = zeros(size(ptNorm,1),3,nCams-1)*NaN;
% Triangulate the estimated 3D position of all points based on the above
% estimate of camera extrinsics
for i=1:nCams-1
  idx=[i,nCams];
  [X1(:,:,i)] = triangulate_v2(R(:,:,i),tv(:,:,i),ptNorm(:,[idx(1)*2-1:idx(1)*2,idx(2)*2-1:idx(2)*2]));
  [X2(:,:,i)] = triangulate_v2(R(:,:,i),tv(:,:,i),ptNorm(:,[idx(1)*2-1:idx(1)*2,idx(2)*2-1:idx(2)*2]+nCams*2));
  [X3(:,:,i)] = triangulate_v2(R(:,:,i),tv(:,:,i),ptNorm2(:,[idx(1)*2-1:idx(1)*2,idx(2)*2-1:idx(2)*2]));
end

% Old scaling routine
dWeights=[1,1,1]; % weights array to adjust for accuracy in reconstruction
% d = zeros(nCams-1,1)*NaN;
% for i=1:nCams-1
%   d(i,1)=nanmean(rnorm((X1(:,:,i)-X2(:,:,i)).*repmat(dWeights,size(X1,1),1)));
% end
%
%sf=wandLen./d;  % Scale to the expected wand length
%sf=1./d; % scale to a unit wand length

% new scaling routine (2015-06-03)
sf=1;
for i=2:nCams-1
  sf(i)=nanmean(nanmean([X1(:,:,i)./X1(:,:,1);X2(:,:,i)./X2(:,:,1);X3(:,:,i)./X3(:,:,1)]));
end
for i=1:nCams-1
  X1(:,:,i)=X1(:,:,i).*sf(i);
  X2(:,:,i)=X2(:,:,i).*sf(i);
  X3(:,:,i)=X3(:,:,i).*sf(i);
  tv(:,:,i)=tv(:,:,i).*sf(i);
end
X1=nanmean(X1,3);
X2=nanmean(X2,3);
xyzMat2=nanmean(X3,3);

% no need to scale since tv is scaled above
%xyzMat2=triangulate_v3(R,tv,ptNorm2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End preliminary calibration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up inputs to run external bundle adjustment starting with the camera
% pose and 3D point locations estimated in the above routines.

%sbaXY_tmp=[ptMatu(:,1:nCams*2);ptMatu(:,nCams*2+1:end);ptMat2u]; % BUG?
sbaXY_tmp=[ptMat(:,1:nCams*2);ptMat(:,nCams*2+1:end);ptMat2];

sbaXYZ_tmp=[X1;X2;xyzMat2];
ndx=find(isfinite(sbaXYZ_tmp(:,1)));
worldXYZ = sbaXYZ_tmp(ndx,:);
imageUV = sbaXY_tmp(ndx,:);
intrinsics=[f', reshape(UoVo,2,nCams)', ones(nCams,1),zeros(nCams,1)];
distortion=reshape(nlin,5,nCams)';
camPos=zeros(nCams,3);
camR=zeros(nCams,4);
for i=1:nCams-1
  camR(i,:)=RMtoQ(R(:,:,i));
  camPos(i,:)=tv(:,:,i);
end
camR(nCams,:)=[1,0,0,0];
distortionFlag=5-distortionMode;
modeList = [4,2,5]; % Number of fixed params for each mode
intrinsicsFlag = modeList(optimMode);

% call to easySBA.  Use fakeSBA to test initialization only
[worldXYZout, camPosout, camRout, intrinsicsout, distortionout] = ...
  easySBA(imageUV, worldXYZ, camPos, camR, intrinsics, intrinsicsFlag, ...
  distortion, distortionFlag);

sbaXYZ_tmp(ndx,:) = worldXYZout;
X1sba=sbaXYZ_tmp(1:size(X1,1),:);
X2sba=sbaXYZ_tmp(size(X1,1)+1:size(X1,1)*2,:);
X3sba=sbaXYZ_tmp(size(X1,1)*2+1:end,:);

weightedD=(X1sba-X2sba).*repmat(dWeights,size(X1,1),1);
D=rnorm(weightedD);
sf=wandLen./nanmean(D);

sbaCamPos = camPosout;
for i=1:nCams-1
  tv(:,:,i)=(sbaCamPos(i,:)-sbaCamPos(end,:))*sf;
end
nlin = reshape(distortionout',1,5*nCams);
f = intrinsicsout(:,1);
UoVo = intrinsicsout(:,2:3);
for i=1:nCams
  R(:,:,i)=QtoRM(camRout(i,:));
end

% optimization function calculation
c=100*nanstd(D)./nanmean(D);
xyzMat=[X1sba,X2sba]*sf;
xyzMat2=X3sba*sf;

% update ptMatu & ptMat2u (distortion-corrected xy points) to reflect SBA
% output
for i = 1:nCams
  
  ptMatu(:,2*i-1:2*i) = undistort(ptMat(:,2*i-1:2*i),f(i),UoVo(i,:), ...
    nlin(i*5-4:i*5),3);
  ptMatu(:,2*nCams+2*i-1:2*nCams+2*i) = undistort(...
    ptMat(:,2*nCams+2*i-1:2*nCams+2*i),f(i),UoVo(i,:),nlin(i*5-4:i*5),3);
  ptMat2u(:,2*i-1:2*i) = undistort(ptMat2(:,2*i-1:2*i),f(i),UoVo(i,:),...
    nlin(i*5-4:i*5),3);
  
end

function [uvdd] = undistort(uv,f,UoVo,nlin,niter)

% function [uvdd] = undistort(uv,f,UoVo,nlin,niter)
%
% inputs:
%  uv - array of pixel coordinates, distorted
%  f - focal length
%  UoVo - principal point
%  nlin - nonlinear distortion coefficients
%  niter - number of undistort iterations, 5 is usually more than good
%
% outputs:
%  uvdd - array of pixel coordinates, undistorted
%
% Iteratively applies undistortion coefficients to estimate undistorted
% pixel coordinates from observation of distorted pixel coordinates

% create normalized points from pixel coordinates
uvn = (uv - repmat(UoVo,size(uv,1),1))./f;

uvnd = uvn;

% undistort (niter iterations)
for i=1:niter
  r2=rnorm(uvnd).^2; % square of the radius
  rad = 1 + nlin(1)*r2 + nlin(2)*r2.^2 + nlin(5)*r2.^3; % radial distortion
  tan = [2*nlin(3).*uvnd(:,1).*uvnd(:,2) + nlin(4)*(r2 + 2*uvnd(:,1).^2)];
  tan(:,2) = nlin(3)*(r2 + 2*uvnd(:,2).^2) + 2*nlin(4).*uvnd(:,1).*uvnd(:,2);
  
  uvnd = (uvn - tan)./repmat(rad,1,2);
end

% restore pixel coordinates
uvdd = uvnd*f + repmat(UoVo,size(uv,1),1);


function [norms] = rnorm(mat)

norms=dot(mat',mat').^0.5';

function [R,T,c] = twoCamCal_v2(ptNorm,E)

% function [R,T,c] = twoCamCal_v2(ptNorm,E)
%
% Computes the rotation matrix and translation vector between two cameras
% from a shared set of [u,v] coordinates.
%
% Inputs:
%  ptNorm - [n,4] array of the form [c1U1,c1V1,c2U1,c2V2]
%                                   [ ................. ]
%                                   [c1Un,c1Vn,c2Un,c2Vn]
%
%  F - [3,3] rank 2 assumed camera matrix
%
% Outputs:
%  R - [3,3] rotation matrix
%  T - [3] translation vector
%  c - Quality score; lower is better
%
% Note that the rotation and translation is for camera1 with respect to
% camera2, i.e. camera2 sits at R=[0,0,0;0,0,0;0,0,0] and T=[0,0,0].
%
% Ty Hedrick

% initialize output variables
R=zeros(3,3)*NaN;
T=zeros(3,1)*NaN;

% clean out any NaN rows in ptNorm
ptNorm(isnan(sum(ptNorm,2))==true,:)=[];

% get an (assumed) Essential matrix if not given in args. Use the computer
% vision toolbox function if it is available, otherwise use the built-in
% 8-point algorithm
if nargin < 2
  if exist('estimateFundamentalMatrix','file')==2
    if size(ptNorm,1)>100
      [E,inliers] = estimateFundamentalMatrix(ptNorm(:,3:4),ptNorm(:,1:2),'Method','RANSAC');
    else
      [E] = estimateFundamentalMatrix(ptNorm(:,3:4),ptNorm(:,1:2),'Method','Norm8Point');
    end
  else
    [E] = computeFnew(ptNorm);
  end
end
  
% solve for Rotation and Translation of camera 2 w.r.t. camera 1
[U,D,V] = svd(E);

% preliminary validity check
D2=D./D(1,1);
c=100*abs(1-D2(2,2))+10*abs(D2(3,3))+1*sum(abs(E*V(:,end)));

if c > 10000
  return
else
  W=[0,-1,0;1,0,0;0,0,1];
  %   Z=[0,-1,0;1,0,0;0,0,0];
  
  R=U*W'*V';
  R2=U*W*V';
  R3=U*W'*-V';
  R4=U*W*-V';
  
  tv=U(:,3);
  
  % Find the right rotation matrix
  if round(det(R))==-1 && round(det(R2))==-1
    R=R3;
    R2=R4;
  end
  
  if round(det(R))==1 && round(det(R2))==-1
    % one valid matrix
    %     R=R;
    T=tv;
    return
  elseif round(det(R))==-1 && round(det(R2))==1
    % one valid matrix
    R=R2;
    T=tv;
    return
  else
    % two valid rotation matrices - find the one that places the
    % reconstructed coordinates in front of (-Z) the cameras
    %
    % Use triangulate_v2 here, more numerically stable than _v3
    [X1,X1r]=triangulate_v2(R,tv',ptNorm(:,1:4));
    [X2,X2r]=triangulate_v2(R2,tv',ptNorm(:,1:4));
    zScore=[sum(sign(X1(:,3))),sum(sign(X1r(:,3))),...
      sum(sign(X2(:,3))),sum(sign(X2r(:,3)))];
    
    % 2015-05-12: attempt to improve decision making for selecting the
    % correct rotation/translation combination in some unusual cases
    %
    % first, check to see if we have paired outputs in zScore.  If we do,
    % use the original method.  If we don't use a new simplified method
    % that may work better in this situation.  In the majority of cases,
    % zScore does produce paired outputs.
    %     if (abs(zScore(1))-abs(zScore(2))==0 & abs(zScore(3))-abs(zScore(4))==0) | min(abs(zScore))>100
    %       % paired or big - use old method
    %       if abs(sum(zScore(1:2)))>abs(sum(zScore(3:4)))
    %         %       R=R;
    %         if sum(zScore(1:2))<0
    %           T=tv;
    %         else
    %           T=-tv;
    %         end
    %         return
    %       elseif abs(sum(zScore(1:2)))<abs(sum(zScore(3:4)))
    %         R=R2;
    %         if sum(zScore(3:4))<0
    %           T=tv;
    %         else
    %           T=-tv;
    %         end
    %         return
    %       else
    %         % insufficient criteria to distinguish the proper R and T combo;
    %         % probably due to either very noisy data or poor normalization of the
    %         % points via poor selection of focal lengths or principal points
    %         %
    %         %disp('Warning - poorly resolved rotation')
    %         R=zeros(3,3)*NaN;
    %         T=zeros(3,1)*NaN;
    %         c=c+5000;
    %       end
    %     else
    %       % not paired
    %       % 2015-05-12: simplified assignment of preliminary calibration
    %       zdx=find(abs(zScore)==max(abs(zScore)));
    %       if zdx(1)==1
    %         T=-tv;
    %         R=R;
    %       elseif zdx(1)==2
    %         T=tv;
    %         R=R;
    %       elseif zdx(1)==3
    %         T=-tv;
    %         R=R2;
    %       else
    %         T=tv;
    %         R=R2;
    %       end
    %     end
    
    % new decision tree for finding the right 8-point outputs (based on
    % 2016-06-10 work)
    %
    % step 1 - look for a case with a better (i.e. larger magnitude)
    % zScore, this indicates that the observed points are more
    % consistently on one side of the base camera when reconstructed in
    % 3D
    if abs(zScore(1))>abs(zScore(3))
      zdx=1;
      R=R;
    elseif abs(zScore(1))<abs(zScore(3))
      zdx=3;
      R=R2;

      
      % step 2 - both initial options are equivalent, so now consider the
      % reversed version of both cases. If things are working well, the
      % reversed case (i.e. from the perspective of cam 2 instead of cam 1)
      % will also have a large zScore of the same sign and the abs() of the
      % sum will be large.
    else
      if abs(sum(zScore(1:2)))>abs(sum(zScore(3:4)))
        zdx=1;
        R=R;
      else
        zdx=3;
        R=R2;
      end
    end
    
    % we want the z score to be negative, if it is positive reverse the
    % translation vector; this will reflect the Z position of the
    % reconstructed points.
    if zScore(zdx)<0
      T=tv;
    else
      T=-tv;
    end
    
  end
end

function [F] = computeFnew(ptNorm)

% [F] = computeFnew(ptNorm)
%
% Computes the Fundamental matrix F via SVD (8 point algorithm) with
% normalization of the inputs as recommended by Hartley

% Set average [X,Y] to the center
mean1=nanmean(ptNorm(:,1:2));
mean2=nanmean(ptNorm(:,3:4));

ptNorm(:,1:2)=ptNorm(:,1:2)-repmat(mean1,size(ptNorm,1),1);
ptNorm(:,3:4)=ptNorm(:,3:4)-repmat(mean2,size(ptNorm,1),1);

% Scale the average [X,Y] distance to 2^0.5
scale1 = 2^0.5 ./ nanmean(rnorm(ptNorm(:,1:2)));
scale2 = 2^0.5 ./ nanmean(rnorm(ptNorm(:,3:4)));

ptNorm(:,1:2)=ptNorm(:,1:2).*scale1;
ptNorm(:,3:4)=ptNorm(:,3:4).*scale2;

% get initial solution
%
% construct matrix A
A(:,1)=ptNorm(:,3).*ptNorm(:,1);
A(:,2)=ptNorm(:,3).*ptNorm(:,2);
A(:,3)=ptNorm(:,3);
A(:,4)=ptNorm(:,4).*ptNorm(:,1);
A(:,5)=ptNorm(:,4).*ptNorm(:,2);
A(:,6)=ptNorm(:,4);
A(:,7)=ptNorm(:,1);
A(:,8)=ptNorm(:,2);
A(:,9)=1;

[~,~,V] = svd(A);
F=V(:,end);

% Next step is given as Let F = UDVt be the SVD of F, where D is a diagonal
% matrix D=diag(r,s,t) satisfying r> s> t.  Then F'=U*diag(r,s,0)*Vt minimizes
% the Frobenius norm of F-F' [8 point algorithm]

[U,D,V] = svd(reshape(F,3,3));
F=U*diag([D(1,1) D(2,2) 0])*V';

% Re-scale to get rid of the normalizations
S1=[scale1,0,-scale1*mean1(1); ...
  0, scale1, -scale1*mean1(2); ...
  0,0,1];

S2=[scale2,0,-scale2*mean2(1); ...
  0, scale2, -scale2*mean2(2); ...
  0,0,1];

F = S1'*F*S2;

F = F./F(3,3);

function [xyz,rmse] = dlt_reconstruct(c,camPts)

% function [xyz,rmse] = dlt_reconstruct(c,camPts)
%
% This function reconstructs the 3D position of a coordinate based on a set
% of DLT coefficients and [u,v] pixel coordinates from 2 or more cameras
%
% Inputs:
%  c - 11 DLT coefficients for all n cameras, [11,n] array
%  camPts - [u,v] pixel coordinates from all n cameras over f frames,
%   [f,2*n] array
%
% Outputs:
%  xyz - the xyz location in each frame, an [f,3] array
%  rmse - the root mean square error for each xyz point, and [f,1] array,
%   units are [u,v] i.e. camera coordinates or pixels
%
% Ty Hedrick

% number of frames
nFrames=size(camPts,1);

% number of cameras
nCams=size(camPts,2)/2;

% setup output variables
xyz(1:nFrames,1:3)=NaN;
rmse(1:nFrames,1)=NaN;

% process each frame
for i=1:nFrames
  
  % get a list of cameras with non-NaN [u,v]
  cdx=find(isnan(camPts(i,1:2:nCams*2))==false); % should already be done by now
  
  % if we have 2+ cameras, begin reconstructing
  if numel(cdx)>=2
    
    % preallocate least-square solution matrices
    m1=zeros(numel(cdx)*2,3);
    m2=zeros(numel(cdx)*2,1);
    
    m1(1:2:numel(cdx)*2,1)=camPts(i,cdx*2-1).*c(9,cdx)-c(1,cdx);
    m1(1:2:numel(cdx)*2,2)=camPts(i,cdx*2-1).*c(10,cdx)-c(2,cdx);
    m1(1:2:numel(cdx)*2,3)=camPts(i,cdx*2-1).*c(11,cdx)-c(3,cdx);
    m1(2:2:numel(cdx)*2,1)=camPts(i,cdx*2).*c(9,cdx)-c(5,cdx);
    m1(2:2:numel(cdx)*2,2)=camPts(i,cdx*2).*c(10,cdx)-c(6,cdx);
    m1(2:2:numel(cdx)*2,3)=camPts(i,cdx*2).*c(11,cdx)-c(7,cdx);
    
    m2(1:2:numel(cdx)*2,1)=c(4,cdx)-camPts(i,cdx*2-1);
    m2(2:2:numel(cdx)*2,1)=c(8,cdx)-camPts(i,cdx*2);
    
    % get the least squares solution to the reconstruction
    xyz(i,1:3)=mldivide(m1,m2);
    if nargout>1
      % compute ideal [u,v] for each camera
      uv=m1*xyz(i,1:3)';
      
      % compute the number of degrees of freedom in the reconstruction
      dof=numel(m2)-3;
      
      % estimate the root mean square reconstruction error
      rmse(i,1)=(sum((m2-uv).^2)/dof)^0.5;
    end
  end
end

function [uv] = dlt_inverse(c,xyz)

% function [uv] = dlt_inverse(c,xyz)
%
% This function reconstructs the pixel coordinates of a 3D coordinate as
% seen by the camera specificed by DLT coefficients c
%
% Inputs:
%  c - 11 DLT coefficients for the camera, [11,1] array
%  xyz - [x,y,z] coordinates over f frames,[f,3] array
%
% Outputs:
%  uv - pixel coordinates in each frame, [f,2] array
%
% Ty Hedrick

% write the matrix solution out longhand for Matlab vector operation over
% all points at once
uv(:,1)=(xyz(:,1).*c(1)+xyz(:,2).*c(2)+xyz(:,3).*c(3)+c(4))./ ...
  (xyz(:,1).*c(9)+xyz(:,2).*c(10)+xyz(:,3).*c(11)+1);
uv(:,2)=(xyz(:,1).*c(5)+xyz(:,2).*c(6)+xyz(:,3).*c(7)+c(8))./ ...
  (xyz(:,1).*c(9)+xyz(:,2).*c(10)+xyz(:,3).*c(11)+1);

function m = nanmean(x,dim)

% Find NaNs and set them to zero
nans = isnan(x);
x(nans) = 0;

if nargin == 1 % let sum deal with figuring out which dimension to use
  % Count up non-NaNs.
  n = sum(~nans);
  n(n==0) = NaN; % prevent divideByZero warnings
  % Sum up non-NaNs, and divide by the number of non-NaNs.
  m = sum(x) ./ n;
else
  % Count up non-NaNs.
  n = sum(~nans,dim);
  n(n==0) = NaN; % prevent divideByZero warnings
  % Sum up non-NaNs, and divide by the number of non-NaNs.
  m = sum(x,dim) ./ n;
end

function d = reprojError(coefs,ptMat)

% function d = reprojError(coefs,ptMat)
%
% Compute the reprojection error for each point in ptMat assuming the
% camera extrinsics contained in coefs (DLT)

nCams = size(ptMat,2)/2;
xyz=dlt_reconstruct(coefs,ptMat);
uv=0*ptMat;
d=zeros(size(uv,1),nCams);
for i=1:nCams
  uv(:,2*i-1:2*i)=dlt_inverse(coefs(:,i),xyz);
  d(:,i)=rnorm(uv(:,2*i-1:2*i)-ptMat(:,2*i-1:2*i));
end

function d = reprojErrorUD(coefs,ptMat,f,ppts,nlin)

% function d = reprojErrorUD(coefs,ptMat,ppts,nlin)
%
% Compute the reprojection error for each point in ptMat assuming the
% camera extrinsics contained in coefs (DLT)
%
% reprojErrorUD is distortion aware

nCams = size(ptMat,2)/2;

% undistort
ptMatU=[];
for i=1:nCams
  try
    ptMatU(:,i*2-1:i*2)=undistort(ptMat(:,i*2-1:i*2),f(i),ppts(i*2-1:i*2),nlin(i*5-4:i*5),3);
  catch
    ptMatU(:,i*2-1:i*2)=ptMat(:,i*2-1:i*2);
  end
end

xyz=dlt_reconstruct(coefs,ptMatU);
uv=0*ptMat;
d=zeros(size(uv,1),nCams);
for i=1:nCams
  uv(:,2*i-1:2*i)=dlt_inverse(coefs(:,i),xyz);
  d(:,i)=rnorm(uv(:,2*i-1:2*i)-ptMatU(:,2*i-1:2*i));
end

function degrees = rad2deg(radians)

degrees = (180/pi) * radians;

function [axisXYZ]=findOrigin(axisXYZ)

% [axisPts]=findOrigin(axisXYZ)
%
% Finds the origin from points on the X, Y & Z axes by assuming mutual
% orthogonality and using fminsearch to find the point that best satisfies
% these conditions.  There will be multiple local minima, so it is
% important to start near the correct value if possible.

% get an initial estimate as the mean of the existing points
if isnan(axisXYZ(1))
  iOrigin=mean(axisXYZ(2:end,:));
else
  iOrigin=axisXYZ(1,:);
end

anonFunc=@(iOrigin)findOriginScore(iOrigin,axisXYZ);
[oOrigin,~]=fminsearch(anonFunc,iOrigin,optimset);

axisXYZ(1,:)=oOrigin;

function [c] = findOriginScore(iOrigin,axisXYZ)

% scoring function for findOrigin

axisXYZ=axisXYZ-repmat(iOrigin,4,1);

axNorm=axisXYZ./repmat(rnorm(axisXYZ),1,3);
nonOrth(1)=abs((pi/2)-acos(dot(axNorm(2,:),axNorm(3,:))));
nonOrth(2)=abs((pi/2)-acos(dot(axNorm(2,:),axNorm(4,:))));
nonOrth(3)=abs((pi/2)-acos(dot(axNorm(4,:),axNorm(3,:))));
c=sum(abs(nonOrth.^2));

function [y]=binarycombinations(n)

% function [y]=binarycombinations(n)
%
% Create a matrix of 2^n rows and n columns with a unique binary state in
% each row.  The first row is always all zeros and the final row all ones.
% Works through the possibilities in order, with all possibilities
% including only one "1" occuring before any possibilities with two "1"s
% and so on.
%
% Ty Hedrick

num_hyp=2^n;			% generate the set of hypotheses
y=zeros(n,num_hyp);		% all possible bit combos
for index=1:n,
  y(index,:)=(-1).^ceil((1:num_hyp)/(2^(index-1)));
end

% change -1s to 0s and rotate
idx=logical(y==-1);
y(idx)=0;
y=y';

% sort
y(:,end+1)=y*ones(n,1);
y=sortrows(y,n+1);
y(:,end)=[];

function [xyz,xyzR] = triangulate_v3(R,T,ptNorm)

% function [xyz,xyzR] = triangulate_v3(R,T,ptNorm)
%
% Combines the normalized coordinates, camera rotation and translation to
% of k cameras to give an xyz coordinate - operates in a purely linear
% manner and is therefore not optimal in the sense of minimizing
% reprojection error in the two cameras.  In fact, this is a pure Euclidian
% ray-midpoint triangulation routine of the type distinctly not favored by
% Hartley.  On the other hand, practical tests conducted with it and other
% triangulation methods show it to be superior for wand-type calibration.
% This function is similar in concept to triangulate_v1, but deals
% correctly with 3 or more cameras.  Based off of the discussion at:
% http://www.multires.caltech.edu/teaching/courses/3DP/ftp/98/hw/1/triangul
% ation.ps
%
% This triangulation function is faster and more accurate than _v2 but also
% occasionally not stable for inputs where the cameras are close to a
% degnerate condition with the optical axes separated by 180deg.
%
%
% Inputs:
%  R - rotation matrix between the cameras   [3,3,k-1] matrix
%  T - translation vector between the two cameras   [3,1,k-1] vector
%  ptNorm - normalized coordinates [principal point subtracted & divided by
%          focal length]   [n,k*2] array
%
% Outputs:
%  xyz - [n,3] array of xyz coordinates
%  xyzR - [n,3,k-1] array of xyz coordinates in the reference frame of
%  non-primary cameras
%
% Ty Hedrick, 2009-09-16

% nPts=size(ptNorm,1); % number of points
nCams=size(R,3)+1; % number of cameras

% note on conventions: the input R and T arrays are for cameras 1 to k-1,
% the final camera is assumed to have R=eye(3) and T=zeros(3,1).
R(:,:,end+1)=eye(3);
T(:,:,end+1)=zeros(1,3);

% this method cannot be easily adapted to more than 2 cameras together, so
% we need to do every possible pair and then get the group mean
bc=binarycombinations(nCams);
bc=bc(sum(bc,2)==2,:);
bc(bc(:,end)==0,:)=[]; % remove combos
xyz = zeros(size(ptNorm,1),3,size(bc,1))*NaN;
for i=1:size(bc,1)
  idx=find(bc(i,:)==true);
  pdx=sort([idx*2-1,idx*2]);
  xyz(:,:,i)=triangulate_v3int(R(:,:,idx),T(:,:,idx),ptNorm(:,pdx));
end

% get mean of all combinations
xyz=nanmean(xyz,3);

% transform to the other cameras
xyzR = zeros(size(xyz))*NaN;
for i=1:nCams-1
  xyzR(:,:,i)=(R(:,:,i)*(xyz'+ repmat(T(:,:,i)',1,size(xyz,1))))';
end

function [xyz] = triangulate_v3int(R,T,ptNorm)

% function [xyz] = triangulate_v3int(R,T,ptNorm)
%
% Internal function that performs the triangulation operation for any two
% cameras, finishes by projecting the 3D point back into the space of the
% base camera with R=eye(3) and T=zeros(1,3).

% make sure that our 2nd camera is a "base" camera with R=eye(3) and
% T=zeros(1,3)
R2(:,:,1)=R(:,:,2)'*R(:,:,1)*R(:,:,2)';
R2(:,:,2)=eye(3);
T2(:,:,1)=-R(:,:,2)'*R(:,:,1)*R(:,:,2)'*T(:,:,2)'+R(:,:,2)'*T(:,:,1)'-R(:,:,2)'*T(:,:,2)';
T2(:,:,2)=zeros(3,1);

% solving based on camera 2
%
% get the transpose (inverse) of the 2nd rotation matrix
R_2T=R2(:,:,2)';

tVec=repmat(R_2T*(T2(:,:,1)-T2(:,:,2)),1,size(ptNorm,1));

% extract homogenous coordinates for cameras 1 & 2
pts_1=ptNorm(:,1:2)';
pts_1(3,:)=1;
pts_2=ptNorm(:,3:4)';
pts_2(3,:)=1;

alpha_2=-R_2T*R2(:,:,1)*pts_2;

% create numerator and denominator for explicit expression of the depth
% vector Z_2
num=dot(pts_1,pts_1) .* dot(alpha_2,tVec) - dot(alpha_2,pts_1) .* dot(pts_1,tVec);
den=dot(pts_1,pts_1) .* dot(alpha_2,alpha_2) - dot(alpha_2,pts_1) .* dot(alpha_2,pts_1);

% depth vector
Z_2=num ./ den;

% get 3D coordinates in the camera #2 view
xyz2=pts_2 .* (ones(3,1) * Z_2);


% solving based on camera 1
%
% get the transpose (inverse) of the 2nd rotation matrix
R_1T=R2(:,:,1)';

tVec=repmat(R_1T*(T2(:,:,2)-T2(:,:,1)),1,size(ptNorm,1));

alpha_1=-R_1T*R2(:,:,2)*pts_1;

% create numerator and denominator for explicit expression of the depth
% vector Z_2
num=dot(pts_2,pts_2) .* dot(alpha_1,tVec) - dot(alpha_1,pts_2) .* dot(pts_2,tVec);
den=dot(pts_2,pts_2) .* dot(alpha_1,alpha_1) - dot(alpha_1,pts_2) .* dot(alpha_1,pts_2);

% depth vector
Z_1=num ./ den;

% get 3D coordinates in the camera #1 view
xyz1=pts_1 .* (ones(3,1) * Z_1);

% transform to the view of camera #2 for comparison
xyz1t=R2(:,:,1)'*(xyz1-repmat(T2(:,:,1),1,size(xyz1,2)));

% get the mean of the view in camera 2 based on both cameras 1 and 2
xyz_m=(xyz2+xyz1t)./2;

% transform these coordinates back to the viewpoint of a neutral camera
% with R=eye(3) and T=zeros(3,1)
xyz=(R(:,:,2)'*(xyz_m-repmat(T(:,:,2)',1,size(xyz_m,2))))';

function [xyz,xyzR] = triangulate_v2(R,tv,ptNorm)

% function [xyz,xyzR] = triangulate_v2(R,T,ptNorm)
%
% Alternative triangulation implementation, this one is more numerically
% stable compared to _v3 but also slower and less accurate
%
% Note that xyzR is only defined in two-camera cases

% [xyz,xyzR] = triangulate_vM2(R,tv,ptNorm);
% return;

% create camera matrix stacks
for i=1:size(R,3)
  pStack(:,:,i)=[R(:,:,i),tv(:,:,i)']; %#ok<AGROW>
end
pStack(:,:,i+1)=[eye(3),zeros(3,1)];

% get xyz
xyz=triangulate_v2int2(pStack,ptNorm);

% if we have a 2-camera case, prepare to calculate the inverse points as
% well
if size(R,3)==1
  pStackInv(:,:,1)=[eye(3),zeros(3,1)];
  
  % was pStackInv(:,:,2)=[inv(R),-1*tv'];
  pStackInv(:,:,2)=[inv(R),(-1*tv*R)']; % bugfix 2016-06-10
  xyzR=triangulate_v2int2(pStackInv,ptNorm);
else
  xyzR=[];
end

function X = triangulate_v2int2(pStack, ptNorm)
% function X = triangulate_v2int2(pStack, ptNorm)

% number of cameras
nCams=size(pStack,3);

% initialize output array
X=ones(size(ptNorm,1),3)*NaN;

% solve for each xyz in a loop (yes, it is faster than setting up one large
% matrix and solving that)
for i=1:size(ptNorm,1)
  if sum(isnan(ptNorm(i,:))==false)<4
    X(i,1:3)=NaN;
  else
    % create skew-symmetric matrices
    a = zeros(3,3,nCams);
    for j=1:nCams
      a(:,:,j)=[0,-1,ptNorm(i,j*2);1,0,-ptNorm(i,j*2-1);-ptNorm(i,j*2),ptNorm(i,j*2-1),0];
    end
    
    % create matrix A
    A = zeros(3*nCams,4)*NaN;
    for j=1:nCams
      A(j*3-2:j*3,1:4)=a(:,:,j)*pStack(:,:,j);
    end
    
    % prune rows with a NaN
    A(isnan(A(:,1))==true,:)=[];
    
    % SVD
    [~,~,V]=svd(A,'econ');
    
    % X
    x=V(:,end)';
    
    % dehomogenize
    X(i,1:3)=x(1:3)./x(4);
  end
end

function [ Q ] = RMtoQ( RM )

% function [ Q ] = RMtoQ( RM )
%
%QTORM Takes in Rotation Matrix RM and returns quaternion versor Q.
%   RM should be in the form of a 3x3 rotational matrix of the form
%   R =[ux, vx, wx]
%      [uy, vy, wy]
%      [uz, vz, wz]
%   NOTE - Limit use as much as possible. Degeneration is inherant in
%   conversion as the sin of the rotational angle approaches zero or as the
%   quaternion approaches the identity quanternion. Care has been taken in
%   the implementation of this program to limit this loss but loss will
%   inevitably occur.

a = (1/2)*sqrt(1 + RM(1,1) + RM(2,2) + RM(3,3));
b = (1/2)*sqrt(1 + RM(1,1) - RM(2,2) - RM(3,3));
if a<b
  a = (1/(4*b))*(RM(3,2) - RM(2,3));
  c = (1/(4*b))*(RM(1,2) + RM(2,1));
  d = (1/(4*b))*(RM(1,3) + RM(3,1));
else
  b = (1/(4*a))*(RM(3,2) - RM(2,3));
  c = (1/(4*a))*(RM(1,3) - RM(3,1));
  d = (1/(4*a))*(RM(2,1) - RM(1,2));
end
Q = [a,b,c,d];
return;

function f = charHeight()

% Determine the pixel width & height of the current font for the current
% system

fig=figure();
size_pixels=get(gcf,'Position');
set(gcf,'Units','characters')
size_characters=get(gcf,'Position');
f=size_pixels(3:4)./size_characters(3:4);
close(fig);
return;

function cellarr = filesplit(str)

% Split full file path by file separator

if ~ischar(str)
  disp('Error - filesplit requires arguments to be strings');
  return
end
delim=filesep;

k = strfind(str,delim);
if isempty(k)
  cellarr = {str};
else
  cellarr = cell(size(k));
  for idx=1:length(k)
    if idx==1
      cellarr{idx}=str(1:k(1)-1);
    elseif idx==length(k)
      if k(idx)==length(str)
        cellarr{idx}=str(k(idx-1)+1:end-1);
      else
        cellarr{idx}=str(k(idx-1)+1:k(idx)-1);
      end
    else
      cellarr{idx}=str(k(idx-1)+1:k(idx)-1);
    end
  end
  if k(end)<length(str)
    cellarr{length(k)+1}=str(k(end)+1:end);
  end
end

function [camud, camd] = create_Tforms(f,c,k,res,name)
% function [camud camd] = create_Tforms(f,c,k,res,name)
%
% Create forward and reverse tforms for intrinsic camera parameters:
% f: [1x2] focal lengths (equal if aspect ratio = 1)
% c: [1x2] principal points (should be set to pixel coords. of the center
%   of the image
% k: [1x5] undistortion coordinates determined by calibration toolbox -
%   must correspond with the focal length!
% res: image resolution [horiz vertical]
% name: filename to use in saving the tforms

% Get window resolution
nc = res(1); nr = res(2);

% Create mesh grid for interpolation points
[mx,my] = meshgrid(1:10:nc, 1:10:nr);
px = reshape(mx',numel(mx),1);
py = reshape(my',numel(my),1);
cp = [px py];

% Apply undistort transform
T.tdata = [f,c,k,3];
imp = undistort_Tform(cp,T);

% Local weighted mean: 1
% Choose some control points and the corresponding image points
points = ceil(numel(px)*rand(10000,1));
points = unique(sort(points));
cpnonlinear = cp(points,:);
impnonlinear = imp(points,:);
% Use cp2tform or fitgeotrans to find local weighted mean approx. of the inverse transform
if exist('fitgeotrans')==2
    camd = fitgeotrans(cpnonlinear,impnonlinear,'lwm',15);
else
    camd = cp2tform(cpnonlinear,impnonlinear,'lwm',15);
end

% Create reverse Tform from undistort_Tform.m
camud = maketform('custom',2,2,[],@undistort_Tform,T.tdata);

% Save Tforms to file
save(name,'camd','camud');

function [uvdd] = undistort_Tform(uv,T)

% function [uvdd] = undistort_Tform(uv,T)
%
% inputs:
%  uv - array of pixel coordinates, distorted
%  T.tdata(1:2) - focal length
%  T.tdata(3:4) - principal point
%  T.tdata(5:9) - nonlinear distortion coefficients
%  T.tdata(10) - number of interations
%
% outputs:
%  uvdd - array of pixel coordinates, undistorted
%
% Iteratively applies undistortion coefficients to estimate undistorted
% pixel coordinates from observation of distorted pixel coordinates. This
% version setup for use with MATLAB's tform routines

% break out packed variables
tdata = T.tdata;
f = mean(tdata(1:2));
UoVo = tdata(3:4);
nlin = tdata(5:9);
niter = tdata(10);

% create normalized points from pixel coordinates
uvn = (uv - repmat(UoVo,size(uv,1),1))./f;

uvnd = uvn;

% undistort (niter iterations)
for i=1:niter
  r2=rnorm(uvnd).^2; % square of the radius
  rad = 1 + nlin(1)*r2 + nlin(2)*r2.^2 + nlin(5)*r2.^3; % radial distortion
  
  % tangential distortion
  tan = [2*nlin(3).*uvnd(:,1).*uvnd(:,2) + nlin(4)*(r2 + 2*uvnd(:,1).^2)];
  tan(:,2) = nlin(3)*(r2 + 2*uvnd(:,2).^2) + 2*nlin(4).*uvnd(:,1).*uvnd(:,2);
  
  uvnd = (uvn - tan)./repmat(rad,1,2);
end

% restore pixel coordinates
uvdd = uvnd*f + repmat(UoVo,size(uv,1),1);

function [coefs, resid] = mdlt_computeCoefficients(xyz, imageuv)
%
%function [coefs,resid] = mdlt_computeCoefficients(xyz,imageuv)
%
% Inputs:
% xyz: [3,n] matrix of computed 3D positions
% imageuv: [2,n] matrix of corresponding image points
%
% REFERENCES: 1. The nonlinear constraint on the orthogonality that is used
% to solve for one of the coefficients in terms of the other 10 was taken
% from http://www.kwon3d.com/theory/dlt/mdlt.html
%
% 2. This paper shows the particular mathematical linearization technique
% for solving non-linear nature of equations due to adding non-linear
% constraints.
%
%	Miller N. R., Shapiro R., and McLaughlin T. M. A Technique for
%	Obtaining Spatial Kinematic Parameters of Segments of Biomechanical
%	Systems from Cinematographic Data. J. Biomech, 1980, v.13, pp535-547

% check for any NaN rows (missing data) in the xyz or imageuv
ndx=find(sum(isnan([xyz,imageuv]),2)>0);

% remove any missing data rows
xyz(ndx,:)=[];
imageuv(ndx,:)=[];

% Compute initial linear least-squares estimate
M=zeros(size(xyz,1)*2,11);
for i=1:size(xyz,1)
  M(2*i-1,1:3)=xyz(i,1:3);
  M(2*i,5:7)=xyz(i,1:3);
  M(2*i-1,4)=1;
  M(2*i,8)=1;
  M(2*i-1,9:11)=xyz(i,1:3).*-imageuv(i,1);
  M(2*i,9:11)=xyz(i,1:3).*-imageuv(i,2);
end

% re-arrange the imageuv array for the linear solution
imageuvF=reshape(flipud(rot90(imageuv)),numel(imageuv),1);

% get the linear solution to the 11 parameters
coefs=M\imageuvF;

% do some iteration to ensure orthogonality: the hard part Using the
% orthogonality contstraint, estimate C1 The basic constraint:
% (C1*C5+C2*C6+C3*C7)*(C9^2+C10^2+C11^2)=(C1*C9+C2*C10+C3*C11) ...
%    *(C5*C9+C6*C10+C7*C11)
% Following the linear least squares technique used in Miller (1980),
% solve for C2, ... C11 using this estimate.  Iterate.
maxIterations=30;
iter=1;
dC=999;
while iter<=maxIterations && dC>10^-7
  
  newCoefs = coefs;
  % Solve for C1 in terms of C2..C11
  newCoefs(1)= -((coefs(2)*coefs(10) + coefs(3)*coefs(11))*(coefs(5)*coefs(9) + ...
    coefs(6)*coefs(10) + coefs(7)*coefs(11)) - (coefs(2)*coefs(6) + ...
    coefs(3)*coefs(7))*(coefs(9)^2 + coefs(10)^2 + coefs(11)^2))/ ...
    (coefs(9)*(coefs(5)*coefs(9) + coefs(6)*coefs(10) + coefs(7)*coefs(11)) ...
    - coefs(5)*(coefs(9)^2 + coefs(10)^2 + coefs(11)^2));
  
  % Use the basic DLT equations
  % u = (C1*X + C2*Y + C3*Z) / (L9*X + L10*Y + L11*Z + 1)
  % v = (C5*X + C6*Y + C7*Z) / (L9*X + L10*Y + L11*Z + 1)
  %
  % and the new value for C1 to solve for C2, ..., C11
  
  % syms C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 X Y Z real
  % constraint = (C1*C5+C2*C6+C3*C7)*(C9^2+C10^2+C11^2)-(C1*C9+C2*C10+C3*C11) ...
  %    *(C5*C9+C6*C10+C7*C11);
  % C1=solve(constraint,C1);
  % u(X,Y,Z) = (C1*X + C2*Y + C3*Z +C4) / (C9*X + C10*Y + C11*Z + 1);
  % v(X,Y,Z) = (C5*X + C6*Y + C7*Z +C8) / (C9*X + C10*Y + C11*Z + 1);
  
  % Set up expression (9) in Miller with DLT formulation instead of explicit
  % camera extrinsics
  
  Zmat = zeros(2*size(imageuv,1),10);
  Fmat = zeros(2*size(imageuv,1),1);
  C2=newCoefs(2); C3=newCoefs(3); C4=newCoefs(4); C5=newCoefs(5);
  C6=newCoefs(6); C7=newCoefs(7); C8=newCoefs(8); C9=newCoefs(9);
  C10=newCoefs(10); C11=newCoefs(11);
  for i=1:size(imageuv,1)
    X = xyz(i,1); Y = xyz(i,2); Z = xyz(i,3);
    Zmat(i*2-1,1) = (Y - (X*(C10*(C5*C9 + C6*C10 + C7*C11) - C6*(C9^2 + ...
      C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 ...
      + C11^2)))/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2-1,2) = (Z - (X*(C11*(C5*C9 + C6*C10 + C7*C11) - C7*(C9^2 + ...
      C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 ...
      + C11^2)))/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2-1,3) = 1/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2-1,4) = -((C9*X*(C2*C10 + C3*C11))/(C9*(C5*C9 + C6*C10 + ...
      C7*C11) - C5*(C9^2 + C10^2 + C11^2)) + (X*(C10^2 + C11^2)*((C2*C10 ...
      + C3*C11)*(C5*C9 + C6*C10 + C7*C11) - (C2*C6 + C3*C7)*(C9^2 + C10^2 ...
      + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + ...
      C11^2))^2)/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2-1,5) = -((X*(C10*(C2*C10 + C3*C11) - C2*(C9^2 + C10^2 + ...
      C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + ...
      C11^2)) - (C9*C10*X*((C2*C10 + C3*C11)*(C5*C9 + C6*C10 + C7*C11) ...
      - (C2*C6 + C3*C7)*(C9^2 + C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 + ...
      C7*C11) - C5*(C9^2 + C10^2 + C11^2))^2)/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2-1,6) = -((X*(C11*(C2*C10 + C3*C11) - C3*(C9^2 + C10^2 + ...
      C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + ...
      C11^2)) - (C9*C11*X*((C2*C10 + C3*C11)*(C5*C9 + C6*C10 + C7*C11) ...
      - (C2*C6 + C3*C7)*(C9^2 + C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 ...
      + C7*C11) - C5*(C9^2 + C10^2 + C11^2))^2)/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2-1,7) = 0;
    Zmat(i*2-1,8) = ((X*(2*C9*(C2*C6 + C3*C7) - C5*(C2*C10 + C3*C11)))...
      /(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + C11^2)) + ...
      (X*(C6*C10 + C7*C11)*((C2*C10 + C3*C11)*(C5*C9 + C6*C10 + C7*C11) ...
      - (C2*C6 + C3*C7)*(C9^2 + C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 + ...
      C7*C11) - C5*(C9^2 + C10^2 + C11^2))^2)/(C9*X + C10*Y + C11*Z + 1)...
      - (X*(C4 + C2*Y + C3*Z - (X*((C2*C10 + C3*C11)*(C5*C9 + C6*C10 + ...
      C7*C11) - (C2*C6 + C3*C7)*(C9^2 + C10^2 + C11^2)))/(C9*(C5*C9 + ...
      C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + C11^2))))/(C9*X + C10*Y + ...
      C11*Z + 1)^2;
    Zmat(i*2-1,9) = - ((X*(C2*(C5*C9 + C6*C10 + C7*C11) - 2*C10*(C2*C6 ...
      + C3*C7) + C6*(C2*C10 + C3*C11)))/(C9*(C5*C9 + C6*C10 + C7*C11) ...
      - C5*(C9^2 + C10^2 + C11^2)) + (X*(2*C5*C10 - C6*C9)*((C2*C10 + ...
      C3*C11)*(C5*C9 + C6*C10 + C7*C11) - (C2*C6 + C3*C7)*(C9^2 + C10^2 ...
      + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + ...
      C11^2))^2)/(C9*X + C10*Y + C11*Z + 1) - (Y*(C4 + C2*Y + C3*Z -...
      (X*((C2*C10 + C3*C11)*(C5*C9 + C6*C10 + C7*C11) - (C2*C6 + ...
      C3*C7)*(C9^2 + C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) ...
      - C5*(C9^2 + C10^2 + C11^2))))/(C9*X + C10*Y + C11*Z + 1)^2;
    Zmat(i*2-1,10) = - ((X*(C3*(C5*C9 + C6*C10 + C7*C11) - 2*C11*(C2*C6 ...
      + C3*C7) + C7*(C2*C10 + C3*C11)))/(C9*(C5*C9 + C6*C10 + C7*C11) ...
      - C5*(C9^2 + C10^2 + C11^2)) + (X*(2*C5*C11 - C7*C9)*((C2*C10 + ...
      C3*C11)*(C5*C9 + C6*C10 + C7*C11) - (C2*C6 + C3*C7)*(C9^2 + C10^2 ...
      + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + ...
      C11^2))^2)/(C9*X + C10*Y + C11*Z + 1) - (Z*(C4 + C2*Y + C3*Z - ...
      (X*((C2*C10 + C3*C11)*(C5*C9 + C6*C10 + C7*C11) - (C2*C6 + ...
      C3*C7)*(C9^2 + C10^2 + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) ...
      - C5*(C9^2 + C10^2 + C11^2))))/(C9*X + C10*Y + C11*Z + 1)^2;
    Zmat(i*2,1) = 0;
    Zmat(i*2,2) = 0;
    Zmat(i*2,3) = 0;
    Zmat(i*2,4) = X/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2,5) = Y/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2,6) = Z/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2,7) = 1/(C9*X + C10*Y + C11*Z + 1);
    Zmat(i*2,8) = -(X*(C8 + C5*X + C6*Y + C7*Z))/(C9*X + C10*Y + C11*Z + 1)^2;
    Zmat(i*2,9) = -(Y*(C8 + C5*X + C6*Y + C7*Z))/(C9*X + C10*Y + C11*Z + 1)^2;
    Zmat(i*2,10) = -(Z*(C8 + C5*X + C6*Y + C7*Z))/(C9*X + C10*Y + C11*Z + 1)^2;
    Fmat(i*2-1) = imageuv(i,1)-((C4 + C2*Y + C3*Z - (X*((C2*C10 + ...
      C3*C11)*(C5*C9 + C6*C10 + C7*C11) - (C2*C6 + C3*C7)*(C9^2 + C10^2 ...
      + C11^2)))/(C9*(C5*C9 + C6*C10 + C7*C11) - C5*(C9^2 + C10^2 + ...
      C11^2)))/(C9*X + C10*Y + C11*Z + 1));
    Fmat(i*2) = imageuv(i,2)-(C5*X + C6*Y + C7*Z +C8) / (C9*X + C10*Y + C11*Z + 1);
  end
  % Find least-squares solution
  delC=(Zmat'*Zmat)\(Zmat'*Fmat);
  coefs(2:11) = newCoefs(2:11)+delC;
  coefs(1)= newCoefs(1);
  % Check for convergence
  dC = norm(delC./newCoefs(2:11));
  iter=iter+1;
  
end

[uv]=dlt_inverse(coefs,xyz);
resid=(sum(sum((uv-imageuv).^2))./numel(imageuv))^0.5;
return

function [Ddata]=splineDerivativeKE2(data,tol,weights,order)

% function [Ddata]=splineDerivativeKE2(data,tol,weights,order)
%
% Inputs:
%   data - a columnwise data matrix. No NaNs or Infs please.
%   tol - the total error allowed: tol=sum((data-Ddata)^2)
%   weights - weighting function for the error:
%     tol=sum(weights*(data-Ddata)^2)
%   order - the derivative order (note that tol is with respect to the 0th
%     derivative)
%
% Outputs:
%   Ddata - the smoothed function (or its derivative) evaluated across the
%     input data
%
% Uses the spaps function of the spline toolbox to compute the smoothest
% function that conforms to the given tolerance and error weights.
%
% version 2, Ty Hedrick, Feb. 28, 2007


% create a sequence matrix, assume regularly spaced data points
X=(1:size(data,1))';

% set any NaNs in the weight matrix to zero
idw=find(isnan(weights)==true);
weights(idw)=0;

% spline order
sporder=3; % quintic spline, okay for up to 3rd order derivative

% spaps can't handle a weights matrix instead of a weights vector, so we
% loop through each column in data ...
%
% initialize output array
Ddata=data*NaN;
for i=1:size(data,2)
  
  % Non-NaN index
  idx=find(isnan(data(:,i))==false);
  
  if numel(idx)>3
    [sp] = spaps(X(idx),data(idx,i)',tol(i),weights(idx,i),sporder);
    
    % get the derivative of the spline
    spD = fnder(sp,order);
    
    % compute the derivative values on X
    Ddata(idx,i) = fnval(spD,X(idx));
  end
  
end
return

function s = nanstd(x)

s=nan(1,size(x,2));

for i=1:size(x,2)
  s(i)=std(x(isfinite(x(:,i)),i));
end
return

function s = nanmedian(x)

s=nan(1,size(x,2));

for i=1:size(x,2)
  s(i)=median(x(isfinite(x(:,i)),i));
end
return

function [ RM ] = QtoRM( Q )
%QTORM Takes in quaternion versor Q and returns Rotation Matrix RM
%   Quaternion should be in the form [qr, qi, qj, qk] where qi, qj, and qk
%   represent the scalars dictating the vector around which we will rotate
%   the
%   NOTE - Limit use as much as possible. Degeneration is inherant in
%   conversion as the sin of the rotational angle approaches zero or as the
%   quaternion approaches the identity quanternion. Care has been taken in
%   the implementation of this program to limit this loss but loss will
%   inevitably occur.

a = 2*acos(Q(1));
s = sin(a);
c = cos(a);
v = (1/(sin(a/2)))*Q(2:4);
q = 1-c;

RM = [c + (v(1)^2)*q, v(1)*v(2)*q-v(3)*s, v(1)*v(3)*q+v(2)*s;...
  v(2)*v(1)*q + v(3)*s, c + (v(2)^2)*q, v(2)*v(3)*q- v(1)*s;...
  v(3)*v(1)*q-v(2)*s, v(3)*v(2)*q+ v(1)*s, c+(v(3)^2)*q];
return

function [c,xyzMat,R,tv,sf,xyzMat2,ptMatu,ptMat2u,f,UoVo,nlin]=sbaCalib_pass2(ptMat,...
  UoVo,wandLen,ptMat2,f,nlin,optimMode,distortionMode,pCams,pass2Mode)

% function
% [c,xyzMat,R,tv,sf,xyzMat2,ptMatu,ptMat2u,f,UoVo,nlin]=sbaCalib_pass2(ptMat...
%    UoVo,wandLen,ptMat2,f,nlin,optimMode,distortionMode)
% Camera calibration function to estimate camera extrinsics and intrinsics
%   for C cameras from a set of shared wand points and background points.
%   Uses the accompanying MEX bundle adjustment code
%
% _pass2 gets the outputs from sbaCalib along with a list of the cameras
% that were and were not calibrated in the first pass
%
% Inputs:
%   ptMat - an [n,C*4] array of [u,v] coordinates from two cameras and two
%     points [c1u1,c1v1,c2u1,c2v1,c1u2,c1v2,c2u2,c2v2] representing the two
%     ends of a wand of known length
%   UoVo_est - a [1,C*2] array of the (estimated) principal point
%     coordinates for the two cameras
%   wandLen - the known wand length (for scale)
%   ptMat2 (optional) - an [n2,C*2] array of [u,v] coordinates shared
%     between the cameras but not part of the wand
%   f_est - a [1,C] array with estimates of the focal length of each camera
%     (in pixels)
%   nlin (optional) - [1,C*5] array of nonlinear lens distortion
%     coefficients
%   optimMode - determines the number of parameters to optimize:
%     1: camera extrinsics only
%     2: camera extrinsics and focal lengths
%     3: camera extrinsics, focal lengths, and principal points
%   distortionMode - number of non-fixed distortion coefficients
%   pCams - a 1D vector of the indices of the primary cameras
%   pass2Mode - mode for 2nd pass; 0 = do SBA in this function, 1 = format
%     outputs but don't do anything; results in DLT-only in the next-level
%     up function

% 2-element index of primary cameras
pdx=sort([pCams*2-1,pCams*2]);

% 5-element array of primary cameras (for nonlinear distortion coefs)
pdx5=sort([pCams*5-4,pCams*5-3,pCams*5-2,pCams*5-1,pCams*5]);

% count number of cameras
nCams=size(ptMat,2)/4;
nPts=size(ptMat,1);

% initialize empty output functions
c=1e24;
xyzMat=ptMat(:,1:6)*NaN;
xyzMat2=zeros(size(ptMat2,1),3)*NaN;
R=repmat(ones(3,3)*NaN,[1 1 numel(pCams)-1]);
tv=repmat((1:3)*NaN,[1 1 numel(pCams)-1]);
sf=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin preliminary calibration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply undistortion for prelim cal
for i = 1:nCams
  ptMatu(:,2*i-1:2*i) = undistort(ptMat(:,2*i-1:2*i),f(i),UoVo(i*2-1:i*2), ...
    nlin(i*5-4:i*5),3);
  ptMatu(:,2*nCams+2*i-1:2*nCams+2*i) = undistort(ptMat(:,2*nCams+...
    2*i-1:2*nCams+2*i),f(i),UoVo(i*2-1:i*2),nlin(i*5-4:i*5),3);
  ptMat2u(:,2*i-1:2*i) = undistort(ptMat2(:,2*i-1:2*i),f(i),...
    UoVo(i*2-1:i*2),nlin(i*5-4:i*5),3);
end

%  subtract the principal point
ptMatrm=ptMatu-repmat([UoVo,UoVo],size(ptMatu,1),1);
ptMat2rm=ptMat2u-repmat(UoVo,size(ptMat2u,1),1);
% divide by the focal lengths
for i=1:numel(UoVo)/2
  fArray(1,i*2-1:i*2)=f(i);
end
ptNorm=ptMatrm./repmat(fArray,size(ptMatrm,1),2);
ptNorm2=ptMat2rm./repmat(fArray,size(ptMat2rm,1),1);

% get a Rotation matrix and Translation vector for each primary camera with respect
% to the last primary camera - 8-point algorithm
for i=1:numel(pCams)-1 %1:nCams-1
%   [R(:,:,i),tv(:,:,i)] = twoCamCal_v2([ptNorm(:,pCams(i)*2-1:pCams(i)*2), ...
%     ptNorm(:,pCams(end)*2-1:pCams(end)*2);ptNorm2(:,[pCams(i)*2-1,pCams(i)*2,pCams(end)*2-1,pCams(end)*2])]);
  [R(:,:,i),tv(:,:,i)] = twoCamCal_v2([ptNorm(:,pCams(i)*2-1:pCams(i)*2), ...
    ptNorm(:,pCams(end)*2-1:pCams(end)*2);...
    ptNorm(:,(pCams(i)*2-1:pCams(i)*2)+nCams*2), ...
    ptNorm(:,(pCams(end)*2-1:pCams(end)*2)+nCams*2); ...
    ptNorm2(:,[pCams(i)*2-1,pCams(i)*2,pCams(end)*2-1,pCams(end)*2])]);
end

if isnan(sum(sum(tv(:,:,1:numel(pCams)-1))))
  mess = 'Failed to find an initial estimate of camera params, exiting...';
  disp(mess);
  msgbox(mess);
  return
end
X1 = zeros(size(ptNorm,1),3,numel(pCams)-1)*NaN;
X2 = zeros(size(ptNorm,1),3,numel(pCams)-1)*NaN;
% Triangulate the estimated 3D position of all points based on the above
% estimate of camera extrinsics
for i=1:numel(pCams)-1 %1:nCams-1
  idx=[pCams(i),pCams(end)];
  [X1(:,:,i)] = triangulate_v2(R(:,:,i),tv(:,:,i),ptNorm(:,[idx(1)*2-1:idx(1)*2,idx(2)*2-1:idx(2)*2]));
  [X2(:,:,i)] = triangulate_v2(R(:,:,i),tv(:,:,i),ptNorm(:,[idx(1)*2-1:idx(1)*2,idx(2)*2-1:idx(2)*2]+nCams*2));
  [X3(:,:,i)] = triangulate_v2(R(:,:,i),tv(:,:,i),ptNorm2(:,[idx(1)*2-1:idx(1)*2,idx(2)*2-1:idx(2)*2]));
end

% Old scaling routine
dWeights=[1,1,1]; % weights array to adjust for accuracy in reconstruction
% d = zeros(nCams-1,1)*NaN;
% for i=1:nCams-1
%   d(i,1)=nanmean(rnorm((X1(:,:,i)-X2(:,:,i)).*repmat(dWeights,size(X1,1),1)));
% end
%
%sf=wandLen./d;  % Scale to the expected wand length
%sf=1./d; % scale to a unit wand length

% new scaling routine (2015-06-03)
sf=1;
for i=2:numel(pCams)-1
  sf(i)=nanmean(nanmean([X1(:,:,i)./X1(:,:,1);X2(:,:,i)./X2(:,:,1);X3(:,:,i)./X3(:,:,1)]));
end
for i=1:numel(pCams)-1
  X1(:,:,i)=X1(:,:,i).*sf(i);
  X2(:,:,i)=X2(:,:,i).*sf(i);
  X3(:,:,i)=X3(:,:,i).*sf(i);
  tv(:,:,i)=tv(:,:,i).*sf(i);
end
X1=nanmean(X1,3);
X2=nanmean(X2,3);
xyzMat2=nanmean(X3,3);

% no need to scale since tv is scaled above
%xyzMat2=triangulate_v3(R,tv,ptNorm2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End preliminary calibration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up inputs to run external bundle adjustment starting with the camera
% pose and 3D point locations estimated in the above routines.

% camera u,v points re-arranged to an [X,2*C] array
sbaXY_tmp=[ptMat(:,pdx);ptMat(:,pdx+size(ptMat,2)/2);ptMat2(:,pdx)];

% estimated 3D points to match the u,v points
sbaXYZ_tmp=[X1;X2;xyzMat2];

% prune bad 3D estimates
ndx=find(isfinite(sbaXYZ_tmp(:,1)));
worldXYZ = sbaXYZ_tmp(ndx,:);
imageUV = sbaXY_tmp(ndx,:);

% collect camera intrinsics
intrinsics=[f(pCams)', reshape(UoVo(pdx),2,numel(pCams))', ones(numel(pCams),1),zeros(numel(pCams),1)];
distortion=reshape(nlin(pdx5),5,numel(pCams))';
camPos=zeros(numel(pCams),3);
camR=zeros(numel(pCams),4);
for i=1:numel(pCams)-1
  camR(i,:)=RMtoQ(R(:,:,i)); % convert rotation matrix to quaternion
  camPos(i,:)=tv(:,:,i);
end
camR(numel(pCams),:)=[1,0,0,0];
distortionFlag=5-distortionMode;
modeList = [4,2,5]; % Number of fixed params for each mode
intrinsicsFlag = modeList(optimMode);

% call to easySBA.  Use fakeSBA if you want to test initialization only
[worldXYZout, camPosout, camRout, intrinsicsout, distortionout] = ...
  easySBA(imageUV, worldXYZ, camPos, camR, intrinsics, intrinsicsFlag, ...
  distortion, distortionFlag);

% check to see if the user wants to try and incorporate points not seen by
% the base camera using preliminary SBA results?
dltPass=false;
if nCams>2
  myAnswer=questdlg('Re-estimate calibration after using current results to incorporate points not seen by the base (i.e. last primary) camera?','Do pass 1.5?','Yes','No','Yes');
  if strcmpi(myAnswer,'Yes')
    dltPass=true;
  end
end
if dltPass
  % create temporary set of DLTcoefs
  coefs=[];
  drmse=[];
  for i=1:numel(pdx)/2
    [coefs(:,i), drmse(i)]=dlt_computeCoefficients(worldXYZout,imageUV(:,i*2-1:i*2));
  end
  sbaXY_tmp=[ptMat(:,pdx);ptMat(:,pdx+size(ptMat,2)/2);ptMat2(:,pdx)];
  X1=dlt_reconstruct(coefs,ptMat(:,pdx));
  X2=dlt_reconstruct(coefs,ptMat(:,pdx+size(ptMat,2)/2));
  X3=dlt_reconstruct(coefs,ptMat2(:,pdx));
  
  % camera u,v points re-arranged to an [X,2*C] array
  sbaXY_tmp=[ptMat(:,pdx);ptMat(:,pdx+size(ptMat,2)/2);ptMat2(:,pdx)];
  
  % estimated 3D points to match the u,v points
  sbaXYZ_tmp=[X1;X2;X3];
  
  % prune bad 3D estimates
  ndx=find(isfinite(sbaXYZ_tmp(:,1)));
  worldXYZ = sbaXYZ_tmp(ndx,:);
  imageUV = sbaXY_tmp(ndx,:);
  
  [worldXYZout, camPosout, camRout, intrinsicsout, distortionout] = ...
    easySBA(imageUV, worldXYZ, camPosout, camRout, intrinsics, intrinsicsFlag, ...
    distortion, distortionFlag);
end

% force garbage collection for Macs
if ismac
    clear mex
    clear easySBA
end

%%% start pass 2 %%%

% first check to see if it is needed, i.e. if there are any secondary
% cameras at all
sCams=setdiff(1:nCams,pCams); % list of secondary cameras
if isempty(sCams)
  worldXYZout2=worldXYZout;
  camPosout2=camPosout;
  camRout2=camRout;
  intrinsicsout2=intrinsicsout;
  distortionout2=distortionout;
else
  % start preliminaries for working on the secondary cameras

  % 2-element index of secondary cameras
  sdx=sort([sCams*2-1,sCams*2]);
  
  % 5-element array of primary cameras (for nonlinear distortion coefs)
  sdx5=sort([sCams*5-4,sCams*5-3,sCams*5-2,sCams*5-1,sCams*5]);
  
  % setup new inputs with the secondary cameras prefixing the primary cameras
  sbaXY_tmp2=[ptMat(:,[sdx,pdx]);ptMat(:,[sdx,pdx]+size(ptMat,2)/2);ptMat2(:,[sdx,pdx])];
  worldXYZ2=worldXYZout;
  intrinsics2=[[f(sCams)', reshape(UoVo(sdx),2,numel(sCams))', ones(numel(sCams),1),zeros(numel(sCams),1)];intrinsicsout];
  distortion2=[[reshape(nlin(sdx5),5,numel(sCams))'];distortionout];
  
  % next check type of 2nd pass - SBA or DLT.  SBA means estimating camera
  % position and orientation using a PnP algorithm applied to the now-known
  % 3D points and then re-running SBA, while the DLT method is to just kick
  % everything up one level where and estimate the DLT coefficients from the
  % known 3D points. DLT is the old way, requires less information but
  % produces sub-optimal outputs
  
  if pass2Mode==1 % DLT 2nd pass
    % message user regarding 2nd pass
    disp(' ')
    disp(['Beginning 2nd calibration pass to add secondary cameras: ( #s ',num2str(sCams),')'])
    disp(['You have chosen a DLT-based instead of bundle-adjustment based calibration, this'])
    disp(['requires less information for stable output but usually does not produce as good'])
    disp(['a final calibration. Manually-input distortion coefficients are incorporated, but'])
    disp(['will not be optimzed.'])
    
    worldXYZout2=worldXYZ2;
    camPosout2=[nan*zeros(numel(sdx)/2,3);camPosout];
    camRout2=[zeros(numel(sdx)/2,4);camRout];
    intrinsicsout2=intrinsics2;
    distortionout2=distortion2;
    
  else % SBA 2nd pass
    % message user regarding 2nd pass
    disp(' ')
    disp(['Beginning 2nd bundle adjustment pass to add secondary cameras: ( #s ',num2str(sCams),')'])
    disp('The second pass calibration employs the Efficient PnP code from Francesc Moreno-Noguer')
    disp('distributed under the GNU public license and described in  DOI: 10.1007/s11263-008-0152-6')
    
    % get the initial orientation and position of the secondary points
    for i=1:numel(sCams)
      xyN=sbaXY_tmp2(ndx,i*2-1:i*2);
      xyN=(xyN-repmat(intrinsics2(i,2:3),size(xyN,1),1))./intrinsics2(i,1);
      edx=intersect(find(isnan(xyN(:,1))==false),find(isnan(worldXYZout(:,1))==false));
      [R2(:,:,i),t2(:,:,i)]=EPnP(worldXYZout(edx,:)',xyN(edx,:)');
    end
    
    % get the apparent rotation and position of the base camera
    xyN=sbaXY_tmp(ndx,end-1:end);
    xyN=(xyN-repmat(intrinsics2(end,2:3),size(xyN,1),1))./intrinsics2(end,1);
    edx=intersect(find(isnan(xyN(:,1))==false),find(isnan(worldXYZout(:,1))==false));
    [R2b,t2b]=EPnP(worldXYZout(edx,:)',xyN(edx,:)');
    
    % setup the camPos2 and camR2
    for i=1:numel(sCams)
        camR2(i,:)=RMtoQ(R2(:,:,i));
        camPos2(i,:)=t2(:,:,i)'-t2b';
    end
    camR2=[camR2;camRout];
    camPos2=[camPos2;camPosout];
    
    % setup imageUV2
    imageUV2 = sbaXY_tmp2(ndx,:);
    
    % run bundle adjustment 2nd pass
    [worldXYZout2, camPosout2, camRout2, intrinsicsout2, distortionout2] = ...
        easySBA(imageUV2, worldXYZ2, camPos2, camR2, intrinsics2, intrinsicsFlag, ...
        distortion2, distortionFlag);
    
    % force garbage collection for Macs
    if ismac
        clear mex
        clear easySBA
    end
  end
end

% re-arrange 2nd pass outputs to match original order and compute final
% outputs
%

% reorder mapping
spOrder=[sCams,pCams]';
spOrder(:,2)=1:size(spOrder,1);
spOrder=sortrows(spOrder,1);
spMap=spOrder(:,2);

% xyz, scale and distance
sbaXYZ_tmp(ndx,:) = worldXYZout2;
X1sba=sbaXYZ_tmp(1:size(X1,1),:);
X2sba=sbaXYZ_tmp(size(X1,1)+1:size(X1,1)*2,:);
X3sba=sbaXYZ_tmp(size(X1,1)*2+1:end,:);

weightedD=(X1sba-X2sba).*repmat(dWeights,size(X1,1),1);
D=rnorm(weightedD);
sf=wandLen./nanmean(D);

% sbaCamPos([sCams,pCams],:) = camPosout2;
% for i=1:nCams-1
%   tv(:,:,i)=(sbaCamPos(i,:)-sbaCamPos(end,:))*sf;
% end

sbaCamPos= camPosout2;
% % re-zero on base camera
% for i=1:nCams-1
%   tv(:,:,i)=(sbaCamPos(i,:)-sbaCamPos(end,:))*sf;
% end
% tv(:,:,i+1)=[0,0,0]; % base row at zero

for i=1:nCams
  tv(:,:,i)=sbaCamPos(i,:)*sf; % fix 2020-03-19
end
tv(:,:,spMap)=tv; % re-arrange

nlin = reshape(distortionout2(spMap,:)',1,5*nCams);
f = intrinsicsout2(spMap,1);
UoVo = intrinsicsout2(spMap,2:3);
for i=1:nCams
  R1(:,:,i)=QtoRM(camRout2(i,:));
end
R(:,:,[sCams,pCams])=R1;

% optimization function calculation
c=100*nanstd(D)./nanmean(D);
xyzMat=[X1sba,X2sba]*sf;
xyzMat2=X3sba*sf;

% update ptMatu & ptMat2u (distortion-corrected xy points) to reflect SBA
% output
for i = 1:nCams
  
  ptMatu(:,2*i-1:2*i) = undistort(ptMat(:,2*i-1:2*i),f(i),UoVo(i,:), ...
    nlin(i*5-4:i*5),3);
  ptMatu(:,2*nCams+2*i-1:2*nCams+2*i) = undistort(...
    ptMat(:,2*nCams+2*i-1:2*nCams+2*i),f(i),UoVo(i,:),nlin(i*5-4:i*5),3);
  ptMat2u(:,2*i-1:2*i) = undistort(ptMat2(:,2*i-1:2*i),f(i),UoVo(i,:),...
    nlin(i*5-4:i*5),3);
  
end

disp('sbaCalib_pass2 done')

function [g] = polyFitGravity(axisXYZ,gravityFreq)

% function [g] = polyFitGravity(axisXYZ,gravityFreq)
%
% Fits a 2nd order polynomial to a the time-series of position of a falling
% object to get the gravitational acceleration vector.

t=(0:size(axisXYZ,1)-1)';
idx=find(sum(isnan(axisXYZ),2)==0);
p1=polyfit(t(idx),axisXYZ(idx,1),2);
p2=polyfit(t(idx),axisXYZ(idx,2),2);
p3=polyfit(t(idx),axisXYZ(idx,3),2);
g1(:,1)=polyval(p1,t);
g1(:,2)=polyval(p2,t);
g1(:,3)=polyval(p3,t);
g=diff(diff(g1)).*gravityFreq.^2;

function  [c,rmse] = dlt_computeCoefficients(frame,camPts)

% function  [c,rmse] = dlt_computeCoefficients(frame,camPts)
%
% A basic implementation of 11 parameter DLT
%
% Inputs:
%  frame - an array of x,y,z calibration point coordinates
%  camPts - an array of u,v pixel coordinates from the camera
%
% Outputs:
%  c - the 11 DLT coefficients
%  rmse - root mean square error for the reconstruction; units =
%
% Notes - frame and camPts must have the same number of rows.  A minimum of
% 6 rows are required to compute the coefficients.  The frame points must
% not all lie within a single plane
%
% Ty Hedrick

% check for any NaN rows (missing data) in the frame or camPts
ndx=find(sum(isnan([frame,camPts]),2)>0);

% remove any missing data rows
frame(ndx,:)=[];
camPts(ndx,:)=[];

% re-arrange the frame matrix to facilitate the linear least squares
% solution
M=zeros(size(frame,1)*2,11);
for i=1:size(frame,1)
  M(2*i-1,1:3)=frame(i,1:3);
  M(2*i,5:7)=frame(i,1:3);
  M(2*i-1,4)=1;
  M(2*i,8)=1;
  M(2*i-1,9:11)=frame(i,1:3).*-camPts(i,1);
  M(2*i,9:11)=frame(i,1:3).*-camPts(i,2);
end

% re-arrange the camPts array for the linear solution
camPtsF=reshape(flipud(rot90(camPts)),numel(camPts),1);

% get the linear solution to the 11 parameters
c=linsolve(M,camPtsF);

% compute the position of the frame in u,v coordinates given the linear
% solution from the previous line
Muv=dlt_inverse(c,frame);

% compute the root mean square error between the ideal frame u,v and the
% recorded frame u,v
rmse=(sum(sum((Muv-camPts).^2))./numel(camPts))^0.5;
