function ReynoldStressProfile(velacc)
 direction = 'xyz';
 uv = velacc(:, 12) .* velacc(:,13);
 uw = velacc(:,12) .* velacc(:, 14);
 vw = velacc(:, 13) .* velacc(:,14);
 uu = vecnorm(velacc(:, 12:14),2,2);
 uv = uv ./uu.^2;
 uw = uw ./ uu.^2;
 vw = vw ./ uu.^2;
 figure;
 marker = {'bo-', 'rs-', 'k^-'};
for dir1 = 1:3
    max_l = max(velacc(:, dir1));
    min_l = min(velacc(:, dir1));
    dl = (max_l - min_l) / 10;
    [~, uxy, uidx] = histcounts(velacc(:,dir1), min_l : dl : max_l);
    uxy = (uxy(1:end - 1) + uxy(2:end)) / 2;
    avgv1 = accumarray(uidx, uv, [], @nanmean);
    ci1 = accumarray(uidx, uv, [], @FitNormal);
    
        avgv2 = accumarray(uidx, uw, [], @nanmean);
    ci2 = accumarray(uidx, uw, [], @FitNormal);
    
        avgv3 = accumarray(uidx, vw, [], @nanmean);
    ci3 = accumarray(uidx, vw, [], @FitNormal);
% stdv1  = accumarray(uidx, uv, [], @nanstd);

mean_map = [uxy', avgv1, avgv2, avgv3];
std(avgv2)

% time = accumarray(uidx, velacc(:,4), [], @(x) {x});
% u1 = accumarray(uidx, uv, [], @(x) {x});
% stdv1 = TemporalSTD(time, u1) * 2;
std_map = [uxy', ci1, ci2, ci3];

subplot(3, 1, dir1);
errorbar(mean_map(:,1),mean_map(:,2),std_map(:,2),marker{1},'LineWidth',2.0,'MarkerSize',6.0, 'DisplayName', '$\langle uv \rangle/ k^2$');
hold on
errorbar(mean_map(:,1),mean_map(:,3),std_map(:,3),marker{2},'LineWidth',2.0,'MarkerSize',6.0, 'DisplayName', '$\langle uw \rangle/ k^2$');
errorbar(mean_map(:,1),mean_map(:,4),std_map(:,4),marker{3},'LineWidth',2.0,'MarkerSize',6.0, 'DisplayName', '$\langle vw \rangle/ k^2$');

ylim([-.2, .2])
end
subplot1 = subplot(3,1, 1);
xlabel('$x$ (mm)', 'Interpreter', 'latex');
ylabel('$\langle \cdot \rangle/ k^2$', 'Interpreter', 'latex');
box(subplot1,'on');
% Create legend
 legend(subplot1,'show',  'Interpreter', 'latex', 'Orientation', 'horizontal','AutoUpdate', 'off');
l = xlim;
plot(l, [0.1, 0.1], 'k--');
plot(l, [-0.1, -0.1], 'k--');
hold(subplot1,'off');
% Set the remaining axes properties
set(subplot1,'FontSize',15,'LineWidth',2);


 subplot2 = subplot(3,1, 2);
xlabel('$y$ (mm)', 'Interpreter', 'latex');
ylabel('$\langle \cdot \rangle/ k^2$', 'Interpreter', 'latex');
box(subplot2,'on');
l = xlim;
plot(l, [0.1, 0.1], 'k--');
plot(l, [-0.1, -0.1], 'k--');
hold(subplot2,'off');
% Set the remaining axes properties
set(subplot2,'FontSize',15,'LineWidth',2);

 subplot3 = subplot(3,1, 3);
xlabel('$z$ (mm)', 'Interpreter', 'latex');
ylabel('$\langle \cdot \rangle/ k^2$', 'Interpreter', 'latex');
box(subplot3,'on');
l = xlim;
plot(l, [0.1, 0.1], 'k--');
plot(l, [-0.1, -0.1], 'k--');
hold(subplot3,'off');
% Set the remaining axes properties
set(subplot3,'FontSize',15,'LineWidth',2);
end

function fitpara = FitNormal(x)
pd = fitdist(x, 'Normal');
ci =  paramci(pd);
fitpara = (ci(2, 1) - ci(1, 1))/2;
end

function stdv = TemporalSTD(time, u)
% u = [time, velocity]
num_bin = length(time);
stdv = zeros(num_bin, 1);
for i = 1 : num_bin
    max_l = max(time{i});
    min_l = min(time{i});
    dl = (max_l - min_l) / 10;
    [~, ~, uidx] = histcounts(time{i}, min_l : dl : max_l);
    argv = accumarray(uidx, u{i}, [], @nanmean).^.5;
    stdv(i) = std(argv);
end
end
