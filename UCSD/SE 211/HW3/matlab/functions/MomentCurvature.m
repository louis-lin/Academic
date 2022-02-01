function [Column] = MomentCurvature(Column)
%% Begin Solutions
n = 25; % As chosen by the class
d_curv = 2*Column.Long.fy/Column.Long.Es/Column.Section.diameter/n; % Curvature step
tol = 0.001; % Tolerance to move onto the next step
max_i = 1000; % Max iteration for each curvature step

i = 1; % Step counter
Column.Curvature(i) = 0; % Initialize
strain = Column.total_axial_load/Column.Confined_Concrete.Ec/Column.Section.transformed_area ; % P/E/At; Initial Strain at Centroid
Column.Concrete_strain(i,:) = strain*ones(Column.Section.no_of_fibers,1); % Initialize
Column.Steel_strain(i,:) = strain*ones(numel(Column.Section.steel_y),1); % Initialize

i = 2; % start at step 2 since we're defining initial conditions
% Shorthands 
A_cc = Column.Section.confined_fiber_area;
A_uc = Column.Section.unconfined_fiber_area;
A_s = Column.Section.steel_fiber_area;
Y_bar = Column.Section.centroid_y;
Y_conc = Column.Section.conc_fiber_y;
Y_steel = Column.Section.steel_y;

while max(Column.Steel_strain(i-1,:)) <= 0.06 && min(Column.Concrete_strain(i-1,2:end-1)) >= Column.Confined_Concrete.ecu
	delta_strain = 1*10^-6; % Initial change in strain 
    Column.Curvature(i) = Column.Curvature(i-1) + d_curv; % increase the curvature
    j = 0;
    while j <= max_i
        % Concrete
        Column.Concrete_strain(i,:) = Column.Curvature(i) .* (Y_bar - Y_conc) + strain; % Calcualte the strain in each fiber layer
        Column.Concrete_Confined_stress(i,:) = constitutive_confined_concrete(Column.Concrete_strain(i,:), Column.Confined_Concrete); % Calcualte the stress in each fiber layer
        Column.Concrete_Unconfined_stress(i,:) = constitutive_unconfined_concrete(Column.Concrete_strain(i,:), Column.Unconfined_Concrete); % Calcualte the stress in each fiber layer
        Column.Concrete_Confined_force(i,:) = Column.Concrete_Confined_stress(i,:) .* A_cc';  % Calculate the force in each fiber layer
        Column.Concrete_Unconfined_force(i,:) = Column.Concrete_Unconfined_stress(i,:) .* A_uc';  % Calculate the force in each fiber layer
        Column.Concrete_force(i,:) = Column.Concrete_Confined_force(i,:) + Column.Concrete_Unconfined_force(i,:); % % Calculate the force in each fiber layer
        % Steel
        Column.Steel_strain(i,:) = Column.Curvature(i) * (Y_bar - Y_steel) + strain; % Calcualte the strain in each fiber layer
        Column.Steel_stress(i,:) = constitutive_steel(Column.Steel_strain(i,:), Column.Long);% Calcualte the stress in each fiber layer
        Column.Confined_stress_atSteel(i,:) = constitutive_confined_concrete(min(Column.Steel_strain(i,:),0), Column.Confined_Concrete); % Calcualte the stress in each fiber layer
        Column.Steel_force(i,:) =  (Column.Steel_stress(i,:)-Column.Confined_stress_atSteel(i,:)) .* A_s; % Calculate the force in each fiber layer         
        Column.TotalForce(i) = sum(Column.Steel_force(i,:)) + sum(Column.Concrete_force(i,:)); % Calculate force in each fiber layer minus the concrete
        
        error = (Column.TotalForce(i) - Column.total_axial_load);   % Error is not normalize :/
        if abs(error) <= tol 
            Column.centroid_strain(i) = strain; % Save the strain and break
            break
        else
            [delta_strain, strain] = brute_force(error, tol,delta_strain,strain); % Change the strain at the centroid
            j = j + 1; % Iteration counter
        end
        
    end   
    Column.Moment(i) = sum(Column.Concrete_force(i,:) .*(Y_bar- Y_conc')) + sum(Column.Steel_force(i,:) .* (Y_bar-Y_steel)); % Compute the moment
    i = i + 1; % Increase curvature counter
end
end
