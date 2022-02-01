%% (PRINTED) Fig 0.1 Confined and unconfined concrete from area_circle
close all; figure(); clc;
bar([Column1.Section.confined_fiber_area,Column1.Section.unconfined_fiber_area],'stacked'); 
legend(["Confined Concrete","Unconfined Concrete"]);
xlabel('Fiber #'); ylabel('Area in^2');
set(gcf, 'Position',  [0, 800, 1300,500])
print_figure("01 Discretized Concrete Area");

%% (PRINTED) Fig 0.2 Stress-Strain Relationship
for Column = Column1
close all; 
figure(); 
subplot(1,2,1);
hold on; grid on;
ylabel("Stress [psi]"); xlabel("Strain [in/in]");
strain_range = 0.01:-0.00001:-0.03;
[confined_stress, unconfined_stress] = deal(zeros(1,numel(strain_range)));
for i = 1:length(strain_range)
	unconfined_stress(i) = constitutive_unconfined_concrete(strain_range(i), Column.Unconfined_Concrete);
    confined_stress(i) = constitutive_confined_concrete(strain_range(i), Column.Confined_Concrete);
end
plot(strain_range,confined_stress,'LineWidth',2);
plot(strain_range,unconfined_stress,'LineWidth',2);
legend(["Unconfined Concrete","Confined Concrete"],"Location","southwest");
title("Stress-Strain Relationship for Concrete");

subplot(1,2,2);
strain_range = -0.05:0.0001:0.15;
steel_stress = zeros(1,numel(strain_range));
for i = 1:length(strain_range)
	steel_stress(i) = constitutive_steel(strain_range(i), Column.Long);
end
plot(strain_range,steel_stress/1000,'LineWidth',2,'DisplayName','Steel Rebar');
grid on; legend("location","Southeast");
ylabel("Stress [ksi]"); xlabel("Strain [in/in]");
title("Stress-Strain Relationship for Steel");
set(gcf, 'Position',  [0, 800, 1300,600])
end
print_figure("02 Constitutive Models");

%% (PRINTED) Fig 0.3 Extreme Fiber Plots Strain Plots
for Column = Column1
close all;
figure; hold on; title('Extreme Fibers');
plot(Column.Curvature,Column.Concrete_strain(:,1),'-',"DisplayName","Tensile Concrete Tension Fiber",'LineWidth',2)
plot(Column.Curvature,Column.Steel_strain(:,1),'-',"DisplayName","Tensile Steel Fiber","MarkerSize",3, 'LineWidth',2);
plot(Column.Curvature,Column.Concrete_strain(:,end),'-',"DisplayName","Compressive Concrete Compression Fiber",'LineWidth',2);
plot(Column.Curvature,Column.Steel_strain(:,end),'-',"DisplayName","Compressive Steel Fiber", 'LineWidth',2);
plot(Column.Curvature,Column.centroid_strain,'--',"DisplayName","Centroid Fiber","MarkerSize",3);
set(gcf, 'Position',  [0, 800, 1300,500])
grid on; legend('Location','Best');
ylabel("Strain [in/in]"); xlabel("Curvature [1/in]");
end
print_figure("03 Strains of Extreme Fibers");

%% (PRINTED) Fig 0.4 Steel Strain Plots (FULL)
close all;
figure; hold on; grid minor
ms = 3;
plot(Column.Curvature,Column.Steel_strain(:,1),'x-',"DisplayName","Fiber 1","MarkerSize",ms);
plot(Column.Curvature,Column.Steel_strain(:,2),'x-',"DisplayName","Fiber 2","MarkerSize",ms);
plot(Column.Curvature,Column.Steel_strain(:,3),'x-',"DisplayName","Fiber 3","MarkerSize",ms);
plot(Column.Curvature,Column.Steel_strain(:,4),'x-',"DisplayName","Fiber 4","MarkerSize",ms);
plot(Column.Curvature,Column.Steel_strain(:,5),'x-',"DisplayName","Fiber 5","MarkerSize",ms);
% plot(Column.Curvature,Column.centroid_strain,'--',"DisplayName","Centroid Fiber","MarkerSize",ms);

yline(Column.Long.ey,'r--',"\epsilon_y","HandleVisibility","off",'LabelVerticalAlignment','top');
yline(-Column.Long.ey,'r--',"-\epsilon_y","HandleVisibility","off",'LabelVerticalAlignment','top');
title("Steel Rebars Strain-Curvature");
set(gcf, 'Position',  [0, 800, 1300,500])
grid on; legend("Location","Best");
ylabel("Strain [in/in]"); xlabel("Curvature [1/in]");
xlim([0,inf]);
print_figure("04 Steel Fibers Strain Curvature FULL");

%% (PRINTED) Fig 0.5 Strain Steel Plots (INITIAL) Finding where the Steel Yeilds
close all; clc;
figure; hold on; grid minor;
ms = 3;
set(gca,'DefaultLineLineWidth',2)

P1= plot(Column.Curvature,Column.Steel_strain(:,1),'-',"DisplayName","Fiber 1");  
P2 = plot(Column.Curvature,Column.Steel_strain(:,2),'-',"DisplayName","Fiber 2"); 
P3 = plot(Column.Curvature,Column.Steel_strain(:,3),'-',"DisplayName","Fiber 3");
P4 = plot(Column.Curvature,Column.Steel_strain(:,4),'-',"DisplayName","Fiber 4"); 
P5 = plot(Column.Curvature,Column.Steel_strain(:,5),'-',"DisplayName","Fiber 5"); 

[~, id1] = min(abs(Column.Long.ey- Column.Steel_strain(:,1)));
[~, id2] = min(abs(Column.Long.ey- Column.Steel_strain(:,2)));
[~, id3] = min(abs(Column.Long.ey- Column.Steel_strain(:,3)));
[~, id4] = min(abs(-Column.Long.ey - Column.Steel_strain(:,4)));
[~, id5] = min(abs(-Column.Long.ey- Column.Steel_strain(:,5)));

add_dataTip(P1, id1, ["\phi","\epsilon"],'northwest');
add_dataTip(P2, id2, ["\phi","\epsilon"],'southeast');
add_dataTip(P3, id3, ["\phi","\epsilon"],'northwest');
add_dataTip(P4, id4, ["\phi","\epsilon"],'southwest');
add_dataTip(P5, id5, ["\phi","\epsilon"],'southwest');

P1.DataTipTemplate.DataTipRows(2) = [];
P2.DataTipTemplate.DataTipRows(2) = [];
P3.DataTipTemplate.DataTipRows(2) = [];
P4.DataTipTemplate.DataTipRows(2) = [];
P5.DataTipTemplate.DataTipRows(2) = [];

yline(Column.Long.ey,'r--',"\epsilon_y","HandleVisibility","off",'LabelVerticalAlignment','top');
yline(-Column.Long.ey,'r--',"-\epsilon_y","HandleVisibility","off",'LabelVerticalAlignment','top');
title("Steel Rebars Strain-Curvature");
grid on; legend("Location","Best");
ylabel("Strain [in/in]"); xlabel("Curvature [1/in]"); 
% xlim([0,2.5*10^-4]);
set(gcf, 'Position',  [0, 800, 1300,500])
% print_figure("05 Steel Fibers Strain Curvature ZOOM");

%% (PRINTED) Fig 0.6 Strain Concrete Plot (INITIAL)
for Column = Column1
close all; clc;
figure; hold on; grid minor;
ms = 3; % Markersize
id = find_points(Column);
curv_range = 1:150;
P1 = plot(Column.Curvature(curv_range),Column.Concrete_strain(curv_range,1),'b-',"DisplayName","Extreme Tensile Fiber","LineWidth",2);
plot(Column.Curvature(curv_range),Column.centroid_strain(curv_range),'g--',"DisplayName","Centroidal Fiber","LineWidth",2);
P2 = plot(Column.Curvature(curv_range),Column.Concrete_strain(curv_range,Column.Section.no_of_fibers),'r-',"DisplayName","Extreme Compressive Fiber","LineWidth",2);

add_dataTip(P1, id.et, ["\phi","\epsilon"],'northwest');
add_dataTip(P2, id.ACI, ["\phi","\epsilon"],'southwest');
add_dataTip(P2, id.Mn, ["\phi","\epsilon"],'southwest');
add_dataTip(P2, id.Spalling, ["\phi","\epsilon"],'southwest');

add_line('y', Column.Confined_Concrete.et, '\epsilon_{t}', 'r--', 'top')
add_line('y', -0.003, '\epsilon_{ACI}', 'r--', 'top')
add_line('y', -0.004, '\epsilon_{Mn}', 'r--', 'bot')
add_line('y', -0.006, '\epsilon_{Spalling}', 'r--', 'bot')
title("Concrete Strain-Curvature");
grid on; legend("Location","Best"); ylabel("Strain [in/in]"); xlabel("Curvature [1/in]"); xlim([0,6*10^-4]); set(gcf, 'Position',  [0, 800, 1300,500])
end
print_figure("06 Concrete Fibers Analysis");

%% (PRINTED) Fig 0.7  Steel Rebar Stress Plots
close all;
plots = plot_steel_stress(Column1, "Column Stress-Curvature Plot");

add_dataTip(plots(1), id1, ["\phi","\sigma_y"],'northwest');
add_dataTip(plots(2), id2, ["\phi","\sigma_y"],'northeast');
add_dataTip(plots(3), id3, ["\phi","\sigma_y"],'southeast');
add_dataTip(plots(4), id4, ["\phi","\sigma_y"],'southwest');
add_dataTip(plots(5), id5, ["\phi","\sigma_y"],'southwest');

grid minor;
print_figure("07 Steel Fibers Stress");

%% (PRINTED) Figure 1 Part i Moment Curvature 
close all; clc;
plot_moment_curvature(Column1);
% print_figure("1 i Vanilla Moment Curvature");

%% (PRINTED) Figure 1 Part ii Moment Curvature w/ Points 
close all; clc;
plot_moment_curvature(Column1);
add_all_dataTips(Column1);
print_figure("08 Moment Curvature with Points");

%% (PRINTED) Figure 1 Part iii Yield points
close all;
plot_moment_curvature(Column1); 
P = plot_approx_curve(Column1,0, 1); P.Color = 'r';
xlim([0,4*10^-4]);
print_figure("09 True Yield Points");

%% (PRINTED) Figure 1 Part iv Effective Flexural Stiffness
close all; clc;

P = plot_moment_curvature(Column1,0); legend("Location",'northwest');
add_dataTip(P, Column1.id.et, ["\phi_{cr}","M_{Model}"],'northwest');
P.DataTipTemplate.DataTipRows(1) = [];
set(gca,'DefaultLineLineWidth',3)
x = [0,Column1.Pcr, Column1.Py]/Column1.norm_P;

% P = plot(x, Column1.Ec_Ie/1000*x,'--',"DisplayName","M_1(\phi)=\phi*E_c*I_{e}");
% add_dataTip(P, 2, ["\phi_{cr}","M_{1}"],'southwest');
% P.DataTipTemplate.DataTipRows(1) = [];

P = plot(x, Column1.Ec_Ig/1000*x,'--',"DisplayName","M_1(\phi)=\phi \cdot E_c*I_g = \phi \cdot"+ sprintf("%.3e",Column1.Ec_Ig/1000));
add_dataTip(P, 2 , ["\phi_{cr}","M_{1}"],'southeast');
P.DataTipTemplate.DataTipRows(1) = [];

P = plot(x, Column1.Ec_It/1000*x,'--',"DisplayName","M_2(\phi)=\phi \cdot E_c*I_t = \phi \cdot"+ sprintf("%.3e",Column1.Ec_It/1000));
add_dataTip(P, 2 , ["\phi_{cr}","M_{2}"],'southwest');
P.DataTipTemplate.DataTipRows(1) = [];

% P = plot(x, Column1.Ec_Ie/1000*2*x,'--',"DisplayName","M_3(\phi)=2*\phi*E_c*I_{e}");
% add_dataTip(P, 2 , ["\phi_{cr}","M_{3}"],'southeast');
% P.DataTipTemplate.DataTipRows(1) = [];

slope = Column1.Moment(Column1.id.et)/Column1.Curvature(Column1.id.et)/1000;
P = plot(x, slope*x,'--',"DisplayName","M_{model}(\phi)= \phi \cdot"+ sprintf("%.3e",slope));
xlim([0,1*10^-5]);
% print_figure("10 Measuring Effective Flexural Stiffness");

%% (PRINTED) Figure 1 Part v Bilinear and Four-Linear
close all; clc;
for Column = Column1
    plot_moment_curvature([Column],1); 
    phi = Column.Curvature;
    M = Column.Moment/1000;
    E_y = Column.My/Column1.Py;
    phi_y = Column.Mn/E_y;
    
    bilinear_x = [0, phi_y, Column.Po, Column.Pul]; % Bilinear Points
    bilinear_y = [0, Column.Mn, Column.Mo, Column.Mul]; % Bilinear Points
    four_x = [0,  Column.Pcr,  phi_y,  Column.Po,  Column.Pul]; % Quad Points
    four_y = [0, Column.Mcr, Column.Mn, Column.Mo, Column.Mul]; % Quad Points
    set(gca,'DefaultLineLineWidth',3)
    
    P = plot(four_x, four_y,'-p',"DisplayName","Four-Line");P.Color(4) = 0.6;
    P = plot(bilinear_x, bilinear_y,'-o',"DisplayName","Bilinear"); P.Color(4) = 0.6;
    xlim([0,15]); xticks(1:15);
end
% print_figure("11 Bilinear Quadlinear Curve");

%%
close all;clc;

E_y = Column.My/Column1.Py;
phi_y = Column.Mn/E_y;

P = plot_moment_curvature(Column1,1); legend("Location",'northwest');
add_dataTip(P, Column1.id.fy, ["\phi_{y}","M_y"],'northwest');
P.DataTipTemplate.DataTipRows(2) = [];
xlim([0,2]); xticks(1:15); legend("Location","Southeast");
add_line('x', 1, "\phi_y = 2.25\cdot \epsilon_y/D=1", 'r', 'bottom');
set(gca,'DefaultLineLineWidth',3);
four_x = [0,  Column.Pcr,  phi_y,  Column.Po,  Column.Pul]; % Quad Points
four_y = [0, Column.Mcr, Column.Mn, Column.Mo, Column.Mul]; % Quad Points
bilinear_x = [0, phi_y, Column.Po, Column.Pul]; % Bilinear Points
bilinear_y = [0, Column.Mn, Column.Mo, Column.Mul]; % Bilinear Points
    
P = plot(bilinear_x, bilinear_y,'-o',"DisplayName","Bilinear"); P.Color(4) = 0.6;
P = plot(four_x, four_y,'-p',"DisplayName","Four-Line");P.Color(4) = 0.6;
add_dataTip(P,3, ["\phi_y","M_y"],'southeast');
P.DataTipTemplate.DataTipRows(2) = [];
print_figure("11 Comparing Yield Points Bilinear Quadlinear Curve");
%%
close all; hold on; grid minor;
P = plot_moment_curvature(Column2,0); P.Color = '#D95319';
plot_moment_curvature(Column1,0)
print_figure("12 Comparing Two Not Normalized Curves");

%% (PRINTED) Figure 2 Normalized Moment Curvature 
close all; clc;
plots = plot_moment_curvature([Column1,Column2],1);

% Ultimate curvature ductility
fprintf("The section curvature ductility of Column 1 is %.2f \n", Column1.Curvature_ductility);
fprintf("The section curvature ductility of Column 2 is %.2f \n", Column2.Curvature_ductility);
% print_figure("12 Normalized Moment Curvature");

%% (PRINTED) Figure 3 M-phi envelope EQ1 EQ2 EQ2
close all; 

figure; hold on; grid on; legend('location','best'); grid minor;
[nM1, nM2, nM3, nP1, nP2 ,nP3] = readvars('..\files\Eq3.txt');

plot(nP3,nM3,"DisplayName","EQ3");
plot(nP2,nM2,"DisplayName","EQ2");
plot(nP1,nM1,"DisplayName","EQ1");
plot([-flip(Column1.Normalized_P),Column1.Normalized_P],[-flip(Column1.Normalized_M), Column1.Normalized_M],'r',"DisplayName","Monotonic M-\phi Envelope","LineWidth",3);

title("Normalized Moment Curvature");
ylabel("Normalized Moment $\frac{M}{D^3\cdot f'_c}$","Interpreter","latex"); 
xlabel(" Normalized Curvature $\frac{\phi \cdot D}{\lambda\epsilon_y}$","Interpreter","latex"); 
set(gcf, 'Position', [0, 800, 1300,500]); xlim([-13 13]);xticks(-14:2:14);
print_figure("13 Monotonic Envelope");

%% (PRINTED) Figure 4 Double Longitudinal Rebar
clc; close all;
P = plot_moment_curvature([Column1,Column3],1);
P(1).DisplayName = '1* Longitudinal Rebar';
add_dataTip(P(1), Column1.id.fy, ["\phi_y","M_y"],'southeast');
add_all_dataTips(Column3,1)
P = add_line('x', 1, '\phi_y = 2.25*\epsilon_y/D', 'k--', 'top'); P.LabelHorizontalAlignment ='center';
add_markers([Column1,Column3],1); % Adds the markers
ylim([0, inf]);  xticks(1:15);
print_figure("14 Double Longitudinal Rebar");

%% (PRINTED) Figure 4 Report
clc;
fprintf("\nFor Column 1:\nMn = %.3g kip-in \nMo = %.3g kip-in \nThe ratio is %.2f\n",  Column1.Mn,Column1.Mo,Column1.Mn/Column1.Mo);
fprintf("\nFor Column 1:\nMn = %.3g kip-in \nMo = %.3g kip-in \nThe ratio is %.2f\n",  Column3.Mn,Column3.Mo,Column3.Mn/Column3.Mo);

fprintf('\nBetween the two columns, Mn2/Mn1 = %.2f', Mn2/Mn1);
fprintf('\nBetween the two columns, Mo2/Mo1 = %.2f', Mo2/Mo1);

% Ultimate Curvature Ratios
fprintf("\n\nThe section curvature ductility of Column 1 is %.2f \n", Column1.Curvature_ductility);
fprintf("The section curvature ductility of Column 2 is %.2f \n", Column3.Curvature_ductility);
% Ratio of flexural stiffness
fprintf("\nThe flexural stiffness ratio of Column 1 is %.2f \n", Column1.Ec_Ie / Column1.Ec_Ig);
fprintf("The flexural stiffness ratio of Column 2 is %.2f \n", Column3.Ec_Ie / Column3.Ec_Ig);

%% (PRINTED) Figure 5 Increased Axial Load Moment Curvature
close all; clc;
list_of_columns = [Column1, Column4, Column5, Column6];
P = plot_moment_curvature(list_of_columns, 1); % Plots the moment curvature
plot_approx_curve(list_of_columns); 
add_markers(list_of_columns,1); % Adds the markers
add_line('x', 1, '\phi_y = 2.25*\epsilon_y/D', 'r--', 'top');
for p = P; p.Color(4) = 0.4; end
P(1).DisplayName = '1*Axial Force = 522 kip'; 
xlim([0,2]); legend("Location","southeast")
print_figure("15 Increased Axial Load Yield");

%% (PRINTED) Figure 5 (Full)
close all; clc;
list_of_columns = [Column1, Column4, Column5, Column6];
P = plot_moment_curvature(list_of_columns, 1); % Plots the moment curvature
add_markers(list_of_columns,1); % Adds the markers
% add_line('x', 1, '\phi_y = 2.25*\epsilon_y/D', 'r--', 'top');
P(1).DisplayName = '1*Axial Force = 522 kip'; 
print_figure("16 Increased Axial Load Full Picture");

%% (PRINTED) Figure 6 Increased Axial Load Stiffness
close all; clc;
plot_figure6([Column1, Column4, Column5, Column6]); 
add_line('y', 0.5, 'ACI Reccomendation', 'r', 'top');
ylim([0.3 inf]);
print_figure("17 Increased Axial Load Stiffness Modifier");

%% (PRINTED) Figure 7
close all; clc;
plot_figure7([Column1, Column4, Column5, Column6]); 
print_figure("18 Increased Axial Load Ultimate Ductility");

%% (PRINTED) Figure 8
close all; clc;
plot_figure8([Column1, Column7, Column8]); 
print_figure("19 Increased Axial Load Hoop Ratio");

%% (PRINTED) Figure 9
close all; clc; 
for Column = Column1
    lp1 = Column.Confined_Concrete.lp1; % [in]; height of plastic hinge 1
    height = Column.height; % [in]; overall height 
    no_levels = 8; % 
    
    height_levels = (height-lp1)*(1:no_levels)/no_levels + lp1;
    height_levels = [0, lp1, height_levels]';
    ratio = height_levels/height;

    subplot(1,2,1); grid minor; hold on; title('First-Order Bending Moment Diagram'); ylabel('Height [in]','Interpreter','latex'); xlabel('Moment [kip-in]','Interpreter','latex'); grid(); legend();
    Mn_list = Column.Mn*(1-ratio);
    Mo_list = Column.Mo*(1-ratio);
    plot(Mo_list/Column.norm_M/1000,height_levels,'-o','Color','#D95319','LineWidth',2,'DisplayName','M^o'); 
    plot(Mn_list/Column.norm_M/1000,height_levels,'-o','Color','#4DBEEE','LineWidth',2,'DisplayName','M_n'); 
 
    subplot(1,2,2);grid minor; hold on; title('Curvature Diagram'); ylabel('Height [in]','Interpreter','latex'); xlabel('Normalized Curvature $\frac{\phi \cdot D}{\lambda \epsilon_y}$','Interpreter','latex'); grid(); legend();
    phi_n = find_curvature_of(Column, Mn_list, 1);
    phi_o = find_curvature_of(Column, Mo_list, 1);
    plot(phi_o,height_levels,'-o','LineWidth',2,'Color','#D95319','DisplayName','M^o');
    plot(phi_n,height_levels,'-o','LineWidth',2,'Color','#4DBEEE','DisplayName','M_n');      
    set(gcf, 'Position',  [0, 800, 1300,500]); 
end
print_figure("20 Moment-Curvature Along Element");

%% (PRINTED) Figure 10
% close all; clc;
test_moment_curvature(Column1)
% print_figure("21a Moment Curvature Approximations");
[Force_real, Delta_real] = plot_force_displacement_real(Column1);
% print_figure("21b Force Displacements");
[Force_approx, Delta_approx] = plot_force_displacement_approx(Column1);
% print_figure("21c Force Displacements Approximate");
%% (PRINTED) Figure 11
close all;
figure; hold on; grid on; legend('location','northwest'); grid minor;
xline(0,"HandleVisibility",'off');
yline(0,"HandleVisibility",'off');
[V_W1, V_W2, V_W3, d_L1, d_L2, d_L3 ] = readvars('..\files\Dynamic_EQ.txt');
P = plot(d_L3,V_W3,"DisplayName","EQ1","LineWidth",2); P.Color(4) = 0.5;
P = plot(d_L2,V_W2,"DisplayName","EQ2","LineWidth",2); P.Color(4) = 0.5;
P = plot(d_L1,V_W1,"DisplayName","EQ3","LineWidth",2); P.Color(4) = 0.5;

V_W = Force_real / Column1.applied_force;
d_L = Delta_real / Column1.height;
P = plot([-flip(d_L),d_L],[-flip(V_W),V_W],"DisplayName","Model F-\Delta Envelope","LineWidth",3); 

V_W = Force_approx / Column1.applied_force;
d_L = Delta_approx / Column1.height;
P = plot([-flip(d_L),d_L],[-flip(V_W),V_W],"DisplayName","Approximated F-\Delta Envelope","LineWidth",3); 

xlabel("Drift Ratio \delta/L"); ylabel("Base Shear Ratio V/W"); title("Drift Ratio Versus Base Shear");
xlim([-.05,0.05]);
set(gcf, 'Position',  [0, 800, 1300,500])
% print_figure("22 Dynamic Envelope");

% close all;
%%
clc;
print_id(Column1); disp(newline)
print_id(Column4); disp(newline)
print_id(Column5); disp(newline)
print_id(Column6); disp(newline)
find_curvature_of(Column1, 53400001,0)
%% Function
% Add individual Data tips
function add_dataTip(plot, n, name,location)
    plot.DataTipTemplate.DataTipRows(1).Label = name(1);
    plot.DataTipTemplate.DataTipRows(1).Format = '%.3g';
%     plot.DataTipTemplate.DataTipRows(2) = []
    plot.DataTipTemplate.DataTipRows(2).Label = name(2);
    plot.DataTipTemplate.DataTipRows(2).Format = '%.3g';
    datatip(plot, 'DataIndex', n,'Location',location);
end

function add_all_dataTips(list_of_columns, normalized)
    arguments
        list_of_columns
        normalized = false
    end
    
    for Column = list_of_columns
        if normalized == false
            phi = Column.Curvature; 
            M = Column.Moment/1000;
        else
            M = Column.Moment/(Column.Section.diameter^3*Column.Confined_Concrete.fc);
            phi = Column.Curvature*Column.Section.diameter/Column.Section.lamba/Column.Long.ey;
        end
        id = find_points(Column);
        P = plot(phi,M); add_dataTip(P, id.et, ["\phi_{cr}","M_{cr}"],'southeast'); P.HandleVisibility= 'off'; P.Color(4) = 0;
        P = plot(phi,M); add_dataTip(P, id.fy, ["\phi_y","M_y"],'southeast'); P.HandleVisibility= 'off'; P.Color(4) = 0;
        P = plot(phi,M); add_dataTip(P, id.ACI, ["\phi_{n,ACI}","M_{n,ACI}"],'southeast'); P.HandleVisibility= 'off'; P.Color(4) = 0;
        P = plot(phi,M); add_dataTip(P, id.Mn, ["\phi_n","M_n"],'northeast'); P.HandleVisibility= 'off'; P.Color(4) = 0;
        P = plot(phi,M); add_dataTip(P, id.Spalling, ["\phi_{spalling}","M_{spalling}"],'southeast'); P.HandleVisibility= 'off'; P.Color(4) = 0;
        P = plot(phi,M); add_dataTip(P, id.Max, ["\phi^o","M^o"],'southwest'); P.HandleVisibility= 'off'; P.Color(4) = 0;
        P = plot(phi,M); add_dataTip(P, id.End, ["\phi_{ul}","M_{ul}"],'southeast'); P.HandleVisibility= 'off'; P.Color(4) = 0;  
    end
end

function id = find_points(Column)
    [~, id.et] = min(abs(Column.Confined_Concrete.et- Column.Concrete_strain(:,2)));

    [~, id.fyc] = min(abs(Column.Confined_Concrete.ec- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.fys] = min(abs(Column.Long.ey- Column.Steel_strain(:,1)));
    id.fy = min(id.fyc,id.fys);

    [~, id.ACI] = min(abs(-0.003- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.Mn] = min(abs(-0.004- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.Spalling] = min(abs(-0.006- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.Max] = max(Column.Moment);
    id.End = length(Column.Moment);

    if (Column.Steel_strain(end,1) - 0.06) <= 0.0001
        id.end_marker = "d";
    elseif (Column.Concrete_strain(end,25) + 0.02) <=0.0001
        id.end_marker = "s";
    end
    
end

function print_id(Column)
%     clc;
    [~, id.et] = min(abs(Column.Confined_Concrete.et- Column.Concrete_strain(:,2)));

    [~, id.fyc] = min(abs(Column.Confined_Concrete.ec- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.fys] = min(abs(Column.Long.ey- Column.Steel_strain(:,1)));
    id.fy = min(id.fyc,id.fys);

    [~, id.ACI] = min(abs(-0.003- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.Mn] = min(abs(-0.004- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.Spalling] = min(abs(-0.006- Column.Concrete_strain(:,Column.Section.no_of_fibers)));
    [~, id.Max] = max(Column.Moment);
    id.End = length(Column.Moment);
    
    pts = ["Cr", "Y", "ACI", "Mn", "Sp", "Mo", "Mu"];
    ids = [id.et, id.fy, id.ACI, id.Mn, id.Spalling, id.Max, id.End];
    [ids, sort_order] = sort(ids);
    pts = pts(sort_order);
    
%     fprintf("%3s \t %3.0f \t %7.2e \t %.2e \n", [pts; ids; Column.Curvature(ids); Column.Moment(ids)]);
%     fprintf('\n');
    fprintf("%3s \t %3.0f \t %7.2f \t %7.4f \n", [pts; ids; Column.Normalized_P(ids); Column.Normalized_M(ids)]);
%     fprintf("(%.2f, %.4f)\n", [Column.Normalized_P(ids); Column.Normalized_M(ids)]);
end

function plots = plot_steel_stress(Column, title_name)
    
    figure; hold on; title(title_name)
    set(gca,'DefaultLineLineWidth',2)
    Column.Steel_stress = Column.Steel_stress/1000;
    plots= [];
    P = plot(Column.Curvature,Column.Steel_stress(:,1),"DisplayName","Fiber 1"); plots = [ plots,P];
    P = plot(Column.Curvature,Column.Steel_stress(:,2),"DisplayName","Fiber 2"); plots = [ plots,P];
    P = plot(Column.Curvature,Column.Steel_stress(:,3),"DisplayName","Fiber 3"); plots = [ plots,P];
    P = plot(Column.Curvature,Column.Steel_stress(:,4),"DisplayName","Fiber 4"); plots = [ plots,P];
    P = plot(Column.Curvature,Column.Steel_stress(:,5),"DisplayName","Fiber 5"); plots = [ plots,P];
    
    set(gcf, 'Position',  [0, 800, 1300,500])
    grid on; legend("Location","east");
    ylabel("Stress [ksi]"); xlabel("Curvature [1/in]");
end

function P = add_line(x_or_y, value, label, color, position)
    arguments
        x_or_y
        value
        label
        color = 'k'
        position = 'bottom'
    end
    if x_or_y == 'x'
        P = xline(value, color, label,'HandleVisibility','off','LabelOrientation','horizontal','LabelVerticalAlignment',position);
    else
        P = yline(value, color, label,'HandleVisibility','off','LabelOrientation','horizontal','LabelVerticalAlignment',position);
    end
end

function add_markers(list_of_columns, normalized)
    arguments
        list_of_columns
        normalized = false
    end
    markers = ['o','p','h','d','s']; i =1;
    col = [	[0, 114, 189]; [217, 83, 25];[237, 177, 32]; [119, 172, 48]; [162, 20, 47]]/255;
    for Column = list_of_columns
        pt_x = [Column.Pcr, Column.Py, Column.PACI, Column.Pn, Column.Ps, Column.Po];
        pt_y = [Column.Mcr, Column.My, Column.MACI, Column.Mn, Column.Ms, Column.Mo];
        if normalized == false
            scatter(pt_x/Column.norm_P, pt_y/Column.norm_M,100,col(i), markers(i,:),'filled','HandleVisibility', 'off');
            scatter(Column.Curvature(end)/Column.norm_P,Column.Moment(end)/Column.norm_M,140,col(i,:),Column.end_marker,'filled', 'HandleVisibility', 'off'); 
        else
            scatter(pt_x, pt_y, 100,col(i,:), markers(i) ,'filled', 'HandleVisibility', 'off');
            scatter(Column.Pul,Column.Mul,140,col(i,:),Column.end_marker,'filled', 'HandleVisibility', 'off');
        end
        i = i + 1;  
    end
end

function plots = plot_figure6(list_of_columns)
    figure; grid on; grid minor; hold on; plots= [];
    for Column = list_of_columns
        P = scatter(Column.Axial_load_ratio, Column.Ec_Ie/Column.Ec_Ig,140,'p','filled','DisplayName' ,Column.name);
        P.DataTipTemplate.DataTipRows(1) = dataTipTextRow('P/(A_g*f_c)',Column.Axial_load_ratio,'%.3g');          
        P.DataTipTemplate.DataTipRows(2) = dataTipTextRow('(E_cI_e/E_cI_g)',Column.Ec_Ie/Column.Ec_Ig,'%.2f');  
        datatip(P,'DataIndex',1);
        plots = [plots, P];
    end
    plots(1).DisplayName = '1*Axial Force = 522 kip'; 
    legend('Location','southeast');
    xlabel('Axial Load Ratio $\frac{P}{A_g \cdot f_c}$','Interpreter','latex');
    ylabel('Stiffness Modified $\frac{E_c \cdot I_e}{E_c \cdot I_g}$','Interpreter','latex');
    title('Flexure Rigidity Per Axial Load Ratio')
    set(gcf, 'Position',  [0, 800, 1300,500])
end

function plots = plot_figure7(list_of_columns)
    figure; grid on; grid minor; hold on; plots= [];
    for Column = list_of_columns
        P = scatter(Column.Axial_load_ratio,Column.Curvature_ductility,'DisplayName' ,Column.name);
        plots = [plots, P];
        P.DataTipTemplate.DataTipRows(1) = dataTipTextRow('P/(A_g*f_c)',Column.Axial_load_ratio,'%.3g');          
        P.DataTipTemplate.DataTipRows(2) = dataTipTextRow('\mu_{\phiu}',Column.Curvature_ductility,'%.2f');  
        datatip(P,'DataIndex',1);
    end
    plots(1).DisplayName = '1*Axial Force = 522 kip'; 
    title('Ultimate Curvature Ductility Per Axial Load Ratio')
    legend('Location','northeast');

    xlabel('Axial Load Ratio $\frac{P}{A_g \cdot f_c}$','Interpreter','latex');
    ylabel('Ultimate Ductility $\frac{\phi_{ul} \cdot D}{\lambda\epsilon_y}$','Interpreter','latex');
    set(gcf, 'Position',  [0, 800, 1300,500])
end

function plots = plot_figure8(list_of_columns)
    figure(8); grid on; grid minor; hold on; plots= [];
    for Column = list_of_columns
        P = scatter(Column.Axial_load_ratio,Column.Hoop.rho,140,'p','filled','DisplayName' ,Column.name);
        P.DataTipTemplate.DataTipRows(1) = dataTipTextRow('\rho_{hoop}',Column.Hoop.rho,'%.3g');          
        P.DataTipTemplate.DataTipRows(2) = dataTipTextRow('P/(A_g*f_c)',Column.Axial_load_ratio,'%.3g');  
        P.DataTipTemplate.DataTipRows(3) = dataTipTextRow('\mu_{\phiu}',Column.Curvature_ductility,'%.2f');   
        datatip(P,'DataIndex',1);
        plots = [plots, P];
    end
    plots(1).DisplayName = '1*Axial Force = 522 kip'; 
    title('Hoop Ratio Per Axial Load Ratio')
    legend('Location','southeast');
    ylabel('\rho_{hoop}');
    xlabel('Axial Load Ratio $\frac{P}{A_g \cdot f_c}$','Interpreter','latex');
    set(gcf, 'Position',  [0, 800, 1300,500]);
end

function plots = plot_approx_curve(list_of_columns , normalized, option)
    arguments
        list_of_columns
        normalized = true
        option = false
    end  
    plots = [];
    col = [	"#0072BD",	"#D95319",	"#EDB120", "#77AC30", 	"#A2142F"];
    i = 1;
    for Column = list_of_columns
        if normalized == false
            p_factor = 1/ Column.norm_P;
            m_factor = 1/Column.norm_M/1000;
        else
            p_factor = 1;
            m_factor = 1;    
        end
        x = [0, Column.Py Column.Mn/Column.Ec_Ie_n, Column.Pn]*p_factor;
        y = [0, Column.My, Column.Mn, Column.Mn]*m_factor;
        P = plot(x,y,'Color',col(i),"HandleVisibility",'off','LineWidth',2);
        datatip(P,'DataIndex',3,'Location','northwest');

        i = i + 1;

        if option == true
            P.DataTipTemplate.DataTipRows(1).Label = '\phi';
            P.DataTipTemplate.DataTipRows(1).Format = '%.2e';
            P.DataTipTemplate.DataTipRows(2).Label = 'M';
            P.DataTipTemplate.DataTipRows(2).Format = '%.0f';
            datatip(P,'DataIndex',2,'Location','northwest');
            datatip(P,'DataIndex',3,'Location','northwest');
            datatip(P,'DataIndex',4,'Location','northwest');
        else
            P.DataTipTemplate.DataTipRows(1).Label = '\phi_y';
            P.DataTipTemplate.DataTipRows(1).Format = '%.2f';
            P.DataTipTemplate.DataTipRows(2) = [];
        end
        plots = [plots,P];
    end
end

function curvature = four_line(Column, list_of_moments, normalized)
    arguments
        Column
        list_of_moments
        normalized = false
    end
    if normalized == false
        p_factor = 1/ Column.norm_P;
        m_factor = 1/Column.norm_M;
    else
        p_factor = 1;
        m_factor = 1;    
    end
    list_of_moments = reshape(list_of_moments,[numel(list_of_moments),1]);
    
    Pcr = Column.Pcr*p_factor;
    Pn = Column.Mn/(Column.My/Column.Py)*p_factor;
    Po = Column.Po*p_factor;
    Pul = Column.Pul*p_factor;
    
    Mcr = Column.Mcr*m_factor;
    Mn =  Column.Mn*m_factor;
    Mo = Column.Mo*m_factor;
    Mul = Column.Mul*m_factor;
    
    curvature = zeros(numel(list_of_moments),1);
    i = 1;
    for moment = list_of_moments'
        if 0<= moment && moment<= Mcr
            m = (Mcr- 0)/(Pcr - 0);
            curvature(i) = (moment - 0)/m + 0;
        elseif Mcr<= moment && moment<= Mn
            m = (Mn- Mcr) /(Pn - Pcr);
            curvature(i) = (moment - Mcr)/m + Pcr;
        elseif Mn<= moment && moment<= Mo
            m = (Mo- Mn) /(Po - Pn);
            curvature(i) = (moment - Mn)/m + Pn;
        elseif Mo<= moment && moment<= Mul
            m = (Mul- Mo) /(Pul - Po);
            curvature(i) = (moment - Mo)/m + Po;
        else
            curvature(i) = Pul;
        end
        i = i+1;
    end

end

function phi = find_curvature_of(Column, list_of_moments, normalized)
    arguments
        Column
        list_of_moments
        normalized = false
    end
    list_of_moments = reshape(list_of_moments,[1,numel(list_of_moments)]);
    
    if normalized == true
        V = list_of_moments';
        N = Column.Normalized_M';
        A = repmat(N,[1 length(V)]);
        [~,ids] = min(abs(A-V'));
        phi = Column.Normalized_P(ids);
    else 
        V = list_of_moments';
        N = Column.Moment';
        A = repmat(N,[1 length(V)]);
        [~,ids] = min(abs(A-V'));
        phi = Column.Curvature(ids);
    end
end

function test_moment_curvature(Column)
        moment = 1:600000:Column.Mul/Column.norm_M;
        curvature = zeros(1,numel(moment));
        curvature_approx = zeros(1,numel(moment));
        for i = 1:numel(moment)
            curvature(i) = find_curvature_of(Column, moment(i));
            curvature_approx(i) = four_line(Column, moment(i), 0);
        end
        figure(); hold on;
        plot(curvature_approx,moment/1000,'-','LineWidth',2,"DisplayName","Approximate 4 Line Curve"); grid on;
        plot(curvature,moment/1000,'-','LineWidth',2,"DisplayName","Real M-\phi Curve");
        title("Moment Curvature"); legend("Location","Best");
        ylabel("Moment [kip-in]"); xlabel("Curvature [1/in]"); 
        set(gcf, 'Position',  [0, 800, 1300,500])
end

function [V_minus_P_delta, displacements] = plot_force_displacement_real(Column)
    clc;
    % Find moments along the curve
    lp1 = Column.Confined_Concrete.lp1; % [in]; height of plastic hinge 1
    lp2 = Column.Confined_Concrete.lp2; % [in]; height of plastic hinge 2
    height = 24*12; % [in]; overall height 
    no_levels = 4; % Numer
    
    height_levels = (height-lp1)*(1:no_levels)/no_levels + lp1;
    height_levels = [0, lp1, height_levels]';
    ratio = (1-height_levels/height);
    height_levels(2) = lp1 + lp2;
    arm = [ height ,(height-lp1)/no_levels/2.*(2*no_levels-1:-2:1)];
    widths = [lp1+lp2 , (height-lp1)/no_levels*ones(1,no_levels)];
    i = 1;
    
%     moments_points = [0, Column.Mcr, Column.My, Column.MACI, Column.Mn, Column.Ms, Column.Mo, Column.Mul] /Column.norm_M;
    moments_points = 1:600000:Column.Mul/Column.norm_M;
    displacements = zeros(1,numel(moments_points));
   
    for moment_base = moments_points
        level_moment = moment_base * ratio;
        curvature = find_curvature_of(Column, level_moment', 0);
        mean_curvature = mean([curvature(1:end-1);curvature(2:end)]);
        mean_curvature(1) = curvature(1);
        displacements(i) = sum(mean_curvature.* widths .*arm);
        i = i + 1;
    end
    
    P = -Column.total_axial_load;
    P_Delta = P*displacements/height;
    
    V = moments_points/ height;
    V_minus_P_delta = V - P_Delta;
    
    figure(); hold on;
    plot(displacements,V/1000,'-o',"DisplayName","F:\Delta");
    plot(displacements,V_minus_P_delta/1000,'-o',"DisplayName","F:\Delta - P\Delta Effect");
    plot(displacements,P_Delta/1000,'-o',"DisplayName","P\Delta Effect");
    xlabel('Lateral Displacement \Delta [in]'); ylabel('Force [kips]'); title('Force Displacement Curve');grid on;
    legend("Location","best");
    set(gcf, 'Position',  [0, 800, 1300,500])
end

function [V_minus_P_delta, displacements_approx] = plot_force_displacement_approx(Column)
        % Find moments along the curve
        lp1 = Column.Confined_Concrete.lp1; % [in]; height of plastic hinge 1
        lp2 = Column.Confined_Concrete.lp2; % [in]; height of plastic hinge 2
        height = Column.height; % [in]; overall height 
        no_levels = 4; % Numer

        height_levels = (height-lp1)*(1:no_levels)/no_levels + lp1;
        height_levels = [0, lp1 + lp2, height_levels]';
        ratio = (1-height_levels/height);
        arm = [ height ,(height-lp1)/no_levels/2.*(2*no_levels-1:-2:1)];
        widths = [lp1+lp2 , (height-lp1)/no_levels*ones(1,no_levels)];
        i = 1;

        moments_points = 1:600000:Column.Mul/Column.norm_M;
        displacements_approx = zeros(1,numel(moments_points));

        for moment_base = moments_points
            level_moment = moment_base * ratio;
            curvature_approx = four_line(Column, level_moment,0);
            mean_curvature_approx = mean([curvature_approx(1:end-1)';curvature_approx(2:end)']);
            
            mean_curvature_approx(1) = curvature_approx(1);
            displacements_approx(i) = sum(mean_curvature_approx.* widths .*arm);
            i = i + 1;
        end

        P = -Column.total_axial_load;
        V = moments_points/ height;
        P_Delta = P*displacements_approx/height;
        V_minus_P_delta = V - P_Delta;
       
        figure(); hold on;
        plot(displacements_approx,V/1000,'-o',"DisplayName","F:\Delta");
        plot(displacements_approx,V_minus_P_delta/1000,'-o',"DisplayName","F:\Delta - P\Delta Effect");
        plot(displacements_approx,P_Delta/1000,'-o',"DisplayName","P\Delta Effect");
        xlabel('Lateral Displacement \Delta  [in]'); ylabel('Force [kips]'); title('Force Displacement Curve Using Approximate 4-Pt M\phi Curve');grid on;
        legend("Location","best");
        set(gcf, 'Position',  [0, 800, 1300,500])
end

function plots = plot_moment_curvature(list_of_columns, normalized)
    arguments
        list_of_columns
        normalized = false
    end
    plots = [];
%     figure; 
    hold on; grid on; grid minor; legend("Location","Best");
    col = [	"#0072BD",	"#D95319",	"#EDB120", "#77AC30", 	"#A2142F"];
    i = 1;
    for Column = list_of_columns
        id = find_points(Column);
        if normalized == false
            title("Moment Curvature")
            ylabel("Moment [kip-in]"); xlabel("Curvature [1/in]");
            P = plot(Column.Curvature, Column.Moment/1000,'Color',col(i),'DisplayName',Column.name,"LineWidth",3);P.Color(4) = 0.6;
            plots = [plots,P];
        else
            title("Normalized Moment Curvature")
            ylabel("Normalized Moment $\frac{M}{D^3\cdot f'_c}$","Interpreter","latex"); 
            xlabel(" Normalized Curvature $\frac{\phi \cdot D}{\lambda\epsilon_y}$","Interpreter","latex"); 
            M_factor = 1/(Column.Section.diameter^3*Column.Confined_Concrete.fc);
            phi_factor = Column.Section.diameter/Column.Section.lamba/Column.Long.ey;
            P = plot(Column.Curvature* phi_factor, Column.Moment*M_factor,'Color',col(i),'DisplayName',Column.name,"LineWidth",3);P.Color(4) = 0.6;
            plots = [plots,P];
        end
        i = i+1;
    end
set(gcf, 'Position',  [0, 800, 1300,500])
xlim([0, inf]);
end

function print_figure(file_name)
    % Saves the figures in a consistent manner
    orient(gcf,'landscape');
    folder = '..\figures\';
    name = 'Figure ' +string(file_name);
    print(folder+name,'-dpdf','-fillpage','-PMicrosoft Print to PDF','-r600','-painters')
    print(folder+name,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters')
end