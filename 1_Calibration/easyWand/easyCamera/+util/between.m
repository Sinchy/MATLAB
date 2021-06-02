function [result] = between(data, iMin, iMax)
%
% return a vector of booleans indicating where the values contained in the
% variable "data" are between the given minimum and maximum values
% (inclusive)
%
%
    if numel(iMin) == 2
        iMax = iMin(2);
        iMin = iMin(1);
    end
    result = data >= iMin & data <= iMax;
end