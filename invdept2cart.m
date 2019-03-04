function [x,y,z] = invdept2cart(u,v,q)
%invdept2cart converts from inverse depth to cartesian coordinates

z = 1/q;
x = u*z;
y = v*z;
end

