function plt = plotHorDisp(figName, folder, nNodeColumn, direction, legendName)
    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
        nNodeColumn = 1; 
        direction = "EW";
        legendName = "";        
    end

    if direction == "EW"; DOF = 1; elseif direction == "NS"; DOF =2; end
    
    idx = getMaxDispIdx(folder);
    idx = 657;
    
    Nstories = 15; 
    
    for wall = [1,2]
        displace = [];
        subplot(1,2,wall); hold on;
        for i = 1:Nstories
            for n = 1:nNodeColumn
                dispNode = load(".\" + folder + "\DeflectedShape\dispNode_" + num2str(1000*i +wall*100 + n) +".txt");
                displace = [displace, dispNode(idx,DOF)];
            end
        end
        height = 16:12/nNodeColumn:184;

        if nNodeColumn == 2
            height = [0, 8 , height];
        else
            height = [0, height];
        end
        
        plt = plot(abs([0, displace]),height,'-o');
        yticks([0, 16:12:184]);
        ylim([0,184])
        grid on;
        xlabel('Horizontal Displacement [in]');
        ylabel('Story Height [ft]');

        title("Wall "+wall);
        if legendName ~= ""; plt.DisplayName = legendName; legend('location','best'); end
        
    end
    sgtitle("Horizontal Displacement in the " +direction+" direction",'FontName','Times');
    h = findobj('Type','line'); set(h,'LineWidth',2,'MarkerSize',2,'MarkerFaceColor','none');
    print_figure(figName,[6.5,4.5]);
end