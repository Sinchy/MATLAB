j = 1;
for i = 1:40
%     a = rni_vel_acc(tracks(1:10^5,:), i, i.*3, 5000);
    a = rni_vel_acc(tracks, i, i.*3, 5000);
    b(j) = std(a(:,11));
    j = j + 1;
end
%%

semilogx(1:40,b,'r.-');