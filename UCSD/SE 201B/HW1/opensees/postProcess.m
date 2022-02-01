%% POST PROCESSOR FOR HW 1 (SE 201B: NONLINEAR STRUCTURAL ANALYSIS)

% Run this file in the same folder as run.tcl

% Run this file after running the code run.tcl in OpenSees. The text
% files generated in the process will be loaded and used for plotting.

close all
clc

%% INPUT
matDef = 'uniaxialMaterial Steel02 1 29.332482664456787 30000. 0.02 3. 0.5 0.15 0. 1. 0. 1. 0.';
L = 60;
A = 10.216981781666002;
localOpenSeesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe"; % full path to OpenSees executable
analysisType = 'Transient'; % Choose between 'Static' & 'Transient'
algorithm = 'Newton'; % Choose between 'Newton', 'ModifiedNewton', and 'ModifiedNewton -intial'
%% PLOT
switch analysisType
    case 'Transient'
        U_TH = load(['Results/disp_' analysisType '_' algorithm '.txt']);
        U = U_TH(:,2);
        t = U_TH(:,1);
        R_TH = load(['Results/res_' analysisType '_' algorithm '.txt']);
        R = -R_TH(:,2);
        V_TH = load(['Results/vel_' analysisType '_' algorithm '.txt']);
        V = V_TH(:,2);
        A_TH = load(['Results/acc_' analysisType '_' algorithm '.txt']);
        Ac_total = A_TH(:,2);
        
        % Time Histories
        figure();
        subplot(3,1,1);
        plot(t,U,'b','LineWIdth',2);
        indexmax = find(max(abs(U)) == abs(U));
        Umax = U(indexmax);
        tmax = t(indexmax);
        hold on
        plot(tmax,Umax,'ro','MarkerFaceColor','r')
        text(tmax,Umax,sprintf('  u_{rel, max} = %1.3f in',abs(Umax)),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',12,'FontWeight','Bold');
        ylabel('u_{relative}(t)');
        set(gca,'XTick',[]);
        set(gca,'YLim',[-abs(Umax)-4,abs(Umax)+4])
        set(gca,'XLim',[0 t(end)])
        title('Time Histories');
        set(gca,'FontSize',18,'FontWeight','Bold')
        
        subplot(3,1,2);
        plot(t,V,'b','LineWIdth',2);
        indexmax = find(max(abs(V)) == abs(V));
        Vmax = V(indexmax);
        tmax = t(indexmax);
        hold on
        plot(tmax,Vmax,'ro','MarkerFaceColor','r')
        text(tmax,Vmax,sprintf('  v_{rel, max} = %1.3f in/s',abs(Vmax)),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',12,'FontWeight','Bold');
        ylabel('v_{relative}(t)');
        set(gca,'XTick',[]);
        set(gca,'YLim',[-abs(Vmax)-10,abs(Vmax)+10])
        set(gca,'XLim',[0 t(end)])
        set(gca,'FontSize',18,'FontWeight','Bold')
        
        subplot(3,1,3);
        plot(t,Ac_total,'b','LineWIdth',2);
        indexmax = find(max(abs(Ac_total)) == abs(Ac_total));
        Amax = Ac_total(indexmax);
        tmax = t(indexmax);
        hold on
        plot(tmax,Amax,'ro','MarkerFaceColor','r')
        text(tmax,Amax,sprintf('  a_{abs, max} = %1.3f in/s^2',abs(Amax)),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',12,'FontWeight','Bold');
        ylabel('a_{absolute}(t)');
        xlabel('Time [sec]')
        set(gca,'YLim',[-abs(Amax)-50,abs(Amax)+50])
        set(gca,'XLim',[0 t(end)])
        set(gca,'FontSize',18,'FontWeight','Bold')
        set(gcf, 'Position',  [1200,0,1300,700])
        print("..\matlab\P2\submittal\figures\"+string(21)+" Opensees A-V-U",'-dsvg','-PMicrosoft Print to PDF','-r600','-painters');
        
        % Resistance - Displacement Curve
        figure(); hold on;
        plot(U,R,'b','LineWIdth',2);
        matHyst = get_materialHysteresis(matDef, U./L, 10, localOpenSeesPath);
        plot(matHyst(:,1).*L, matHyst(:,2).*A,'k--','LineWidth',1.5)
        xlabel('U_{rel} [in]')
        ylabel('R [kips]')
        set(gca,'FontSize',18,'FontWeight','Bold'); grid on;
        legend('Linearized PO Curve b/w equilibrium pts','True F-d curve','location','best',"FontSize",14)
        title("Opensees " + analysisType + " Anlaysis " + algorithm + " Method");
        set(gcf, 'Position',  [1200,0,1300,700])
        print("..\matlab\P2\submittal\figures\"+string(21)+" Opensees "+analysisType,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters');

    case 'Static'
        U = load(['Results/disp_' analysisType '_' algorithm '.txt']);
        R = -load(['Results/res_' analysisType '_' algorithm '.txt']);
        
        % Resistance - Displacement Curve
        figure();
        plot([0;U],[0;R],'b','LineWIdth',2);
        hold on
        plot([0;U],[0;R],'ro','LineWIdth',2);
        matHyst = get_materialHysteresis(matDef, U./L, 100, localOpenSeesPath);
        plot(matHyst(:,1).*L, matHyst(:,2).*A,'k--','LineWidth',1.5)
        xlabel('U [in]')
        ylabel('R [kips]')
        legend('Linearized PO Curve b/w equilibrium pts','Equilibrium Pts','True F-d curve','location','best',"FontSize",14)
        set(gca,'FontSize',18,'FontWeight','Bold'); grid on;
        title("Opensees " + analysisType + " Anlaysis " + algorithm + " Method");
        set(gcf, 'Position',  [1200,0,1300,700])
        print("..\matlab\P2\submittal\figures\"+string(21)+" Opensees "+analysisType,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters');
end