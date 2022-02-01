clear; close; clc;

%% Material Properties
fc = -7.8; % ksi; Expected Compressive Strength
fy = 70; % ksi; Expected  Yielding Strength of Concrete
Es = 29000; % ksi; Elastic Modulus
ecu = -0.003; % -; Concrete Max Compressive Strain ACI 318-19
beta1 = max(0.65, min(0.9, 0.85-0.05*(-fc-4))); % Factor for equiv. block
beta2 = 0.85; % Factor for max compressive strength for equiv. block
%% Dimensions
%  ______
% |    ___|
% |   |
% |   |   ->>
% |   |___
% |______|

% Please refer to figures
bf1 = 140;
tf1 = 28;
bw = 28;
tw = 260;
bf2 = 140;
tf2 = 28;
% Total dimensions
flange1 = (bf1); % Total Width of Top Flange
flange2 = (bf2); % Total Width of 'Top' Flange when direction reverses
ttotal = (tf1 + tw+tf2);  % Total height of core wall
% Spacings and Centroid
spacing = [14, 158, 302]; % Spacing of the rebars from top
Ytop = 158; % Centroid of the section
%% Plotting
close; clc;
figure(1); hold on;
colors = [	"#0072BD",	"#D95319",	"#EDB120", "#4DBEEE","#77AC30", "#A2142F"]; % Plotting
k = -1; % Plotting Positive and Negative Moments
j = 1; % Color Counter
c_ratios = [0,0.05, 0.1,0.15,0.2]; % For Neutral Axis Lines 
steel_ratios = (0.008:0.002:0.018); % Steel Ratios to run through
% steel_ratios = 0.0125;

% Plot Demands
Pu = [50.476,179.520,392.500,688.350,1053.200,1470.500,1921.400,2472.600,3050.900,3655.900,4285.900,4929.200,5558.100,6116.000,6463.100]; 
Mu = [2299.396,3775.894,4596.662,5363.692,6265.489,7210.340,8603.029,9446.822,9824.368,10034.639,10706.207,13026.257,17964.433,25644.776,42135.741];
scatter(Mu,Pu,50,'r','filled','DisplayName','0.9D-0.2SDS+1.0EQX')

% Pu = [-3531, -3526  -8724, -8719];
% Mu = [-131790,  130537,  -132810,  129516];
% scatter(Mu,Pu,50,'r','filled','DisplayName','MU_{EW} Demands')

% 
% Pu = [-3531, -3526  -8724, -8719];
% Mu = [-131790,  130537,  -132810,  129516];
% scatter(Mu,Pu,50,'r','filled','DisplayName','MU_{EW} Demands')
% 
% Pu = [-3531, -3526  -8724, -8719];
% Mu = [-131790,  130537,  -132810,  129516];
% scatter(Mu,Pu,50,'r','filled','DisplayName','MU_{EW} Demands')
%%

for rho = steel_ratios 
    As = [bf1*tf1*rho, bw*tw*rho, bf2*tf2*rho]; % Calculates the area of steel per section
    for offset = [0, ttotal] % Flips between top and bottom 
        d = abs(offset - spacing); % Recalculates spacing
        centroid_Y = abs(offset - Ytop); % Recalculates Centroid
        i = 1; % Neutral Axis counter
        Pn = []; % Resets ! Important since Pn & Mn ...
        Mn = []; % will have different lengths but uses the same variable
        cmax = abs(tf1)/beta1; % Calculates the distance that excludes flanges
        for c = 0:cmax % Neutral Axis counter
            a = beta1*c; % Equivalent block height
            es = ecu/c*(c-d); % Strain at every steel layer
            fs = min(max(Es*es,-fy),fy); % Stress at every steel layer
            Fs = As.*fs; % Force at every steel layer
            if offset == 0; L = flange1; else; L = flange2; end % Changes the flange width
            Fc = a*L*(beta2*fc);% Force developed by the concrete equivalent block
            P(i) = Fc + sum(Fs); % Total resisted axial force
            M(i) = -Fc*(centroid_Y - a/2) + sum(Fs .* (d-centroid_Y)); % Moment in section
            et = ecu/c*(c-ttotal); % Strain at extreem concrete fiber
            phi = max(0.65, min(0.90, 0.65+(et-0.002)*250/3)); % capacity factor
%             phi = 1;
            Pn(i) = phi*P(i); % Factored Axial capacity
            Mn(i) = phi*M(i)/12; % Factored moment Capacity /12 for feet
            i = i +1; % Increment neutral axis counter
            NA(i) = c;
        end
        plt = plot(k*Mn,Pn,'-','DisplayName',"\rho =" + rho,"Color",colors(j)); % Plot
%         plt = scatter(k*Mn,Pn,'DisplayName',"\rho =" + rho,'b'); % Plot
        if k == 1; plt.HandleVisibility = 'on'; else;  plt.HandleVisibility = 'off'; end % Legend
%         scatter(k*Mn(c_ratios*cmax+1),Pn(c_ratios*cmax+1),'HandleVisibility','off','MarkerFaceColor',colors(j),'MarkerEdgeColor','k'); % Adds NA lines   
        k = k*-1; % Flips between positive and negative plotting
        
%             for i = 1:4
%                 [~, idx] = min(abs(Pu(i)-Pn));
%                 P = Pn(idx);
%                 disp("The maximum probable moment is "+ sprintf("%g",Mn(idx)) +" kip ft");
%                 disp("The omega for this LC is " +Mn(idx)/Mu(i));
%                 disp(newline);
%             end
    end
    j = j +1; % Increment Color 
end
%%
% Pu = 3526; 
% [~, idx] = min(abs(Pu - P));
% disp("The NA is " + NA(idx));

% Plot Settings
set(gcf,'Position',[600,600,1000,600]);
xlabel('Design Moment \phiMn [kip-ft]');
ylabel('Design Axial Load \phiPn [kip]');
set (gca,'Ydir','reverse');
xline(0,'HandleVisibility','off');
yline(0,'HandleVisibility','off');
legend('Location','Best');
grid on; grid minor;
% xlim([-1.25*10^5, 1.25*10^5])
title("PM Interaction Diagram for Lower Stories Core Wall","(Earthquake in the NS Directions)");