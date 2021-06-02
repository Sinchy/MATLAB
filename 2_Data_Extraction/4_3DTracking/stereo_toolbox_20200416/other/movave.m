function b = movave(a, nn, sp)
%MOVAVE  Moving average filter
%
%   B = MOVAVE(A, NN, SP) runs a moving average filter over data A, with a
%   width of 2*NN data points and filtering column SP of the data. First
%   and last NN entries of B are NaNs

%                                                       created by M. Klindworth
%                                                       last changed: 04.03.2011
% ------------------------------------------------------------------------------

    % default column is 1
    if ~exist('sp','var'), sp = 1;  end;

    [nRows, ~] = size(a);
    b = a;
    
    % set first NN entries of result to NaN
    b(1:nn,sp) = ones(nn,1) * NaN;
    % set last NN entries of result to NaN
    b(nRows-nn:nRows,sp) = ones(nn+1,1) * NaN;
    
    sum = 0;
    for n = (nn+1):(nRows-(nn+1))
        for i = 1:(2*nn+1)
            sum = sum + a(n-nn+i-1,sp);
        end;
        b(n,sp) = sum/(2*nn+1);
        sum = 0;
    end;
