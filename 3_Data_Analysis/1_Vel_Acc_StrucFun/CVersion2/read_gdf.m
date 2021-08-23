function [data sz type ne]=read_gdf(fn, data_type)

if ~exist('data_type','var')
  data_type=0;
end

%  NAME:
% 		read_gdf
%  PURPOSE:
% 		Read in data files created by write_gdf.
%  CATEGORY:
% 		General Purpose Utility
%  CALLING SEQUENCE:
% 		data = read_gdf(filename)
%  INPUTS:
% 		file:	Complete pathname of the file to be read.
%  OUTPUTS:
% 		data:	Data structure.  For example, if the original
% 			data was stored as an array of bytes, then
% 			DATA will be returned as an array of bytes also.
%  RESTRICTIONS:
% 		Current implementation does not support structures or
% 		arrays of structures.
%  PROCEDURE:
% 		Reasonably straightforward.
% 		Determines if the file is ASCII or binary, reads the size
% 		and dimension info from the header, and reads in the data
%  MODIFICATION HISTORY:
% 		Written by David G. Grier, AT&T Bell Laboratories, 9/91
% 	12/95 Figures out how to deal with data from different-endian
% 		machines DGG.
%   converted to matlab 04/29/04, MDS NB: endian not implemented
% -

MAGIC = 082991;
HEADER = 'GDF v. 1.0';

typelist={'Undefined',...
          'char',...
          'int16',...
          'int32',...
          'float',...
          'double',...
          'complex float',...
          'string',...
          'structure',...
          'complex double'...
          'pointer',...
          'object'};

%file = findfile(filespec, count=nfiles)
% MDS no error checking at this time
%if nfiles eq 0 then message,'No files matched specification '+filespec

ascii=false;

fid=fopen(fn,'r');

mgc=fread(fid,1,'int32');

if(mgc~=MAGIC)
  fseek(fid,0,'bof');
  hdr=fscanf(fid,'%s');
  if (hdr==HEADER) 
    disp('-ascii may not work right');
    ascii=true;
  else
    error([fn ' is not a GDF file']);
  end
end

if ascii
  ndim=fscanf(fid,'%d');
  sz=fscanf(fid,'%d',ndim+2);
  data=fscanf(fid,'%f',sz(end));
  data=reshape(data,sz(1:end-1));
else
  ndim=fread(fid,1,'int32');
  sz=fread(fid,ndim,'int32');
  if(ndim==1)
    sz=[1;sz];
  end
  tp=fread(fid,1,'int32');
  ne=fread(fid,1,'int32');
  if nargin < 2
    type=typelist{tp+1};  
  else
    type = data_type;
  end
  a=fread(fid,type);
  data=reshape(a,[sz(1) length(a)./sz(1)]);
  data=data';
end
fclose(fid);

end
