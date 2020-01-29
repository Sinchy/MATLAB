indexofmatch =indexofmatchold;
[len, ~] = size(indexofmatch);
for i = 1:len/4
    index(i,:) = indexofmatch((i - 1) * 4 + 1: (i - 1) * 4 + 4);
end