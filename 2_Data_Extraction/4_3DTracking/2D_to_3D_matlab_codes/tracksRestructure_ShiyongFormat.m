tr2D = zeros(1,200,3);
for i = 1:size(trackFit,1)
    temp = trackFit{i};
    for j = 1:size(temp,2)
        tr = zeros(1,200,3);
        if (numel(temp{j}) ~= 0)
            tr(1,temp{j}(:,4),:) = temp{j}(:,1:3);
            tr2D = [tr2D; tr];
        end
    end
end