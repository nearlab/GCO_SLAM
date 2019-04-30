function [err] = edge_err(x, X_1, X_2)
%edge_err calculates the error in mapping a set of points from one frame to
%another. For use with the lsqnonlin function
%   INPUTS
%   x = [7x1] vector to be minimized. [s [angles for 123 rotation] T]
%   X_1 = Nx3 location estimate of N points in primary frame
%   X_2 = Nx3 location estimate of N points in secondary frame
% 
%   OUTPUTS:
%   err = 3Nx1 Vector containing the error in each spatial dimension for
%   each point

%extract translation information from x
s = x(1,1);
R = angle2dcm(x(2,1),x(3,1),x(4,1),'XYZ');
T = x(5:7,1);

%grab N
N = size(X_1,1);

%map points through from X_1 to X_2_est
X_2_est = zeros(N,3);
for ii = 1:N
    X_2_est(ii,:) = (s*(R*X_1(ii,:)' + T))';
end

%calculate position error
pos_err = X_2_est - X_2;

%reshape into a vector
err = reshape(pos_err,3*N,1);

end

