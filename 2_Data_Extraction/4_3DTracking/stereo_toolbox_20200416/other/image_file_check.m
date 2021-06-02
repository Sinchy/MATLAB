function [ settings ] = image_file_check( settings )
% This function reads all images and outputs the image data type and gives
% an error if some files are not found. Additionally it puts image
% properties to the settings-file (height+width).


fprintf(1,'\nChecking for image file existence...');
passed = ones(settings.nCams,1);

for camNo = 1:settings.nCams
    for im_number = settings.im_range(1):settings.im_range(end)
        % checks for the existence of all image files.
        
        fMask = eval(sprintf('settings.cam%d_filename;',camNo));
        
        if ~exist(sprintf(fMask,im_number),'file')
            passed(camNo) = 0;
        end
        
    end
end
% put out some text...

if passed
    fprintf(1,'[ done ]\n');
    % report the filetype of the images (only one willl be checked!)
    info = imfinfo(sprintf(settings.cam1_filename,settings.im_range(1)) );
    settings.image_height = info.Height;
    settings.image_width  = info.Width;
    
    fprintf(1,sprintf('Image dimensions found to be %d x %d pixels.\n** Note: All images must be of equal size! **\n',info.Width,info.Height));
else
    fprintf(2,'[ fail ]\n');
    for camNo = 1:settings.nCams
        if passed(camNo)
            fprintf(1,'Camera #%d: Images found\n',camNo);
        else
            fprintf(1,'Camera #%d: Images not (entirely) found\n',camNo);
        end
    end
end






    
end

