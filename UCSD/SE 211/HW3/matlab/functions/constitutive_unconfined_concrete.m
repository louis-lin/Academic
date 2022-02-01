function [fcu]= Mander_unconfined_concrete_split(strain, Concrete)
    % Return stress in confined concrete
    %% Input
    % Concrete data structure
        % fc is the modulus of the concrete
        % ecu is the maximum compressive strain
        % ec is the strain at the maximum compressive force
        % lambda_c is the softening branch normalization factor
    % strain is the current strain in the concrete fiber
    %% Output
    % fcu is the stress in the unconfined concrete fiber
    %%
    fc = Concrete.fc;
    n_E = 1 + 3600/fc;
    i = 1;
    
    fcu = zeros(1,numel(strain));
    for es = strain
        e_ec = es/Concrete.ec;
        if 0 <= es && es <= Concrete.et % Elastic Tension
            fcu(i) = Concrete.Ec *es; 
        elseif es >= Concrete.et % Post Tensile cracking concrete
            fcu(i) = 0.7*Concrete.ft/(1+sqrt(500*es));
        elseif es <= 0 && es >= Concrete.ec % Elastic and hardening range
            fcu(i) = -(1-(1-e_ec)^n_E) *fc;
        elseif es < Concrete.ec && es >= Concrete.ecu % Post peak compression
            r_c = 1/(1-1/n_E);
            L_c = Concrete.lambda_c;
            fcu(i) = -(1+(1/L_c)*(e_ec-1))/(r_c-1+(1+(1/L_c)*(e_ec-1))^r_c)*r_c*fc;
        else
            fcu(i) = 0;
        end
        i = i +1;
    end
end