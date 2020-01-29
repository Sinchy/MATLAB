function intercept = CalculateInterceptWithTwoPoint(point1, point2)
intercept = -(point2(2) - point1(2)) / (point2(1) - point1(1)) * point1(1) + point1(2);
end

