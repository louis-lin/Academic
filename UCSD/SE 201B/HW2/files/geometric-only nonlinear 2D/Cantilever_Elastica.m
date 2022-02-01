%  Cantilever Beam Subjected to Horizontal Compressive Load - Linear Elastic Material - Nonlinear Geometry (Corotational "Exact")
%  Length = 1000 mm; Cross-section dimensions: 25 mm x 5 mm (Bending around weak axis)
%  Euler Buckling Load (pi^2EI/(2L)^2) = 127.5 N
%  Tip load of 15[N] produces tip (vertical) deflection of 96 mm in linear elastic
%  analysis
%  Initial imperfection:  10*(1-cos(2*pi/(4*L0)*x) ==> 10 mm of imperfection
%  at the tip of the cantilever
%  
% UNITS: mm, N
%
% INITIALIZATIONS
clear all
close all
clc
format long e
% cd('G:\UCSD\Courses\SE201B Nonlinear Structural Analysis\Matlab\Cantilever_Beam_Nonlinear_Geometry')
% GLOBAL VARIABLES
% global Pe Qe
%
% STARTING DATA
numele=10     % number of elements
nnodes=10;    % number of free nodes
ndofs=30;     % number of structure free degrees of freedom (size of U_sub f)
c0=[9.999992421160751e-001 9.999932906147666e-001 9.999819704798469e-001 ...
    9.999663902795007e-001 9.999480755867365e-001 9.999288194644362e-001 ...
    9.999105068359198e-001 9.998949299755967e-001 9.998836131807003e-001 ...
    9.998776637436397e-001];   % initial elements' cosines
s0=[1.231165007405348e-003 3.663157852296321e-003 6.004890943424276e-003 ...
    8.198677416823961e-003 1.019049215603746e-002 1.193130355237436e-002 ...
    1.337827788371830e-002 1.449582729948530e-002 1.525647707394465e-002 ...
    1.564153274334120e-002];   % initial elements' sines
L0=[1.000000757884499e+002 1.000006709430249e+002 1.000018029845222e+002 ...
    1.000033610850150e+002 1.000051927109548e+002 1.000071185602593e+002 ...
    1.000089501173823e+002 1.000105081065273e+002 1.000116400366768e+002 ...
    1.000122351224351e+002];                    % Initial elements' lengths (L0)
E=2.e5*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];         % elements' moduli of elasticity
A=(25*5)*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];       % elements' cross section areas
I=(25*5^3/12)*[1. 1. 1. 1. 1. 1. 1. 1. 1. 1.];  % element sections' moment of inertia
nloadsteps = 200;
%
% ELEMENTS "ID" ARRAYS
ID=[0 0 0 1 2 3; 1 2 3 4 5 6; 4 5 6 7 8 9; 7 8 9 10 11 12; 10 11 12 13 14 15;...
    13 14 15 16 17 18; 16 17 18 19 20 21; 19 20 21 22 23 24; 22 23 24 25 26 27; ...
    25 26 27 28 29 30]';
U = zeros(ndofs,nloadsteps+1,3);    
%displ. vector (total displ., total incremental displ., last incremental displ.)
Pe = zeros(6,nloadsteps+1,numele);   % Element end forces in global coordinates
Pr = zeros(ndofs,1);   % Initialization of structure resisting force vector
Qe = zeros(3,nloadsteps+1,numele);   % Element end forces in basic coordinates
%
% LOOP OVER LOAD STEPS
for nload = 1:nloadsteps
   %
   % VECTOR OF EXTERNAL NODAL FORCES Pf
   Pf = zeros(30,1);
   Pf(28)=-1.0*nload;
   Punb = Pf - Pr;
   itn = 0;
   %
   % LOOP OVER NEWTON-RAPHSON ITERATIONS FOR A GIVEN LOAD STEP
   %
   % CONVERGENCE CHECK
   while norm(Punb,2) > 1e-4,
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
      % SOLVE INCREMENTAL LINEARIZED EQUILIBRIUM EQUATIONS
      U(:,nload+1,3) = Kstr\Punb;
      U(:,nload+1,2) = U(:,nload+1,2) + U(:,nload+1,3);   %Update total incremental displ.
      U(:,nload+1,1) = U(:,nload,1) + U(:,nload+1,2);     %Update total/current displ.
      %
   end
   U(:,nload+2,1) = U(:,nload+1,1);    %Initialize total/current displ. vector for next load step
end
%
%