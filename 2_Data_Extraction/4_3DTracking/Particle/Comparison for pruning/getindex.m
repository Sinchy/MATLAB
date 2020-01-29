frameindex = frameindexnew3;
len = length(frameindex);
for i = 1:len/4
    index(i, :) = frameindex( (i-1)*4 + 1 : (i-1)*4 + 4);
end

