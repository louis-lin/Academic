% Resolution of Linear (Geometric and Material) Frame in Lecture Notes using Direct Stiffness Method
% 
% UNITS: in, kips
%
% INITIALIZATIONS
clear all
close all
clc
format long e
% path(path,'C:\DATA\UCSD\Courses\Nonlinear Structural Analysis\Matlab\Linear-Frame-Analysis')
%
% STARTING DATA
ndofs=3;     % number of structure free degrees of freedom (size of U_sub f)
c=[1 0.8];   % elements' cosines
s=[0 0.6];  % elements' sines
L=[8*12 10*12];         % elements' lengths
E=29000*[1 1];       % elements' moduli of elasticity
A=[12.414 17.379];       % elements' cross section areas
I=[82.759 682.759];   % element sections' moment of inertia
%
% ELEMENTS "ID" ARRAYS
ID=[0 0 0 1 2 3; 0 0 0 1 2 3]';
%
element_connectivity = [[1,2];[2,3]];
nodal_coord = [[0,0],[100,,[

% ELEMENTS' STIFFNESS MATRICES Kele(6,6,2)
Kele = zeros(6,6,2);
Kele = all_frame_element_stiffnesses(c,s,L,E,A,I);
%
% STRUCTURE STIFFNESS MATRIX Kstr(3,3)
Kstr = zeros(ndofs,ndofs);
numele=size(ID,2);
for n=1:numele,
    for i=1:6,
        for j=1:6,
            if ((ID(i,n)~=0) && (ID(j,n)~=0))
                Kstr(ID(i,n),ID(j,n)) = Kstr(ID(i,n),ID(j,n)) + Kele(i,j,n);
            end
        end
    end
end    
%
% VECTOR OF EXTERNAL NODAL FORCES Pf
% Vertical Nodal Load at Node 2
%
Pf = [0 -100 0]';
%
% SOLVE EQUATIONS OF EQUILIBRIUM
Uf = Kstr\Pf
%
% ELEMENT DEFORMATIONS AND FORCES (ELEMENT STATE DETERMINATION)
delement=zeros(6,numele);    % initialize vectors of elements end DOF's in global coord. (delta)
dpelement=zeros(6,numele);  % initialize vector of elements end DOF's in local coord. (delta_prime)
Fele=zeros(6,numele);        % initialize vector of elements end forces in global coord. (F)
Fpele=zeros(6,numele);      % initialize vector of element end forces in local coord. (F_prime)
for n=1:numele,
    for k=1:6,
        if (ID(k,n)~=0)
            delement(k,n) = Uf(ID(k,n));   % element end DOF's in global coord.
        end
    end
    Fele(:,n) = Kele(:,:,n)*delement(:,n);    % Element end forces in global coord.
    grot=gamma_rotation(c(n),s(n));    % Displ. transf. matrix from element end DOF's
%                                        in global coord. to element local DOF's
    grbm=gamma_rigid_body_modes(L(n));    % Displ. transf. matrix from element local DOF's to basic DOF
    dpelement(:,n) = grot*delement(:,n);  % Element end DOF's in local coord.
    Kbpele = frame_stiffness_local(E(n),A(n),I(n),L(n));   % K_bar_prime
    Kpele = grbm'*Kbpele*grbm;
    Fpele(:,n) = Kpele*dpelement(:,n);
end
%
Fpele  % Print vector of element end forces in local DOF's
%
%
% SUPPORT REACTIONS (Pd)
Pd = zeros(6,1);      % initialize vector of support reactions = [P4,..., P9]'
AbdT=zeros(6,6,2);    % initialize equilibrium matrices betweem bar forces and support reactions (A_bd_Transposed)
AbdT(1,:,1) = [1 0 0 0 0 0];
%
AbdT(2,:,1) = [0 1 0 0 0 0];
%
AbdT(3,:,1) = [0 0 1 0 0 0];
%
AbdT(4,:,2) = [1 0 0 0 0 0];
%
AbdT(5,:,2) = [0 1 0 0 0 0];
%
AbdT(6,:,2) = [0 0 1 0 0 0];
%
for n=1:numele,
    Pd = Pd + AbdT(:,:,n)*Fele(:,n);
end
%
Pd   % Print vector of support reactions (Pd)

element_connectivity = 
G = graph(element_connectivity(:,1), element_connectivity(:,2));
figure(1);
set(gcf, 'position', [0 0 600 500]);
plot(G,'xdata', nodal_coord(:,1),'ydata',nodal_coord(:,2));
