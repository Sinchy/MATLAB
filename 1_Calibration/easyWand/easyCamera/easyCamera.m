function easyCamera()

focalLength = 0;
pixelSize = 0;
imageSize = [0 0];

observationDistance = 0;
baselineDistance = 0;
numCams=0;
DLT=[];
camPos = [];
camDir = [];
camUp = [];
transformationMatrix = eye(4);
bShareCameraOrientation = false;
dltFilename = '';

worldBounds=zeros(1,7);
worldExtent = zeros(1,2);
worldCenter = zeros(1,3);
granularity = 0;
sliceDimension=2;
noiseModel = 'none';
noiseParameter = 0;
bBusyComputing = false;
reconstructionUncertainty=[];
histAxis = [];

cameraPlotFigure=[];
cameraColors = [];
nanColor=[1 .85 .75];
uncertaintyColormap = [nanColor; plot_util.DianesColormaps('rainbow', 255, .6, .4, 1)];
successColor = [0 1 0];
errorColor = [1 0 0];

verticalPadding = 3;
horizontalPadding=5;
leftEdge=horizontalPadding;
textHeight = 25;
textWidth = 180;
editBoxWidth = 55;
editBoxOffset = 5;
popupWidth = editBoxWidth*3+horizontalPadding*2;
lineHeight = textHeight+verticalPadding;
editBoxAlign = textWidth+horizontalPadding;

intrinsicsHeight = lineHeight*3.5+verticalPadding*5;
intrinsicsOffset = intrinsicsHeight+verticalPadding*2;
extrinsicsHeight = lineHeight*6+verticalPadding*8;
extrinsicsOffset = extrinsicsHeight+verticalPadding*2;
errorHeight = 7*lineHeight+verticalPadding*8;
errorOffset = errorHeight+verticalPadding*2;
figureHeight = intrinsicsOffset+extrinsicsOffset+errorOffset+verticalPadding*2;

figureWidth = 380;

    function position = editBoxPosition(panelHeight, lineNum, colNum)
        position = [editBoxAlign+(editBoxWidth+horizontalPadding)*(colNum(1)-1)  panelHeight-lineHeight*lineNum+editBoxOffset-verticalPadding editBoxWidth*((colNum(end)-colNum(1))+1)+horizontalPadding*(colNum(end)-colNum(1)) textHeight];
    end
    function position = labelPosition(panelHeight, lineNum)
        position = [leftEdge panelHeight-lineHeight*lineNum-verticalPadding textWidth textHeight];
    end
    function position = popupBoxPosition(panelHeight, lineNum)
        position = [editBoxAlign  panelHeight-lineHeight*lineNum+editBoxOffset-verticalPadding editBoxWidth*2+horizontalPadding*1 textHeight];
    end


%%
figure;
pos = get(gcf, 'position');
set(gcf, 'position', [pos(1:2)-[0 figureHeight-pos(4)] figureWidth figureHeight])

%%
intrinsics = uipanel('Title', 'Internal Camera Parameters', 'fontsize', 10', 'units', 'pixels', 'position', [leftEdge figureHeight-intrinsicsOffset figureWidth-leftEdge-horizontalPadding intrinsicsHeight]);
set(intrinsics, 'units', 'pixels');
intrinsicsPosition = get(intrinsics, 'position');
intrinsicsHeight = intrinsicsPosition(4)-20;

lineNum = 1;
labelFocalLength = uicontrol('parent', intrinsics, 'style', 'text', 'string', 'Focal Length (mm):', 'position', labelPosition(intrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxFocalLength = uicontrol('parent', intrinsics, 'style', 'edit', 'string', '', 'position', editBoxPosition(intrinsicsHeight, lineNum, 1));
set(textBoxFocalLength, 'callback', @setFocalLengthCallback);

lineNum = 2;
labelPixelSize = uicontrol('parent', intrinsics, 'style', 'text', 'string', 'Pixel Size (um):', 'position', labelPosition(intrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxPixelSize = uicontrol('parent', intrinsics, 'style', 'edit', 'string', '', 'position', editBoxPosition(intrinsicsHeight, lineNum, 1));
set(textBoxPixelSize, 'callback', @setPixelSizeCallback);

lineNum = 3;
labelImageSize = uicontrol('parent', intrinsics, 'style', 'text', 'string', 'Image Size (pixels):', 'position', labelPosition(intrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxImageSize(1) = uicontrol('parent', intrinsics, 'style', 'edit', 'string', 'Width', 'position', editBoxPosition(intrinsicsHeight, lineNum, 1));
textBoxImageSize(2) = uicontrol('parent', intrinsics, 'style', 'edit', 'string', 'Height', 'position', editBoxPosition(intrinsicsHeight, lineNum, 2));
set(textBoxImageSize(1), 'callback', @setImageSizeCallback);
set(textBoxImageSize(2), 'callback', @setImageSizeCallback);

%%
extrinsics = uipanel('Title', 'Camera Placement Parameters', 'fontsize', 10', 'units', 'pixels', 'position', [leftEdge figureHeight-intrinsicsOffset-extrinsicsOffset figureWidth-leftEdge-horizontalPadding extrinsicsHeight]);
set(extrinsics, 'units', 'pixels');
extrinsicsPosition = get(extrinsics, 'position');
extrinsicsHeight = extrinsicsPosition(4)-20;

lineNum = 1;
labelCameraPlacement = uicontrol('parent', extrinsics, 'style', 'text', 'string', 'Placement Type:', 'position', labelPosition(extrinsicsHeight, lineNum), 'horizontalalignment', 'left');
popupCameraPlacement = uicontrol('parent', extrinsics, 'style', 'popupmenu', 'String', 'Constructed|Estimated',  'position', popupBoxPosition(extrinsicsHeight, lineNum));
set(popupCameraPlacement, 'value', 1);
set(popupCameraPlacement, 'callback', @setCameraPlacementCallback);

lineNum = 2;
labelNumCams = uicontrol('parent', extrinsics, 'style', 'text', 'string', 'Number of Cameras:', 'position', labelPosition(extrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxNumCams = uicontrol('parent', extrinsics, 'style', 'edit', 'string', '', 'position', editBoxPosition(extrinsicsHeight, lineNum, 1));
set(textBoxNumCams, 'callback', @setNumCamsCallback);

lineNum = 3;
labelObservationDistance = uicontrol('parent', extrinsics, 'style', 'text', 'string', 'Observation Distance (m):', 'position', labelPosition(extrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxObservationDistance = uicontrol('parent', extrinsics, 'style', 'edit', 'string', '', 'position', editBoxPosition(extrinsicsHeight, lineNum, 1));
set(textBoxObservationDistance, 'callback', @setObservationDistanceCallback);

lineNum = 4;
labelBaselineDistance = uicontrol('parent', extrinsics, 'style', 'text', 'string', 'Baseline Distance (m):', 'position', labelPosition(extrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxBaselineDistance = uicontrol('parent', extrinsics, 'style', 'edit', 'string', '', 'position', editBoxPosition(extrinsicsHeight, lineNum, 1));
set(textBoxBaselineDistance, 'callback', @setBaselineDistanceCallback);

lineNum = 5;
checkBoxParallel = uicontrol('parent', extrinsics, 'style', 'checkbox', 'string', 'Use Parallel Image Planes', 'position', labelPosition(extrinsicsHeight, lineNum)+[0 0 editBoxWidth 0]);
set(checkBoxParallel, 'callback', @setParallelCallback);

cameraPlacementWidgets = [labelNumCams, textBoxNumCams, labelObservationDistance, textBoxObservationDistance, labelBaselineDistance, textBoxBaselineDistance, checkBoxParallel];

%button to load DLT coefficients from easyWand
lineNum = 2;
buttonLoadDLT = uicontrol('parent', extrinsics, 'style', 'pushbutton', 'string', 'Load DLT Coefficients', 'position', labelPosition(extrinsicsHeight, lineNum)+[0 editBoxOffset 0 0]);
set(buttonLoadDLT, 'callback', @loadDLTCallback);
set(buttonLoadDLT, 'visible', 'off');

labelLoadDLT = uicontrol('parent', extrinsics, 'style', 'edit', 'string', 'No File Selected', 'position', editBoxPosition(extrinsicsHeight, lineNum, 1:3), 'horizontalalignment', 'center');
set(labelLoadDLT, 'visible', 'off');

lineNum = 3;
labelFrustumDistance = uicontrol('parent', extrinsics, 'style', 'text', 'string', 'View Distance (m):', 'position', labelPosition(extrinsicsHeight, lineNum), 'horizontalalignment', 'left');
textBoxFrustumDistance = uicontrol('parent', extrinsics, 'style', 'edit', 'string', '', 'position', editBoxPosition(extrinsicsHeight, lineNum, 1));
set(textBoxFrustumDistance, 'callback', @setFrustumDistanceCallback);
set(labelFrustumDistance, 'visible', 'off');
set(textBoxFrustumDistance, 'visible', 'off');

loadDLTWidgets = [buttonLoadDLT labelLoadDLT labelFrustumDistance textBoxFrustumDistance];

lineNum = 6;
buttonDisplayCameras = uicontrol('parent', extrinsics, 'style', 'pushbutton', 'string', 'Display Camera Setup', 'position', [leftEdge extrinsicsHeight-lineHeight*lineNum figureWidth-leftEdge-horizontalPadding*3, textHeight]);
set(buttonDisplayCameras, 'callback', @displayConstructedCamerasCallback);

%%

uncertainty = uipanel('Title', 'Uncertainty Computation Parameters', 'fontsize', 10', 'units', 'pixels', 'position', [leftEdge figureHeight-intrinsicsOffset-extrinsicsOffset-errorOffset figureWidth-leftEdge-horizontalPadding errorHeight]);
set(uncertainty, 'units', 'pixels');
errorPosition = get(uncertainty, 'position');
errorHeight = errorPosition(4)-20;

lineNum = 1;
labelDimension = uicontrol('parent', uncertainty, 'style', 'text', 'string', 'Slice Dimension:', 'position', labelPosition(errorHeight, lineNum), 'horizontalalignment', 'left');
popupDimension = uicontrol('parent', uncertainty, 'style', 'popupmenu', 'parent', uncertainty, 'String', 'X|Y|Z',  'position', popupBoxPosition(errorHeight, lineNum));
set(popupDimension, 'value', 2);
set(popupDimension, 'callback', @setSliceDimensionCallback);

lineNum=2;
labelGranularity = uicontrol('parent', uncertainty, 'style', 'text', 'string', 'Granularity (cm):', 'position', labelPosition(errorHeight, lineNum), 'horizontalalignment', 'left');
textBoxGranularity = uicontrol('parent', uncertainty, 'style', 'edit', 'position', editBoxPosition(errorHeight, lineNum, 1));
set(textBoxGranularity, 'callback', @setUncertaintyExtentCallback);

lineNum = 3;
labelCenter = uicontrol('parent', uncertainty, 'style', 'text', 'string', 'Center (m) [X] [Y] [Z]:', 'position', labelPosition(errorHeight, lineNum), 'horizontalalignment', 'left');
textBoxCenter(1) = uicontrol('parent', uncertainty, 'style', 'edit', 'string', 'X', 'position', editBoxPosition(errorHeight, lineNum, 1));
textBoxCenter(2) = uicontrol('parent', uncertainty, 'style', 'edit', 'string', 'Y', 'position', editBoxPosition(errorHeight, lineNum, 2));
textBoxCenter(3) = uicontrol('parent', uncertainty, 'style', 'edit', 'string', 'Z', 'position', editBoxPosition(errorHeight, lineNum, 3));
set(textBoxCenter(1), 'callback', @setUncertaintyExtentCallback);
set(textBoxCenter(2), 'callback', @setUncertaintyExtentCallback);
set(textBoxCenter(3), 'callback', @setUncertaintyExtentCallback);

lineNum = 4;
labelExtent = uicontrol('parent', uncertainty, 'style', 'text', 'string', 'Extent (m) [Width] [Length]:', 'position', labelPosition(errorHeight, lineNum), 'horizontalalignment', 'left');
textBoxExtent(1) = uicontrol('parent', uncertainty, 'style', 'edit', 'string', 'Width', 'position', editBoxPosition(errorHeight, lineNum, 1));
textBoxExtent(2) = uicontrol('parent', uncertainty, 'style', 'edit', 'string', 'Length', 'position', editBoxPosition(errorHeight, lineNum, 2));
set(textBoxExtent(1), 'callback', @setUncertaintyExtentCallback);
set(textBoxExtent(2), 'callback', @setUncertaintyExtentCallback);

lineNum=5;
labelNoiseModel = uicontrol('parent', uncertainty, 'style', 'text', 'string', 'Noise Model', 'position', labelPosition(errorHeight, lineNum), 'horizontalalignment', 'left');
popupNoiseModel = uicontrol('parent', uncertainty, 'style', 'popupmenu', 'parent', uncertainty, 'String', 'None|Target Size|Pixels',  'position', popupBoxPosition(errorHeight, lineNum));
set(popupNoiseModel, 'callback', @setNoiseModelCallback);

lineNum=6;
labelNoiseParameter = uicontrol('parent', uncertainty, 'style', 'text', 'string', 'Noise Parameter:', 'position', labelPosition(errorHeight, lineNum), 'horizontalalignment', 'left');
textBoxNoiseParameter = uicontrol('parent', uncertainty, 'style', 'edit', 'position', editBoxPosition(errorHeight, lineNum, 1));
set(textBoxNoiseParameter, 'callback', @setNoiseParameterCallback);
set(textBoxNoiseParameter, 'enable', 'off');
set(textBoxNoiseParameter, 'visible', 'off');
set(labelNoiseParameter, 'visible', 'off');

lineNum=7;
buttonDisplayError = uicontrol('parent', uncertainty, 'style', 'pushbutton', 'string', 'Display Reconstruction Uncertainty', 'position', [leftEdge errorHeight-lineHeight*lineNum figureWidth-leftEdge-horizontalPadding*3, textHeight]);
set(buttonDisplayError, 'callback', @displayErrorCallback);
buttonSaveError = uicontrol('parent', uncertainty, 'style', 'pushbutton', 'string', 'Save', 'position', [editBoxAlign+editBoxWidth*2+horizontalPadding*2 errorHeight-lineHeight*lineNum, editBoxWidth, textHeight]);
set(buttonSaveError, 'callback', @saveErrorCallback);
set(buttonSaveError, 'visible', 'off');
%%
    function value = validateNumericalTextBoxEntry(textbox, default, bPositive)
        value = str2num(get(textbox, 'string'));
        if isempty(value) || (bPositive && value<=0)
            set(textbox, 'string', default);
            set(textbox, 'backgroundcolor', errorColor);
            value = default;
        else
            set(textbox, 'backgroundcolor', successColor);
        end
    end

    function setFocalLengthCallback(hobject, eventdata)
        focalLength = validateNumericalTextBoxEntry(textBoxFocalLength, focalLength, true);
    end

    function setPixelSizeCallback(hobject, eventdata)
        pixelSize = validateNumericalTextBoxEntry(textBoxPixelSize, pixelSize, true);
    end

    function setImageSizeCallback(hobject, eventdata)
        if hobject == textBoxImageSize(1)
            imageSize(1) = validateNumericalTextBoxEntry(textBoxImageSize(1), imageSize(1), true);
        else
            imageSize(2) = validateNumericalTextBoxEntry(textBoxImageSize(2), imageSize(2), true);
        end
    end

    function setCameraPlacementCallback(hobjects, eventdata)
        value = get(popupCameraPlacement, 'value');
        if value == 1
            set(cameraPlacementWidgets, 'visible', 'on');
            set(loadDLTWidgets, 'visible', 'off');
            set(buttonDisplayCameras, 'callback', @displayConstructedCamerasCallback);
        else
            set(cameraPlacementWidgets, 'visible', 'off');
            set(loadDLTWidgets, 'visible', 'on');
            set(buttonDisplayCameras, 'callback', @displayDLTCamerasCallback);
            if ~isempty(dltFilename)
                DLT = dlmread(dltFilename);
            end
               
        end
    end

    function setNumCamsCallback(hobjects, eventdata)
        numCams = validateNumericalTextBoxEntry(textBoxNumCams, numCams, true);
        DLT=[];
    end

    function setObservationDistanceCallback(hobjects, eventdata)
        observationDistance = validateNumericalTextBoxEntry(textBoxObservationDistance, observationDistance, true);
        set(textBoxFrustumDistance, 'string', num2str(observationDistance*2));
        DLT=[];
    end

    function setFrustumDistanceCallback(hobjects, eventdata)
        observationDistance = validateNumericalTextBoxEntry(textBoxFrustumDistance, observationDistance*2, true)/2;
        set(textBoxObservationDistance, 'string', num2str(observationDistance));
    end

    function setBaselineDistanceCallback(hobjects, eventdata)
        baselineDistance = validateNumericalTextBoxEntry(textBoxBaselineDistance, baselineDistance, true);
        DLT=[];
    end

    function setParallelCallback(hobjects, eventdata)
        bShareCameraOrientation = get(checkBoxParallel, 'value');
    end

    function loadDLTCallback(hobjects, eventdata)
        [Filename, PathName] = uigetfile({'*.csv'}, 'Choose DLT Coefficients', dltFilename);
        if ~isempty(Filename) && ischar(Filename)
            dltFilename = [PathName '/' Filename];
            DLT = dlmread(dltFilename);
            if isempty(DLT) || size(DLT, 1) ~= 11
                errordlg('Data in file for DLT Coefficients is invalid');
                set(buttonLoadDLT, 'backgroundcolor', errorColor);
                return;
            end
            numCams = size(DLT, 2);
            set(textBoxNumCams, 'string', num2str(numCams));
            set(buttonLoadDLT, 'backgroundColor', successColor);
            set(labelLoadDLT, 'string', dltFilename);
        end
    end

    function setUncertaintyExtentCallback(hobjects, eventdata)
        if any(hobjects == textBoxCenter)
            idx = find(hobjects == textBoxCenter);
            worldCenter(idx) = validateNumericalTextBoxEntry(textBoxCenter(idx), worldCenter(idx), false);
        elseif any(hobjects == textBoxExtent)
            idx = find(hobjects == textBoxExtent);
            worldExtent(idx) = validateNumericalTextBoxEntry(textBoxExtent(idx), worldExtent(idx), true);
        elseif hobjects == textBoxGranularity
            granularity = validateNumericalTextBoxEntry(textBoxGranularity, granularity, true);
        end
        
        if granularity > 0 && all(worldExtent > 0)
            setBounds();
        end
    end

    function setBounds()
        if sliceDimension==1
            worldBounds(1:2) = worldCenter(1)+[0 granularity/100];
            worldBounds(3:4) = worldCenter(2)+[-worldExtent(1) worldExtent(1)]/2;
            worldBounds(5:6) = worldCenter(3)+[-worldExtent(2) worldExtent(2)]/2;
        elseif sliceDimension==2
            worldBounds(1:2) = worldCenter(1)+[-worldExtent(1) worldExtent(1)]/2;
            worldBounds(3:4) = worldCenter(2)+[0 granularity/100];
            worldBounds(5:6) = worldCenter(3)+[-worldExtent(2) worldExtent(2)]/2;
        elseif sliceDimension==3
            worldBounds(1:2) = worldCenter(1)+[-worldExtent(1) worldExtent(1)]/2;
            worldBounds(3:4) = worldCenter(2)+[-worldExtent(2) worldExtent(2)]/2;
            worldBounds(5:6) = worldCenter(3)+[0 granularity/100];
        end
    end

    function setWorldExtentsCallback(hobjects, eventdata)
        idx = find(textBoxExtent==hobjects);
        if isempty(idx)
            return;
        end
        
        bPositive = false;
        if idx == 7
            bPositive = true;
        end
        worldBounds(idx) = validateNumericalTextBoxEntry(hobjects, worldBounds(idx), bPositive);
        
        if idx==7
            worldBounds(sliceDimension*2)=worldBounds(sliceDimension*2-1)+worldBounds(idx);
        end
        
        if (idx+1)/2 == sliceDimension
            worldBounds(sliceDimension*2) = worldBounds(sliceDimension*2-1)+worldBounds(7);
        end
        
        idx = find(worldBounds(1:2:5) >= worldBounds(2:2:6));
        if ~isempty(idx)
            set(textBoxExtent([idx*2-1 idx*2]), 'backgroundcolor', errorColor);
        end
        
        for i=1:7
            set(textBoxExtent(i), 'string', num2str(worldBounds(i)));
        end
    end

    function setSliceDimensionCallback(hobjects, eventdata)
        sliceDimension = get(popupDimension, 'value');
        setBounds();
    end

    function setNoiseModelCallback(hobjets, eventdata)
        val = get(popupNoiseModel, 'value');
        if val == 1
            noiseModel = 'none';
            noiseParameter = 0;
            set(textBoxNoiseParameter, 'string', num2str(noiseParameter));
            set(textBoxNoiseParameter, 'enable', 'off');
            set(textBoxNoiseParameter, 'visible', 'off');
            set(labelNoiseParameter, 'visible', 'off');
        elseif val == 2
            noiseModel = 'target';
            set(textBoxNoiseParameter, 'visible', 'on');
            set(textBoxNoiseParameter, 'enable', 'on');
            set(textBoxNoiseParameter, 'string', num2str(noiseParameter));
            set(labelNoiseParameter, 'string', 'Target Size (cm):');
            set(labelNoiseParameter, 'visible', 'on');
        elseif val == 3
            noiseModel = 'pixels';
            set(textBoxNoiseParameter, 'visible', 'on');
            set(textBoxNoiseParameter, 'enable', 'on');
            set(textBoxNoiseParameter, 'string', num2str(noiseParameter));
            set(labelNoiseParameter, 'string', 'Image Ambiguity (pixels):');
            set(labelNoiseParameter, 'visible', 'on');
        end
    end

    function setNoiseParameterCallback(hobjects, eventdata)
        noiseParameter = validateNumericalTextBoxEntry(textBoxNoiseParameter, noiseParameter, true);
        if noiseParameter < 0
            noiseParameter = 0;
            set(textBoxNoiseParameter, 'backgroundcolor', errorColor', 'string', num2str(noiseParameter));
        end
    end

%%
    function displayConstructedCamerasCallback(hobject, eventdata)
        if any([focalLength pixelSize imageSize numCams observationDistance baselineDistance]<=0)
            errordlg('Could not display camera set up because the parameters are not all set');
            return;
        end
        
        cameraColors = plot_util.DianesColormaps('hsv', ceil(numCams*1.1), .85, .65);
        cameraColors = cameraColors(end:-1:1,:);
        frustumDistance = observationDistance*2;
        [DLT, Axis, camPos, camDir, camUp] = plotCameraSetup(focalLength*1e-3, pixelSize*1e-6, imageSize, observationDistance, baselineDistance, numCams, transformationMatrix, frustumDistance, cameraColors, bShareCameraOrientation);
        view([0 0]);
        cameraPlotFigure=gcf;
        set(cameraPlotFigure, 'DeleteFcn', @resetCameraPlotFigure);
    end

    function displayDLTCamerasCallback(hobject, eventdata)
        if isempty(DLT)
            errordlg('Could not display camera set up because DLT parameters are not loaded');
            return;
        end
        numCams=size(DLT,2);
        
        cameraColors = plot_util.DianesColormaps('hsv', ceil(numCams*1.1), .85, .65);
        cameraColors = cameraColors(end:-1:1,:);
        if observationDistance <= 0
            errordlg('Could not plot the cameras because the view distance is not set.');
            return;
        end
        frustumDistance = observationDistance*2;
        plotDLTCameraSetup(DLT, focalLength*1e-3, pixelSize*1e-6, imageSize, transformationMatrix, frustumDistance, cameraColors);
        cameraPlotFigure=gcf;
        set(cameraPlotFigure, 'DeleteFcn', @resetCameraPlotFigure);
    end

    function resetCameraPlotFigure(hObj, event)
        if hObj == cameraPlotFigure
            cameraPlotFigure=[];
        end
    end

    function displayErrorCallback(hobject, eventdata)
        if isempty(DLT) || isempty(cameraPlotFigure)
            displayConstructedCamerasCallback(hobject, eventdata);
        end
        if any(worldBounds(2:2:6) <= worldBounds(1:2:5))
            errordlg('Could not display reconstruction uncertainty because the values of the bounds are invalid');
            return;
        end
        if granularity <= 0
            errordlg('Could not reconstruction uncertainty because granularity should be set to a positive value.');
            return;
        end
        
        if bBusyComputing
            return;
        end

        bBusyComputing = true;
        
        histExtent={worldBounds(1:2), worldBounds(3:4), worldBounds(5:6)};
        histDX = granularity/100;
        histSmooth = false;

        
        bDropPlane = false;
        
        bgcolor = get(buttonDisplayCameras, 'backgroundcolor');
        set(buttonDisplayError, 'backgroundcolor', [1 1 0], 'String', 'Computing ...')
        figure(cameraPlotFigure);
        
        noiseParamTemp = noiseParameter;
        if strcmp(noiseModel, 'target')
            noiseParamTemp = noiseParamTemp/100;
        end
        [a e] = view;
        [reconstructionUncertainty, histAxis] = plotReconstructionError(DLT, imageSize, histExtent, noiseModel, noiseParamTemp, histDX, histSmooth, transformationMatrix, uncertaintyColormap, bDropPlane);
        view([a e]);
        set(buttonDisplayError, 'backgroundcolor', bgcolor, 'String', 'Display Reconstruction Uncertainty')
        set(buttonDisplayError, 'position', [leftEdge errorHeight-lineHeight*lineNum textWidth+editBoxWidth*2+horizontalPadding*1, textHeight]);
        set(buttonSaveError, 'visible', 'on');
        
        bBusyComputing = false;
    end

    function saveErrorCallback(hobject, eventdata)        
        [Filename, PathName] = uiputfile({'*.mat'}, 'Save Uncertainty Data', dltFilename);
        if ~isempty(Filename) && ischar(Filename)
            save([PathName Filename], 'reconstructionUncertainty', 'histAxis');
        end
    end

q=0;
end