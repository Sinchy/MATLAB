%this function reduces several matrices according to a window provided by the user
%windowProcess : [left_index right_index top_index bottom_index]
%the indices correspond to number of columns/rows EXCLUDED from the
%original field
%I, J: number of columns and rows in the original matrices
%varargin(1)...varargin(n): n matrices to process

%created by Ricardo Mejia-Alvarez. Urbana, IL. 09/11/09

%modified:  01/03/2010
%           01/27/2010

function [Ired,Jred,varargout] = WindowFile(windowProcess,I,J,varargin)

Ired = I - windowProcess(1) - windowProcess(2) + 2;
Jred = J - windowProcess(3) - windowProcess(4) + 2;


for k = 1 : length(varargin)
    U = cell2mat(varargin(k));
    U = U(windowProcess(3) : length(U(:,1)) - windowProcess(4) + 1 , windowProcess(1) : length(U(1,:)) - windowProcess(2) + 1); 
    varargout(k) = {U}; %#ok<AGROW>
end

end