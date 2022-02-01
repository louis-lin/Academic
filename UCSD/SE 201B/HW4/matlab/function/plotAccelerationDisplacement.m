function plotAccelerationDisplacement(figName, folder, direction, legendName, labelOn)
    arguments; 
        figName = "temp"; 
        folder = "dynamic_EW";
        direction = "EW"
        legendName = ""
        labelOn = true;
    end
    
figure(1); hold on;
dir =".\" +folder + "\Results_dynamic\accel_FL";

i = 1;
for FL = [2, 6, 11, 15]
    subplot(4,1,i); hold on;
    [time, accX, accY] = readvars(dir+num2str(FL)+".txt");
    if direction =="EW"
        A = accX/386.4;
    elseif direction =="NS"
        A = accY/386.4;
    end
    plt = plot(time,A); 
    [~, idx] = min(max(abs(A))-abs(A));
    plot(time(idx),A(idx),'ro','MarkerFaceColor','r','HandleVisibility','off');
    if labelOn
    text(time(idx),A(idx),sprintf('%1.3f g',abs(A(idx))),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',12,'FontWeight','Bold');
    end
    
    xlabel("Time (sec)"); ylabel("Acceleration (g)"); 
    title("Absolute Acceleration in the "+direction+" direction at Floor " + num2str(FL));grid on;
    i = i+1;
    xlim([0,20])
    if legendName ~= ""; plt.DisplayName = legendName; legend(); end;
end

print_figure(figName +" i ",[6.5,8])


figure(2); hold on;
dir =".\" +folder + "\Results_dynamic\disp_FL";
i = 1;
for FL = [2, 6, 11, 15]
    subplot(4,1,i); hold on;
    [time, dispX, dispY] = readvars(dir+num2str(FL)+".txt");
    if direction =="EW"
        U = dispX;
    elseif direction =="NS"
        U = dispY;
    end
    plt = plot(time,U); 
    [~, idx] = min(max(abs(U))-abs(U));
    plot(time(idx),U(idx),'ro','MarkerFaceColor','r','HandleVisibility','off');
    if labelOn
    text(time(idx),U(idx),sprintf('%1.3f in',abs(U(idx))),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',12,'FontWeight','Bold');
    end
    
    xlabel("Time (sec)"); ylabel("Displacement (in)"); 
    title("Relative Displacement in the "+direction+" direction at Floor " + num2str(FL));grid on;
    i = i+1;
    xlim([0,20])
    if legendName ~= ""; plt.DisplayName = legendName; legend(); end;
end
print_figure(figName +" ii ",[6.5,8])
end