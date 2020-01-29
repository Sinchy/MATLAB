index_error_new = index_error_new_3;
[len, ~] = size(index_error_new);
k = 1;
for i = 1 : len
    for j = 2 : 5 
        if isempty(find(index_error_old(:,j) == index_error_new(i,j)))  % to find match in two index arraies
            repeated_cam_in_new = 0;
            for l = 2 : 5
                if ~isempty(find(index_error_new(:,l) == index_error_new(i,l))) % to see wether such a match has repeated in all the camera
                    if (find(index_error_new(:,l) == index_error_new(i,l)) ~= i)
                      repeated_cam_in_new = l - 1;
                    end
                end
            end
            repeated_cam_in_old = 0;
            for l = 2 : 5
                if ~isempty(find(index_error_old(:,l) == index_error_new(i,l))) % to see wether such a match has repeated in all the camera
                   repeated_cam_in_old = l - 1;
                end
            end
                difference(k,:) = [ index_error_new(i,:) 1  repeated_cam_in_new repeated_cam_in_old ];
            k = k + 1;
            break;
        else % if a match isfound, then compare all of the indices to see whether they are exactly matching each other
             matchindex = find(index_error_old(:,j) == index_error_new(i,j));
            for l = 2 : 5
                if index_error_new(i,l) ~= index_error_old(matchindex, l)
                    difference(k,:) = [ index_error_new(i,:) 2  l-2 l-2];
                    k = k + 1;
                    difference(k,:) = [ index_error_old(matchindex,:) 2  l-2 l-2];
                    k = k + 1;
                    break;
                end
             end
        end
    end
end
[len, ~] = size(index_error_old);
for i = 1 : len
    for j = 2 : 5 
        if isempty(find(index_error_new(:,j) == index_error_old(i,j)))  % to find match in two index arraies
            repeated_cam_in_old = 0;
            for l = 2 : 5
                if ~isempty(find(index_error_old(:,l) == index_error_old(i,l))) % to see wether such a match has repeated in all the camera
                    if (find(index_error_new(:,l) == index_error_new(i,l)) ~= i)
                      repeated_cam_in_old = l - 1;
                    end
                end
            end
            repeated_cam_in_new = 0;
            for l = 2 : 5
                if ~isempty(find(index_error_new(:,l) == index_error_old(i,l))) % to see wether such a match has repeated in all the camera
                    repeated_cam_in_old = l - 1;
                end
            end
                difference(k,:) = [ index_error_old(i,:) 0  repeated_cam_in_old repeated_cam_in_new ];
            k = k + 1;
            break;
        end
    end
end