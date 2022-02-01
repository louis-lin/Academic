function [Kele] = frame_stiffness(E,A,I,L,c,s)
% function [Kele] = frame_stiffness(E,A,I,L,c,s)
grbm=gamma_rigid_body_modes(L);  % Displ. transf. matrix from element local DOF's to basic DOF's.
grot=gamma_rotation(c,s);    % Displ. transf. matrix from element end DOF's
%                                                 in global coord. to element local DOF's.
% Frame element stiffness in basic deformation
Kele = frame_stiffness_local(E,A,I,L);
% Frame element stiffness in local DOF's
Kele = grbm'*Kele*grbm;
% Frame element stiffness in global DOF's
Kele = grot'*Kele*grot;
