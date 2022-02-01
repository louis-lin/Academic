function plotMomentCurvature(figName, folder, direction)
    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
        direction = "EW";
    end
    
    idx = getMaxDispIdx(folder);

    try 
        [~, kx, ky, ~] = readvars(".\" +folder+ "\Results_static\SecD_W1_base.txt");
        [~, Mx, My, ~] = readvars(".\" +folder+ "\Results_static\SecF_W1_base.txt");
    catch
        [~, kx, ky, ~] = readvars(".\" +folder+ "\Results_dynamic\SecD_W1_base.txt");
        [~, Mx, My, ~] = readvars(".\" +folder+ "\Results_dynamic\SecF_W1_base.txt");
    end
    
    figure(1); hold on;
    set(gca,'DefaultLineLineWidth',2)
    title('Moment Curvature of Base Section');
    if direction == "EW"
        plot(ky,My,'r','DisplayName','Wall 1');
        scatter(ky(idx),My(idx),50,'ks','filled','HandleVisibility','off') % Wall 1
    elseif direction == "NS"
        plot(kx,Mx,'r','DisplayName','Wall 1');
        scatter(kx(idx),Mx(idx),50,'ks','filled','HandleVisibility','off') % Wall 1
    end
    
    try 
        [~, kx, ky, ~] = readvars(".\" +folder+ "\Results_static\SecD_W2_base.txt");
        [~, Mx, My, ~] = readvars(".\" +folder+ "\Results_static\SecF_W2_base.txt");
    catch
        [~, kx, ky, ~] = readvars(".\" +folder+ "\Results_dynamic\SecD_W2_base.txt");
        [~, Mx, My, ~] = readvars(".\" +folder+ "\Results_dynamic\SecF_W2_base.txt");
    end

    if direction == "EW"
        plot(-ky,-My,'b','DisplayName','Wall 2');
        scatter(-ky(idx),-My(idx),50,'ks','filled','DisplayName','Max. Drift') % Wall 2
    elseif direction == "NS"
        plot(-kx,-Mx,'b','DisplayName','Wall 2');
        scatter(-kx(idx),-Mx(idx),50,'ks','filled','DisplayName','Max. Drift') % Wall 2
    end

    legend('Location','Best'); 
    grid on; 
    box on; 
    if direction == "EW"
        xlabel('Curvature \kappa_y [1/in]');
    elseif direction == "NS"
        xlabel('Curvature \kappa_x [1/in]');
    end
    
    ylabel('Moment [kip-in]'); 
   
    print_figure(figName)
end