function [y_p] = WienerPredictor(series, order)
%R = autocorr(y)
r = autocorrelation(series);
for i = 1 : order
    for j = 1 : order
        R(i,j) = r(abs(i - j) + 1);
    end
end

H = R \ r(1: order + 1);
y_p = H' * flip(series(end - order + 1:end))';
end

function autocorr = autocorrelation(x)
    len = length(x);
    autocorr = zeros(len,1);
    for i = 1 :  len
        autocorr(i) = correlation(x, i - 1);
    end
end
% 
% function corr = correlation(x, lag)
%     len = length(x);
%     avg_x = mean(x);
%     if lag < len
%         num = 0;
%         denum = 0;
%         for i = 1 : len - lag
%             num = num + (x(i) - avg_x) * (x(i + lag) - avg_x);
%         end
%         for i = 1 : len
%             denum = denum + (x(i) - avg_x) ^ 2;
%         end
%         corr = num / denum;
%     else
%         corr = 0;
%     end
% end


function corr = correlation(x, lag)
    len = length(x);
    if lag < len
        num = 0;
        for i = 1 : len - lag
            num = num + x(i) * x(i + lag);
        end
        corr = num / (len - lag);
    else
        corr = 0;
    end
end


