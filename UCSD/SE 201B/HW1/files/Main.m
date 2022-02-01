% Material Tester for Menegotto-Pinto Uni-Axial Stress-Strain Constitutive
% Model
%
% UNITS:  kips, inches
%
clear all
close all
clc
%
%
MatData.E = 30000;
MatData.fy = 36.;
MatData.b = 0.02;
MatData.R0 = 20.;
MatData.cR1 = 18.5;
MatData.cR2 = 0.15;
MatData.a1 = 0.0;
MatData.a2 = 0.0;
%
%Initialize State
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
deps = 0.00004;

eps = [0.:deps:(500*deps), 499*deps:-deps:0., -deps:-deps:-500*deps, -499*deps:deps:0, ...
    deps:deps:(500*deps), 499*deps:-deps:0., -deps:-deps:-500*deps, -499*deps:deps:0,];

for n = 1:4001
    State.eps(1,1) = eps(n);
    if n == 1
        State.eps(1,2) = 0.;
    else
        State.eps(1,2) = eps(n)-eps(n-1);
    end
    State = Mate25n(MatData,State);
    strain(n) = State.eps(1,1);
    stress(n) = State.Pres.sig;
    State.Past = State.Pres;
end
%
plot(strain,stress)