%  Horizontal Cantilever Beam Subjected to Vertical Tip Force - Linear Elastic Material - Nonlinear Geometry (Corotational "Exact")
%  Length = 1000 mm; Cross-section dimensions: 25 mm x 5 mm (Bending around weak axis)
%  Tip load of 15[N] produces tip (vertical) deflection of 96 mm in linear elastic
%  analysis
%  
% UNITS: mm, N
%
% INITIALIZATIONS
clear all
close all
clc
format long e
% path(path,'C:\DATA\UCSD\Courses\Nonlinear Structural Analysis\Matlab\Cantilever_Beam_Nonlinear_Geometry')
%
% GLOBAL VARIABLES
% global Pe Qe     % Not needed since Pe and Qe are in the argument list of function all_frame_element_stiffnesses
%
% STARTING DATA
numele=10     % number of elements
nnodes=10;    % number of free nodes
ndofs=30;     % number of structure free degrees of freedom (size of U_sub f)
c0=[1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0];   % initial elements' cosines
s0=[0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0];   % initial elements' sines
L0=100*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];         % Initial elements' lengths (L0)
E=2.e5*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];         % elements' moduli of elasticity (steel)
A=(25*5)*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];       % elements' cross section areas
I=(25*5^3/12)*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];  % element sections' moment of inertia
nloadsteps = 40;
%
% ELEMENTS "ID" ARRAYS
ID=[0 0 0 1 2 3; 1 2 3 4 5 6; 4 5 6 7 8 9; 7 8 9 10 11 12; 10 11 12 13 14 15;...
    13 14 15 16 17 18; 16 17 18 19 20 21; 19 20 21 22 23 24; 22 23 24 25 26 27; ...
    25 26 27 28 29 30]';
% displ. vector (total displ., total incremental displ., last incremental displ.)
U = zeros(ndofs,nloadsteps+1,3);    
Pe = zeros(6,nloadsteps+1,numele);   % Element end forces in global coordinates
Pr = zeros(ndofs,1);   % Initialization of structure resisting force vector
Qe = zeros(3,nloadsteps+1,numele);   % Element end forces in basic coordinates
%
% LOOP OVER LOAD STEPS
for nload = 1:nloadsteps
   disp(sprintf('\n%s%d\n','LOAD STEP # ',nload))
%
% VECTOR OF EXTERNAL NODAL FORCES Pf
   Pf = zeros(30,1);
   Pf(29)=-2.0*nload;
   Punb = Pf - Pr;
   itn = 0;
%
% LOOP OVER NEWTON-RAPHSON ITERATIONS FOR A GIVEN LOAD STEP
%
% CONVERGENCE CHECK
   while norm(Punb,2) > 1e-2,
      itn = itn + 1;
      % ELEMENTS' TANGENT STIFFNESS MATRICES in  Global Coordinates: Kele(6,6,10)
      Kele = zeros(6,6,numele);
      [Kele,Pe,Qe] = all_frame_element_stiffnesses(c0,s0,L0,E,A,I,U,ID,nload);
      %
      % STRUCTURE TANGENT STIFFNESS MATRIX Kstr(ndofs,ndofs)
      Kstr = zeros(ndofs,ndofs);
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
      % STRUCTURE RESISTING FORCE VECTOR Pr(ndofs,1)
      Pr = zeros(ndofs,1);
      for n=1:numele,
          for i=1:6,
              if ((ID(i,n)~=0))
                   Pr(ID(i,n),1) = Pr(ID(i,n),1) + Pe(i,nload+1,n);
              end
          end
      end
      %
      % UNBALANCED NODAL FORCES IN GLOBAL COORDINATES: Punb(ndofs,1) = Pf - Pr
      Punb = Pf - Pr;
      %
      disp(sprintf('%s%d%s%e\n','ITERATION # ',itn,',  NORM OF UNBALANCED FORCE = ',norm(Punb,2)))
      %
      % SOLVE INCREMENTAL LINEARIZED EQUILIBRIUM EQUATIONS
      U(:,nload+1,3) = Kstr\Punb;
      U(:,nload+1,2) = U(:,nload+1,2) + U(:,nload+1,3);   %Update total incremental displ.
      U(:,nload+1,1) = U(:,nload,1) + U(:,nload+1,2);     %Update total/current displ.
      %
   end
   disp(sprintf('%s%d%s\n','LOAD STEP # ',nload,' IS CONVERGED'))
   U(:,nload+2,1) = U(:,nload+1,1);    %Initialize total/current displ. vector for next load step
end
%
%