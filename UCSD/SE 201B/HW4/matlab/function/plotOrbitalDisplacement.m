function plotOrbitalDisplacement(figName, folder)
    arguments; 
        figName = "temp"; 
        folder = "dynamic_EW";
    end
    
dir =".\" +folder + "\Results_dynamic\disp_FL";
i = 1;
for FL = [2, 6, 11, 15]
    figure(i);
    [~, dispX, dispY] = readvars(dir+num2str(FL)+".txt");
    plot(dispX,dispY); axis equal
    xlabel("EW Displacement (in)"); ylabel("NS Displacement (in)"); 
    title("Displacement at Floor " + num2str(FL));grid on; 
    i = i+1;
    
    xlim([-40,20]);
    ylim([-20,20]);
   
    print_figure(figName+" ii " + string(i),[3.25, 3.25])
end
end