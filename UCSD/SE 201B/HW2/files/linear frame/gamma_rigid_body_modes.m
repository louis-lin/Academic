function [grbm] = gamma_rigid_body_modes(L)
% function [grbm] = gamma_rigid_body_modes(L)
grbm=[0 1/L 1 0 -1/L 0; 0 1/L 0 0 -1/L 1; -1 0 0 1 0 0];  % Displ. transf. matrix from element local DOF's to basic DOF.
%
%
%