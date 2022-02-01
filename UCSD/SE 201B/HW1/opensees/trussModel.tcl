# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# HOMEWORK # 1
# NONLINEAR QUASI-STATIC & TIME-HISTORY ANALYSIS OF A SDOF SYSTEM
# ####################################################################################
# Louis Lin
# UNITS: kip, in, sec

# DEFINE EQUIVALENT TRUSS MODEL PROPERTIES -------------------------------------------
set g 386.4; # Acceleration due to gravity
set pi [expr 2*asin(1.0)]; # pi
set wt 2000.; # Weight of the structure
set m [expr $wt/$g]; # Mass of the structure
set T0 0.20; # Initial time period of the structure
set K0 [expr 4.*pow($pi,2.)*$m/(pow($T0,2))]; # Initial stiffness of the structure
set xi 0.02; # Damping ratio
set c [expr 2.*$xi*sqrt($K0*$m)]; # Damping coefficient
set E0 30000.; # Modulus of elasticity (steel)
set Ry0 [expr 0.15*$wt]; # Yield strength
set L 60.; # Length of the equivalent truss model
set A [expr $K0*$L/$E0]; # Area of cross-section of the equivalent truss model

# DEFINE NODES -----------------------------------------------------------------------
set nodeTag1 1;
set nodeTag2 2;

#node $nodeTag  (ndm $coords)
node $nodeTag1 0
node $nodeTag2 60

# DEFINE MASS ------------------------------------------------------------------------
# Needed for transient (dynamic) analysis only
#mass $nodeTag (ndf $massValues)
mass $nodeTag2 $m

# APPLY CONSTRAINTS-------------------------------------------------------------------
#fix $nodeTag (ndf $constrValues)
fix 1 1
fix 2 0

# DEFINE MATERIAL PARAMETERS ---------------------------------------------------------
# ...
set matTag_1 1
set Fy [expr $Ry0/$A]
set E $E0
set b 0.02
set R0 5
set cR1 3
set cR2 0.15

# DEFINE MATERIAL --------------------------------------------------------------------
#uniaxialMaterial Steel02 $matTag             $Fy         $E  $b    $R0 $cR1 $cR2 <$a1 $a2 $a3 $a4 $sigInit>
uniaxialMaterial Steel02 $matTag_1 $Fy $E $b $R0 0.6 0.15 0 1 0 1

# DEFINE ELEMENT ---------------------------------------------------------------------
#element truss $eleTag $iNode    $jNode    $A $matTag
element truss 1 $nodeTag1 $nodeTag2 $A $matTag_1 