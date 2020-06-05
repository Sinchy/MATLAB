function result = MeanWithConfidenceInterval(y)

% x = 1:100;                                          % Create Independent Variable
% y = randn(50,100);                                  % Create Dependent Variable ‘Experiments’ Data

N = length(y);                                      % Number of ‘Experiments’ In Data Set
yMean = mean(y);                                    % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(y)/sqrt(N);                              % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’

CI95 = tinv([0.025 0.975], N-1);                    % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));              % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’
yCI95 = yCI95';

result = [yMean, yCI95];
% figure
% plot(x, yMean)                                      % Plot Mean Of All Experiments
% hold on
% plot(x, yCI95+yMean)                                % Plot 95% Confidence Intervals Of All Experiments
% hold off
% grid
end

