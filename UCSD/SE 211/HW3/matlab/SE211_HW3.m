%%
addpath('functions');
clear; clc;

%% Regular column
Column1 = GiveMeAColumn("Model M-\phi"); 
%% Scaled Regular Column down by 0.5
Column2 = GiveMeAColumn("1/2 Scaled",... % name
                                        141809,... % Applied Load
                                        24, ... % Diameter  [in]
                                        [1.1700    1.5600    1.5600    1.5600    1.1700],...% Long steel rebar area [in^2]
                                        [1.6750    4.4050   12.0000   19.5950   22.3250],... % Long steel rebar y
                                        .705,... % Diameter of Longitudinal Bars [in]
                                        0.3125,... % Hoop Diameter [in]
                                        3,...% Hoop spacing [in]
                                        12,...% Height of Column [ft]
                                        1); % Cover [in]

%% Two times the longitudinal rebar
Column3 = GiveMeAColumn('2* Longitudinal Rebar', ... %name
                                        522000,... % Applied Weight
                                        48,... % Diameter [in]
                                        2*[4.68, 6.24, 6.24, 6.24, 4.68]); % Long Steel rebar area [in^2]
%% Increase axial load
Column4 = GiveMeAColumn('6*Axial Force = 3132 kip', 6*522000); % 6 times axial force everything else default
Column5 = GiveMeAColumn('9*Axial Force = 4698 kip', 9*522000); % 9 times axial force everything else default
Column6 = GiveMeAColumn('12*Axial Force = 6264 kip', 12*522000); % 12 times axial force everything else default

%% Increase axial load- keep same ductility, alter the hoop reinforcement ratio
% Change the spacing in order to vary the transverse reinforcement
hoop.spacing_2 =  .238; 
hoop.spacing_3 =  .035;
hoop.spacing_4 =  .01;
Column7 = GiveMeAColumn('6*Axial Force = 3132 kip', 6*522000, 48, [4.68, 6.24, 6.24, 6.24, 4.68], [3.35, 8.81, 24., 39.19, 44.65],1.410, 0.625,hoop.spacing_2 ); 
Column8 = GiveMeAColumn('9*Axial Force = 4698 kip', 9*522000, 48, [4.68, 6.24, 6.24, 6.24, 4.68], [3.35, 8.81, 24., 39.19, 44.65],1.410, 0.625,hoop.spacing_3  );
Column9 = GiveMeAColumn('12*Axial Force = 6264 kip', 12*522000, 48, [4.68, 6.24, 6.24, 6.24, 4.68], [3.35, 8.81, 24., 39.19, 44.65],1.410, 0.625,hoop.spacing_4 ); 


%% Columm Function
function Column = GiveMeAColumn(name, Axial_Load, Diameter,Steel_Area, Steel_Y, long_db, hoop_db, hoop_spacing, height, cover)
% Returns a Coloumn structure couple of main data structures:
%   Confined concrete; used for the constitutive functions
%   Unconfined concrete; used for the constitutive functions
%   Long; (for the longitudinal rebars)
%   Hoop; (for the hoop rebar)
%   Section; (with all section properties.
%   id; array of indices for the critical points of the curve
%   A bunch  of calcualted properties like EcIg and EcIe

% The moment curvature function is called in the body

    arguments 
        % Allows me to set the defautl column values
        % All of them are given
        name ="Column"
        Axial_Load = 522000
        Diameter = 48
        Steel_Area = [4.68, 6.24, 6.24, 6.24, 4.68]    
        Steel_Y = [3.35, 8.81, 24., 39.19, 44.65]
        long_db = 1.410
        hoop_db = 0.625
        hoop_spacing = 6
        height = 24
        cover = 2
    end
    % Cross Section Geometry
    Column.name = name; % Name the column for plotting purposes
    Column.Section.diameter = Diameter; % in ; 
    Column.Section.area = Column.Section.diameter^2*pi()/4; % in^2 ;  
    Column.Section.cover = cover; % in ; 
    Column.Section.diameter_confined = Diameter-2*Column.Section.cover ; % in 
    Column.Section.no_of_fibers = 100; % # 
    Column.Section.fiber_width = Diameter/Column.Section.no_of_fibers; % in 
    Column.Section.centroid_y = Column.Section.diameter/2; % in 
    Column.Section.lamba = 2.25; % Priestley's lambda value to find yield curv.

    Column.height = height*12; % in; given in feet
    Column.density = 150*12^-3; % pcf
    Column.volume = Column.Section.area*Column.height;  % in^3
    Column.self_weight = Column.density * Column.volume; %lbf
    Column.applied_force = Axial_Load; % lbf
    Column.total_axial_load = -(Column.self_weight + Column.applied_force); % lbf

    % Hoop reinforcement properties
    Hoop.fy = 60400; % psi; Hoops
    Hoop.db = hoop_db; %in; Diameter of hoops
    Hoop.spacing = hoop_spacing; % in; spacing
    Hoop.clear_spacing = Hoop.spacing-2*Hoop.db; % in; clear vertical spacing between hoops
    Hoop.diameter = Column.Section.diameter - 2*cover - Hoop.db; % Hoop diameter
    Hoop.area = 2*hoop_db^2*pi()/4; % in^2; area of hoop
    Hoop.rho = Hoop.area/Hoop.diameter/Hoop.spacing; % Steel ratio of the transverse rebar
    Column.Hoop = Hoop; % Saves the hoop

    % Longitudinal reinforcement properties
    Long.fy = 74300; % psi; Longitudinal 
    Long.db = long_db; % Longitudinal rebar diameter
    Long.Es = 29000000; % psi
    Long.P = 3; % Mander's model
    Long.esh = 0.0145; % Strain hardening strain
    Long.esu = 0.1054; % Maximum longitudinal strain of steel
    Long.fsu = 101700; % psi
    Long.ey = Long.fy/Long.Es; % Yeilding strain
    Column.Long = Long;  % Saves the longitudinal rebar

    % Concrete data structure
    Concrete.fc = 6000; % psi; Compressive strength of concrete
    Concrete.Ec = 3250000; % ksi; Young's Modulus
    Concrete.ec = -0.0027; % Maximum compressive strain
    Concrete.lp1 = 0.08*Column.height; % Length of the plastic hinge region
    Concrete.lp2 = 0.15*Long.db*Long.fy/1000; % Strain penetration length
    Concrete.lambda_c = 16/ Concrete.lp1; % Normalization factor
    Concrete.ft = 300*log(1+Concrete.fc/1800); % Cracking stress
    Concrete.et = Concrete.ft/Concrete.Ec; % Cracking strain

    [Unconfined_C, Confined_C] = deal(Concrete); % Both concrete have base values 
    % Unconfined Concrete modifications
    Unconfined_C.ecu = -0.006; % Maximum compressive strain
    Column.Unconfined_Concrete = Unconfined_C;
    % Confined Concrete modifications
    Confined_C.ecu = -0.02; % Maximum compressive strain of confined concrete 
    Confined_C.Ke = (1-Hoop.clear_spacing/2/Hoop.diameter)^2; % Confinement efficiency coefficient
    Confined_C.fI = 2*Hoop.fy*Hoop.area/Hoop.spacing/Hoop.diameter;% Passive confining stress
    Confined_C.fie = Confined_C.Ke * Confined_C.fI; % Effective confining stress
    Confined_C.Kc = 4.1;
    Confined_C.fcc = Confined_C.fc + Confined_C.Kc*Confined_C.fie;
    Confined_C.ecc = Confined_C.ec*(1+20*Confined_C.fie/Confined_C.fc);
    Confined_C.E_secc = -Confined_C.fcc/Confined_C.ecc;
    Confined_C.r_cc = 1/(1-Confined_C.E_secc/Confined_C.Ec);
    Column.Confined_Concrete = Confined_C;
    % Discretize the section
    % Reinforcement
    Column.Section.steel_y = Steel_Y; % height for each later
    Column.Section.steel_fiber_area = Steel_Area; % steel area per layer 
    Column.Section.transformed_area = Column.Section.area +(Long.Es/Concrete.Ec - 1)*sum(Column.Section.steel_fiber_area); % transformed area
    [Column.Section.conc_fiber_y, Column.Section.unconfined_fiber_area, Column.Section.confined_fiber_area] = areas_circle(Column.Section); % discretize the system
    Column = MomentCurvature(Column); % RUNS THE MOMENT CURVATURE!!!!!!!!
      
    Column.norm_M = 1/(Column.Section.diameter^3*Column.Confined_Concrete.fc); % Moment normillization factor
    Column.norm_P = Column.Section.diameter/Column.Section.lamba/Column.Long.ey; % Curvature normillization factor
    Column.Curvature_ductility = Column.Curvature(end)*Column.Section.diameter/Column.Section.lamba/Column.Long.ey; % Curvature ductility
    Column.Normalized_P = Column.Curvature * Column.norm_P; % normalized curvature
    Column.Normalized_M = Column.Moment * Column.norm_M;% normalized moment

    
    [~, id.et] = min(abs(Column.Confined_Concrete.et- Column.Concrete_strain(:,2))); % index for cracking
    [~, id.fyc] = min(abs(Column.Confined_Concrete.ec - Column.Concrete_strain(:,Column.Section.no_of_fibers))); % index for yeilding in concrete
    [~, id.fys] = min(abs(Column.Long.ey - Column.Steel_strain(:,1))); % index for yeilding in rebar
    id.fy = min(id.fyc,id.fys); % takes the minimum
    [~, id.ACI] = min(abs(-0.003- Column.Concrete_strain(:,Column.Section.no_of_fibers))); % index for -.3% strain
    [~, id.Mn] = min(abs(-0.004- Column.Concrete_strain(:,Column.Section.no_of_fibers))); % index for -.4% strain
    [~, id.Spalling] = min(abs(-0.006- Column.Concrete_strain(:,Column.Section.no_of_fibers))); % index for -.6% strain
    [~, id.Max] = max(Column.Moment); % index for overstrength moment
    id.End = length(Column.Moment); % index for ultimate strain
    
    Column.id = id; % Saves all of those ids
        
    % determine the end marker
    if abs(Column.Steel_strain(end,1) - 0.06) <= 0.001
        Column.end_marker = "d"; 
    elseif abs(Column.Concrete_strain(end,end) + 0.02) <=0.001
        Column.end_marker = "s";
    end
    
    Column.Mcr = Column.Normalized_M(id.et);
    Column.My = Column.Normalized_M(id.fy);
    Column.MACI = Column.Normalized_M(id.ACI);
    Column.Mn = Column.Normalized_M(id.Mn);
    Column.Ms = Column.Normalized_M(id.Spalling);
    Column.Mo = Column.Normalized_M(id.Max);
    Column.Mul = Column.Normalized_M(id.End);   

    Column.Pcr = Column.Normalized_P(id.et);
    Column.Py = Column.Normalized_P(id.fy);
    Column.PACI = Column.Normalized_P(id.ACI);
    Column.Pn = Column.Normalized_P(id.Mn);
    Column.Ps = Column.Normalized_P(id.Spalling);
    Column.Po = Column.Normalized_P(id.Max);
    Column.Pul = Column.Normalized_P(id.End);   
    
    Column.Section.Ig = Column.Section.diameter^4 * pi()/64;
    Column.Section.n = Column.Long.Es / Column.Confined_Concrete.Ec;
    Column.Section.It = Column.Section.Ig + (Column.Section.n-1)*sum(Column.Section.steel_fiber_area.*(Column.Section.centroid_y - Column.Section.steel_y).^2);
    Column.Ec_It = Column.Confined_Concrete.Ec * Column.Section.It;
    Column.Ec_Ig = Column.Confined_Concrete.Ec * Column.Section.Ig;
    Column.Ec_Ie = Column.Moment(id.fy)/Column.Curvature(id.fy);
    Column.Ec_Ie_n = Column.My/Column.Py;
    
    Column.Axial_load_ratio = -Column.total_axial_load/(Column.Section.area*Column.Confined_Concrete.fc);
end