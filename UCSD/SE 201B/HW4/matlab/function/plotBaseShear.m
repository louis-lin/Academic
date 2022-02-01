function plotBaseShear(figName, folder)
    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
    end
    try
        [~, disp] = readvars(".\"+folder+"\Results_static\Disp.txt");
        [total, v1, v2] = readvars(".\"+folder+"\Results_static\Reaction.txt");
    catch
        [~, disp] = readvars(".\"+folder+"\Results_dynamic\Disp.txt");
        [total, v1, v2] = readvars(".\"+folder+"\Results_dynamic\Reaction.txt"); 
    end
    idx = getMaxDispIdx(folder);
    
    figure(1); hold on; box on;
    builidngHeight = (16+14*12)*12;
    plt = plot(disp/builidngHeight ,total,'k','DisplayName','Total Base Shear','LineWidth',3); plt.Color(4) = 0.5;
    plot(disp/builidngHeight ,-v1,'r-.','DisplayName','Wall 1','LineWidth',2);
    plot(disp/builidngHeight ,-v2,'b-.','DisplayName','Wall 2','LineWidth',2);
    scatter(disp(idx)/builidngHeight, -v1(idx),100,'ks','filled','DisplayName','Max Drift');
    scatter(disp(idx)/builidngHeight, -v2(idx),100,'ks','filled','HandleVisibility','off');
    grid on; 
    legend('Location','best');
    title('Base Shear of Core Wall');
    xlabel('Roof Drift Ratio [%]');
    ylabel('Base Shear [kip]');
    print_figure(figName)
end