function[fs]=Mander_steel_split(strain, Steel)
% Obtains steel stress using Mander's reinforcing steel model.
%% Input
% Es is the Young's modulus of steel
% fy is the yield stress of steel
% P is the power of the function for the strain hardening region
% esh is the strain at onset of strain hardening
% esu is the uniform strain
% strain is the strain at the fiber
% fsu is the ultimate yield strength
%% Output
% fs is the stress at strain
%%

Es = Steel.Es;
fy = Steel.fy;
P = Steel.P;
esh = Steel.esh;
esu = Steel.esu;
fsu = Steel.fsu;
i = 1;

fs = zeros(1,numel(strain));
for es = strain
if es>0
    if es <=fy/Es
        fs(i)=es*Es;
    else
        if es<=esh
            fs(i)=fy;
        else
            if es<esu
                fs(i)=fsu-(fsu-fy)*(((esu-es)/(esu-esh)))^P;
            else, fs(i)=0;
            end
        end
    end
else
    if es > -fy/Es
        fs(i)=es*Es;
    else, fs(i)=-fy;
    end
end
i = i +1;
end
end