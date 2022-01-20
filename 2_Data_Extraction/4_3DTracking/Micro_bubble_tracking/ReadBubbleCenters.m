function [centers,radii] = ReadBubbleCenters(filepath)

% particles = frame1Loop0New;
fileID = fopen(filepath,'r');
formatspec = '%f,';
particles = fscanf(fileID, formatspec);
l = length(particles);
centers = reshape(particles, [2 l/2]);
centers = centers' +[1 1];
fclose(fileID);
filepath = extractBefore(filepath, '.txt');
filepath = [filepath  '_r.txt'];
fileID = fopen(filepath,'r');
formatspec = '%f,';
radii = fscanf(fileID, formatspec);
fclose(fileID);

end

