function plotShearDeformation(figName, folder)
    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
    end
    C_dim4 = 32; %in
    C_dim6 = 84; %in
    l_t = sqrt(C_dim4^2 + C_dim6^2);
    tanCB = C_dim4/C_dim6;
    figure(1); hold on; 
    
    for FL = ["1", "8", "15"]
        try 
            beam_force = load(".\" +folder +"\Results_static\EleF_CB_f"+FL+".txt");
            [beam1_deformation, beam2_deformation] = readvars(".\" +folder +"\Results_static\AxialDef_CB_f"+ FL+".txt");
        catch
            beam_force = load(".\" +folder +"\Results_dynamic\EleF_CB_f"+FL+".txt");
            [beam1_deformation, beam2_deformation] = readvars(".\" +folder +"\Results_dynamic\AxialDef_CB_f"+ FL+".txt");            
        end
        
        shear = beam_force(:,3) + beam_force(:,15);
        gamma = (beam1_deformation - beam2_deformation)/(2*l_t)*(tanCB + 1/tanCB);
        plot(gamma, shear,'DisplayName',"Floor "+ FL)
    end
    title("Coupling Beam Shear Deformation vs Shear Force")
    grid on; legend('Location','best');
    xlabel('Shear Deformation [-]');
    ylabel('Shear Force [kip]');
    h = findobj('Type','line'); set(h,'LineWidth',2);
    print_figure(figName)
end