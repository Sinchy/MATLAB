dir = '/home/tanshiyong/Documents/Data/Bubble/08.01.18/Run1_Bubbles/Bubbles2/Bubbles2/2Dtracks/';

load([ dir 'allcams.mat']);
start_frame = 2380; end_frame = 2819;
totFrames = end_frame - start_frame;
mkdir([dir 'AllCam']);
for frame = 1:totFrames
    eval(['output_data = frame_' num2str(frame) ';']);
    if ~isempty(output_data)
        fileID = fopen([dir 'AllCam/' 'Frame' num2str(frame + start_frame - 1) '.txt'], 'at');
        formatspec = '%f,';
        for i = 1 : size(output_data, 1)
            fprintf(fileID, formatspec, output_data(i, [1:8 17:20]));
        end
        fclose(fileID);
    end
end