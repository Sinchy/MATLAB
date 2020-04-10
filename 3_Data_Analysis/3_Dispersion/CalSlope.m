function slope = CalSlope(tn, Rn)
slope = (log(Rn(10:end)) - log(Rn(1:end-9))) ./ (log(tn(10:end)) - log(tn(1:end-9)))';
end

