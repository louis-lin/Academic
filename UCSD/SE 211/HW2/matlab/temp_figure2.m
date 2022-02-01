% close all; hold on;
% [fc, Ec] = get_Modulus_data();
% scatter(fc,Ec,"Displayname","Experimental Data"); 
% Ec = @(fc) 57*sqrt(fc*1000); range = 3:17;
% ylabel("Modulus of Elasticity E_c (ksi)");
% xlabel("Concrete Cylinder Compressive Strength f'_c (ksi)")
% plt = plot(range,Ec(range), 'LineWidth',5,"DisplayName","$57 \cdot \sqrt{f'_c/psi} \cdot ksi$"); plt.Color(4) = 0.3;
% plot_point(-fc_prime/1000, Ec_test/1000)
% print_figure(2)


close all; hold on;
n_test = Ec_test/(fc_prime/ec_prime)
[fc, nE] = get_nE_data();
scatter(fc,nE,'DisplayName','Power Coefficient');
range = 3:30;
nE = @(f) 1+3.6./(f); % fc is in ksi
pl = plot(range,nE(range),'b','linewidth',6,'DisplayName','Theoretical Line'); pl.Color(4) = 0.3;
plot_point(-fc_prime/1000, n_test);
xlabel("Concrete Cylinder Compressive Stregnth (ksi)"); ylabel("Coefficient n_E");
print_figure(4)

function plot_point(x,y)
    scatter(x, y,500,'red','+','LineWidth',1.5,'HandleVisibility',"off"); 
    scatter(x, y,500,'red','o','LineWidth',1.5,'HandleVisibility',"off");
    legend('Interpreter',"latex",'Location',"best"); grid on; 
end


function print_figure(no)
    % Saves the figures in a consistent manner
    orient(gcf,'landscape');
    folder = '..\figures\';
    name = 'Figure' +string(no);
    print(folder+name,'-dpdf','-fillpage','-PMicrosoft Print to PDF','-r600','-painters')
    print(folder+name,'-djpeg','-PMicrosoft Print to PDF','-r600','-painters')
end

function [fc, Ec] = get_Modulus_data()
    opts = spreadsheetImportOptions("NumVariables", 2);
    opts.Sheet = "Ec (NCHRP 496)";
    opts.DataRange = "B10:C698";
    opts.VariableNames = ["fc1", "Ec"];
    opts.VariableTypes = ["double", "double"];
    tbl = readtable("C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 211\Homework\HW 2\data\SE211 HW2 2021 Students.xlsx", opts, "UseExcel", false);
    fc = tbl.fc1; Ec = tbl.Ec;
end
function [fc, nE] = get_nE_data()
    opts = spreadsheetImportOptions("NumVariables", 2);
    opts.Sheet = "nE";
    opts.DataRange = "C4:D212";
    opts.VariableNames = ["fc1", "nE"];
    opts.VariableTypes = ["double", "double"];
    tbl = readtable("C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 211\Homework\HW 2\data\SE211 HW2 2021 Students.xlsx", opts, "UseExcel", false);
    fc = tbl.fc1; nE = tbl.nE;
end