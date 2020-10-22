function gradu=gradufit_rni(np, pts)
% least square fit of velocity gradient tensor

A(1:3:3*np,1) = pts(:,1);
A(1:3:3*np,2) = pts(:,2);
A(1:3:3*np,3) = pts(:,3);


A(2:3:3*np+1,4) = pts(:,1);
A(2:3:3*np+1,5) = pts(:,2);
A(2:3:3*np+1,6) = pts(:,3);

A(3:3:3*np+2,7) = pts(:,1);
A(3:3:3*np+2,8) = pts(:,2);
A(3:3:3*np+2,9) = pts(:,3);

b(1:3:3*np) = pts(:,6);
b(2:3:3*np+1) = pts(:,7);
b(3:3:3*np+2) = pts(:,8);

gradu = A\b';

end