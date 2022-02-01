function [fc_con]= Mander_confined_concrete_split(strain, Concrete)
    % Return stress in confined concrete
    %% Input
    % Concrete data structure
        % fcc is the confine concrete compressive strength
        % ecc is the compressive strain at fcc
        % r_cc is the power term for the curve
        % lambda_c is the softening branch normalization factor
    % strain is the current strain in the concrete fiber
    %% Output
    % fc is the stress in the confined concrete fiber
    %%
    fcc = Concrete.fcc;
    ecc = Concrete.ecc;
    r_cc = Concrete.r_cc;
    i = 1;
    fc_con = zeros(1,numel(strain));
    for es = strain
        if 0 <= es && es <= Concrete.et % Elastic Tension
            fc_con(i) = Concrete.Ec *es; 
        elseif es >= Concrete.et % Post Tensile cracking concrete
            fc_con(i) = 0.7*Concrete.ft/(1+sqrt(500*es));
        elseif es <= 0 && es >= ecc % Elastic and hardening range
            L_c = 1;
            fc_con(i) = -(1+1/L_c*(es/ecc-1))/(r_cc-1+(1+1/L_c*(es/ecc-1))^r_cc)*r_cc*fcc;
        elseif es <= ecc && es >= Concrete.ecu  % Post peak
            L_c = Concrete.lambda_c;
            fc_con(i) = -(1+1/L_c*(es/ecc-1))/(r_cc-1+(1+1/L_c*(es/ecc-1))^r_cc)*r_cc*fcc;
        else
            fc_con(i) = 0;
        end
        i = i + 1;
    end
end