%% Axial Moment
function plotElementAxialMoment(figName, folder, direction, beamType, nNodeColumn, flip, legendName,  GL, Nstories)
    arguments
        figName = "temp"; 
        folder = "static_EW_force";
        direction = 'EW';
        beamType = 'forceBeamColumn';
        nNodeColumn = 1;
        flip = -1;
        legendName ="Element Forces";
        GL = 5;
        Nstories = 15;
    end    
    
    idx = getMaxDispIdx(folder);
    idx = 657;
    totalheights = [];
    culumheight = zeros(1,GL);
    A = []; My = [];
    wall = 2;

    for i = 1:Nstories
        for n = 1:nNodeColumn
            global_ele_force = load(".\"+folder+"\Results_Static\GlobEleF_" + beamType +num2str(1000*i +wall*100 + n)+ ".txt");
            local_heights = load(".\"+folder+"\Results_Static\IntPts_" + beamType + num2str(1000*i +wall*100 + n) +".txt");
            culumheight = culumheight(5) + local_heights(idx,:);
            totalheights = [totalheights, culumheight(1), culumheight(5)];
            A = [A, global_ele_force(idx, 3),-global_ele_force(idx, 9)];
            My= [My, global_ele_force(idx, 5),-global_ele_force(idx, 11)];
        end
    end
    
    figure(1); 
    subplot(1,2,1); hold on;
    plot(flip*[A,0],[totalheights,totalheights(end)]/12,'-.d','DisplayName',legendName);
    grid on; xlabel('Axial [kip]');
    ylabel('Story Height [ft]');
    legend('Location','northwest');
    xline(0,'HandleVisibility','off');
    height = 16:12:184;
    yticks(height);
    ylim([0,184])
    
    subplot(1,2,2);  hold on;
    plot(flip*[My,0],[totalheights,totalheights(end)]/12,'-.d','DisplayName',legendName);
    grid on; xlabel('Moment [kip-in]'); 
    ylabel('Story Height [ft]');
    legend('Location','Northeast')
    xline(0,'HandleVisibility','off');
    yticks(height);
    ylim([0,184])
   
    h = findobj('Type','line'); set(h,'LineWidth',2,'MarkerSize',2,'MarkerFaceColor','none');
    sgtitle("Forces along the Height of the Builiding",'FontName','Times');
    print_figure(figName,[6.5,4.5])
end