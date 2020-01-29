%% Uses the 2D trackID combinations from triangulation code to find the number of tracks

% Input parameters
common_frames = 4;
first = 5;
last = 175;

%% getting the # of repeating track combinations
I = cell(1,2 + common_frames);
I{1,1} = 'frame';
I{1,2} = '# of common tracks';

k = 1;
for frame = first:common_frames:(last-common_frames)
    I{k+1,1} = [num2str(frame) ' to ' num2str(frame + common_frames - 1)];
    j = 1;
    eval(['I{k+1,2} = frame' num2str(frame) '(:,4:7);']);
    for i = frame:(frame + common_frames - 1)
        eval(['I{k+1,j+2} = frame' num2str(i) '(:,1:7);']);
        temp = I{k+1,2};
        eval(['tmp = frame' num2str(i) '(:,4:7);']);
        [temp,ia,ib] = intersect(temp,tmp,'rows');
        for l = 0:j-1
            I{k+1,l+2} = I{k+1,l+2}(ia,:);
        end
        I{k+1,j+2} = I{k+1,j+2}(ib,:);
        j = j + 1;
    end
    
    k = k + 1;
end

%% unique combinations
avg = 0;
for i = 2:size(I,1)
    tmp1 = I{i,2};
    [~,ind] = unique(tmp1(:,1),'rows');
    tmp1 = tmp1(ind,:);
    for j = 2:size(I,2)
        I{i,j} = I{i,j}(ind,:);
    end
    [~,ind] = unique(tmp1(:,2),'rows');
    tmp1 = tmp1(ind,:);
    for j = 2:size(I,2)
        I{i,j} = I{i,j}(ind,:);
    end
    [~,ind] = unique(tmp1(:,3),'rows');
    tmp1 = tmp1(ind,:);
    for j = 2:size(I,2)
        I{i,j} = I{i,j}(ind,:);
    end
    [~,ind] = unique(tmp1(:,4),'rows');
    tmp1 = tmp1(ind,:);
    for j = 2:size(I,2)
        I{i,j} = I{i,j}(ind,:);
    end
    avg = avg + numel(ind);
end

avg = avg/(size(I,1) - 1);