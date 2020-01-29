function [  ] = flipImages( parameter )
% This function flips (horizontal, vertical, or both) all images in this
% folder (overwriting the original ones!)
% parameter can be 'lr', 'ud', 'lrud'

%doCont = input('This function will flip and OVERWRITE all images\nin the current folder. Continue? [y/n] [N]: ','s');
doCont = 'y';

if isempty(doCont)
    doCont = 'N';
end

% check parameter
switch parameter
    case 'lr'
        fprintf(1,'Flipping all images horizontally.\n');
    case 'ud'
        fprintf(1,'Flipping all images vertically.\n');
    case 'lrud'
        fprintf(1,'Flipping all images horizontally AND vertically.\n');
    otherwise
        fprintf(1,'No correct parameter given. Aborting.\n');
        doCont = 0;
end
fprintf(1,'\nFlipping images...');
if strcmp(doCont,'y') || strcmp(doCont,'Y')
    
    numOfFlipped = 0;
    
    % try to load all images in this directory
    list = dir;
    for k = 3:length(list)
        fprintf(1,'%05d/%05d',numOfFlipped , length(list)-2);
        try
            I = imread(list(k).name); % when file is not an image, the execution will be aborted
            
            switch parameter
                case 'lr'
                    I = flipdim(I,2);
                case 'ud'
                    I = flipdim(I,1);
                case 'lrud'
                    I = flipdim(I,1);
                    I = flipdim(I,2);
            end
            imwrite(I,list(k).name);
            numOfFlipped = numOfFlipped +1;
        end
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b');
    end
    fprintf(1,'done. %d images have been flipped.\n',numOfFlipped);
end