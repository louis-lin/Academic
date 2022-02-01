function [grot] = gamma_rotation(c,s)
% function [grot] = gamma_rotation(c,s)
grot=[c s 0 0 0 0; -s c 0 0 0 0; 0 0 1 0 0 0; 0 0 0 c s 0; 0 0 0 -s c 0; 0 0 0 0 0 1];    % Displ. transf. matrix from element end DOF's
%                                                 in global coord. to element local DOF's.
%
%
%