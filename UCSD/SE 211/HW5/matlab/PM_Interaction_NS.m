clear; close; clc;
%% Material Properties
fc = -7; % ksi; Compressive Strength
fy = 60*1.25; % ksi; Yielding Strength of Concrete
Es = 29000; % ksi; Elastic Modulus
ecu = -0.003; % -; Concrete Max Compressive Strain ACI 318-19
beta1 = max(0.65, min(0.9, 0.85-0.05*(-fc-4))); % Factor for equiv. block
beta2 = 0.85; % Factor for max compressive strength for equiv. block
%% Dimensions
% Please refer to figures
bf = 260; % Top Flange Width 
tf = 28; % Thickness of Top Flange
bw1 = 28; % Width of Web 1
tw1 = 140; % Height of Web 1
bw2 = 28; % Width of Web 2
tw2 = 140; % Height of Web 2
% Total dimensions
flange1 = (bf+tw1+tw2); % Total Width of Top Flange
flange2 = (bw1+bw2); % Total Width of 'Top' Flange when direction reverses
ttotal = tw2; % Total height of core wall
% Spacings and Centroid
spacing = [14, 35, 105]; % Spacing of the rebars
Ytop = 43.037; % Centroid of the section
%% Plotting
figure(1); hold on;
colors = [	"#0072BD",	"#D95319",	"#EDB120", "#4DBEEE","#77AC30", "#A2142F"]; % Plotting
k = -1; % Plotting Positive and Negative Moments
j = 1; % Color Counter
c_ratios = [0,0.05, 0.1,0.15,0.2]; % For Neutral Axis Lines 
steel_ratios = (0.006:0.002:0.016); % Steel Ratios to run through

% Demands
Pu = [6199  -13256  1006  -18449];
Mu = [27322  -27460  27243  -27540]; 
scatter(Mu,Pu,50,'r','filled','DisplayName','MU_{NS} Demands')

% steel_ratios = 0.0125;
for rho = steel_ratios 
    As = [bf*tf*rho, bw1*tw1*rho, bw2*tw2*rho]; % Calculates the area of steel per section
    for offset = [0, ttotal] % Flips between top and bottom 
        d = abs(offset - spacing); % Recalculates spacing
        centroid_Y = abs(offset - Ytop); % Recalculates Centroid
        i = 1; % Neutral Axis counter
        Pn = []; % Resets ! Important since Pn & Mn ...
        Mn = []; % will have different lengths but uses the same variable
        cmax = abs(offset-tf)/beta1; % Calculates the distance that excludes flanges
        for c = 0:0.1:cmax % Neutral Axis incrementor
            a = beta1*c; % Equivalent block height
            es = ecu/c*(c-d); % Strain at every steel layer
            fs = min(max(Es*es,-fy),fy); % Stress at every steel layer
            Fs = As.*fs; % Force at every steel layer
            if offset == 0; L = flange1; else; L = flange2; end % Changes the flange width
            Fc = a*L*(beta2*fc);% Force developed by the concrete equivalent block
            P = Fc + sum(Fs); % Total resisted axial force
            M = -Fc*(centroid_Y - a/2) + sum(Fs .* (d-centroid_Y)); % Moment in section
            et = ecu/c*(c-ttotal); % Strain at extreme concrete fiber
            phi = max(0.65, min(0.90, 0.65+(et-0.002)*250/3)); % capacity factor
%             phi = 1;
            Pn(i) = phi*P; % Factored Axial capacity
            Mn(i) = phi*M/12; % Factored moment Capacity /12 for feet
            i = i +1; % Increment neutral axis counter
        end
        plt = plot(k*Mn,Pn,'DisplayName',"\rho =" + rho,"Color",colors(j)); % Plot
        if k == 1; plt.HandleVisibility = 'on'; else;  plt.HandleVisibility = 'off'; end % Legend
        k = k*-1; % Flips between positive and negative plotting
%         for i = 1:4
%             [~, idx] = min(abs(Pu(i)-Pn));
%             P = Pn(idx);
%             disp("For LC " + i );
%             disp("The maximum probable moment is "+ sprintf("%g",k*Mn(idx)) +" kip ft");
%             disp("The omega for this LC is " +k*Mn(idx)/Mu(i));
% %             end
%         end
    end
    j = j +1; % Increment Color 
end

% Plot Settings
set(gcf,'Position',[0,0,1000,600]);
xlabel('Design Moment \phiMn [kip-ft]');
ylabel('Design Axial Load \phiPn [kip]');
set (gca,'Ydir','reverse');
xline(0,'HandleVisibility','off');
yline(0,'HandleVisibility','off');
legend('Location','Best');
grid on; grid minor;
% xlim([-2*10^5, 2*10^5])
title("PM Interaction Diagram for Core Wall (Earthquake in the EW Direction)");
