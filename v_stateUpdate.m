function [v_prime] = v_stateUpdate(x,z,X,K,weight)
%v_stateUpdate is a vector valued function who's sum of squares is to be
%minimized in the state update

% INPUTS: 
% x - is a vector which is to be minimized. The first three
% correspond to camera position elements while the remaining correspond to
% updates in the locations of the visible features
% z - is an image measurement
% X - is the 3xN prior of the 3D structure in inverse depth coordinates. 
% Where there are N points
% weight - is an weighting which effects the weight of each element of
% v_prime. It is a crude implementation of Q which does not allow for 
% corellations
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

%create new X
X = X + dX;

%convert X to cartesian coordinates
for ii = 1:N
    [X(1,ii), X(2,ii), X(3,ii)] = invdept2cart(X(1,ii),X(2,ii),X(3,ii));
end

%generate predicted image
I_pred = imageGen(X, C, eye(3), K);

%reshape predicted image
g = reshape(I_pred,2*N,1);

%calculate v
v = z - g;

v_prime = weight'.*[v' dmu']';

end

