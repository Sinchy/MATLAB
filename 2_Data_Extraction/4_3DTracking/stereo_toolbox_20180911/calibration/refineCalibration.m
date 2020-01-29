function varargout = refineCalibration(varargin)
% This function helps to refine the calibration results. The inputs are the
% settings-structure and the cameraSystem-Object. Have a look for example
% calls in the "do_calibration.m"-script



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @refineCalibration_OpeningFcn, ...
                   'gui_OutputFcn',  @refineCalibration_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before refineCalibration is made visible.
function refineCalibration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to refineCalibration (see VARARGIN)

% Choose default command line output for refineCalibration
handles.cameraSystem = varargin{1};
handles.settings = varargin{2};

set(handles.slider_frameNo,'Min',handles.settings.im_range(1));
set(handles.slider_frameNo,'Max',handles.settings.im_range(end));
set(handles.slider_frameNo,'SliderStep',[1/(handles.settings.im_range(end)-handles.settings.im_range(1)+1)  0.1] );
set(handles.slider_frameNo,'Value',handles.settings.im_range(1));
set(handles.edit_roiXMax, 'String', num2str(handles.settings.image_width));
set(handles.edit_roiYMax, 'String', num2str(handles.settings.image_height));

slider_frameNo_Callback(handles.slider_frameNo, eventdata, handles)


handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes refineCalibration wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = refineCalibration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Apply the horizontal and vertical shifts to the camera system
handles.cameraSystem.cameraCalibrations(1).camera.u0 = ...
    handles.cameraSystem.cameraCalibrations(1).camera.u0 + str2num(get(handles.edit_1h,'String'));
handles.cameraSystem.cameraCalibrations(1).camera.v0 = ...
    handles.cameraSystem.cameraCalibrations(1).camera.v0 + str2num(get(handles.edit_1v,'String'));
handles.cameraSystem.cameraCalibrations(2).camera.u0 = ...
    handles.cameraSystem.cameraCalibrations(2).camera.u0 + str2num(get(handles.edit_2h,'String'));
handles.cameraSystem.cameraCalibrations(2).camera.v0 = ...
    handles.cameraSystem.cameraCalibrations(2).camera.v0 + str2num(get(handles.edit_2v,'String'));
handles.cameraSystem.cameraCalibrations(3).camera.u0 = ...
    handles.cameraSystem.cameraCalibrations(3).camera.u0 + str2num(get(handles.edit_3h,'String'));
handles.cameraSystem.cameraCalibrations(3).camera.v0 = ...
    handles.cameraSystem.cameraCalibrations(3).camera.v0 + str2num(get(handles.edit_3v,'String'));
varargout{1} = handles.cameraSystem;
close(hObject);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, call UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
fprintf(1,'\nThe cameraSystem-Object has been altered.\nSave the object from workspace if you want to keep the changes\n');


% --- Executes on slider movement.
function slider_frameNo_Callback(hObject, eventdata, handles)
% hObject    handle to slider_frameNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(hObject,'Value', round(get(hObject,'Value')));
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
I1 = imread(sprintf(handles.settings.cam1_filename,get(hObject,'Value')));
I2 = imread(sprintf(handles.settings.cam2_filename,get(hObject,'Value')));
I3 = imread(sprintf(handles.settings.cam3_filename,get(hObject,'Value')));

xmin = str2num(get(handles.edit_roiXMin,'String')); 
xmax = str2num(get(handles.edit_roiXMax,'String')); 
ymin = str2num(get(handles.edit_roiYMin,'String')); 
ymax = str2num(get(handles.edit_roiYMax,'String'));

axes(handles.axes1);
imshow(imcomplement(I1));hold on;
axis([ xmin, xmax, ymin, ymax]); 
axes(handles.axes2);
imshow(imcomplement(I2));hold on;
axis([ xmin, xmax, ymin, ymax]); 
axes(handles.axes3);
imshow(imcomplement(I3));hold on;
axis([ xmin, xmax, ymin, ymax]); 




% --- Executes during object creation, after setting all properties.
function slider_frameNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_frameNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pb_findCorrespondences.
function pb_findCorrespondences_Callback(hObject, eventdata, handles)
% hObject    handle to pb_findCorrespondences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[P1, P2, P3] = handles.cameraSystem.getProjectionMatrices;

% shift matrices 
[P1, P2, P3] = shiftIntrinsics (P1, P2, P3, handles);


% compose temporary settings-file to process single-image correspondence
% search:
settings_temp.im_range = get(handles.slider_frameNo,'Value');
settings_temp.output2Dcoords = handles.settings.output2Dcoords;
settings_temp.params_3CAM3D.epipolar_distance = str2num(get(handles.edit_epiDist,'String'));

% do the stuff that one has to do...
res3d = threeCam3D_alg(settings_temp, 1, P1, P2, P3);
if ~isempty(res3d{1}) 
    delete(findobj('Type','Line'));
    % highlight all particles in images
    axes(handles.axes1); hold on;
    plot(res3d{1}(:,4), res3d{1}(:,5), 'ro');
    axes(handles.axes2); hold on;
    plot(res3d{1}(:,6), res3d{1}(:,7), 'ro');
    axes(handles.axes3); hold on;
    plot(res3d{1}(:,8), res3d{1}(:,9), 'ro');
    
    for k = 1:size(res3d{1},1)
        % plot epipolar lines
        [l21, ~] = projectRay(P1, P2, res3d{1}(k,6:7));
        [l12, ~] = projectRay(P2, P1, res3d{1}(k,4:5));
        [l13, ~] = projectRay(P3, P1, res3d{1}(k,4:5));
        [l31, ~] = projectRay(P1, P3, res3d{1}(k,8:9));
        [l23, ~] = projectRay(P3, P2, res3d{1}(k,6:7));
        [l32, ~] = projectRay(P2, P3, res3d{1}(k,8:9));
        % get the lines
        image_width = handles.settings.image_width;
        ll21 = [[1 image_width]'  ([1 image_width].*l21(1)+l21(2))'];
        ll12 = [[1 image_width]'  ([1 image_width].*l12(1)+l12(2))'];
        ll13 = [[1 image_width]'  ([1 image_width].*l13(1)+l13(2))'];
        ll31 = [[1 image_width]'  ([1 image_width].*l31(1)+l31(2))'];
        ll32 = [[1 image_width]'  ([1 image_width].*l32(1)+l32(2))'];
        ll23 = [[1 image_width]'  ([1 image_width].*l23(1)+l23(2))'];
        
        axes(handles.axes1);
        plot(ll21(:,1), ll21(:,2),'-g');
        plot(ll31(:,1), ll31(:,2),'-b');
        axes(handles.axes2);
        plot(ll12(:,1), ll12(:,2),'-r');
        plot(ll32(:,1), ll32(:,2),'-b');
        axes(handles.axes3);
        plot(ll13(:,1), ll13(:,2),'-r');
        plot(ll23(:,1), ll23(:,2),'-g');
    end
    
    fprintf(1,'%d correspondences found.\n',size( res3d{1},1));
else
    display('No correspondences found!');
end



function edit_epiDist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epiDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epiDist as text
%        str2double(get(hObject,'String')) returns contents of edit_epiDist as a double


% --- Executes during object creation, after setting all properties.
function edit_epiDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epiDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_1h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_1h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_1h as text
%        str2double(get(hObject,'String')) returns contents of edit_1h as a double


% --- Executes during object creation, after setting all properties.
function edit_1h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_1h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_1v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_1v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_1v as text
%        str2double(get(hObject,'String')) returns contents of edit_1v as a double


% --- Executes during object creation, after setting all properties.
function edit_1v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_1v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_2h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_2h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_2h as text
%        str2double(get(hObject,'String')) returns contents of edit_2h as a double


% --- Executes during object creation, after setting all properties.
function edit_2h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_2h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_2v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_2v as text
%        str2double(get(hObject,'String')) returns contents of edit_2v as a double


% --- Executes during object creation, after setting all properties.
function edit_2v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_3h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_3h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_3h as text
%        str2double(get(hObject,'String')) returns contents of edit_3h as a double


% --- Executes during object creation, after setting all properties.
function edit_3h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_3h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_3v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_3v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_3v as text
%        str2double(get(hObject,'String')) returns contents of edit_3v as a double


% --- Executes during object creation, after setting all properties.
function edit_3v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_3v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function [P1, P2, P3] = shiftIntrinsics (P1, P2, P3, handles)
[K R t C] = P2KRtC(P1);
K(1:2,3) = K(1:2,3) + [str2num(get(handles.edit_1h,'String')) ; str2num(get(handles.edit_1v,'String'))] ;
P1 = K*[R t];

[K R t C] = P2KRtC(P2);
K(1:2,3) = K(1:2,3) + [str2num(get(handles.edit_2h,'String')) ; str2num(get(handles.edit_2v,'String'))] ;
P2 = K*[R t];

[K R t C] = P2KRtC(P3);
K(1:2,3) = K(1:2,3) + [str2num(get(handles.edit_3h,'String')) ; str2num(get(handles.edit_3v,'String'))] ;
P3 = K*[R t];


% --- Executes on button press in pb_projectTo1.
function pb_projectTo1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_projectTo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[X, Y] = ginput(2);
% find the points closest to the clicks
points = dlmread(sprintf(handles.settings.output2Dcoords,get(handles.slider_frameNo,'Value' ) ) );
dist2d = distance2d(points(:,3:4), [ X(1) , Y(1)]);
match2 = points( dist2d==min(dist2d) , 3:4 );
dist2d = distance2d(points(:,5:6), [ X(2) , Y(2)]);
match3 = points( dist2d==min(dist2d) , 5:6 );

% get proijection matrices
[P1, P2, P3] = handles.cameraSystem.getProjectionMatrices;

% shift matrices (if desired)
[P1, P2, P3] = shiftIntrinsics (P1, P2, P3, handles);

[ m2, m3 ] = optimizeProjection( match2, match3,  getFundamental(P2, P3), 0);

% plot epipolar lines
[l21, ~] = projectRay(P1, P2, m2);
[l31, ~] = projectRay(P1, P3, m3);

% get the intersection in cam1
Poly1 = l21;
Poly2 = l31;
inter_cam1 = [ (Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1)) Poly1(1)*(Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1))+Poly1(2)];

% get the lines
image_width = handles.settings.image_width;
ll21 = [[1 image_width]'  ([1 image_width].*l21(1)+l21(2))'];
ll31 = [[1 image_width]'  ([1 image_width].*l31(1)+l31(2))'];

% plot 
delete(findobj('Type','Line'));

axes(handles.axes1);
plot(ll21(:,1), ll21(:,2),'-g');
plot(ll31(:,1), ll31(:,2),'-b');

axes(handles.axes2);
plot(match2(1),match2(2),'ro');

axes(handles.axes3);
plot(match3(1),match3(2),'ro');

% let the user choose a point to match for
[X, Y] = ginput(1);
if ~isempty(X)
    dist2d = distance2d(points(:,1:2), [ X(1) , Y(1)]);
    match1 = points( dist2d==min(dist2d) , 1:2 );
    plot(match1(1),match1(2),'ro');
    % make the appropriate shift-entries to match this point exactly
    shift1 = match1-inter_cam1;
    shift2 = match2'-m2(1:2);
    shift3 = match3'-m3(1:2);
    set(handles.edit_1h,'String',num2str(shift1(1)+str2num(get(handles.edit_1h,'String'))));
    set(handles.edit_1v,'String',num2str(shift1(2)+str2num(get(handles.edit_1v,'String'))));
    set(handles.edit_2h,'String',num2str(shift2(1)+str2num(get(handles.edit_2h,'String'))));
    set(handles.edit_2v,'String',num2str(shift2(2)+str2num(get(handles.edit_2v,'String'))));
    set(handles.edit_3h,'String',num2str(shift3(1)+str2num(get(handles.edit_3h,'String'))));
    set(handles.edit_3v,'String',num2str(shift3(2)+str2num(get(handles.edit_3v,'String'))));
end

% --- Executes on button press in pb_projectTo2.
function pb_projectTo2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_projectTo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[X, Y] = ginput(2);
% find the points closest to the clicks
points = dlmread(sprintf(handles.settings.output2Dcoords,get(handles.slider_frameNo,'Value' ) ) );
dist2d = distance2d(points(:,1:2), [ X(1) , Y(1)]);
match1 = points( dist2d==min(dist2d) , 1:2 );
dist2d = distance2d(points(:,5:6), [ X(2) , Y(2)]);
match3 = points( dist2d==min(dist2d) , 5:6 );



% get proijection matrices
[P1, P2, P3] = handles.cameraSystem.getProjectionMatrices;

% shift matrices (if desired)
[P1, P2, P3] = shiftIntrinsics (P1, P2, P3, handles);

[ m1 m3 ] = optimizeProjection( match1, match3,  getFundamental(P1, P3), 0);

% plot epipolar lines
[l12, ~] = projectRay(P2, P1, m1);
[l32, ~] = projectRay(P2, P3, m3);

% intersection in cam 2
Poly1 = l12;
Poly2 = l32;
inter_cam2 = [ (Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1)) Poly1(1)*(Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1))+Poly1(2)];

% get the lines
image_width = handles.settings.image_width;
ll12 = [[1 image_width]'  ([1 image_width].*l12(1)+l12(2))'];
ll32 = [[1 image_width]'  ([1 image_width].*l32(1)+l32(2))'];

% plot 
delete(findobj('Type','Line'));

axes(handles.axes2);
plot(ll12(:,1), ll12(:,2),'-r');
plot(ll32(:,1), ll32(:,2),'-b');

axes(handles.axes1);
plot(match1(1),match1(2),'ro');

axes(handles.axes3);
plot(match3(1),match3(2),'ro');

% let the user choose a point to match for
[X, Y] = ginput(1);
if ~isempty(X)
    dist2d = distance2d(points(:,3:4), [ X(1) , Y(1)]);
    match2 = points( dist2d==min(dist2d) , 3:4 );
    plot(match2(1),match2(2),'ro');
    plot(inter_cam2(1),inter_cam2(2),'r+');
    % make the appropriate shift-entries to match this point exactly
    shift2 = match2-inter_cam2;
    shift1 = match1'-m1(1:2);
    shift3 = match3'-m3(1:2);
    set(handles.edit_1h,'String',num2str(shift1(1)+str2num(get(handles.edit_1h,'String'))));
    set(handles.edit_1v,'String',num2str(shift1(2)+str2num(get(handles.edit_1v,'String'))));
    set(handles.edit_2h,'String',num2str(shift2(1)+str2num(get(handles.edit_2h,'String'))));
    set(handles.edit_2v,'String',num2str(shift2(2)+str2num(get(handles.edit_2v,'String'))));
    set(handles.edit_3h,'String',num2str(shift3(1)+str2num(get(handles.edit_3h,'String'))));
    set(handles.edit_3v,'String',num2str(shift3(2)+str2num(get(handles.edit_3v,'String'))));
end




% --- Executes on button press in pb_projectTo3.
function pb_projectTo3_Callback(hObject, eventdata, handles)
% hObject    handle to pb_projectTo3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[X, Y] = ginput(2);
% find the points closest to the clicks
points = dlmread(sprintf(handles.settings.output2Dcoords,get(handles.slider_frameNo,'Value' ) ) );
dist2d = distance2d(points(:,1:2), [ X(1) , Y(1)]);
match1 = points( dist2d==min(dist2d) , 1:2 );
dist2d = distance2d(points(:,3:4), [ X(2) , Y(2)]);
match2 = points( dist2d==min(dist2d) , 3:4 );

% get proijection matrices
[P1, P2, P3] = handles.cameraSystem.getProjectionMatrices;

% shift matrices (if desired)
[P1, P2, P3] = shiftIntrinsics (P1, P2, P3, handles);

[ m1 m2 ] = optimizeProjection( match1, match2,  getFundamental(P1, P2), 0);

% plot epipolar lines
[l13, ~] = projectRay(P3, P1, m1);
[l23, ~] = projectRay(P3, P2, m2);

% intersection cam3
Poly1 = l13;
Poly2 = l23;
inter_cam3 = [ (Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1)) Poly1(1)*(Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1))+Poly1(2)];

% get the lines
image_width = handles.settings.image_width;
ll13 = [[1 image_width]'  ([1 image_width].*l13(1)+l13(2))'];
ll23 = [[1 image_width]'  ([1 image_width].*l23(1)+l23(2))'];

% plot 
delete(findobj('Type','Line'));

axes(handles.axes3);
plot(ll13(:,1), ll13(:,2),'-r');
plot(ll23(:,1), ll23(:,2),'-b');

axes(handles.axes1);
plot(match1(1),match1(2),'ro');

axes(handles.axes2);
plot(match2(1),match2(2),'ro');

% let the user choose a point to match for
[X, Y] = ginput(1);
if ~isempty(X)
    dist2d = distance2d(points(:,5:6), [ X(1) , Y(1)]);
    match3 = points( dist2d==min(dist2d) , 5:6 );
    plot(match3(1),match3(2),'ro');
    % make the appropriate shift-entries to match this point exactly
    shift3 = match3-inter_cam3;
    shift1 = match1'-m1(1:2);
    shift2 = match2'-m2(1:2);
    set(handles.edit_1h,'String',num2str(shift1(1)+str2num(get(handles.edit_1h,'String'))));
    set(handles.edit_1v,'String',num2str(shift1(2)+str2num(get(handles.edit_1v,'String'))));
    set(handles.edit_2h,'String',num2str(shift2(1)+str2num(get(handles.edit_2h,'String'))));
    set(handles.edit_2v,'String',num2str(shift2(2)+str2num(get(handles.edit_2v,'String'))));
    set(handles.edit_3h,'String',num2str(shift3(1)+str2num(get(handles.edit_3h,'String'))));
    set(handles.edit_3v,'String',num2str(shift3(2)+str2num(get(handles.edit_3v,'String'))));
end




function edit_roiXMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roiXMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roiXMin as text
%        str2double(get(hObject,'String')) returns contents of edit_roiXMin as a double


% --- Executes during object creation, after setting all properties.
function edit_roiXMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roiXMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_roiXMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roiXMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roiXMax as text
%        str2double(get(hObject,'String')) returns contents of edit_roiXMax as a double


% --- Executes during object creation, after setting all properties.
function edit_roiXMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roiXMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_roiYMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roiYMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roiYMin as text
%        str2double(get(hObject,'String')) returns contents of edit_roiYMin as a double


% --- Executes during object creation, after setting all properties.
function edit_roiYMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roiYMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_roiYMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roiYMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roiYMax as text
%        str2double(get(hObject,'String')) returns contents of edit_roiYMax as a double


% --- Executes during object creation, after setting all properties.
function edit_roiYMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roiYMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_1h,'String','0');
set(handles.edit_1v,'String','0');
set(handles.edit_2h,'String','0');
set(handles.edit_2v,'String','0');
set(handles.edit_3h,'String','0');
set(handles.edit_3v,'String','0');


% --- Executes on button press in pb_showAll.
function pb_showAll_Callback(hObject, eventdata, handles)
% hObject    handle to pb_showAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
points = dlmread(sprintf(handles.settings.output2Dcoords,get(handles.slider_frameNo,'Value' ) ) );

axes(handles.axes1);
plot(points(:,1),points(:,2),'ro');
axes(handles.axes2);
plot(points(:,3),points(:,4),'ro');
axes(handles.axes3);
plot(points(:,5),points(:,6),'ro');
