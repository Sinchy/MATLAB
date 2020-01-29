% save the results from the (single-camera)-calibration-proedure
[fileToSave, pathToSave] = uiputfile('cameraX.mat','Where to store the calibration information for this camera?');
if any(fileToSave)
    save( fullfile(pathToSave, fileToSave) ,'settings','imageLocations');
    fprintf(1,'Results have been saved to %s.\n',fullfile(pathToSave, fileToSave));
else
    warning('The calibration has not been saved yet!');
end
