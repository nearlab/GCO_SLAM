function [v_prime] = v_stateUpdate(x,z,X,K)
%v_stateUpdate is a vector valued function who's sum of squares is to be
%minimized in the state update

% INPUTS: 
% x - is a vector which is to be minimized. The first three
% correspond to camera position elements while the remaining correspond to
% updates in the locations of the visible features
% z - is an image measurement
% X - is the 3xN prior of the 3D structure. Where there are N points
% 
% OUTPUTS:
% 
% v-prime: augmented vector containing [v' dmu']' This is the vector to be
% minimized

%extract C and dmu from X
C = x(1:3);
dmu = x(4:end);

%find N
N = size(X,2);

%reshape dmu into the correct shape for structure
dX = reshape(dmu,3,N);

%generate predicted image
I_pred = imageGen(X+dX, C, eye(3), K);

%reshape predicted image
g = reshape(I_pred,2*N,1);

%calculate v
v = z - g;

v_prime = [v' dmu']';

end

