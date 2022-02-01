# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# NONLINEAR FIBER SECTION ANALYSIS
# ####################################################################################

#Always start with
wipe; # Clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6; # Define the model builder, ndm=#dimension, ndf=#dofs

# ------------------------------------------------------------------------------------
# DEFINE NODES
# ------------------------------------------------------------------------------------
set nodeTag1 1;
set nodeTag2 2;

node $nodeTag1       0. 0. 0.;
node $nodeTag2       0. 0. 0.;

# ------------------------------------------------------------------------------------
# DEFINE CONSTRAINTS
# ------------------------------------------------------------------------------------ 
fix $nodeTag1        1 1 1 1 1 1; # Pin
fix $nodeTag2        0 1 1 1 0 0; # Roller

# ------------------------------------------------------------------------------------
# DEFINE MATERIAL
# ------------------------------------------------------------------------------------

# Define unconfined concrete material parameters
set fpc             [expr -32.5*$MPa]
set Ec              [expr 27000.0*$MPa]
set epsc0           [expr 2.0*$fpc/$Ec]
set ft              [expr 1.9*$MPa]
set lambda          0.25
set Ets             [expr 0.1*$Ec]
set fpcU            [expr 0.2*$fpc]
set epsU            -0.004

# Define confined concrete material parameters
set fpcc            [expr -47.9*$MPa]
set Ecc             [expr 27000.0*$MPa]
set epscc0          [expr 2.0*$fpcc/$Ecc]
set ftc             [expr 1.9*$MPa]
set lambdac         0.25
set Etsc            [expr 0.1*$Ecc]
set fpccU           [expr 0.85*$fpcc]
set epscU           -0.0276

# Define steel material parameters
set fy              [expr 455.0*$MPa]
set Es              [expr 215000.0*$MPa]
set b               0.01
set R0              20.0
set cR1             0.925
set cR2             0.15
set a1              0.0
set a2              1.0
set a3              0.0
set a4              1.0
set sigInit         0.0

set matTagConcCover 1
set matTagConcCore  2
set matTagSteel     3

# Unconfined concrete:
uniaxialMaterial Concrete02 $matTagConcCover  $fpc $epsc0 $fpcU $epsU $lambda $ft $Ets

# Confined concrete:                          
uniaxialMaterial Concrete02 $matTagConcCore   $fpcc $epscc0 $fpccU $epscU $lambdac $ftc $Etsc

# Reinforcing steel:                          
uniaxialMaterial Steel02    $matTagSteel      $fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit

# ------------------------------------------------------------------------------------
# DEFINE SECTION
# ------------------------------------------------------------------------------------
set colWidth    [expr 16.*$in]
set colDepth    [expr 16.*$in]
set colArea     [expr $colWidth * $colDepth]
set cover       [expr 2.5*$in]
set dB          [expr 1.128*$in]
set As          [expr 1.*$in2]
set y1          [expr $colDepth/2.0]
set z1          [expr $colWidth/2.0]
set totNumBars  8
set secTag 1

section Fiber $secTag -GJ $Ubig {

    # -------------------------------------------------------------------------------------
    # Create rectangular patches
    # -------------------------------------------------------------------------------------
    
    # Cover concrete
    patch rect $matTagConcCover 7   2   [expr $cover - $y1]     [expr -$z1]             [expr $y1 - $cover]      [expr $cover - $z1]
    patch rect $matTagConcCover 7   2   [expr $cover - $y1]     [expr $z1 - $cover]     [expr $y1 - $cover]      [expr $z1]
    patch rect $matTagConcCover 2   9   [expr -$y1]             [expr -$z1]             [expr $cover - $y1]      [expr $z1]
    patch rect $matTagConcCover 2   9   [expr $y1 - $cover]     [expr -$z1]             [expr $y1]               [expr $z1]
    
    # Core concrete
    patch rect $matTagConcCore  7   7   [expr $cover - $y1]     [expr $cover - $z1]     [expr $y1 - $cover]     [expr $z1 - $cover]
    
    # -------------------------------------------------------------------------------------
    # Create straight layers
    # -------------------------------------------------------------------------------------
    
    # Reinforcing steel
    layer straight $matTagSteel  4  $As [expr $y1 - $cover] [expr $z1 - $cover] [expr $y1 - $cover] [expr $cover - $z1]
    layer straight $matTagSteel  4  $As [expr $cover - $y1] [expr $cover - $z1] [expr $cover - $y1] [expr $z1 - $cover]
    
}

# ------------------------------------------------------------------------------------
# DEFINE ELEMENT
# ------------------------------------------------------------------------------------
set eleTag 1
element zeroLengthSection $eleTag $nodeTag1 $nodeTag2 $secTag -orient 1 0 0 0 1 0

set controlNode $nodeTag2