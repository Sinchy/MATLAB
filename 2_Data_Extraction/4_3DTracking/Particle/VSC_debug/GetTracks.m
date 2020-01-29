
tr_long = tracks; mat = particles;
tr_long(tr_long(:,15) == 1, :) = [];
[a,b,c] = intersect(tr_long(:,2:4),mat(:,2:4),'rows');
C = mat(c,:);