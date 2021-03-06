function plotNA(figName, folder, direction)

    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
        direction = "EW";
    end
   
    centroid_x = 43;
    centroid_y = 158;
    lw1 = 140;
    lw2 = 316; 
    idx = getMaxDispIdx(folder);
    idx = 657;
    
    [eo1, Kx1, Ky1, ~] = readvars(".\" +folder+ "\Results_static\SecD_W1_base.txt");
    [eo2, Kx2, Ky2, ~] = readvars(".\" +folder+ "\Results_static\SecD_W2_base.txt");
    
    
    if direction == "EW"
        K1 = Ky1; % Gets the curvature of the strain profile
        K2 = Ky2; % Gets the curvature of the strain profile
        sectionCoord = linspace(-centroid_x,lw1-centroid_x,1000)'; % Gets the domain of the NA
        sectionCoord2 = linspace(-lw1+centroid_x, centroid_x,1000)'; % Gets the domain of the NAs
        eps(:,1) = eo1(idx) - sectionCoord*K1(idx); % Calculates the strain using point-slope form
        eps(:,2) = eo2(idx) - sectionCoord2*K2(idx); % Calculates the strain using point-slope form
    elseif direction == "NS"
        K1 = -Kx1;
        K2 = -Kx2;
        sectionCoord = linspace(-centroid_y, lw2-centroid_y,1000)';
        sectionCoord2 = linspace(-centroid_y, lw2-centroid_y,1000)';
        eps(:,1) = eo1(idx) - sectionCoord*K1(idx);
        eps(:,2) = eo2(idx) - sectionCoord2*K2(idx);
    end
    
    for i=1:2 % For wall 1 and wall 2
        if i == 2; sectionCoord = sectionCoord2; end;
        figure(i); hold on;
        % Plots the actual profile
        plot(sectionCoord,eps(:,i),'LineWidth',1.,'Color','k') 
        % Plots vertical lines
        plot([sectionCoord(1),sectionCoord(1)], [0, eps(1,i)], 'LineWidth',1.,'Color','k'); 
        plot([sectionCoord(end),sectionCoord(end)], [0, eps(end,i)], 'LineWidth',1.,'Color','k')
        xline(0); 
        % Plots the compression and tension
        [~,indNA] = min(abs(eps(:,i) - 0));
        depthNA = max(sectionCoord) - sectionCoord(indNA);
        if sectionCoord(1) >= 0 
            Colors = ["b","r"];
        elseif sectionCoord(1) <= 0 
            Colors = ["r","b"];
        end
        plot([sectionCoord(1),sectionCoord(indNA)],[0,0],Colors(1),'LineWidth',2); % Plots the tension side
        plot([sectionCoord(indNA),sectionCoord(end)],[0,0],Colors(2),'LineWidth',2); % Plots the tension side

        title(["Wall "+ i, "depth of NA = "+ num2str(depthNA,3)+ " in"])
        grid on
%         print_figure(figName +i, [3.25, 2.75])
    end
end 