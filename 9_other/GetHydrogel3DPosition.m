function [possible_position, position_info] = GetHydrogel3DPosition(calib_path, position_2D)
load(calib_path);
for i = 1 : 4
    num_pos2D(i) = length(position_2D{i});
end
position_info = [];
figure;
for i = 1 : num_pos2D(1)
    for j = 1 : num_pos2D(2)
        for k = 1 : num_pos2D(3)
            for l = 1 : num_pos2D(4)
                match_2Dposition = [position_2D{1}(i,:) position_2D{2}(j,:) position_2D{3}(k,:) position_2D{4}(l,:)];
                [position3D, error] = Triangulation(camParaCalib, match_2Dposition) ;
                % reproject and see whether they are in a acceptable range
                pass = 1;
                for n = 1 : 4
                    pos2D_reproj = calibProj_Tsai(camParaCalib(n), position3D');
                    error_2D = norm(pos2D_reproj - match_2Dposition((n - 1) * 2 + 1 : (n - 1) * 2 + 2));
                    if error_2D > 500 || isnan(error_2D)
                        pass = 0;
                        break;
                    end
                end
                
                if pass
                    for n = 1 : 4
                        img = imread([num2str(n) '.tiff']);
                        subplot(2,2,n);
                        imshow(img);
                        hold on
                        pos2D_reproj = calibProj_Tsai(camParaCalib(n), position3D');
                        plot(pos2D_reproj(1), pos2D_reproj(2), 'r*');
                        plot(match_2Dposition((n - 1) * 2 + 1), match_2Dposition((n - 1) * 2 + 2), 'go');
                        hold off
                    end
                    position_info = [position_info; position3D' error match_2Dposition i j k l];
                end
            end
        end
    end
end
num_hydrogel = min(num_pos2D);
position_info = sortrows(position_info, 4);
pick_label = cell(1, 4);
for i = 1 : 4
    pick_label{i} = zeros(1, num_pos2D(i));
end
start = 1;
possible_position = zeros(num_hydrogel, 12);
i = 1;
while i <= num_hydrogel
    candidate = position_info(start, :);
    if pick_label{1}(candidate(13)) + pick_label{2}(candidate(14)) ...
            + pick_label{3}(candidate(15)) + pick_label{4}(candidate(16)) == 0 % if 2D positions are not picked
        possible_position(i, :) = candidate(1:12);
        pick_label{1}(candidate(13)) = 1;
        pick_label{2}(candidate(14)) = 1;
        pick_label{3}(candidate(15)) = 1;
        pick_label{4}(candidate(16)) = 1; % label the 2D positions are picked
        i = i + 1;
    end
    start = start + 1;
    if start > length(position_info) 
        break;
    end
end
plot3(position_info(:,1), position_info(:,2), position_info(:,3), 'b*');
hold on
plot3(possible_position(:,1), possible_position(:,2), possible_position(:,3), 'ro');
end

