
%% loads the output from triangulation C code in a framewise manner
% figure
data  = zeros(1,12);
for frame = 1:200
%     a = load(['posframe' num2str(frame) '.mat'], ['pos3Dframe' num2str(frame)]);
    a = load(['cleanlistTrIDframe' num2str(frame) '.mat'], ['pos3Dframe' num2str(frame)]);
    eval(['b = a.pos3Dframe' num2str(frame) ';']);
    eval(['frame' num2str(frame) '= cell2mat(b);']);
%     figure(2)
%     hold on;plot3(b(:,1),b(:,2),b(:,3),'r.')
%     figure(3)
%     hold on;plot(b(:,4),b(:,5),'r.')
    
%     data = [data;b];

end

data(1,:) = [];