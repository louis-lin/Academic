% Nonlinear SDOF System Subjected to Quasi-Static Monotonic Loading
%
% UNITS:  kips, inches
%
close all
clear all
clc
%
% Define Structure Parameters
%
L = 60.;
A = 0.2046;
% 
% Initialize Structure State
%
StructState.disp(1,1) = 0.; % Total displ.
StructState.disp(1,2) = 0.; % Total incremental displ. since last converged state
StructState.disp(1,3) = 0.; % Last Incremental displ.
%
% Define Material Model Constitutive Parameters
%
MatData.E = 30000;
MatData.fy = 39.;
MatData.b = 0.02;
MatData.R0 = 0.5;
MatData.cR1 = 0.;  % ==> so that R remains always equal to R0
MatData.cR2 = 0.15;
MatData.a1 = 0.0;
MatData.a2 = 0.0;
%
%Initialize Material State
%
Et   = MatData.E;
ey   = MatData.fy/Et;
sig  = 0;
State.Pres.sig   = sig;
State.Pres.Et    = Et;
State.Pres.epmin = -ey;
State.Pres.epmax = ey;
State.Pres.epex  = 0;
State.Pres.ep0   = ey;
State.Pres.s0    = MatData.fy;
State.Pres.epr   = 0;
State.Pres.sr    = 0;
State.Pres.kon   = 0;
State.sig  = 0;
State.Et   = Et;
%
% Initialize State.Past
%
State.Past = State.Pres;
%
% Initialize State.eps
%
State.eps(1,1) = 0.;
State.eps(1,2) = 0.;
State.eps(1,3) = 0.;
State.eps(1,4) = 0.;
%
%
% Loop Over Load Steps
%
U(1) = 0.;
Uiter(1) = 0.;
P(1) = 0;
Piter(1) = 0;
dP = 20./2;
for n = 1:10 % Loop over load steps
    disp(sprintf('\n%s%d\n','LOAD STEP # ',n))
    P(n+1) = n*dP;
    conv = 0;
    j = 1;
    % Max iteration is 20
    while ( j <= 20 & conv == 0) % Loop over Newton-Raphson iterations
        State = Mate25n(MatData,State);
        R = A*State.Pres.sig;
        if (j > 1)
            Uiter = [Uiter,StructState.disp(1,1)];
            Piter = [Piter,R];
        end
        Unb = P(n+1)-R;
        disp(sprintf('%s%d%s%e\n','ITERATION # ',j,',  UNBALANCED FORCE = ',abs(Unb)))
        if (abs(Unb) < 1.e-5)
            U(n+1) = StructState.disp(1,1);
            StructState.disp(1,2) = 0;
            StructState.disp(1,3) = 0;
            State.eps(1,2) = StructState.disp(1,2)/L;
            State.eps(1,3) = StructState.disp(1,3)/L;
            State.Past = State.Pres;
            conv = 1;
            disp(sprintf('%s%d%s\n','LOAD STEP # ',n,' IS CONVERGED'))
        else
            Ktan = A*State.Pres.Et/L;  % Tangent stiffness
%
            StructState.disp(1,3) = Unb/Ktan;
            StructState.disp(1,2) = StructState.disp(1,2) + StructState.disp(1,3);
            StructState.disp(1,1) = StructState.disp(1,1) + StructState.disp(1,3);
            Uiter = [Uiter,StructState.disp(1,1)];
            Piter = [Piter,P(n+1)];
%
            State.eps(1,1) = StructState.disp(1,1)/L;  % Total strain
            State.eps(1,2) = StructState.disp(1,2)/L;  % Total incremental strain from last converged state
            State.eps(1,3) = StructState.disp(1,3)/L;  % Last incremental strain
            j = j + 1;
        end
    end
end
%
%
%hold on
plot(U,P,'b-',U,P,'ro')
hold on
%plot(Uiter,Piter)
%plot(U,P,'b-')
%plot(U,P,'ro')
