function [K0, A, s_y0] = eqivalent_truss(mg, T0, Ry0, L, E0, g)
    % Takes in SDOF system with properties 
        % mg; Weight
        % T0; Natural period
        % Ry0;  Yeild Strength
        % L; Length
        % E0; Elastic stiffness
        % g ; Gravitational constant
    % Returns the structural parameter of equivalent Truss
        % K0; stiffness
        % A; Area
        % s_y0; Initial Yeilding stress
    K0 = 4*pi^2*mg/g/T0^2; % kip/in; stiffness
    A = K0*L/E0; % in^2
    s_y0 = Ry0/A; % ksi
end