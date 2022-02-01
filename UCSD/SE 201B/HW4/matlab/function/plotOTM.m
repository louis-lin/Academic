function plotOTM(figName, folder, direction)
    arguments; 
        figName = "temp"; 
        folder = "dynamic_EW";
        direction = "EW"
    end

Reaction = load(".\" +folder +"\Results_dynamic\Reaction.txt");
Disp = load(".\" +folder +"\Results_dynamic\Disp.txt");

figure(1); hold on;
title("Overturning Moment of Base Section in the " +direction+" Direction");

x_arm = 139; 
y_arm = 62.48;
builidngHeight = 2208;

if direction =="EW"
    OTM1 = Reaction(:,6) + Reaction(:,4)*x_arm;
    OTM2 = Reaction(:,12) - Reaction(:,10)*x_arm;
    drift = Disp(:,2)/builidngHeight; 
elseif direction =="NS"
    OTM1 = Reaction(:,5) - Reaction(:,4)*y_arm;
    OTM2 = Reaction(:,11) + Reaction(:,10)*y_arm;
    drift = -Disp(:,3)/builidngHeight; 
end

OTM_total = OTM1 + OTM2;


plt = plot(drift ,-OTM_total ,'k','DisplayName','Total','LineWidth',3);  plt.Color(4) = 0.5;
plot(drift ,-OTM1 ,'r--','DisplayName','Wall 1','LineWidth',2);
plot(drift ,-OTM2,'b--','DisplayName','Wall 2','LineWidth',2);
xlabel("Drift Ratio [%]"); 

if direction =="EW"
    ylabel("Overturning Moment M_y [kip*in]");
elseif direction =="NS"
    ylabel("Overturning Moment M_x [kip*in]");
end
legend('Location','southeast','Orientation','horizontal');
grid on
grid minor

print_figure(figName)
end
