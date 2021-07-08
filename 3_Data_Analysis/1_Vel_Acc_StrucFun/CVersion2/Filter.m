function x1 = Filter(x, rkernel)
 x1 = conv(x,rkernel,'valid');
end

