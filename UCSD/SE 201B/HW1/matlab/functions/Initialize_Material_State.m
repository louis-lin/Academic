function MatState = Initialize_Material_State(sig, Et, fy, epmin, epmax, epex, ep0, epr, sr, kon, initial_strains)
    % Inputs
        % sig,; Modulus of Elasticity
        % Et; Yeild Stress
        % fy;Menegotto-Pinto Model parameters
        % epmin; minimum yield strain
        % epmax; maxmimum yield strain 
        % ep0; Initial strain
        % epr; Max reversal starin
        % sr; Max reversal stress
        % kon; Initial branch
        % initial_strains; initial strains of the system stored as MatState.eps
    % Returns the structural parameter of equivalent Truss
        % MatState; Structure with all of the above information
    MatState.Pres.sig   = sig;
    MatState.Pres.Et    = Et;
    MatState.Pres.s0    = fy;
    MatState.Pres.epmin = epmin;
    MatState.Pres.epmax = epmax;
    MatState.Pres.epex  = epex;
    MatState.Pres.ep0   = ep0;

    MatState.Pres.epr   = epr;
    MatState.Pres.sr    = sr;
    MatState.Pres.kon   = kon;
    
    MatState.sig  = 0;
    MatState.Et   = Et;
    MatState.Past = MatState.Pres;
    for i = 1:length(initial_strains)
        MatState.eps(1,i) = initial_strains(i);
    end
    
end
