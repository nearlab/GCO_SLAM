function [R] = rotationMatrix(aHat,phi)
% rotationMatrix : Generates the rotation matrix R corresponding to a rotation
% through an angle phi about the axis defined by the unit
% vector aHat. This is a straightforward implementation of
% Euler�s formula for a rotation matrix.
%
% INPUTS
%
% aHat ------- 3-by-1 unit vector constituting the axis of rotation.
%
% phi -------- Angle of rotation, in radians.
%
%
% OUTPUTS
%
% R ---------- 3-by-3 rotation matrix
%
%+------------------------------------------------------------------------------+
% References: Lab Report 1 from Aerial Robotics, Eqn. 1
%
%
% Author: Corey Marcus
%+==============================================================================+

%create ax with cross product equivalent function
ax = crossProductEquivalent(aHat);

%calculate rotation matrix
R = cos(phi)*eye(3) + (1-cos(phi))*aHat*aHat' - sin(phi)*ax;