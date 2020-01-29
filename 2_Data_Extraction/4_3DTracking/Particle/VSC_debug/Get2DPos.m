
for k = 1 : 4
image_file_path = ['/home/shiyongtan/Documents/Experiment/EXP14/cam' num2str(k) 'ImageNames.txt'];
dir = '/home/shiyongtan/Documents/Experiment/EXP14/';

fid = fopen(image_file_path,'r'); %# open csv file for reading
data = [];
i = 1;
while ~feof(fid)
    line = fgetl(fid); %# read line by line
    path_img = [dir line];
    img = imread(path_img);
    pos2D = Get2DPosOnImage(img);
    num_particle = size(pos2D, 1);
    data = [data; [pos2D, 2 * ones(num_particle, 1), 20 * ones(num_particle, 1), zeros(num_particle, 1),i * ones(num_particle, 1)]];
    i = i + 1;
    if ~(mod(i, 100))
        i
    end
end
fclose(fid);
write_gdf(data, ['/home/shiyongtan/Documents/Experiment/EXP14/cam' num2str(k) '.gdf']);
end
