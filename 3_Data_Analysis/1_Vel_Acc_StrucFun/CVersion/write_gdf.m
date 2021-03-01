function [a]=write_gdf(data, filename)

MAGIC_int = int32(082991);

sz = size(data);
whz = whos('data');
if ~(strcmp(whz.class, 'double'))
    warning('converting to double precision before saving as .gdf');
    data = double(data);
end
    
idl_sz = int32([length(sz),sz,4,length(data)]);

fid = fopen(filename, 'w');
if fid == -1, error('Could not open file'), end;

count = fwrite(fid, MAGIC_int, 'int32');
if count ~= 1,  error('failed to write Magic number'), end;
    
count = fwrite(fid, idl_sz , 'int32'); 
if count < 4,  error('failed to write array info'), end;
    
count = fwrite(fid, data , 'float'); 
if count < length(data),  error('failed to write data'), end;
 
fclose(fid);
 a=1;
 
end
    
    
    

