function [predict, error] = LMSWienerPredictor(series, order)
%LMSWIENERPREDICTOR Summary of this function goes here
%   Detailed explanation goes here
dn = series(end); % the last element is used to be a reference of desired signal
un = series(end - order: end - 1); % un is used to predict the desired signal
h0 = 1 * ones(1, order); % the initial value of H
u = 1 / sum(un' * un); % step
%  u = .000001;
while (abs(dn - h0 *  un) > 1e-8)
    h0 = h0 + u * un' * (dn - h0 * un);
end
predict = h0 * series(end - order + 1: end);
error = -2 * un * dn + 2 * (un * un') * h0';
error = norm(error);
end

