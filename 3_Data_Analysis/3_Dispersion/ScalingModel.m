function [k, n] = ScalingModel(Re_struct)

if ~isstruct(Re_struct)
    Re = Re_struct;
    n_max = Re^(3/4);
    a = 2; 
    C2 = 2.1;
    b = 4;

    % adjust Re
     Re = (b / C2) ^ (1/2) * Re;

    C3 = 1;
    n_tr = (15 * C2)^(3/4);
    n1 = n_tr/20 : n_tr/20 : n_tr;
    n2 = n_tr: n_max/100 : n_max;

    k1 = log(15 * C2 * C3 * Re^(1/2).* n1.^(-2)/(a * b))./log((15 * C2 / b)^(-1/2) *  C3 * Re^(1/2));
    % k2 = 1 - log(a * b ^ (3/2))./(1/2 * log(b) + 1/2 * log( C3 * Re) - 2/3 * log(n2));
    k2 = 1 - log(a * b ^ (3/2))./log(b^(1/2) * Re^(1/2) * n2.^(-2/3));

    n = [n1, n2];
    k = [k1, k2];
else
%     a = 2;
%     b = 3;
%     struct = Re_struct.struct;
%     L = Re_struct.L;
%     ul_s = Re_struct.ul_s;
%     TL = Re_struct.TL;
%     len_kol = Re_struct.len_kol;
%     n_max = max(struct(:,1) / len_kol)/10;
%     n = n_max/100 : n_max/100 : n_max;
%     u0_s = interp1(struct(:,1) / len_kol, struct(:,2), n);
% %     ul_s = interp1(struct(:,1) / len_kol, struct(:,2), L/len_kol);
% %     ul_s = max(struct(:,2));
% %     ul_s = struct(end - 10,2);
% %     TL = struct(struct(:,2) == ul_s, 1) / ul_s ^ (1/2);
%     
%     TL = ul_s ^ (1/2) * TL / (ul_s / b) ^ (1/2);
%     ul_s = ul_s / b;
% %     L = interp1(struct(10:end,2), struct(10:end,1), ul_s);
%     t0 = (n * len_kol) ./ (u0_s) .^ (1/2);
% %     TL = L / ul_s ^ (1/2);
%     k = log(ul_s ./ (a * u0_s)) ./ log(TL ./ t0); 


    a = 2;
    b = 1.3;
    struct = Re_struct.struct;
%     L = Re_struct.L;
    ul_s = Re_struct.ul_s;
    TL = Re_struct.TL;
    len_kol = Re_struct.len_kol;
    n_max = max(struct(:,1) / len_kol)/5;
    n = n_max/100 : n_max/100 : n_max;
    u0_s = interp1(struct(:,1) / len_kol, struct(:,2), n);
    
%     TL = ul_s ^ (1/2) * TL / (ul_s / b) ^ (1/2);
    ul_s = ul_s / b;
    t0 = (n * len_kol) /1e3 ./ (u0_s) .^ (1/2);
    k = log(ul_s ./ (a * u0_s)) ./ log(TL ./ t0); 
end
% figure;
% plot(n, k+2);

end

