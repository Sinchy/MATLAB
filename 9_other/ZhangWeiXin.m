color_max = [251,222,229];
color_min = [226,173,188];

for i = 1 : 1040
for j = 1:1388
if img2(i,j,1) > color_min(1) && img2(i,j,2) > color_min(2) && img2(i,j,3) > color_min(3) && img2(i,j,1) < color_max(1) && img2(i,j,2) < color_max(2) && img2(i,j,3) < color_max(3)
blob2(i,j) = 1;
end
end
end