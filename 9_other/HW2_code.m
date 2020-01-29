%% Part 1


trackID = 0; % select trackID
range = find(tracks(:,5)==trackID); % pick the entire trajectory

plot3(tracks(range,1),tracks(range,2),tracks(range,3),'ro');

xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
%% Part 2

subplot(3,1,1)
plot((1:length(range))./5000,tracks(range,1),'bo'); %% plot x position
xlabel('t (s)');
ylabel('X (mm)');

subplot(3,1,2)

plot((1:length(range)-1)./5000,diff(tracks(range,1)).*5000./1000,'bx'); %% plot x velocity
xlabel('t (s)');
ylabel('U (m/s)');


subplot(3,1,3)

plot((1:length(range)-2)./5000,diff(diff(tracks(range,1))).*5000.*5000./1000,'bx'); %% plot x velocity
xlabel('t (s)');
ylabel('a_x (m/s)');

%% part 3
% polynomial fit
track = tracks(range,1);
filter_length = 8;
for i = filter_length : length(range)
    p = polyfit([1:filter_length]',track(i - filter_length + 1 : i, 1),2);
    x(i) = polyval(p, filter_length);
end

subplot(3,1,1)
hold on
plot((filter_length:length(range))./5000, x(filter_length:end), 'r^');

subplot(3,1,2)
hold on
plot((filter_length:length(range)-1)./5000,diff(x(filter_length:end)).*5000./1000,'r^');

subplot(3,1,3)
hold on
plot((filter_length:length(range)-2)./5000,diff(diff(x(filter_length:end))).*5000.*5000./1000,'r^');

% Gaussin fit
 % position kernel
fitwidth = 4;
filterwidth = 6;
fitl = 1:fitwidth;
Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
rkernel = -fitwidth:fitwidth;
rkernel = Av.*exp(-rkernel.^2./filterwidth^2);
x_gf = conv(track(:,1),rkernel,'valid');

subplot(3,1,1)
hold on
plot((fitwidth + 1:length(range) - fitwidth )./5000, x_gf, 'go');

subplot(3,1,2)
hold on
plot((fitwidth + 1:length(range) - fitwidth - 1 )./5000,diff(x_gf).*5000./1000,'go');

subplot(3,1,3)
hold on
plot((fitwidth + 1:length(range) - fitwidth - 2 )./5000,diff(diff(x_gf)).*5000.*5000./1000,'go');

