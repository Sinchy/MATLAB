plot((1:length(range)-2)./5000,diff(diff(tracks(range,1))).*5000.*5000./1000,'b.'); %% plot x velocity %% plot x velocity
xlabel('t (s)');
ylabel('U (m/s)');

track = tracks(range,1);
filter_length = 8;
for i = filter_length : length(range)
    p = polyfit([1:filter_length]',track(i - filter_length + 1 : i, 1),2);
    x(i) = polyval(p, filter_length);
end

hold on
plot((filter_length:length(range)-2)./5000,diff(diff(x(filter_length:end))).*5000.*5000./1000,'rx');

track = tracks(range,1);
filter_length = 16;
for i = filter_length : length(range)
    p = polyfit([1:filter_length]',track(i - filter_length + 1 : i, 1),2);
    x(i) = polyval(p, filter_length);
end

plot((filter_length:length(range)-2)./5000,diff(diff(x(filter_length:end))).*5000.*5000./1000,'r.-');

fitwidth = 4;
filterwidth = 6;
fitl = 1:fitwidth;
Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
rkernel = -fitwidth:fitwidth;
rkernel = Av.*exp(-rkernel.^2./filterwidth^2);
x_gf = conv(track(:,1),rkernel,'valid');

plot((fitwidth + 1:length(range) - fitwidth - 2 )./5000,diff(diff(x_gf)).*5000.*5000./1000,'gx');

fitwidth = 4;
filterwidth = 8;
fitl = 1:fitwidth;
Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
rkernel = -fitwidth:fitwidth;
rkernel = Av.*exp(-rkernel.^2./filterwidth^2);
x_gf = conv(track(:,1),rkernel,'valid');

plot((fitwidth + 1:length(range) - fitwidth - 2 )./5000,diff(diff(x_gf)).*5000.*5000./1000,'g.-');
