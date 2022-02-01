%% Plot Everything
% Short Hand Notations
close all; clc;

force = "Applied Force (kip)";
U = "Relative Displacement (in)";
iter = "Number of Iterations";
LS = "Load Steps (n)";
T = "Time (sec)";
A = "Acceleration (in/sec^2)";

analy1 = "Quasi-Static Cyclic Loading Pushover Analysis";
analy2 = "Time History Analysis";

algo1 = "Netown-Raphson Algorithm";
algo2 = "Modified Netown-Raphson Algorithm";
algo3 = "Modified Netown-Raphson With Intial E_0 Algorithm";

R = "Internal Resisting Force";
UnBaFo = "Unbalanced Force";
MP = "Megenetto-Pinto Uniaxial Model";
plot_size = [1200, 0, 1300,700];

%% Figure 1 - Force Pushover Curve
close all;
P = load('P.txt');
name = "Force Used in Pushover Analysis";
plot(P); 
title(name); xlabel(LS); ylabel(force); grid on; 
xticks(1:23); xlim([1,23]);
set(gcf, 'Position',  [1200, 0, 1300,500])
print_file(1, name)
%% Figure 2 -Quasi Static Cyclic Loading Using the Newton Algorithm
close;
name = [analy1, "using "+algo1];
fig = 2;
title(name);
grid on; hold on;
plot_MenegottoPinto(record_static1);
plot_iterations(record_static1);
plot_RU_curve(record_static1, R);
set(gcf, 'Position',  plot_size)
set(gca,"FontSize",18)
print_file(fig, name)
%% Figure 3 -Quasi Static Cyclic Loading Using the Modified Newton Algorithm
close;
fig = 3;
name = [analy1, "using "+algo2];
title(name);
grid on; hold on;
plot_MenegottoPinto(record_static2);
plot_iterations(record_static2);
plot_RU_curve(record_static2, R);
set(gcf, 'Position',  plot_size)
print_file(fig, name)
%% Figure 4 -Quasi Static Cyclic Loading Using the Modified Newton Algorithm -Inital
close;
name = [analy1, "using "+algo3];
title(name);
fig = 4;
grid on; hold on;
plot_MenegottoPinto(record_static3);
plot_iterations(record_static3);
plot_RU_curve(record_static3, R);
set(gcf, 'Position',  plot_size)
print_file(fig, name)
%% Figure 5 -Unbalanecd Force Per Iterations
close all; 
fig = 5;
subplot(1,2,1); hold on; 
name = [UnBaFo+" Per Iteration","Using " + algo1];
for i = 1:size(record_static1.Unb,1)
    Unb = record_static1.Unb(i,:);
    Unb = Unb(Unb ~=0); 
    plot(i*ones(numel(Unb)), Unb,'r-x');
end
title(name); set(gca, 'YScale', 'log','xminorgrid','on','yminorgrid','on'); ylabel("Unbalanced Force (kip)"); xlabel("Load Step (n)"); xlim([0,22]);
subplot(1,2,2); hold on;
name = [UnBaFo+" Per Iteration","Using " + algo2];
for i = 1:size(record_static2.Unb,1)
    Unb = record_static2.Unb(i,:);
    Unb = Unb(Unb ~=0); 
    if length(Unb) >= 100; step = 50; else; step = 1; end;
    Unb = Unb(1:step:end);
    plot(i*ones(numel(Unb)), Unb,'r-x');
end
set(gca, 'YScale', 'log','xminorgrid','on','yminorgrid','on'); ylabel("Unbalanced Force (kip)"); xlabel("Load Step (n)");xlim([0,22]);
title(name); 
set(gcf, 'Position',  plot_size)
% 
print_file(fig, "Unbalanced Force Per Iteration")
%% Figure 6 - Number of Iterations Per Load Step for Static Analysis
close all; 
fig = 6;
name = "Number of Iterations Per Load Step for Static Analysis";
title(name); hold on; grid on;
scatter(1:length(record_static3.iter),record_static3.iter,70,'+',"LineWidth",3,'DisplayName',"Modified Newton - intial");
scatter(1:length(record_static2.iter),record_static2.iter,70,'+',"LineWidth",3,'DisplayName',"Modified Newton");
scatter(1:length(record_static1.iter),record_static1.iter,70,'+',"LineWidth",3,'DisplayName',"Newton");
set(gca, 'YScale', 'log'); legend("location","best");
ylabel("Number of Iterations"); xlabel("Load Step"); xlim([0,22]); xticks(0:22)
set(gcf, 'Position',  [1200, 0, 1300,500])
print_file(fig, name)
%% Figure 7 - Milliseconds to Run Each Algorithm
% Commented Out because it takes too long..
% n = 500;
% [T1, T2, T3] = deal(zeros(1,n));
% for i = 1:n
%     tic
%     ans = Static_no_record(P, MatData,MatState,"Newton", 10);
%     T1(i) = toc; 
% end
% %
% for i = 1:n
%     disp("Running Modified Newton. On Iteration " + i)
%     tic
%     ans = Static_no_record(P, MatData,MatState,"ModifiedNewton", 200);
%     T2(i) = toc; 
% end
% %
% for i = 1:n
%     disp("Running Modified Newton - initial. On Iteration " + i)
%     tic
%     ans = Static_no_record(P, MatData,MatState,"ModifiedNewton -initial", 800);
%     T3(i) = toc; 
% end
% close all; figure;
% fig = 7;
% name = "Milliseconds to run each Algorithm";
% 
% subplot(1,3,1); 
% histogram(T1*10^3,"BinWidth",0.01,"BinLimit",[1.21,1.25]); 
% xlabel("Milliseconds"); ylabel("Counts");title(algo1,'FontSize',12);
% subplot(1,3,2);
% histogram(T2*10^3,"BinWidth",0.01,"BinLimit",[13.5,13.8]); 
% xlabel("Milliseconds"); ylabel("Counts");title(algo2,'FontSize',12);
% subplot(1,3,3);
% histogram(T3*10^3,"BinWidth",0.1,"BinLimit",[56,57.5]); 
% xlabel("Milliseconds"); ylabel("Counts"); title(algo3,'FontSize',12);
% set(gcf, 'Position',  [1200, 0, 1300,500])
% print_file(fig, name)
%% Figure 8 -1994 Northright Earthquake from Sylmar Hospital Station
close;
name = "1994 Northright Earthquake from Sylmar Hospital Station";
fig = 8;
[time, acc] = readvars(".\SYL360.txt");  % Loads in time and acceleration
acc= acc(2:end); time = time(2:end);
plot(time,acc); 
title(name); xlabel(T);ylabel(A);
set(gcf, 'Position',  [1200, 0, 1300,600]);
print_file(fig, name)
%% Figure 9 -Dyanmic Loading Using the Newton Algorithm 
close;
name = ["Comparing " + analy2, "using "+algo1+" and "+algo2];
fig = 9;
title(name); grid on; hold on;
p = plot_RU_curve(record_Trans1, R+" "+ algo1); p.Color = 'r';
plot_RU_curve(record_Trans2, R+" "+ algo2);
set(gcf, 'Position',  plot_size)
print_file(fig, name)
%% Figure 10 -Dyanmic Loading Relative Displacement and Absolute Acceleration
close all; clc
name = ["Comparing Relative Displacement and Absolute Acceleration for the", strjoin([algo1,algo2]," and ")];
sgtitle((name),"FontSize",18);
fig = 10;
plot_disp_acc(record_Trans1,record_Trans2,[algo1, algo2]);
set(gcf, 'Position',  plot_size)
print_file(fig,strjoin(name))
%% Figure 11- Number of Iterations Per Load Step For Dynamic Anlaysis
close all; 
fig = 11;
name = "Number of Iterations Per Load Step for Dyanmic Analysis";
title(name); hold on; grid on;
scatter(1:length(record_Trans2.iter),record_Trans2.iter,70,'+',"LineWidth",3,'DisplayName',"Modified Newton");
scatter(1:length(record_Trans1.iter),record_Trans1.iter,70,'+',"LineWidth",3,'DisplayName',"Newton");
legend("location","best");
ylabel("Number of Iterations"); xlabel("Load Step");
set(gcf, 'Position',  [1200, 0, 1300,500])
print_file(fig, name)
%% Figure 12 -Comparing Force History Hisory Using  Delta = 0.1
close all; clc
name = ["Comparing " + analy2, "with \Deltat=0.2s and \Deltat=0.1s "];
fig = 12;
title(name); hold on; grid on;
p = plot_RU_curve(record_Trans1, R+"; \Deltat = 0.2s"); set(p,'Color','r');
plot_RU_curve(record_Trans3, R+"; \Deltat = 0.1s");
set(gcf, 'Position',  plot_size)
% print_file(fig, "Comparing Changes in Time Step")
%% Figure 13 -Dyanmic Loading Relative Displacement and Absolute Acceleration
close all; clc; hold on;
name = ["Comparing Relative Displacement and Absolute Acceleration" ,"with \Deltat=0.2s and \Deltat=0.1s "];
t = sgtitle((name),"FontSize",18); t.FontWeight =' bold';
fig = 13;
plot_disp_acc(record_Trans1, record_Trans3,["\Deltat = 0.2s", "\Deltat = 0.1s"]);
set(gcf, 'Position',  [1200, 0, 1300,650])
print_file(fig,"Comparing Displacment Delta ")
%% Figure 14 -Comparing Force Hisory with Acceleration*2
name = ["Comparing " + analy2, "with Scaling Accleration by 2"];
close all; clc; grid on; hold on; title(name)
fig = 14;
plot_RU_curve(record_Trans4,  R+"; 2\cdotAcceleration"); 
p = plot_RU_curve(record_Trans1, R+"; 1\cdotAcceleration"); set(p,'Color','r');
set(gcf, 'Position',  [1200, 0, 1300,650])
print_file(fig, name)
%% Figure 15 -Comparing Relative Displacement and Absolute Acceleration with Scaling Acceleration by 2
close all; clc; hold on;
name = ["Comparing Relative Displacement and Absolute Acceleration" ,"with Scaling Accleration by 2"];
t = sgtitle((name),"FontSize",18); t.FontWeight =' bold';
fig = 15;
plot_disp_acc(record_Trans4, record_Trans1,["Scaling by 2", "Scaling by 1"]);
set(gcf, 'Position',  plot_size)
print_file(fig,strjoin(name))
%% Figure 16- Ratio of Various Paramter as Acceleration is scaled- Nonlinear
close all; clc; 
fig = 16;
name = "Comparing Scaling Accleration in Nonlinear and Linear Systems";
t = sgtitle((name),"FontSize",18); t.FontWeight =' bold';
maxU = max(abs(record_Trans1.U));
maxR = max(abs(record_Trans1.R));
maxA = max(abs(record_Trans1.A));
n = 10;
[ratio_U, ratio_R, ratio_G] = deal(zeros(1,n));
for i = 1:n
    record = Transient(i*acc, MatData, MatState, time_step_method,"Newton" , 10);
    ratio_U(i) = max(abs(record.U))/maxU;
    ratio_R(i) = max(abs(record.R))/maxR;
    ratio_G(i) = max(abs(record.A))/maxA;
end
subplot(1,2,1);hold on; grid minor; 
title("Nonlinear System")
plot(ratio_R,"DisplayName","Ratio of Max Internal Force","LineWidth",2); 
plot(ratio_U,"DisplayName","Ratio of Max Displacement","LineWidth",2); 
plot(ratio_G,"DisplayName","Ratio of Max Rel. Acceleration","LineWidth",2);
plot(1:n,'-.',"DisplayName","1:1"); xticks(1:n);
xlabel("Acceleration Factor"); ylabel("Ratio of Scaled:Original Values"); legend("Location","Northwest","FontSize",12);


maxU = max(abs(record_Trans5.U));
maxR = max(abs(record_Trans5.R));
maxA = max(abs(record_Trans5.A));
[ratio_U, ratio_R, ratio_G] = deal(zeros(1,n));
for i = 1:n
    record = Transient(i*acc, MatData, MatState, time_step_method,"Newton", 10);
    ratio_U(i) = max(abs(record.U))/maxU;
    ratio_R(i) = max(abs(record.R))/maxR;
    ratio_G(i) = max(abs(record.A))/maxA;
end
subplot(1,2,2); hold on; grid minor; 
title("Linear System")
plot(ratio_R,"DisplayName","Ratio of Max Internal Force","LineWidth",2); 
plot(ratio_U,"DisplayName","Ratio of Max Displacement","LineWidth",2); 
plot(ratio_G,"DisplayName","Ratio of Max Rel. Acceleration","LineWidth",2);
plot(1:n,'-.',"DisplayName","1:1");xticks(1:n);
xlabel("Acceleration Factor"); ylabel("Ratio of Scaled:Original Values"); legend("Location","Northwest","FontSize",12);

set(gcf, 'Position',  [1200, 0, 1300,550])
print_file(fig,name)
%% Figure 17 -Comparing Force History of Linear and Nonlinear System
close all; clc
name = ["Comparing " + analy2, "Of Nonlinear and Linear- Elastic System"];
fig = 17;
title(name); hold on; grid on;
yyaxis right; p = plot_RU_curve(record_Trans5, "Linear Elastic System"); set(p,'Color','r');
yyaxis left ;plot_RU_curve(record_Trans1, "Nonlinear System");
set(gcf, 'Position',  plot_size)
print_file(fig, name)
%% Figure 18 -Comparing Relative Displacement and Absolute Acceleration with Linear System
close all; clc; hold on;
name = ["Comparing Relative Displacement and Absolute Acceleration" ,"Between Nonlinear and Linear System"];
t = sgtitle((name),"FontSize",18); t.FontWeight =' bold';
fig = 18;
plot_disp_acc(record_Trans5, record_Trans1,["Linear System", "Nonlinear System"]);
set(gcf, 'Position',  plot_size)
print_file(fig,strjoin(name))
%% Figure 19 -Dyanmic Loading Using the Newton Algorithm Base Case
close all; clc;
name = analy2+ " using "+algo1;
fig = 19;
title(name); grid on; hold on;
p = plot_RU_curve(record_Trans1, R+" "+ algo1);
set(gcf, 'Position',  plot_size)
print_file(fig, name)
%% Figure 10 -Relative Displacement and Absolute Acceleration
close all; clc
name = "Relative Displacement and Absolute Acceleration for the " + algo1;
t = sgtitle((name),"FontSize",18); t.FontWeight =' bold';
fig = 20;
plot_disp_acc(record_Trans1,[],[]);
set(gcf, 'Position',  plot_size)
print_file(fig,strjoin(name))
%% 
clc; close all
print_info(record_Trans1)
compare_records(record_Trans1, record_Trans4)
compare_records(record_Trans5, record_Trans6)

%%
function print_info(record)
disp(newline + "Printing Information On the Record")
maxU = max(record.U);
t_maxU = record.time(record.U ==max(record.U));
maxR = record.R(record.U ==max(record.U));
minU = min(record.U);
t_minU = record.time(record.U ==min(record.U));
minR = record.R(record.U ==min(record.U));
maxV = max(abs(record.V));
t_maxV = record.time(max(abs(record.V))  == abs(record.V));
maxG = max(abs(record.A+record.acc));
t_maxG = record.time(max(abs(record.A))  == abs(record.A));
str = [sprintf("The maximum positive displacement was %.3f inches at %.2f seconds.",maxU,t_maxU) ;...
        sprintf("At that moment, the structure was experiencing %.3f kip of internal resisting force.", maxR); ... 
        sprintf("The maximum negative displacement was %.3f inches at %.2f seconds.",minU,t_minU);...
        sprintf("At that moment, the structure was experiencing %.3f kip of internal resisting force.", minR);...
        sprintf("The maximum absolute velocity of the structure was %.3f in/s at %.3f seconds.",maxV,t_maxV);...
        sprintf("The maximum absolute acceleration felt by the structure was %.3f in/sec^2 at %.3f seconds.",maxG,t_maxG);...
        sprintf("The average iteration for this record is %.2f.",mean(record.iter))];
    disp(strjoin(str));
disp(str);
end

%%
function compare_records(record1, record2)
disp(newline+ "Comparing Two Records")
maxU1 = max(abs(record1.U));
t_maxU1 = record1.time(abs(record1.U) ==max(abs(record1.U)));
maxU2 = max(abs(record2.U));
t_maxU2 = record2.time(abs(record2.U) ==max(abs(record2.U)));
maxR1 = record1.R(abs(record1.U) ==max(abs(record1.U)));
maxR2 = record2.R(abs(record2.U) ==max(abs(record2.U)));
maxG1 = max(abs(record1.A+record1.acc))/386;
maxG2 = max(abs(record2.A+record2.acc))/386;

str = [sprintf("Record 1 had a maximum displacement of %.2f inches at %.2f seconds.",maxU1,t_maxU1) ;...
        sprintf("Record 2 had a maximum displacement of %.2f inches at %.2f seconds.",maxU2,t_maxU2) ;...
        sprintf("The ratio between records 2 to 1 is %.2f.",maxU2/maxU1);...
        
        sprintf("The structure in Record 1 resisted a maximum force of %.2f kips.",maxR1) ;...
        sprintf("The structure in Record 2 resisted a maximum force of %.2f kips.",maxR2) ;...
        sprintf("The ratio between records 2 to 1 is %.2f.",maxR2/maxR1);...
        
        sprintf("Record 1 had a maximum acceleration of %.2fg",maxG1) ;...
        sprintf("Record 2 had a maximum acceleration of %.2fg.",maxG2) ;...
        sprintf("The ratio between records 2 to 1 is %.2f.",maxG2/maxG1)];
disp(strjoin(str));
disp(str);
end

%% Functions
function plot_disp_acc(record1, record2, name)
    if ~isempty(record2)
    subplot(2,1,1); hold on;
    plot(record1.time,record1.U,'Color',[1,0,0,1],"DisplayName",name(1),"LineWidth",1); 
    plot(record2.time,record2.U,'Color',[0,0,1,1],"DisplayName",name(2)); 
    xlabel("Time (sec)"); ylabel("Displacement (in)"); title("Relative Displacement");grid on; legend("Location","best");
    
    subplot(2,1,2); hold on;
    plot(record1.time,record1.A+record1.acc,'Color',[1,0,0,1],"DisplayName",name(1),"LineWidth",1); 
    plot(record2.time,record2.A+record2.acc,'Color',[0,0,1,1],"DisplayName",name(2)); 
    xlabel("Time (sec)"); ylabel("Acceleration(in/sec^2)");title("Absolute Accleration");grid on; legend("Location","best");
    else
    subplot(2,1,1);
    plot(record1.time,record1.U,'b'); 
    xlabel("Time (sec)"); ylabel("Displacement (in)"); title("Relative Displacement");grid on;
    subplot(2,1,2);
    plot(record1.time,record1.A+record1.acc,'b'); 
    xlabel("Time (sec)"); ylabel("Acceleration(in/sec^2)");title("Absolute Accleration");grid on;
    end
    % subplot(3,1,2); plot(time,record1.V,'b',"DisplayName","Velocity"); xlabel("Time (sec)"); ylabel("Velocity (in/sec)");
end
function plot_iterations(record)
    plot(record.U_iter,record.P_iter,"DisplayName","Unbalanced Force Path"); 
end
function plot_MenegottoPinto(record)
    [MP_U, MP_Force] = Menegotto_Pinto(record.U,record.MatData, record.MatState);
    plt = plot(MP_U , MP_Force,'r','LineWidth',4, "DisplayName"," Menegotto-Pinto Uniaxial Model" ); 
    plt.Color(4) = 0.3;
end
function pl = plot_RU_curve(record, name)
    pl = plot(record.U,record.R,'b',"DisplayName",name,'MarkerEdgeColor','r',"MarkerSize",4);
    xlabel("Relative Displacement (in)"); ylabel("Internal Resisting Force (kip)"); legend("Location","Southeast");
end
function print_file(no, name)
    print("figures\"+string(no)+" "+ strjoin(name),'-dsvg','-PMicrosoft Print to PDF','-r600','-painters');
end