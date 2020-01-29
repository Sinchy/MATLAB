figure
for n = 1 : 3
    xrange(1) = min(data(:,n));
    xrange(2) = max(data(:,n));
    N = 100;
    delta_x = (xrange(2) - xrange(1)) / N;
    for i = 1 : N
        if i == 1 
            x(i) = xrange(1) + delta_x / 2;
        else
            x(i) = x(i-1) + delta_x;
        end
        y(i) = mean(data(data(:,n) > x(i) - delta_x / 2 & data(:,n) < x(i) + delta_x / 2, 12));
    end
    subplot(3,3,n);
    plot(x, y);
    title(['ufluc & x(' num2str(n) ')'])
end


for n = 1 : 3
    xrange(1) = min(data(:,n));
    xrange(2) = max(data(:,n));
    N = 100;
    delta_x = (xrange(2) - xrange(1)) / N;
    for i = 1 : N
        if i == 1 
            x(i) = xrange(1) + delta_x / 2;
        else
            x(i) = x(i-1) + delta_x;
        end
        y(i) = mean(data(data(:,n) > x(i) - delta_x / 2 & data(:,n) < x(i) + delta_x / 2, 13));
    end
    subplot(3,3,3 + n);
    plot(x, y);
    title(['vfluc & x(' num2str(n) ')'])
end


for n = 1 : 3
    xrange(1) = min(data(:,n));
    xrange(2) = max(data(:,n));
    N = 100;
    delta_x = (xrange(2) - xrange(1)) / N;
    for i = 1 : N
        if i == 1 
            x(i) = xrange(1) + delta_x / 2;
        else
            x(i) = x(i-1) + delta_x;
        end
        y(i) = mean(data(data(:,n) > x(i) - delta_x / 2 & data(:,n) < x(i) + delta_x / 2, 14));
    end
    subplot(3,3,6 + n);
    plot(x, y);
    title(['wfluc & x(' num2str(n) ')'])
end

