% Lee Frame
clear; clc; close;
format shortg
%% Pre-Processing
% Set up system geometry
[Struct.nodal_coord(:,1), Struct.nodal_coord(:,2)] = readvars('.\matlab\coordinates.txt');
Struct.num_nodes = length(Struct.nodal_coord); 
% Set up connectivity
[Struct.element_connectivity(:,1), Struct.element_connectivity(:,2)] = readvars('.\matlab\connectivity.txt');
Struct.num_elems = length(Struct.element_connectivity);
% Set up structural DOF
Struct.node_dof = ones(Struct.num_nodes,3); 
Struct.node_dof(1,1:2) = 0;
Struct.node_dof(21,1:2) = 0;
Struct = define_DOF_number(Struct);
% Set up ID array, gamma_rot, and element coordinates
Struct = define_orientaion(Struct);
% Set up material properties
Struct = define_section(Struct, 30, 20, 7.2e4);
% Set up Forces
dof_load = 36;
Struct = define_point_load(Struct, dof_load , -18000, 100);

%% Run analysis
clc;
tic;
% Linear, Corotational, PD-Consistent, PD-Nonconsistent 
Analysis_1 = geomtric_analysis(Struct, 'Linear'); 
Analysis_2 = geomtric_analysis(Struct, 'Corotational');
Analysis_3 = geomtric_analysis(Struct, 'PD-Consistent');
Analysis_4 = geomtric_analysis(Struct, 'PD-Nonconsistent');
% In order to find the snap back- Increase load, larger load step
Struct = define_point_load(Struct, dof_load , -25000, 45); 
Analysis_5 = geomtric_analysis(Struct, 'Corotational');
toc;
%% Post-Processing
% Deformed Shape
plot_figure_1([Analysis_1, Analysis_2], dof_load, 1);
plot_figure_2([Analysis_1, Analysis_2], dof_load, 2);
plot_figure_3([Analysis_1, Analysis_2], dof_load, 3);
plot_figure_4([Analysis_1, Analysis_2], 4, 25);
plot_figure_5(Analysis_2,5);
plot_figure_6([Analysis_1, Analysis_2, Analysis_3],5);
plot_figure_7(Analysis_5,7,dof_load);
plot_figure_8(Analysis_5,dof_load,8);
plot_figure_9([Analysis_1,Analysis_2, Analysis_3,Analysis_4], dof_load, 2);
plot_figure_10([Analysis_1,Analysis_2, Analysis_3,Analysis_4], dof_load, 2);
plot_figure_11([Analysis_1, Analysis_3,Analysis_4], dof_load, 20);
plot_figure_12([Analysis_1, Analysis_2,Analysis_4], dof_load);
% close all;

function plot_figure_1(list_of_analysis, dof_load, figNum)
    close all; clc
    plot_load_displacement_of_node(list_of_analysis, 13, dof_load, figNum);
    print_figure("01 RU Node 13- Corotational");
end
function plot_figure_2(list_of_analysis, dof_load, figNum)
    close all; clc
    plot_load_displacement_of_node(list_of_analysis, 11, dof_load, figNum);
    print_figure("02 RU Node 11- Corotational");
end
function plot_figure_3(list_of_analysis, dof_load, figNum)
    close all; clc
    sgtitle('Rotation at Supports','FontWeight','bold', 'Fontsize',36)
    subplot(1,2,1);
    plot_load_rotation(list_of_analysis, 1, dof_load,1);
    subplot(1,2,2);
    plot_load_rotation(list_of_analysis, 59, dof_load,1);
    print_figure("03 Rotation at Supports- Corotational");
end
function plot_figure_4(list_of_analysis, figNum, num_step)
    close all; clc; 
    plot_deformed_shape(list_of_analysis, figNum, num_step);
    axis([-250,1250,-50,1250])
    print_figure("04 Matlab Deformed Shape Results- Corotational");
end
function plot_figure_5(list_of_analysis, figNum)
    close all; clc; 
    num_step = 'end';
    for Analysis = list_of_analysis
       plot_deformed_shape(Analysis, figNum, num_step);
    end
    axis([-250,1250,-50,1250])
    print_figure("05 Finding Equlibrium- Corotational");
end
function plot_figure_6(list_of_analysis, figNum)
    close all; clc; 
    plot_deformed_shape(list_of_analysis, figNum,20,0)
    axis([-250,1250,-50,1250])
    print_figure("06 Observe Structural Deformation- Corotational");
end
function plot_figure_7(list_of_analysis, figNum,dof_load)
    close all; clc; 
    plot_deformed_shape(list_of_analysis, figNum,10,0);
    axis([-300,1450,-300,1450]);
    print_figure("07 Snapback Structural Deformation- Corotational");
end
function plot_figure_8(list_of_analysis, dof_load, figNum)
    close all; clc
    sgtitle('Displacements Beneath Load Point','FontWeight','bold', 'Fontsize',36)
    subplot(1,2,1);
    plot_load_displacement(list_of_analysis, 35, dof_load,1); xlabel("Horizontal Displacement [in]");
    subplot(1,2,2);
    plot_load_displacement(list_of_analysis, 36, dof_load,1); xlabel("Veritcal Displacement [in]");
    print_figure("08 Displacement of Snapback");
end
function plot_figure_9(list_of_analysis, dof_load, figNum)
    close all; clc
    plot_load_displacement_of_node(list_of_analysis, 13, dof_load, figNum);
    set(gca,'DefaultLineLineWidth',4)
    print_figure("09 RU Node 13- Pdelta");
end
function plot_figure_10(list_of_analysis, dof_load, figNum)
    close all; clc
    plot_load_displacement_of_node(list_of_analysis, 11, dof_load, figNum);
    set(gca,'DefaultLineLineWidth',4)
    print_figure("10 RU Node 11- Pdelta");
end
function plot_figure_11(list_of_analysis, figNum, num_step)
    close all; clc; 
    plot_deformed_shape(list_of_analysis, figNum, num_step,0);
    axis([-600,1400,-200,1400])
    print_figure("11 Matlab Deformed Shape Results- Pdelta");
end
function plot_figure_12(list_of_analysis, dof_load)
    close all; clc
    sgtitle('Matlab Results','FontWeight','bold', 'Fontsize',36)
    subplot(1,2,1);
    set(gca,'DefaultLineLineWidth',4)
    plot_load_displacement(list_of_analysis, 35, dof_load,1); xlabel("Horizontal Displacement [in]");
    
    legend('Linear','Corotational','P\Delta Nonconsistent');
    subplot(1,2,2);
    set(gca,'DefaultLineLineWidth',4)
    plot_load_displacement(list_of_analysis, 36, dof_load,1); xlabel("Veritcal Displacement [in]");
    
    legend('Linear','Corotational','P\Delta Nonconsistent');
    print_figure("12 Matlab Dispalcement Node 13");
end
    

%% Main Functions
function Struct = geomtric_analysis(Struct, AnalysisType)
	Struct.name = AnalysisType;
    Struct.U_global =    zeros(Struct.num_dofs, Struct.num_loadsteps);
    Struct.dU_global =  zeros(Struct.num_dofs, Struct.num_loadsteps);
    Struct.F_internal = zeros(Struct.num_dofs, Struct.num_loadsteps);
    Struct.Beta = zeros(Struct.num_elems, Struct.num_loadsteps);
    Struct.L = zeros(Struct.num_elems, Struct.num_loadsteps);
    max_iteration = 1000;
    end_loadstep = Struct.num_loadsteps;
    fprintf('\nStarting %s analysis',Struct.name)
    % Main loop    
    for nload = 1:Struct.num_loadsteps
            itn = 0; 
            error = 1;
            while error > 1.e-5 && itn < max_iteration
                % Structural State determination
                    [K_struct, Struct] = get_struct_state(Struct, nload, AnalysisType);
                % Calculate the unbalanced force
                    P_unb = Struct.F_external(:,nload) - Struct.F_internal(:,nload);
                % Update the displacements
                    Struct.dU_global(:,nload) = K_struct\P_unb; % Calculate the delta in displacement
                    Struct.U_global(:,nload) = Struct.U_global(:,nload) + Struct.dU_global(:,nload);  %Update total/current displ.
                    itn = itn + 1; % Iteration counter 
                    error = norm(P_unb,2);
                    Struct.unbalanced_force(nload, itn) = error;
            end
            if itn == max_iteration; end_loadstep = nload;fprintf('\nThe %s analysis did not fully converged. \nThe last converged step was %d', Struct.name, end_loadstep); break; end;
            Struct.U_global(:,nload+1) = Struct.U_global(:,nload); % Seed the next global displacement
            Struct.Beta(:,nload+1) =  Struct.Beta(:,nload); % Seed the next beta 
    end
        fprintf('\nThe %s analysis was completed.\n',Struct.name)
        Struct.end_loadstep = end_loadstep; % Grab the last load step 
        % Only save up to the last converged load steps
        Struct.U_global = Struct.U_global(:,1:end_loadstep);  
        Struct.F_external = Struct.F_external(:,1:end_loadstep); 
        Struct.F_internal = Struct.F_internal(:,1:end_loadstep); 
        % Caculate the strain of the structure
        Struct = calculate_strains(Struct,Struct.end_loadstep);
end
function [K_struct, Struct] = get_struct_state(Struct, nload, AnalysisType)
    %% Extract Material Properties 
    E_ = Struct.Mat.E;
    A_ = Struct.Mat.A;
    I_ = Struct.Mat.I;
    L0_ = Struct.Mat.L0;
    ID_ = Struct.ID;
    g_rot_ = Struct.g_rot;
    Beta = Struct.Beta(:,nload);
    U_global = Struct.U_global(:,nload);
    dU_global = Struct.dU_global(:,nload); 
    % Initialize structural matrix and internal resisting force
    K_struct = zeros(Struct.num_dofs, Struct.num_dofs); % Initializes the global strucural stiffness
    F_internal = zeros(Struct.num_dofs, 1); % Initializes the internal resisting forces matrix
    % Necessary functions
    g_rbm_func = @(c,s,L) [-c, -s, 0, c,  s, 0; -s/L,  c/L, 1, s/L, -c/L, 0;-s/L,  c/L, 0, s/L, -c/L, 1]; 
    g_rbm_pd_func = @(d, L) [-1, -d/L, 0, 1,  d/L, 0; 0,  1/L, 1, 0, -1/L, 0; 0,  1/L, 0, 0, -1/L, 1]; 
    k_basic_func = @(E,A,I,L) [E*A/L, 0, 0; 0, 4*E*I/L, 2*E*I/L; 0, 2*E*I/L, 4*E*I/L];
    axial_func = @(s,c) [ s^2, -s*c, 0,-s^2,s*c,0; -s*c,c^2, 0,	s*c -c^2, 0; 0,0,0,0,0,0; -s^2,s*c,0,s^2,-s*c,0;s*c,-c^2,0,-s*c,c^2,0; 0,0,0,0,0,0];
    tran_func = @(s,c) [-2*s*c, c^2-s^2,0,	2*s*c,-c^2+s^2,0; c^2-s^2,2*s*c,0,-c^2+s^2,-2*s*c,0; 0,0,0,0,0,0; 2*s*c,-c^2+s^2,0,-2*s*c,c^2-s^2,0;-c^2+s^2,-2*s*c,0,c^2-s^2,2*s*c,0; 0,0,0,0,0,0];
    k_tan_g_func = @(Q,L,s,c) Q(1)/L*axial_func(s,c) + (Q(2)+Q(3))/L^2*tran_func(s,c);
    %% Loop over each Element
    for ele_no = 1:Struct.num_elems
        % Get the properties of the current element 
            E = E_(ele_no);
            I = I_(ele_no);
            A = A_(ele_no);
            L0 = L0_(ele_no);
            g_rot = g_rot_(:,:,ele_no);
            ID = ID_(ele_no,:);
            beta = Beta(ele_no);
        % Get the element displacement
            u_global = get_U(U_global,ID); % Extract element displacement from global matrix
            du_global = get_U(dU_global, ID); % Extract element displacement from global matrix
            u_local = g_rot*u_global'; % Transform to local displacement with the gamma_rot
            du_local = g_rot*du_global'; % Transform to local displacement with the gamma_rot
        % Define the orientation of the element
            dUx1 = u_local(4) - u_local(1); 
            dUx2 = u_local(5) - u_local(2); 
            L = ((L0 + dUx1)^2 +(dUx2)^2)^0.5; % Sqrt(Change)
            Struct.L(ele_no,nload) = L;
            c = (L0 + dUx1)/L; % Definition of cos
            s = dUx2/L; % Definition of cos
        % Find rotation of element based on previous rotation
            dbeta_dU = [dUx2/L^2; -(L0+dUx1)/L^2; 0; -dUx2/L^2; (L0+dUx1)/L^2; 0];
            dbeta = sum(dbeta_dU.*du_local);
            beta = beta + dbeta;
            Beta(ele_no) = beta;
%             beta = atan(dUx2/(L0+dUx1)); % Can also be used but will not
%             be able to handle >90 deg rotations
        % Analyze the structure
            switch AnalysisType
            case 'Corotational'
                g_rbm = g_rbm_func(c,s,L); % Calculate the rigid body mode transformation
                u_basic = [L - L0; u_local(3) - beta; u_local(6) - beta]; % Calculate basic deformation
                k_basic = k_basic_func(E, A, I, L); % Calculate the basic stiffness matrix
                f_basic = k_basic * u_basic; % Calculate the basic forces
                f_global = g_rot' * g_rbm' *f_basic ; % Transform to global forces
                k_tan_g = k_tan_g_func(f_basic, L,s,c); % Calcualte the geometric tangent stiffness
                k_tan_m = g_rbm'*k_basic*g_rbm; % Calculate the material tangent stiffness
                k_local = k_tan_g + k_tan_m; % Calculate the tangent local stiffness
                k_global = g_rot' * k_local * g_rot; % Transform to global stiffness
            case 'PD-Consistent'
                g_rbm = g_rbm_pd_func(dUx2, L0); % Calculate the rigid body mode transformation for PD
                u_basic = [dUx1 + dUx2^2/2/L0; u_local(3) - dUx2/L0; u_local(6) - (dUx2)/L0]; % Calculate basic deformation
                k_basic = k_basic_func(E, A, I, L0); % Calculate the basic stiffness matrix
                f_basic = k_basic * u_basic;
                f_global = g_rot' *g_rbm' *f_basic  ; % Transform to global forces
                k_tan_g = f_basic(1)/L0*axial_func(s,c);
                k_local = k_tan_g + g_rbm' * k_basic * g_rbm;
                k_global = g_rot' * k_local * g_rot; % Transform to global stiffness
            case 'PD-Nonconsistent'
                g_rbm_lin = g_rbm_func(1,0,L0); % Calculate the rigid body mode transformation for PD
                g_rbm = g_rbm_pd_func(dUx2, L0);
                u_basic = [dUx1; u_local(3) - dUx2/L0; u_local(6) - (dUx2)/L0]; % Calculate basic deformation
                k_basic = k_basic_func(E, A, I, L0); % Calculate the basic stiffness matrix
                f_basic = k_basic * u_basic;
                f_global = g_rot' * g_rbm' * f_basic; % Transform to global forces
                k_tan_g = f_basic(1)/L0*axial_func(s,c);
                k_local = k_tan_g + g_rbm_lin' * k_basic * g_rbm_lin; %
%                 Another PD- assumption that is equivalent
%                 k_local = k_tan_g + g_rbm' * k_basic * g_rbm_lin;
                k_global = g_rot' * k_local * g_rot; % Transform to global stiffness
            case 'Linear'
                g_rbm = g_rbm_func(1,0,L0); % Calculate the rigid body mode transformation Linear Approx
                u_basic = g_rbm * u_local; % Calculate basic deformation from global
                k_basic = k_basic_func(E, A, I, L0); % Caculate basic stiffness matrix
                f_basic =  k_basic * u_basic;
                f_global = g_rot' * g_rbm' * f_basic; % Transform to global forces
                k_global = g_rot' * g_rbm' * k_basic * g_rbm * g_rot; % Transform to global stiffness
            end
            Struct.F_global(ele_no,:,nload) = f_global; % Store global force vectors for each element
            Struct.F_basic(ele_no,:,nload) = f_basic; % Store basic force vectors for each element
            % Assemble into larger matrix
            F_internal = add_to_F_internal(F_internal, f_global, ID); % Assemble into global internal resisting force
            K_struct = add_to_K_struct(K_struct, k_global, ID); % Assemble into structural stiffness
    end
    Struct.F_internal(:,nload) = F_internal; % Save the internal resisting force for the load step
    Struct.Beta(:,nload) = Beta; % Saves the beta of the current load step
end
%% Preprocessing Functions
function Struct = define_DOF_number(Struct)
    dof_num = 1;
    for n = 1:Struct.num_nodes
        if (Struct.node_dof(n,1)~=0); Struct.node_dof(n,1) = dof_num; dof_num = dof_num +1; end
        if (Struct.node_dof(n,2)~=0); Struct.node_dof(n,2) = dof_num; dof_num = dof_num +1; end
        if (Struct.node_dof(n,3)~=0); Struct.node_dof(n,3) = dof_num; dof_num = dof_num +1; end
    end
    Struct.num_dofs = dof_num-1;
end

function Struct = define_orientaion(Struct)
    g_rot_func =@(c,s) [c s 0 0 0 0; -s c 0 0 0 0; 0 0 1 0 0 0; 0 0 0 c s 0; 0 0 0 -s c 0; 0 0 0 0 0 1];
    for n = 1:Struct.num_elems
    % Setting ID array
        node_i = Struct.element_connectivity(n,1); % Get 1st node of element n
        node_j = Struct.element_connectivity(n,2); % Get 2nd node of element n
        Struct.ID(n,:) = [Struct.node_dof(node_i,:), Struct.node_dof(node_j,:)]; % Set the DOF number of element n
    % Setting XY
        P1 = Struct.nodal_coord(node_i,:); % Get coordinates for node i
        P2 = Struct.nodal_coord(node_j,:); % Get coordinates for node j
        Struct.element_coord(n,:) = [P1, P2]; % Set element n coordinates to [X1 Y1 X2 Y2]
    % Setting Orientation
        Struct.Mat.L0(n) = ((P2(2)-P1(2))^2 +(P2(1)-P1(1))^2)^0.5; % Original Length of each member
        c0 = (P2(1)-P1(1))/Struct.Mat.L0(n); % cosine of each memeber
        s0 = (P2(2)-P1(2))/Struct.Mat.L0(n); % sine of each member
        Struct.g_rot(:,:,n) = g_rot_func(c0, s0); % Gamma_Rotation
    end
end

function Struct = define_section(Struct, b, h, E)
    Struct.Mat.b = b*ones(1,Struct.num_elems); % in; width
    Struct.Mat.h = h*ones(1,Struct.num_elems); % in; height
    Struct.Mat.E = E*ones(1,Struct.num_elems); % [ksi] Young's modulus
    Struct.Mat.A = b*h*ones(1,Struct.num_elems); % [in^2]
    Struct.Mat.I = b*h^3/12*ones(1,Struct.num_elems); % [in^4] moment of inertia 
end

function Struct = define_point_load(Struct, node, load, steps)
    Struct.num_loadsteps = steps;
    Struct.F_external = zeros(Struct.num_dofs, steps);
    Struct.F_external(node,1:end)= load/steps .* (1:steps);
end
%% Analysis Functions
function Struct = calculate_strains(Struct, load_step)
    E = [Struct.Mat.E, Struct.Mat.E(end)];
    I = [Struct.Mat.I, Struct.Mat.I(end)]';
    A = [Struct.Mat.A, Struct.Mat.A(end)]';
    y = [Struct.Mat.h/2,Struct.Mat.h(end)/2]';
    N = [Struct.F_basic(:,1,load_step);Struct.F_basic(end,1,load_step)]; % Assumes last element =
    M = [Struct.F_basic(:,2,load_step);Struct.F_basic(end,3,load_step)];% Grabs last element moment
    Struct.N = N; Struct.M = M;
    Struct.Strain = 1/E'.*(N./A+M.*y./I);
    Struct.Strain = Struct.Strain(:,1);
end

% Extraction of Element Displacement
function u_global = get_U(U_global, ID)
    u_global = zeros(1,6);
    for i=1:6
        if (ID(i)~=0)
            u_global(i) = U_global(ID(i));
        end
    end
end
% Assmeble Structural Stiffness Matrix
function K_struct = add_to_K_struct(K_struct, k_global, ID)
    for i=1:6
        for j=1:6
            if ((ID(i)~=0) && (ID(j)~=0))
                K_struct(ID(i),ID(j)) = K_struct(ID(i),ID(j)) + k_global(i,j);
            end
        end
    end
end
% Assemble Internal Resisting Force
function F_internal = add_to_F_internal(F_internal, f_internal, ID)
    for i=1:6
        if (ID(i)~=0)
            F_internal(ID(i)) = F_internal(ID(i)) + f_internal(i);
        end
    end
end

%% Plotting Functions
%% Plot Load Displacement Function
function plot_load_displacement(list_of_analysis, dof_num, dof_load,figNum)
    figure(figNum);  hold on; title(["Force-Displacement Curve of DOF " + string(dof_num)]);
    for Analysis = list_of_analysis
        displacement_history = [0, Analysis.U_global(dof_num,:)];
        force_history = -[0,Analysis.F_external(dof_load,:)];
        p = plot(displacement_history,force_history,...
                'DisplayName',Analysis.name);
%         p.Color(4) = 0.4;
    end
    set(gcf,'Position',[0,0,2000,800]);set(gca,'DefaultLineLineWidth',4)
    xlabel('Displacement [in]'); ylabel('Force [N]');
    grid on; grid minor; legend('Location','Best');
end
%
function plot_load_rotation(list_of_analysis, dof_num, dof_load,figNum)
    figure(figNum);  hold on; 
    title(["Force-Displacement Curve of DOF " + string(dof_num)]);
    for Analysis = list_of_analysis
        displacement_history = abs([0, Analysis.U_global(dof_num,:)]);
        force_history = -[0,Analysis.F_external(dof_load,:)];
        p = plot(displacement_history,force_history,...
                'DisplayName',Analysis.name,...
                'LineWidth',2);
%         p.Color(4) = 0.4;
    end
    set(gcf,'Position',[0,0,2000,800]);
    xlabel('Rotatation [rad]'); ylabel('Force [lbf]');
    grid on; grid minor; legend('Location','Best');
end
%
function plot_load_displacement_of_node(list_of_analysis, node_num, dof_load, figNum)
    figure(figNum); hold on; 
    sgtitle(["Force-Displacement Curve for Node " + string(node_num)],...
        'FontWeight','bold', 'Fontsize',36);
    for Analysis = list_of_analysis
        i = 1;
        for dof = Analysis.node_dof(node_num,:)
            subplot(1,3,i); hold on;
            displacement_history = [0, Analysis.U_global(dof,:)];
            force_history = -[0,Analysis.F_external(dof_load,:)];
            p = plot(displacement_history,force_history,...
                    'DisplayName',Analysis.name,...
                    'LineWidth',3);
%             p.Color(4) = 0.4;
            title("DOF " + string(dof));
            if i == 3; xlabel('Roatation [rad]'); elseif i==2; xlabel('Veritcal Displacement [in]'); else; xlabel('Horizontal Displacement [in]'); end;
            grid on; grid minor; legend('Location','best');ylabel('Force [lbf]');
            i = i +1;
        end
    end
    set(gcf,'Position',[0,0,2000,800]);
end
%% Plot Deformed Shape Function
function plt = plot_deformed_shape(list_of_analysis, figNum, num_step, addnode)
    arguments list_of_analysis; figNum; num_step; addnode= true; end
    scale = 1;
    color = ["#0072BD", "#D95319", "#7E2F8E","#4DBEEE"]; i = 1;
    for Analysis = list_of_analysis
        if i == 1; linewidth = 2; else; linewidth = 2; end;
        if num_step == 'end'; lsPlot = Analysis.end_loadstep; else lsPlot = num_step:num_step:Analysis.end_loadstep;end
        [~, ~, ~, plt ] = Plot_ANY_Deflected_Shape(Analysis.U_global, scale, Analysis.ID', Analysis.element_coord, lsPlot, color(i), 1, color(i), linewidth, figNum, Analysis.name); i = i+1;
    end
    title("Matlab Results"); set(gcf,'Position',[0,0,900,800]);
    legend('Location','Southeast'); xlabel("Deformation [in]"); ylabel("Deformation [in]");
    if addnode ==true; addnodes(list_of_analysis(1),figNum); end
end

function addnodes(Analysis, figNum)
    figure(figNum);
    G = graph(Analysis.element_connectivity(:,1), Analysis.element_connectivity(:,2));
    P = plot(G,'xdata', Analysis.nodal_coord(:,1),'ydata',Analysis.nodal_coord(:,2));
    P.DisplayName = 'Nodes';
end
%% Print Current Figure Funciton
function print_figure(file_name)
    % Saves the figures in a consistent manner
    orient(gcf,'landscape');
    folder = '.\figures\';
    name = 'Figure ' +string(file_name);
%     print(folder+name,'-dpdf','-fillpage','-PMicrosoft Print to PDF','-r600','-painters')
    print(folder+name,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters')
end