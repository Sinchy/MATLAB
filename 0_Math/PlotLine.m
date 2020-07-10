function PlotLine(xrange,yrange)

num = 100;
x = xrange(1):(xrange(2) - xrange(1)) / num:xrange(2);
y = yrange(1):(yrange(2) - yrange(1)) / num:yrange(2);
plot(x,y)
end

