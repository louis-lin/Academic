%% Axial Moment
function plotSectionAxialMoment(figName, folder, direction,beamType, nNodeColumn, flip, legendName, GL, Nstories)
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

    wall = 2;
    totalheights = [];
    culumheight = zeros(1,GL);
    A = []; My = [];
    
    for i = 1:Nstories
        for n = 1:nNodeColumn
            sec_force = load(".\"+folder+"\Results_Static\SecF_" + beamType +num2str(1000*i +wall*100 + n)+ ".txt");
            local_heights = load(".\"+folder+"\Results_Static\IntPts_" + beamType +num2str(1000*i +wall*100 + n)+ ".txt");
            culumheight = culumheight(5) + local_heights(idx,:);
            totalheights = [totalheights, culumheight];
            A = [A, sec_force(idx, 1:4:(4*GL)-3)];
            My = [My,  sec_force(idx, 3:4:(4*GL)-1)];
        end
    end

    subplot(1,2,1); hold on;
    plot([A,0],[totalheights, totalheights(end)] /12,'--o','DisplayName','Section Forces');
    
    subplot(1,2,2); hold on;
    plot(flip*[My,0],[totalheights, totalheights(end)]/12,'--o','DisplayName','Section Forces');

    
    h = findobj('Type','line'); set(h,'LineWidth',2,'MarkerSize',2,'MarkerFaceColor','none');
    sgtitle("Forces along the Height of the Builiding",'FontName','Times');
    print_figure(figName,[6.5,4.5])
end