dirr = '/home/tanshiyong/Documents/Data/Bubble/08.01.18/Run1_Bubbles/Bubbles2/Bubbles2/';
cam_dir = {[dirr 'cam1/'], [dirr 'cam2/'], [dirr 'cam3/'], [dirr 'cam4/'], [dirr 'cam5/'], [dirr 'cam6/']}; 
start_frame = 2380; end_frame = 2819;
frames = end_frame - start_frame;

for cam = 1:4
    outputFileName = [cam_dir{cam} 'cam' num2str(cam) '_' num2str(frames) 'frames.tif'];
    for frame= start_frame:end_frame
        img = imread([cam_dir{cam} 'cam' num2str(cam) 'frame' num2str(frame,'%05.0f') '.tif']);
        imwrite(img(:, :), outputFileName, 'WriteMode', 'append', 'Compression', 'none');
    end
end