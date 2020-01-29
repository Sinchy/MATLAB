function varargout = particle_detection_GUI(varargin)
% This GUI is used to manually control the 2D detection of single particles
% which are assumed to be white on dark background. The output variable
% "settings" can be used to trigger the processing function
% "do_detection_2D.m"
%
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

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @particle_detection_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @particle_detection_GUI_OutputFcn, ...
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


% --- Executes just before particle_detection_GUI is made visible.
function particle_detection_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to particle_detection_GUI (see VARARGIN)

% Choose default command line output for particle_detection_GUI
handles.output = hObject;

handles.settings = varargin{1};
handles.current_camera = varargin{2};

% pre-set certain variabes and gui-parameters
set(handles.slider_frame,'Min',handles.settings.im_range(1));
set(handles.slider_frame,'Max',handles.settings.im_range(end));
set(handles.slider_frame,'Value',handles.settings.im_range(1));
set(handles.slider_frame,'SliderStep',[1/(handles.settings.im_range(end)-handles.settings.im_range(1)+1), 0.25]);

set(handles.edit_options_lNoise,'String','1');handles.settings.params2D.optionsNoise = 1;
set(handles.edit_options_lObject,'String','3');handles.settings.params2D.optionsObject = 3;
set(handles.edit_options_threshold,'String','20');handles.settings.params2D.optionsThreshold = 20;



set(handles.edit_sobel_lNoise,'String','1');handles.settings.params2D.sobelNoise = 1;
set(handles.edit_sobel_lGaussian,'String','5');handles.settings.params2D.sobelGaussian = 5;
set(handles.edit_sobel_gain,'String','1');handles.settings.params2D.sobelGain = 1;

set( handles.text_imagenumber,'String',sprintf('Image No %d/%d',handles.settings.im_range(1),handles.settings.im_range(end)) );

% if 2D params already present, pre-set these variables
% TODO

handles.settings.params2D.doSobel = 0;
set(handles.edit_sobel_gain,'Enable','off');
set(handles.edit_sobel_lGaussian,'Enable','off');
set(handles.edit_sobel_lNoise,'Enable','off');

% predisplay the first image (this hides the ugly axes labels)
cla(handles.axes1,'reset')

fMask = eval(sprintf('handles.settings.cam%d_filename',handles.current_camera));
% get the current image
I = imread(sprintf(fMask,get(handles.slider_frame,'Value')));

% assume grayscale image:
I = double(I(:,:,1));

% show image on gui
axes(handles.axes1)
imshow(I./max(I(:)));


set(handles.figure1,'toolbar','figure');

% Update handles structure
guidata(hObject, handles);
        
% UIWAIT makes particle_detection_GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = particle_detection_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.settings;
delete(handles.figure1);


% --- Executes on slider movement.
function slider_frame_Callback(hObject, eventdata, handles)
% hObject    handle to slider_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(hObject,'Value',round(get(hObject,'Value')));
set(handles.text_imagenumber, 'string', sprintf('Image No %d/%d',get(hObject,'Value'),handles.settings.im_range(end)) );


% --- Executes during object creation, after setting all properties.
function slider_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function text_imagenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_imagenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_sobel_lNoise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sobel_lNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sobel_lNoise as text
%        str2double(get(hObject,'String')) returns contents of edit_sobel_lNoise as a double
newValue = str2double(get(hObject,'String'));
handles.settings.params2D.sobelNoise = newValue;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_sobel_lNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sobel_lNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sobel_lGaussian_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sobel_lGaussian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sobel_lGaussian as text
%        str2double(get(hObject,'String')) returns contents of edit_sobel_lGaussian as a double
newValue = str2double(get(hObject,'String'));
handles.settings.params2D.sobelGaussian = newValue;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_sobel_lGaussian_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sobel_lGaussian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_sobel_gain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sobel_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sobel_gain as text
%        str2double(get(hObject,'String')) returns contents of edit_sobel_gain as a double
newValue = str2double(get(hObject,'String'));
handles.settings.params2D.sobelGain = newValue;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_sobel_gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sobel_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.settings.params2D.doSobel = get(hObject,'Value'); % (de-)activate sobel filtering
if get(hObject,'Value')
    set(handles.edit_sobel_gain,'Enable','on');
    set(handles.edit_sobel_lGaussian,'Enable','on');
    set(handles.edit_sobel_lNoise,'Enable','on');
else
        set(handles.edit_sobel_gain,'Enable','off');
    set(handles.edit_sobel_lGaussian,'Enable','off');
    set(handles.edit_sobel_lNoise,'Enable','off');
end
guidata(hObject, handles);



function edit_options_lNoise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_options_lNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_options_lNoise as text
%        str2double(get(hObject,'String')) returns contents of edit_options_lNoise as a double
newValue = str2double(get(hObject,'String'));
handles.settings.params2D.optionsNoise = newValue;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_options_lNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_options_lNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_options_lObject_Callback(hObject, eventdata, handles)
% hObject    handle to edit_options_lObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_options_lObject as text
%        str2double(get(hObject,'String')) returns contents of edit_options_lObject as a double
newValue = str2double(get(hObject,'String'));
handles.settings.params2D.optionsObject = newValue;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_options_lObject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_options_lObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_options_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_options_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_options_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_options_threshold as a double
newValue = str2double(get(hObject,'String'));
handles.settings.params2D.optionsThreshold = newValue;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_options_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_options_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pb_process.
function pb_process_Callback(hObject, eventdata, handles)
% hObject    handle to pb_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes1,'reset')
fMask = eval(sprintf('handles.settings.cam%d_filename;',handles.current_camera));
% get the current image
I = imread(sprintf(fMask,get(handles.slider_frame,'Value')));



% do sobel-filtering if demanded
if handles.settings.params2D.doSobel
    I = sobel_filter(I, handles.settings.params2D.sobelNoise, handles.settings.params2D.sobelGaussian, handles.settings.params2D.sobelGain);
end

% assume grayscale image:
I = double(I(:,:,1));

% show image on gui
axes(handles.axes1)
imshow(I./max(I(:))); hold on;

if isfield(handles.settings.params2D,'ROI')
    if ~isempty(handles.settings.params2D.ROI.X)
        X = handles.settings.params2D.ROI.X;
        Y = handles.settings.params2D.ROI.Y;
        plot([X ; X(1)] ,[Y ; Y(1)],'r-');
    end
end

% detect particles 
% this subroutines can be replaced by anything you want...
lNoise = handles.settings.params2D.optionsNoise;
lObject = handles.settings.params2D.optionsObject;
lThreshold = handles.settings.params2D.optionsThreshold;

Ibpass    = bpass(I, lNoise, lObject);
if any(Ibpass(:))
    pkfnd_out = pkfnd(Ibpass, lThreshold, lObject);
    if ~isempty(pkfnd_out)
        positions = cntrd(Ibpass, pkfnd_out, lObject +2, 0);
        if isfield(handles.settings.params2D,'ROI')
            if ~isempty(handles.settings.params2D.ROI.X)
                positions = positions(inpolygon(positions(:,1),positions(:,2), X,Y ),: );
            end
        end
    else
        positions = [];
    end
else positions = [];
end


if isempty(positions) % if any positions were found
   fprintf(2,'No particles could be found. Adjust parameters...\n');
   
else    
    fprintf(1,sprintf('%d particles found.\n',size(positions,1)));
    % show the detected particle positions
    axis(handles.axes1);
    hold on
    
    plot(positions(:,1),positions(:,2),'ro');
end


% --- Executes on button press in pb_QUIT.
function pb_QUIT_Callback(hObject, eventdata, handles)
% hObject    handle to pb_QUIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This button closes the gui and stores the data according to a camera
% independent naming-scheme

% if no ROI given, use the full image size:
if ~isfield(handles.settings.params2D,'ROI')
    handles.settings.params2D.ROI.X = [];
    handles.settings.params2D.ROI.Y = [];
end

handles.settings.parameters2D(handles.current_camera) = handles.settings.params2D;

guidata(hObject, handles);
close(handles.figure1);



function figure1_CloseRequestFcn(hObject, ~, handles)
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end


% --- Executes on button press in pb_roi.
function pb_roi_Callback(hObject, eventdata, handles)
% hObject    handle to pb_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[X, Y] = ginput;
handles.settings.params2D.ROI.X = X;
handles.settings.params2D.ROI.Y = Y;
axes(handles.axes1); hold on;
plot([X ; X(1)] ,[Y ; Y(1)],'r-');
guidata(hObject, handles);
