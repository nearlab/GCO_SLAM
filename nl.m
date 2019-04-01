function [m] = nl(C,node,K)
%nl evaluates the nonlinearity of a given node and camera pose
% INPUTS:
% 
% C - structure with following elements
% 
% C.R - 3x3 dcm mapping from the inertial frame to the camera frame
% 
% C.pos - 3x1 position vector of the camera within the inertial frame
% 
% node - structure with the following elements
% 
% node.R - 3x3 dcm mapping from the inertial frame to the node frame
% 
% node.X - 3xN array containing inverse depth coordinates of each element
% within the node
% 
% node.T - 3x1 position vector of the node origin in the inertial frame
% 
% K - Camera Calibration Matrix
% 
% 
% OUTPUTS
% 
% m - scalar measure of nonlinearity

%map node into camera
R_CN = C.R*node.R';

%pos of camera in node
pos_C = C.pos - node.T;

%create t (vector from camera to node center in camera frame)
t = -R_CN*pos_C;

%Create A matrix
A = K*[R_CN t]

%initialize partial matrix
P = zeros(2,3);

%calculate all the partials
for i = 1:2
    for j = 1:3
        P(i,j) = 2*A(3,j)^2/(A(3,3)+A(3,4))^2 - 2*A(i,j)*A(3,j)/(A(3,3)+A(3,4))^2;
    end
end

P

%calculate the nonlin heuristic
m = sum(P,2)

m = norm(m,2)

end

