struct = read_gdf('vE3DstructOUT.gdf','double');
struct_strips = read_gdf('vE3DstructOUT.strips.gdf','double');
struct_UA = read_gdf('vE3DstructOUT.strips.gdf','double');

%%
e1_strips = zeros(50,1);
e2_strips = zeros(50,1);
e3_strips = zeros(50,1);
strip_size = 0;
strip_prev = 1;
figure
for i = 1:10
    strip_prev = strip_prev + strip_size + 1;
    strip_size = struct_strips(strip_prev,1);
    e1_strips(1:strip_size,i) = (struct_strips(strip_prev+1:strip_prev+strip_size,3)./(2)).^(3/2)./(struct_strips(strip_prev+1:strip_prev+strip_size,1));
    e2_strips(1:strip_size,i) = (struct_strips(strip_prev+1:strip_prev+strip_size,4)./(16/3)).^(3/2)./(struct_strips(strip_prev+1:strip_prev+strip_size,1));
    e3_strips(1:strip_size,i) = (struct_strips(strip_prev+1:strip_prev+strip_size,5)./(-4/5))./(struct_strips(strip_prev+1:strip_prev+strip_size,1));
    
    loglog(struct_strips(strip_prev+1:strip_prev+strip_size,1),e1_strips(1:strip_size,i)./1e6)
    hold all
%     loglog(struct_strips(strip_prev+1:strip_prev+strip_size,1),e2_strips(1:strip_size,i)./1e6)
end
        