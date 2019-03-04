function [u,v,q] = cart2invdept(x,y,z)
%cart2invdept converts from cartesian to inverse depth coordinates

u = x/z;
v = y/z;
q = 1/z;

end

