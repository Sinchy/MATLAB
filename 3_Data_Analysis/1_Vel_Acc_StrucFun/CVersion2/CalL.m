function [statistics_struct]=CalL(data_map,redge_log)
% [statistics_struct, statistics_corr]=rni_findpairs(data_map,redge_log,redge_lin)
% or3d=[or3d,(1:length(or3d))',zeros(length(or3d),1)];
% r_pairs=zeros(length(or3d).*4,20); %need to modify for large data set

% [C,ia,ic]=unique(or3d(:,5));

% for i=1:length(ia)-1
% or3d(ia(i)+1:ia(i+1),13)=(ia(i+1)-ia(i)):-1:1;
% end
% or3d(1:ia(1),13)=1:(ia(1));

% eulrot=sortrows(eulrot,4);
% [frame_no, ia1, ~] = unique(data_map.Data.tracks(:,4),'first');
[frame_no, start_index, ic] = unique(data_map.Data.tracks(:,4),'first');
a_counts = accumarray(ic,1);
frame_info = [frame_no, start_index, a_counts];

% clear or3d; % free the memory
% eulrot(:, 9:end) = []; % delete rows that would not be used
    
% pointer=1;

count_log = zeros(length(redge_log)-1,1);
A= zeros(length(redge_log)-1,1);
A_D1 = zeros(length(redge_log)-1,1);
A_D2 = zeros(length(redge_log)-1,1);
B = zeros(length(redge_log)-1,1);
B_D1 = zeros(length(redge_log)-1,1);
B_D2 = zeros(length(redge_log)-1,1);
% count_lin = zeros(length(redge_lin)-1,1);
% RLL = zeros(length(redge_lin)-1,1);
% RNN= zeros(length(redge_lin)-1,1);


 addpath D:\0.Code\MATLAB\3_Data_Analysis\1_Vel_Acc_StrucFun\SoundZone_Tools-master/;
fprintf('\t Completion for calculating structure function: ');
showTimeToCompletion; startTime=tic;

% total_num = length(ia1)-1;
% percent = parfor_progress(total_num);
% h = parpool(16);
% parfor i=1:1:length(ia1)-1

% % randomize frame_no
%     num_frame = length(frame_no);
%     seq_frame = randperm(num_frame);
%     frame_no = frame_no(seq_frame);

% for i=1:1:length(frame_no)-1
percent = parfor_progress(length(frame_no));
  h = parpool(8);
parfor i=1:1:length(frame_no)
% for i=1:1:1
%     i
%     X=data_map.Data.eulrot(ia1(i):ia1(i+1)-1,1:3);
%     data = data_map.Data.tracks(data_map.Data.tracks(:,4) == frame_no(i), [1:3 12:14 9:11]);
%     data = data_map.Data.tracks(data_map.Data.tracks(:,4) == frame_no(i), [1:3 5:7]);
    data = data_map.Data.tracks(frame_info(i, 2) : frame_info(i, 2) + frame_info(i, 3) - 1, [1:3 5:7]);
    X = data(:, 1:3);
    
%     partID=eulrot(ia1(i):ia1(i+1)-1,5);
%     frm=eulrot(ia1(i):ia1(i+1)-1,4);
%     linenum=eulrot(ia1(i):ia1(i+1)-1,12);
    %trajremain=eulrot(ia1(i):ia1(i+1)-1,13);
    
%     u=data_map.Data.eulrot(ia1(i):ia1(i+1)-1,12:14);
 
    u = data(:, 4:6);
%     a = data(:, 7:9);
    data = [];
%     a=eulrot(ia1(i):ia1(i+1)-1,9:11);
    
    %% find pairs
    distd=pdist(X);
    tmp = uint8(ones(size(X,1))); % use uint8 to save memory
    tmp = tril(tmp,-1); %# creates a matrix that has 1's below the diagonal

    %# get the indices of the 1's
    [rowIdx,colIdx ] = find(tmp); 
    rowIdx = uint32(rowIdx); colIdx = uint32(colIdx);
    tmp = []; % free the memory
    
    
    
    %% get du, da, and dr
    % pairs: 
    % r,linenum_1,linenum_2,x_1,y_1,z_1,x_2,y_2,z_2,ux_1,uy_1,uz_1,ux_2,uy_2,uz_2,ax_1,ay_1,az_1,ax_2,ay_2,az_2,frame,pID_1,pID_2
    % where 1 and 2 are 1st and 2nd particles
%% the old version which takes a large memory  
%     pairs=[distd',linenum(rowIdx),linenum(colIdx),X(rowIdx,:),X(colIdx,:),u(rowIdx,:),u(colIdx,:),a(rowIdx,:),a(colIdx,:),frm(rowIdx),partID(rowIdx,:),partID(colIdx,:)];
%     dr = pairs(:,4:6)-pairs(:,7:9);
%     drl = dr./repmat(sqrt(sum(dr.^2,2)),[1 3]);
%     
%     % two point correlation fxn
%     u1 = pairs(:,10:12);
%     u1l = sum(u1.*drl,2);
%     u1n = sqrt(sum(u1.^2,2)-u1l.^2);
%     u2 = pairs(:,13:15);
%     u2l = sum(u2.*drl,2);
%     u2n = sqrt(sum(u2.^2,2)-u2l.^2);
%     
%     [bin_lin,c_lin]=histc(pairs(:,1),redge_lin);
%     hasdata = all(c_lin>0, 2);  
%     count_lin = count_lin+bin_lin(1:end-1);
%     
%     %RLL
%     RLL_tmp = accumarray(c_lin(hasdata,:), u1l(hasdata,:).*u2l(hasdata,:), [length(bin_lin)-1,1],@sum);
%     RLL = RLL+RLL_tmp;
%     
%     %RNN
%     RNN_tmp = accumarray(c_lin(hasdata,:), u1n(hasdata,:).*u2n(hasdata,:), [length(bin_lin)-1,1],@sum);
%     RNN = RNN+RNN_tmp;
%     
%     % structure function
%     du = pairs(:,10:12)-pairs(:,13:15);
%     dul = sum(du.*drl,2);
%     dun = sqrt(sum(du.^2,2)-dul.^2);
%     
%     [bin_log,c_log]=histc(pairs(:,1),redge_log);
%     hasdata = all(c_log>0, 2);
%     
%     count_log = count_log+bin_log(1:end-1);
%    
%     %DLL
%     DLL_tmp = accumarray(c_log(hasdata,:), dul(hasdata,:).^2, [length(bin_log)-1,1],@sum);
%     DLL = DLL+DLL_tmp;
% 
%     %DNN
%     DNN_tmp = accumarray(c_log(hasdata,:), dun(hasdata,:).^2, [length(bin_log)-1,1],@sum);
%     DNN = DNN+DNN_tmp;
% 
%     %DLLL
%     DLLL_tmp = accumarray(c_log(hasdata,:), dul(hasdata,:).^3, [length(bin_log)-1,1],@sum);
%     DLLL = DLLL+DLLL_tmp;
%     
    
%% new version to save memory

%     pairs=[distd',linenum(rowIdx),linenum(colIdx),X(rowIdx,:),X(colIdx,:),u(rowIdx,:),u(colIdx,:),a(rowIdx,:),a(colIdx,:),frm(rowIdx),partID(rowIdx,:),partID(colIdx,:)];
    dr = X(rowIdx,:) - X(colIdx,:);
    drl = dr./repmat(sqrt(sum(dr.^2,2)),[1 3]);
    dr = []; % free the memory
    
    % two point correlation fxn
%     u1l = sum(u(rowIdx,:) .* drl,2);
%     u1n = sqrt(sum(u(rowIdx,:) .^ 2, 2)-u1l .^ 2);
%     u2l = sum(u(colIdx,:) .* drl, 2);
%     u2n = sqrt(sum(u(colIdx,:).^2,2)-u2l.^2);
%     
%     [bin_lin,c_lin]=histc(distd',redge_lin);
%     hasdata = all(c_lin>0, 2);  
%     count_lin = count_lin + bin_lin(1:end-1);
%     
%     %RLL
%     RLL_tmp = accumarray(c_lin(hasdata,:), u1l(hasdata,:) .* u2l(hasdata,:), [length(bin_lin)-1,1],@sum);
%     RLL = RLL+RLL_tmp;
%     u1l = []; u2l = [];
%     
%     
%     
%     
%     %RNN
%     RNN_tmp = accumarray(c_lin(hasdata,:), u1n(hasdata,:) .* u2n(hasdata,:), [length(bin_lin)-1,1],@sum);
%     RNN = RNN+RNN_tmp;
%     u1n = []; u2n = []; bin_lin = []; c_lin = []; hasdata = [];
    
    % structure function
%     du = u(rowIdx,:) - u(colIdx,:);
%     dul = sum(du .* drl, 2);
%     drl = [];
%     dun = sqrt(sum(du .^ 2,2)-dul.^2);
%     du = [];
    
    % correlation function
    u1 = u(rowIdx, :);
    u2 = u(colIdx, :);
    u1l = sum(u1 .* drl, 2);
    u2l = sum(u2 .* drl, 2);
    a = u1l .* u2l;
    a_d1 = u1l .* u1l; a_d2 = u2l .* u2l;
    sign = cross(u1, drl);
    sign = sign(:,3);
    sign(sign > 0) =1; sign(sign < 0) = -1;
    u1n = sqrt(sum(u1 .^ 2, 2) - u1l.^2) .* sign;
    sign = cross(u2, drl);
    sign = sign(:,3);
    sign(sign > 0) =1; sign(sign < 0) = -1;
    u2n = sqrt(sum(u2 .^ 2, 2) - u2l.^2) .* sign;
    b = u1n .* u2n;
    b_d1 = u1n .* u1n; b_d2 = u2n .* u2n;
    
    
%     % a
%     da = (vecnorm(a(rowIdx,:) - a(colIdx,:),2,2)/1e3);
    
    [bin_log,c_log]=histc(distd',redge_log);
    hasdata = all(c_log>0, 2);
    
    count_log = count_log+bin_log(1:end-1);
%     for j = 1 : length(bin_log)
%         index = find(c_log == j,3000, 'first' );
%         if isempty(index) 
%             continue; 
%         end
%         count_log(j) = length(index);
%         DLL(j) = sum(dul(index,:).^2);
%         DNN(j) = sum(dun(index,:).^2);
%     end
%    
    %A
    A_tmp = accumarray(c_log(hasdata,:), a(hasdata,:), [length(bin_log)-1,1],@sum);
    A_d1_tmp = accumarray(c_log(hasdata,:), a_d1(hasdata,:), [length(bin_log)-1,1],@sum);
    A_d2_tmp = accumarray(c_log(hasdata,:), a_d2(hasdata,:), [length(bin_log)-1,1],@sum);
    A = A+A_tmp;
    A_D1 = A_D1 + A_d1_tmp;
    A_D2 = A_D2 + A_d2_tmp;
    
    %ALL
%     ALL_tmp = accumarray(c_log(hasdata,:), da(hasdata,:).^2, [length(bin_log)-1,1],@sum);
%     ALL = ALL + ALL_tmp;

%     %DNN
%     DNN_tmp = accumarray(c_log(hasdata,:), dun(hasdata,:).^2, [length(bin_log)-1,1],@sum);
%     DNN = DNN+DNN_tmp;
%     dun = [];

        %B
    B_tmp = accumarray(c_log(hasdata,:), b(hasdata,:), [length(bin_log)-1,1],@sum);
    B_d1_tmp = accumarray(c_log(hasdata,:), b_d1(hasdata,:), [length(bin_log)-1,1],@sum);
    B_d2_tmp = accumarray(c_log(hasdata,:), b_d2(hasdata,:), [length(bin_log)-1,1],@sum);
    B = B+B_tmp;
    B_D1 = B_D1 + B_d1_tmp;
    B_D2 = B_D2 + B_d2_tmp;
    
    
%     %DLLL
%     DLLL_tmp = accumarray(c_log(hasdata,:), dul(hasdata,:).^3, [length(bin_log)-1,1],@sum);
%     DLLL = DLLL+DLLL_tmp;
%     hasdata = []; dul = []; bin_log = []; c_log = [];
%      %loglog(redge(1:end-1)./1000,(DLL_tmp./bin(1:end-1)./2).^(3/2)./(redge(1:end-1)'./1000),'.');
%     %hold all;
%     
    
    %[meanu edge mid loc]= histcn(out(:,1),redge, 'AccumData', dul, 'Fun', @sum);
    
%     ind=find(out(:,1)<3&out(:,17)>10&out(:,18)>10);
%     else continue;
%     end;
%     if ~isempty(ind)
%         r_pairs(pointer:pointer+size(ind,1)-1,:)=out(ind,:);
%         pointer=pointer+size(ind,1);
%     end
    percent = parfor_progress;
    showTimeToCompletion( percent / 100, [], [], startTime );

end
delete(h);
f = A ./ count_log ./ (A_D1 ./ count_log .* A_D2 ./ count_log) .^.5;
g = B ./ count_log ./ (B_D1 ./ count_log .* B_D2 ./ count_log) .^.5;
% statistics_struct=[DLL,DNN,DLLL,ALL, count_log];
% statistics_corr=[RLL,RNN,count_lin];
statistics_struct=[f , g];

end
