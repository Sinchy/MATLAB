function [DistVec] = DistVecContent(cores,vecContent)
% This function separates any vector content into DistVec to be processed
% in each individual core
%
% Note that matlabpool needs to be opened in order this function to work
%
% Author: Julilo Barros - University of Illinois at Urbana-Champaign
% Sept 24, 2009
%
% Update by Julio and Blake
% 2011

a=length(vecContent)/cores;
% b=rem(length(DirContent),cores);

spmd
    DistVec = [];
end

j=1;
for i=1:cores;

    if i~=cores;
    DistVec{i} = vecContent( j : ( i * floor(a) ) ) ;
    j = j + floor(a) ;
    else
        DistVec{i} = vecContent( j : end ) ;
    end
end

% OLD VERSION
% CompOut = Composite();
% 
% if rem(size(dirContent,1),cores*2)~=0
%     %sum=0;
%     for i=1:cores
%         int_size = floor(size(dirContent)/cores);
%         CompOut{i} = dirContent((i-1)*int_size+1:int_size*i);
%         %sum = size(CompOut{i});
%     end
%     % Need some better way to deal with odd numbers of files
%     %if sum~=size(dirContent,1)
%     %    CompOut{1}(end+1,1) = dirContent(end);
%     %end
% else
%     for i=1:cores
%         CompOut{i} = dirContent((i-1)*size(dirContent)/cores+1:size(dirContent)/cores*i);
%     end
% end

% If Stereo PIV, check if both list have the same size
% 
% NLeft = 0;
% NRight = 0;
% if varargin > 2
%     if strcmp(varargin,'Stereo Piv')
%         for j=1:cores
%             sizeDircore(j) = length(CompOut{j});
%             for i=1:length(CompOut{j})
%                 if isempty(findstr(CompOut{j}(i),'LA'))==0 || isempty(findstr(CompOut{j}(i),'LB'))==0
%                     NLeft(j) = NLeft(j) + 1;
%                 elseif isempty(findstr(CompOut{j}(i),'RA'))==0 || isempty(findstr(CompOut{j}(i),'RB'))==0
%                     NRight(j) = NRight(j) + 1;
%                 end
%             end
%             
%         end
%         
%     end
% else
%     error('Your PIV application is ill defined');
% end