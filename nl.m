function [m] = nl(C,node)
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
% node.s - scalar value representing the scale of the node's features
% 
% OUTPUTS
% 
% m - scalar measure of nonlinearity


%point p (same in inverse depth and cartesian coordinates)
p = [0 0 1]';

end

