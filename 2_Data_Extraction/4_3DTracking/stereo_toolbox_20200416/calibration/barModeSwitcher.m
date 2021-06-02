function [ id0,  id1 ] = barModeSwitcher( stats, barMode, id0_old, id1_old )
% look for barMode and correct/change bars if neccessary:
switch barMode
    case 1,
        %do nothing, this is the expected mode
        id0 = id0_old;
        id1 = id1_old;
    case 2,
        % Auto-Inverse: just exchange the bars
        id0 = id1_old;
        id1 = id0_old;
    case 3,
        %Top-First: id0 is the upper bar
        if stats(id1_old).Centroid(2) < stats(id0_old).Centroid(2) % remember: y increases downwards
            id0 = id1_old;
            id1 = id0_old;
        else
            id0 = id0_old;
            id1 = id1_old;
        end
    case 4,
        %Bottom-First: id0 is the lower bar
        if stats(id0_old).Centroid(2) < stats(id1_old).Centroid(2) % remember: y increases downwards
            id0 = id1_old;
            id1 = id0_old;
        else
            id0 = id0_old;
            id1 = id1_old;
        end
end

end

