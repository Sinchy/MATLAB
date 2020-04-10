function [Lvel, Lvel_fluct_std] = PlotLVelPDF(data_map, pairs, t)
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

num_pair = size(pairs, 1);
num_t = length(t);
Lvel = zeros(num_pair, num_t);
pool = parpool(11);
parfor i = 1 : num_t
    t_f = round(t(i) * 4000); %switch time into frame
    for j = 1 : num_pair
        track1 = tracks(tracks(:,5) == pairs(j, 1), :);
        track2 = tracks(tracks(:,5) == pairs(j, 2), :);
        track1 = track1(track1(:,4) >= pairs(j, 3), :);
        track2 = track2(track2(:,4) >= pairs(j, 3), :);
        len1 = size(track1, 1);
        len2 = size(track2, 1);
        len = min(len1, len2);
        if len < t_f 
            continue;
        end
        dr = track1(t_f, 1:3) - track2(t_f, 1:3);
        dr = dr / norm(dr);
                vel = track1(t_f, 6:8) - track2(t_f, 6:8);
        Lvel(j, i) = dot(vel, dr);
%         Lvel(j, i) = dot(track1(i, 6:8), dr) * dot(track2(i, 6:8), dr);
    end
end
delete(pool);
Lvel_fluct_std = zeros(num_pair, num_t);
% Create figure
figure1 = figure;
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

set(gca, 'YScale', 'log');
% create a default color map ranging from red to blue
red = [1, 0, 0];
pink = [0.00,0.00,1.00];
colors_p = [linspace(red(1),pink(1),num_t)', linspace(red(2),pink(2),num_t)', linspace(red(3),pink(3),num_t)'];

linewidth = [3:-4/(num_t-2):1 1:4/(num_t-2):3];

hold on
for i = 1 : num_t
   Lvel_mean = mean(nonzeros(Lvel(:, i))); 
   Lvel_fluct = Lvel(:, i) - Lvel_mean;
   Lvel_var = mean(Lvel_fluct.^2) ^ .5;
   Lvel_fluct_std(:, i) = Lvel_fluct / Lvel_var;
   [cn, cr] = hist(Lvel_fluct_std(:, i), -8:.2:8);
   cn = cn / sum(cn);
   plot(cr, cn, 'Color', colors_p(i,:), 'LineWidth',  linewidth(i));
end

% Create ylabel
ylabel({'PDF'},'Interpreter','latex');

% Create xlabel
xlabel({'$(V^\parallel(t) - \langle V^\parallel(t) \rangle)/\langle (V^\parallel(t) - \langle V^\parallel(t) \rangle) ^2 \rangle ^{1/2} $'},...
    'FontSize',20,...
    'Interpreter','latex');

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',20,'LineWidth',2,'MinorGridAlpha',0.1,'YGrid','on',...
    'YMinorTick','on','YScale','log');

end

