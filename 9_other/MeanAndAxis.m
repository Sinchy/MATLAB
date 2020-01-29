%  figure
N = 6;
for n = 1 : 3
    xrange(1) = min(data(:,n));
    xrange(2) = max(data(:,n));
    
    delta_x = (xrange(2) - xrange(1)) / N;
    for i = 1 : N
        if i == 1 
            x(i) = xrange(1) + delta_x / 2;
        else
            x(i) = x(i-1) + delta_x;
        end
        y(i) = mean(data(data(:,n) > x(i) - delta_x / 2 & data(:,n) < x(i) + delta_x / 2, 4));
    end
    subplot(3,3,n);
    plot(x, y, 'b.-');
    hold on
    title(['u & x(' num2str(n) ')'])
end


for n = 1 : 3
    xrange(1) = min(data(:,n));
    xrange(2) = max(data(:,n));
% %     N = 5;
    delta_x = (xrange(2) - xrange(1)) / N;
    for i = 1 : N
        if i == 1 
            x(i) = xrange(1) + delta_x / 2;
        else
            x(i) = x(i-1) + delta_x;
        end
        y(i) = mean(data(data(:,n) > x(i) - delta_x / 2 & data(:,n) < x(i) + delta_x / 2, 5));
    end
    subplot(3,3,3 + n);
    plot(x, y,'b.-');
    hold on
    title(['v & x(' num2str(n) ')'])
end


for n = 1 : 3
    xrange(1) = min(data(:,n));
    xrange(2) = max(data(:,n));
%     N = 5;
    delta_x = (xrange(2) - xrange(1)) / N;
    for i = 1 : N
        if i == 1 
            x(i) = xrange(1) + delta_x / 2;
        else
            x(i) = x(i-1) + delta_x;
        end
        y(i) = mean(data(data(:,n) > x(i) - delta_x / 2 & data(:,n) < x(i) + delta_x / 2, 6));
    end
    subplot(3,3,6 + n);
    plot(x, y,'b.-');
    hold on
    title(['w & x(' num2str(n) ')'])
end

