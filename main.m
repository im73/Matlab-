function varargout = main(varargin)
% UNTITLED MATLAB code for main.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 19-Dec-2018 01:18:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
handles.colorset=['r','b','g','y','k','c'];%颜色集
handles.kind=zeros(6,1);

handles.colorid=1;
%坐标点集
handles.X=[];
handles.Y=[];
handles.funcid=1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
%????
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on;
point = get(gca,'CurrentPoint');%获取鼠标点击点的坐标
plot(point(1,1),point(1,2),[handles.colorset(handles.colorid) 'o']);%绘制该点
handles.X=[point(1,1) point(1,2);handles.X];%存储坐标
handles.Y=[handles.colorid;handles.Y];
handles.kind(handles.colorid)=1;
axis([0,1,0,1]);
guidata(hObject,handles);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)%
%????
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1) ;
cla;%清空操作
handles.X=[];
handles.Y=[];
handles.kind=zeros(6,1);

guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %??±?????
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.colorid=mod(handles.colorid+1,7);%改变颜色
if handles.colorid==0
    handles.colorid=1;
end
set(handles.edit3,'BackgroundColor',handles.colorset(handles.colorid));


guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)%????
%?ò hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',handles.colorset(handles.colorid));
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)%start
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
randn('state', 0);
opts= struct;
opts.depth= 9;
opts.numTrees= 100;
opts.numSplits= 5;
opts.verbose= true;
opts.classifierID= 2;
kinds=sum(handles.kind);
color_set=find(handles.kind==1);
if handles.funcid==1
    m = ClassificationKNN.fit(handles.X,handles.Y,'NumNeighbors',get(handles.popupmenu2,'Value'));%KNN
elseif handles.funcid==2
    lambda=0.1;
    m = lgst_train(handles.X,handles.Y,kinds,lambda,color_set);
elseif handles.funcid==3
    m= forestTrain(handles.X, handles.Y, opts);%random_forest
else
    k=get(handles.popupmenu2,'Value');
    [pre_label nods]=kmeans(handles.X,k);
    pot_edge_color=['b','y','g','k','c','r'];
    pot_inner_color=rand(k,3);
    for i=1:k
        plot(handles.X(pre_label==i,1), handles.X(pre_label==i,2), 'o', 'MarkerFaceColor',pot_inner_color(i,:), 'MarkerEdgeColor',pot_edge_color(i));
    end
    hold on;
     plot(nods(:,1), nods(:,2), 'r*','MarkerSize',15);
  
end
if handles.funcid~=4
    xrange = [0 1];
    yrange = [0 1];
    inc = 0.01;
    [x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2));
    image_size = size(x);
    xy = [x(:) y(:)];

    if handles.funcid==1

        yhat = m.predict(xy);
    %yhat = str2num(cell2mat(yhat_origin));% TreeBagger训出的模型，predict得到的是元胞数组
    % ClassificationKNN预测出的是double矩阵
        decmaphard= reshape(yhat, image_size);
    elseif handles.funcid==2
        pred = lgst_predict(m,xy);
        decmaphard= reshape(pred, image_size);
    else
        [yhat, ysoft] = forestTest(m, xy);
        decmaphard= reshape(yhat, image_size);
    end  

    cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1;0.8 0.8 0.8;0.5 0.7 1;1 0.5 0.7];
    colormap(cmap);
    imagesc(xrange,yrange,decmaphard);
    hold on;
    set(gca,'ydir','normal');

    X=handles.X;
    Y=handles.Y;
    pot_edge_color=['b','y','g','k','c','r'];
    pot_inner_color=rand(kinds,3);

    for i=1:kinds
        plot(X(Y==color_set(i),1), X(Y==color_set(i),2), 'o', 'MarkerFaceColor',pot_inner_color(i,:), 'MarkerEdgeColor',pot_edge_color(i));
    end
    hold on;
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
funcc=get(handles.popupmenu1,'Value');
handles.funcid=funcc;
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
funcc=get(handles.popupmenu1,'Value');
handles.funcid=funcc;
guidata(hObject,handles);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu2.
function popupmenu2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

