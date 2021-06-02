function [output pedigree] = cellcat(input)
%concatenate the contents of a cell array into a single matrix (or tensor)
%
%assume sizes of all cells are compatible for concatentation along the 
%first dimension.
%
% @param[in] input - a cell array containing items
%
% @param[out] output - a normal matrix with all of the data contained in it

output = [];
pedigree = [];
sz = [];
for i=1:length(input)
    if isempty(input{i})
        continue;
    end
    if isempty(sz)
        s = size(input{i});
        if length(s) <= 2
            if length(s)==1
                s(2)=1;
            end
            [output pedigree] = cellcat2(input, s(2));
            return;
        end
    end
    
    output = cat(1, output, input{i});
    pedigree = [pedigree; ones(size(input{i},1),1)*i];
end
end

function [output pedigree] = cellcat2(input, numdims)
    sz = nan(length(input),1);
    for i=1:length(input)
        sz(i) = size(input{i},1);
    end
    
    num = sum(sz);
    output = nan(num,numdims);
    pedigree = nan(num,1);

    IDX = cumsum([1; sz]);
    for i=1:length(input)
        idx = IDX(i):IDX(i+1)-1;
        output(idx,:) = input{i};
        pedigree(idx) = ones(sz(i),1)*i;
    end
end