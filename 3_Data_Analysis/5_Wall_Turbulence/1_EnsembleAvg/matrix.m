%this code organizes a text file (Tecplot format) in Matlab matrix
%format.
%Created by Ricardo Mejia-Alvarez. Urbana, IL. 03/03/08
%modified: 07/10/08
%modified: 11/14/08
%modified: 09/29/09

%input:
%path: full path for the file to analyze

%outputs:
%nc: number of columns in the file, which will be the number of matrices
%generated by this function
%I: number of columns in the matrices
%J: number of rows in the matrices
%Dx and Dy: grid spacings in each coordinate

%2D-PIV:    varargout(1) => x coordinate
%           varargout(2) => y coordinate
%           varargout(3) => U
%           varargout(4) => V
%           varargout(5) => validity parameter in Insight 3G or zero in other versions
%           varargout(6), varargout(7), varargout(8) => 0

%stereo PIV:    varargout(1) => x coordinate
%               varargout(2) => y coordinate
%               varargout(3) => z coordinate
%               varargout(4) => U
%               varargout(5) => V
%               varargout(6) => W
%               varargout(7) => validity parameter in Insight 3G
%               varargout(8) => residual pixels

%For other kind of files, these parameters are user defined


function [nc,I,J,Dx,Dy,varargout] = matrix(path)

m = fopen(path,'r');      %open the file selected

fgets(m);  %discards all the characters before the numerical data.
first = fgets(m);   %reads the first line of data
first = str2num(first); %#ok<ST2NM>
nc = length(first); %calculates the number of columns in the files
                                            
C = textscan(m,'%f64','delimiter',','); %reads the numerical data from the file
A = C{:};     %saves the data in a vector
A = [first' ; A];

A = reshape(A,nc,length(A)/nc)';

A = sortrows(A,[1,2]);
J = find(A(1,1)-A(:,1) == 0, 1 , 'last');
Dy = abs( A(2,2) - A(1,2) );

A = sortrows(A,[2,1]);
I = find(A(1,2)-A(:,2) == 0, 1 , 'last');
Dx = abs( A(2,1) - A(1,1) );

varargout = cell(1,nc);

for k = 1 : nc
    U = reshape(A(:,k),I,J)';
    varargout(k) = {U};
end


fclose(m);      %closes the current file




end %end of the function