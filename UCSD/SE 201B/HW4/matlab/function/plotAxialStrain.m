function plotAxialStrain(figName, folder, direction)
    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
        direction = "EW";
    end
    
    try 
        [eo1, Kx1, Ky1, ~] = readvars(".\" +folder+ "\Results_static\SecD_W1_base.txt");
        [eo2, Kx2, Ky2, ~] = readvars(".\" +folder+ "\Results_static\SecD_W2_base.txt");
    catch
        [eo1, Kx1, Ky1, ~] = readvars(".\" +folder+ "\Results_dynamic\SecD_W1_base.txt");
        [eo2, Kx2, Ky2, ~] = readvars(".\" +folder+ "\Results_dynamic\SecD_W2_base.txt");
    end
    
    figure(1); hold on
    set(gca,'DefaultLineLineWidth',2)
    if direction == "EW" 
        K1 = Ky1; K2 = Ky2;
    elseif direction == "NS"
        K1 = Kx1; K2 = Kx2;
    end

    plot(K1,eo1,'r-','DisplayName','Wall 1') % Wall 1
    plot(-K2,eo2,'b-','DisplayName','Wall 2') % Wall 2

    grid on; legend('Location','northwest');
    xlabel('Curvature \kappa_y [1/in]');
    ylabel('Centroidal strain \epsilon_o [-]');
    title("Axial Strain Versus Curvature");    
    grid on; legend('Location','northwest');
    
    if direction == "EW"
        xlabel('Curvature \kappa_y [1/in]');
    elseif direction == "NS"
        xlabel('Curvature \kappa_x [1/in]');
    end
    
    ylabel('Centroidal strain [-]');
    
    idx = getMaxDispIdx(folder);
    scatter(K1(idx),eo1(idx),'ks','filled','HandleVisibility','off') % Wall 1
    scatter(-K2(idx),eo2(idx),'ks','filled','DisplayName','Max. Drift') % Wall 2
%     legend('Location','north')
    legend('Location','best');
    print_figure(figName)
    
end