function varargout = hdr_tone_map_gui(varargin)
% HDR_TONE_MAP_GUI MATLAB code for hdr_tone_map_gui.fig
%      HDR_TONE_MAP_GUI, by itself, creates a new HDR_TONE_MAP_GUI or raises the existing
%      singleton*.
%
%      H = HDR_TONE_MAP_GUI returns the handle to a new HDR_TONE_MAP_GUI or the handle to
%      the existing singleton*.
%
%      HDR_TONE_MAP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HDR_TONE_MAP_GUI.M with the given input arguments.
%
%      HDR_TONE_MAP_GUI('Property','Value',...) creates a new HDR_TONE_MAP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hdr_tone_map_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hdr_tone_map_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hdr_tone_map_gui

% Last Modified by GUIDE v2.5 02-May-2021 20:17:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hdr_tone_map_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @hdr_tone_map_gui_OutputFcn, ...
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


% --- Executes just before hdr_tone_map_gui is made visible.
function hdr_tone_map_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hdr_tone_map_gui (see VARARGIN)

% Choose default command line output for hdr_tone_map_gui
handles.output = hObject;
setappdata(gcf,'Alpha',1e-5);
setappdata(gcf,'Beta',0.5);
setappdata(gcf,'Gamma',0.5);
setappdata(gcf,'hdr',[]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hdr_tone_map_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hdr_tone_map_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.hdr','Select an HDR file');
if isequal(file,0)
    img_path_string = 'User selected Cancel';
    set(handles.img_path,'string',img_path_string);
    handles.apply_button.Visible='off';
else
    hdr = hdrread(strcat(path,'\',file));
    img_path_string = strcat(path,'\',file);
    setappdata(gcf,'hdr',hdr);
    axes(handles.axes);
    axis off
    imshow(hdr);
    set(handles.img_path,'string',img_path_string);
    setappdata(gcf,'first_time',1);
    handles.apply_button.Visible='on';
end

% --- Executes on slider movement.
function slider_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to slider_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.alpha_box.String = sprintf('%0.5g',handles.slider_alpha.Value);
setappdata(gcf,'Alpha',handles.slider_alpha.Value);
handles.apply_button.Visible='on';
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function alpha_box_Callback(hObject, eventdata, handles)
% hObject    handle to alpha_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(handles.alpha_box.String))
    handles.alpha_box.String = getappdata(gcf,'Alpha');
elseif str2double(handles.alpha_box.String)>handles.slider_alpha.Max
    handles.alpha_box.String = sprintf('%0.5g',handles.slider_alpha.Max);
    handles.slider_alpha.Value = handles.slider_alpha.Max;
    setappdata(gcf,'Alpha',handles.slider_alpha.Value);
elseif str2double(handles.alpha_box.String)<handles.slider_alpha.Min
    handles.alpha_box.String = sprintf('%0.5g',handles.slider_alpha.Min);
    handles.slider_alpha.Value = handles.slider_alpha.Min;
    setappdata(gcf,'Alpha',handles.slider_alpha.Value);
else
    handles.slider_alpha.Value = str2double(handles.alpha_box.String);
    setappdata(gcf,'Alpha',handles.slider_alpha.Value);
end
handles.apply_button.Visible='on';
    
% Hints: get(hObject,'String') returns contents of alpha_box as text
%        str2double(get(hObject,'String')) returns contents of alpha_box as a double


% --- Executes during object creation, after setting all properties.
function alpha_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_beta_Callback(hObject, eventdata, handles)
% hObject    handle to slider_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.beta_box.String = sprintf('%0.5g',handles.slider_beta.Value);
setappdata(gcf,'Beta',handles.slider_beta.Value);
handles.apply_button.Visible='on';
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function beta_box_Callback(hObject, eventdata, handles)
% hObject    handle to beta_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(handles.beta_box.String))
    handles.beta_box.String = getappdata(gcf,'Beta');
elseif str2double(handles.beta_box.String)>handles.slider_beta.Max
    handles.beta_box.String = sprintf('%0.5g',handles.slider_beta.Max);
    handles.slider_beta.Value = handles.slider_beta.Max;
    setappdata(gcf,'Beta',handles.slider_beta.Value);
elseif str2double(handles.beta_box.String)<handles.slider_beta.Min
    handles.beta_box.String = sprintf('%0.5g',handles.slider_beta.Min);
    handles.slider_beta.Value = handles.slider_beta.Min;
    setappdata(gcf,'Beta',handles.slider_beta.Value);
else
    handles.slider_beta.Value = str2double(handles.beta_box.String);
    setappdata(gcf,'Beta',handles.slider_beta.Value);
end
handles.apply_button.Visible='on';
% Hints: get(hObject,'String') returns contents of beta_box as text
%        str2double(get(hObject,'String')) returns contents of beta_box as a double


% --- Executes during object creation, after setting all properties.
function beta_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to slider_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.gamma_box.String = sprintf('%0.5g',handles.slider_gamma.Value);
setappdata(gcf,'Gamma',handles.slider_gamma.Value);
handles.apply_button.Visible='on';
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gamma_box_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(handles.gamma_box.String))
    handles.gamma_box.String = getappdata(gcf,'Gamma');
elseif str2double(handles.gamma_box.String)>handles.slider_gamma.Max
    handles.gamma_box.String = sprintf('%0.5g',handles.slider_gamma.Max);
    handles.slider_gamma.Value = handles.slider_gamma.Max;
    setappdata(gcf,'Gamma',handles.slider_gamma.Value);
elseif str2double(handles.gamma_box.String)<handles.slider_gamma.Min
    handles.gamma_box.String = sprintf('%0.5g',handles.slider_gamma.Min);
    handles.slider_gamma.Value = handles.slider_gamma.Min;
    setappdata(gcf,'Gamma',handles.slider_gamma.Value);
else
    handles.slider_gamma.Value = str2double(handles.gamma_box.String);
    setappdata(gcf,'Gamma',handles.slider_gamma.Value);
end
handles.apply_button.Visible='on';
% Hints: get(hObject,'String') returns contents of gamma_box as text
%        str2double(get(hObject,'String')) returns contents of gamma_box as a double


% --- Executes during object creation, after setting all properties.
function gamma_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_button.
function apply_button_Callback(hObject, eventdata, handles)
% hObject    handle to apply_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.apply_button.Visible='off';
alpha = getappdata(gcf,'Alpha');
beta = getappdata(gcf,'Beta');
gamma = getappdata(gcf,'Gamma');
hdr = getappdata(gcf,'hdr');
handles.status.String = 'Processing...';
drawnow;
Iout = hdr_fast_tone_mapping(hdr,alpha,beta,gamma,2^13);
handles.status.String = '';
axes(handles.axes);
axis off
imshow(Iout);


