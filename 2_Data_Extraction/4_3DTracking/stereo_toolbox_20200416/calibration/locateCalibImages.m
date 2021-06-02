function [ imageLocations ] = locateCalibImages
% This function locates a set of calibration images using sprintf-based
% directory scan. Trailing Zeros are neccessary!

[filename, pathname, ~] = uigetfile({'*.bmp;*.png;*.jpg;*.pgm','Graphic Files'; ...
                                     '*.*',                    'All Files'}, ...
                                     'Select the first image file in the folder');

if ~isempty(filename)
    % one file has been selected, look for further files:

    % scan for numerics in the filename
    nums = regexp(filename,'\d');
    % look for separator (- or _):
    separator = ismember(filename,'-_');
    if any(separator)
        nums = max(find(separator))+1 :nums(end);
    end
    
    num_of_digits = length(nums);
    first_image = str2num(filename(nums));
    
    
    [~, filename_skel, extension] = fileparts(filename);
    filename_skel = filename_skel(1:min(nums)-1);
    
    % scan for largst existing image_number
    last_image = first_image;
    file_found = 1;
    struct_counter = 1;
    while file_found
      % compose number-string to be used by sprintf
      num_string = num2str(zeros(1,num_of_digits));
      num_string(ismember(num_string,' ')) =  [];
      num_digits_counter = numel(num2str(abs(last_image)));
      num_string(end-num_digits_counter+1 : end) = num2str(last_image);
      % now compose the image-filename
      next_filename = sprintf('%s%s%s',filename_skel, num_string , extension);
      next_filename = fullfile(pathname,next_filename);
      if exist(next_filename,'file')
          file_found = 1;
          imageLocations(struct_counter).fileName = next_filename;
          imageLocations(struct_counter).imageNo  = last_image;
          struct_counter = struct_counter +1;
          last_image = last_image+1; 
      else
          file_found = 0;
      end
      
    end
    
    
    



end

