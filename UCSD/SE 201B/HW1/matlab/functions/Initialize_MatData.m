function MatData = Initialize_MatData(E0, s_y0, b, R0, cR1, cR2, a1, a2, L, A)
    % Inputs
        % E0,; Modulus of Elasticity
        % s_y0; Yeild Stress
        % b, R0, cR1, cR2, a1, a2, ;Menegotto-Pinto Model parameters
        % L; length 
        % A; Area
    % Returns the structural parameter of equivalent Truss
        % MatData; Structure with all of the above information
    MatData.E = E0;
    MatData.fy = s_y0;
    MatData.b = b;
    MatData.R0 = R0;
    MatData.cR1 = cR1;  
    MatData.cR2 = cR2;
    MatData.a1 = a1;
    MatData.a2 = a2;
    MatData.L = L;
    MatData.A = A;
    MatData.ey = MatData.fy/MatData.E;
end