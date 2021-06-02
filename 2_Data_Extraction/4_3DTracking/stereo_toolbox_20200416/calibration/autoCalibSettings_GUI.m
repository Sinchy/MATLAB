function varargout = autoCalibSettings_GUI(varargin)
%--------------------------------------------------------------------------
%     Copyright (C) 2016 Michael Himpel (himpel@physik.uni-greifswald.de)
%     
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

% This GUI can be used to manually control and test the calibration
% parameters. The output that is produced here, will be the input for the
% BoLi-calibration toolbox.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autoCalibSettings_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @autoCalibSettings_GUI_OutputFcn, ...
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


% --- Executes just before autoCalibSettings_GUI is made visible.
function autoCalibSettings_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to autoCalibSettings_GUI (see VARARGIN)

% Choose default command line output for autoCalibSettings_GUI
handles.output = hObject;

handles.imageLocations =varargin{1};

imshow(imread(handles.imageLocations(1).fileName));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes autoCalibSettings_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = autoCalibSettings_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.settings;
delete(hObject);



function edit_minEllipticity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minEllipticity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minEllipticity as text
%        str2double(get(hObject,'String')) returns contents of edit_minEllipticity as a double


% --- Executes during object creation, after setting all properties.
function edit_minEllipticity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minEllipticity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxEllipticity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxEllipticity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxEllipticity as text
%        str2double(get(hObject,'String')) returns contents of edit_maxEllipticity as a double


% --- Executes during object creation, after setting all properties.
function edit_maxEllipticity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxEllipticity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minSolidity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minSolidity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minSolidity as text
%        str2double(get(hObject,'String')) returns contents of edit_minSolidity as a double


% --- Executes during object creation, after setting all properties.
function edit_minSolidity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minSolidity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_min_BarSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_BarSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_BarSize as text
%        str2double(get(hObject,'String')) returns contents of edit_min_BarSize as a double


% --- Executes during object creation, after setting all properties.
function edit_min_BarSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_BarSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minArea_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minArea as text
%        str2double(get(hObject,'String')) returns contents of edit_minArea as a double


% --- Executes during object creation, after setting all properties.
function edit_minArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxArea_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxArea as text
%        str2double(get(hObject,'String')) returns contents of edit_maxArea as a double


% --- Executes during object creation, after setting all properties.
function edit_maxArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MAX_ERROR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MAX_ERROR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MAX_ERROR as text
%        str2double(get(hObject,'String')) returns contents of edit_MAX_ERROR as a double


% --- Executes during object creation, after setting all properties.
function edit_MAX_ERROR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MAX_ERROR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_markerDiameter_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit_markerDiameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_markerDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_preview.
function pb_preview_Callback(hObject, eventdata, handles)
% hObject    handle to pb_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateHandleFromGUI(handles);

minEllipticity = handles.settings.minEllipticity;
maxEllipticity = handles.settings.maxEllipticity;
minSolidity = handles.settings.minSolidity;
min_BarSize = handles.settings.min_BarSize;
minArea = handles.settings.minArea;
maxArea = handles.settings.maxArea;
%MAX_ERROR = handles.settings.MAX_ERROR;
markerDiameter = handles.settings.markerDiameter;
barMode = get(handles.pu_barMode,'Value');

current_image = str2num(get(handles.edit_imageNo,'String'));

im = imread(handles.imageLocations(current_image).fileName);
if ndims(im)>2
    im = rgb2gray(im);
end
% start the target analysis
processTargetImage;
if exist('x','var')
    handles.settings.images(current_image).imData = im;
    handles.settings.images(current_image).x = x;
    handles.settings.images(current_image).X = X;
end
guidata(hObject, handles);


% --- Executes on selection change in pu_barMode.
function pu_barMode_Callback(hObject, eventdata, handles)
% hObject    handle to pu_barMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pu_barMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pu_barMode
handles.settings.barMode = get(handles.pu_barMode,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pu_barMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pu_barMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

function handles = updateHandleFromGUI(handles)
handles.settings.minEllipticity = str2double(get(handles.edit_minEllipticity,'String'));
handles.settings.maxEllipticity = str2double(get(handles.edit_maxEllipticity,'String'));
handles.settings.minSolidity    = str2double(get(handles.edit_minSolidity,'String'));
handles.settings.min_BarSize    = str2double(get(handles.edit_min_BarSize,'String'));
handles.settings.markerDiameter = str2double(get(handles.edit_markerDiameter,'String'));
handles.settings.minArea   = str2double(get(handles.edit_minArea,'String'));
handles.settings.maxArea   = str2double(get(handles.edit_maxArea,'String'));
handles.settings.MAX_ERROR = str2double(get(handles.edit_MAX_ERROR,'String'));



function edit_imageNo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_imageNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_imageNo as text
%        str2double(get(hObject,'String')) returns contents of edit_imageNo as a double
current_image = str2num(get(hObject,'String'));
if current_image>length(handles.imageLocations)
    set(hObject,'String',length(handles.imageLocations));
    warndlg('The image number exceeded the number of existing images');    
else
    try
        set(handles.cb_active,'Value',handles.settings.images(current_image).isActive);
    catch
        set(handles.cb_active,'Value',1);
        handles.settings.images(current_image).isActive = 1;
    end
    
    
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function edit_imageNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_imageNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in cb_active.
function cb_active_Callback(hObject, eventdata, handles)
% hObject    handle to cb_active (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_active
current_image = str2num(get(handles.edit_imageNo,'String'));
handles.settings.images(current_image).isActive = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in pb_prevImage.
function pb_prevImage_Callback(hObject, eventdata, handles)
% hObject    handle to pb_prevImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_image = str2num(get(handles.edit_imageNo,'String'))-1;
if current_image<handles.imageLocations(1).imageNo
    set(handles.edit_imageNo,'String',num2str(handles.imageLocations(1).imageNo));
    warndlg('The image number exceeded the number of existing images');
else
    set(handles.edit_imageNo,'String',num2str(current_image));
    try
        set(handles.cb_active,'Value',handles.settings.images(current_image).isActive);
    end
    pb_preview_Callback(hObject, eventdata, handles);
end



% --- Executes on button press in pb_nextImage.
function pb_nextImage_Callback(hObject, eventdata, handles)
% hObject    handle to pb_nextImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_image = str2num(get(handles.edit_imageNo,'String'))+1;

if current_image > (handles.imageLocations(end).imageNo-handles.imageLocations(1).imageNo+1)
    set(handles.edit_imageNo,'String',num2str(handles.imageLocations(end).imageNo));
    warndlg('The image number exceeded the number of existing images');
else
    set(handles.edit_imageNo,'String',num2str(current_image));
    try
        set(handles.cb_active,'Value',handles.settings.images(current_image).isActive);
    catch
        handles.settings.images(current_image).isActive = get(handles.cb_active,'Value');
    end
    pb_preview_Callback(hObject, eventdata, handles);
end
