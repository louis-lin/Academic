# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# NONLINEAR FIBER SECTION ANALYSIS
# ####################################################################################

#Always start with
wipe; # Clear memory of all past model definitions
model BasicBuilder -ndm 2 -ndf 3; # Define the model builder, ndm=#dimension, ndf=#dofs

# ------------------------------------------------------------------------------------
# DEFINE NODES
# ------------------------------------------------------------------------------------
set nodeTag1 1;
set nodeTag2 2;

node $nodeTag1       0. 0.;
node $nodeTag2       0. 0.;

#puts $modelExportFileID "node $nodeTag1       0. 0.;"
#puts $modelExportFileID "node $nodeTag2       0. 0.;"

# ------------------------------------------------------------------------------------
# DEFINE CONSTRAINTS
# ------------------------------------------------------------------------------------ 
fix $nodeTag1        1 1 1; # Pin
fix $nodeTag2        0 1 0; # Roller

# ------------------------------------------------------------------------------------
# DEFINE MATERIAL
# ------------------------------------------------------------------------------------

# Define unconfined concrete material parameters
# set fpc             [expr -32.5*$MPa]
# set Ec              [expr 27000.0*$MPa]
# set epsc0           [expr 2.0*$fpc/$Ec]
# set ft              [expr 1.9*$MPa]
# set lambda          0.25
# set Ets             [expr 0.1*$Ec]
# set fpcU            [expr 0.2*$fpc]
# set epsU            -0.004

# Define confined concrete material parameters
# set fpcc            [expr -47.9*$MPa]
# set Ecc             [expr 27000.0*$MPa]
# set epscc0          [expr 2.0*$fpcc/$Ecc]
# set ftc             [expr 1.9*$MPa]
# set lambdac         0.25
# set Etsc            [expr 0.1*$Ecc]
# set fpccU           [expr 0.85*$fpcc]
# set epscU           -0.0276

# Define steel material parameters
# set fy              [expr 455.0*$MPa]
# set Es              [expr 215000.0*$MPa]
# set b               0.01
# set R0              20.0
# set cR1             0.925
# set cR2             0.15
# set a1              0.0
# set a2              1.0
# set a3              0.0
# set a4              1.0
# set sigInit         0.0

# set matTagConcCover 1
# set matTagConcCore  2
# set matTagSteel     3
# set modelnum 1.0

# Unconfined concrete:
# uniaxialMaterial Concrete02 $matTagConcCover  $fpc $epsc0 $fpcU $epsU $lambda $ft $Ets

# Confined concrete:                          
# uniaxialMaterial Concrete02 $matTagConcCore   $fpcc $epscc0 $fpccU $epscU $lambdac $ftc $Etsc

# Reinforcing steel:                          
# uniaxialMaterial Steel02    $matTagSteel      $fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit

#puts $modelExportFileID "uniaxialMaterial Concrete02 $matTagConcCore   $fpcc $epscc0 $fpccU $epscU $lambdac $ftc $Etsc"
#puts $modelExportFileID "uniaxialMaterial Concrete02 $matTagConcCover  $fpc $epsc0 $fpcU $epsU $lambda $ft $Ets"
#puts $modelExportFileID "uniaxialMaterial Steel02    $matTagSteel      $fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit"
set unconfinedConcMatTagWall 1;

set fpc     [expr -9.1*$ksi];					# Unconfined Concrete strength.
	set EcWall		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
	set nuc 0.2; 												 # Poisson's Ratio of Concrete
	set GcWall 	[expr $EcWall/(2.0*(1.0+$nuc))];						 # Shear Modulus of Concrete
	set epsc0 [expr 2*$fpc/$EcWall];
	set fpcU [expr 0.2*$fpc];
	set epsU -0.006;
	set lambda 0.25;
	set fr [expr 0.236*$ksi];
	set Ets [expr 0.1*$EcWall];

    uniaxialMaterial Concrete02 $unconfinedConcMatTagWall  $fpc $epsc0 $fpcU $epsU $lambda $fr $Ets
	
	set confinedConcMatTagWall 2;
set fpcc     [expr -12.1*$ksi];					# Confined Concrete strength.
	set EccWall		[expr 57000.0*sqrt(-1.0*$fpcc/$psi)*$psi];		# Concrete Initial Young's Modulus
	set nuc 0.2; 												 # Poisson's Ratio of Concrete
	set GccWall 	[expr $EccWall/(2.0*(1.0+$nuc))];						 # Shear Modulus of Concrete
	set epscc0 [expr 2*$fpcc/$EccWall];
	set fpccU [expr 0.85*$fpcc];
	set epscU -0.015;
	set lambdac 0.25;
	set ftc [expr 0.236*$ksi];
	set Etsc [expr 0.1*$EccWall];

    uniaxialMaterial Concrete02 $confinedConcMatTagWall  $fpcc $epscc0 $fpccU $epscU $lambdac $ftc $Etsc


	set SteelMatTagWall 4
	set Es [expr 29000.*$ksi];
	set fy [expr 69.*$ksi];
	set b 0.0165;
	set R0 20.;
	set cR1 0.925;
	set cR2 0.15;
	set a1 0.;
	set a2 1.;
	set a3 0.;
	set a4 1.;
	set sigInit 0.;

    uniaxialMaterial Steel02    $SteelMatTagWall      $fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit
	
	set SteelMatTagBeam 5
	
		set Es [expr 29000.*$ksi];
	set fy [expr 69.*$ksi];
	set b 0.0165;
	set R0 20.;
	set cR1 0.925;
	set cR2 0.15;
	set a1 0.;
	set a2 1.;
	set a3 0.;
	set a4 1.;
	set sigInit 0.;

    uniaxialMaterial Steel02    $SteelMatTagBeam      $fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit
# ------------------------------------------------------------------------------------
# DEFINE SECTION
# ------------------------------------------------------------------------------------
set colWidth    [expr 400.*$mm]
set colDepth    [expr 400.*$mm]
set colArea     [expr $colWidth * $colDepth]
set cover       [expr 40.*$mm]
set dB          [expr 20.*$mm]
set As          [expr 314.159*$mm2]
set y1          [expr $colDepth/2.0]
set z1          [expr $colWidth/2.0]
set totNumBars  8

set secTag 3
set fiberA 3
set fiberB 1
set fiberC 3

# local y-z axis defined for C - wall section (left wall)
set JWall [expr 4361130.7*$in4];
set JBeam [expr 7411.38*$in4];

# WALL SECTION


# Lengths used in sections
set yy1	[expr 130.*$in]
set yy2 [expr 1.*$in]
set yy3 [expr 28.*$in]
set yy4 [expr 1.*$in]

set zz1 [expr 28.*$in]
set zz2 [expr 15.*$in]
set zz3 [expr 55.*$in]
set zz4 [expr 41.*$in]
set zz5 [expr 1.*$in]
set zz6 [expr 42.*$in]

set Aswall [expr 4.*$in2]
set AsBeam [expr 12.*$in2]
set dBeam [expr 42.*$in]
set bBeam [expr 28.*$in]
set AcBeam [expr 0.362*$dBeam*$bBeam]

section Fiber $secTag -GJ [expr $GcWall*$JWall] {


    # -------------------------------------------------------------------------------------
    # Create rectangular patches
    # -------------------------------------------------------------------------------------
    
    # Confined concrete
    patch rect $confinedConcMatTagWall 		6  	10  [expr $yy1+$yy2]		[expr -$zz3-$zz4]	[expr $yy1+$yy2+$yy3]	[expr -$zz3]
    patch rect $confinedConcMatTagWall 		6  	10  [expr -$yy1-$yy2-$yy3]	[expr -$zz3-$zz4]	[expr -$yy1-$yy2]		[expr -$zz3]

    # Unconfined concrete
    patch rect $unconfinedConcMatTagWall 	5  	30  [expr $yy1]     				[expr -$zz3]     [expr $yy1+$yy2+$yy3+$yy4]     [expr $zz1+$zz2]
    patch rect $unconfinedConcMatTagWall 	5  	30  [expr -$yy1-$yy2-$yy3-$yy4]     [expr -$zz3]     [expr -$yy1]      				[expr $zz1+$zz2]

    patch rect $unconfinedConcMatTagWall 	60 	5  	[expr -$yy1]            [expr $zz2]             [expr $yy1]      [expr $zz1+$zz2]

    patch rect $unconfinedConcMatTagWall 	2   5   [expr $yy1+$yy2+$yy3]   	[expr -$zz3-$zz4]     	[expr $yy1+$yy2+$yy3+$yy4]    		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr $yy1]     			[expr -$zz3-$zz4]       [expr $yy1+$yy2]         		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr -$yy1-$yy2-$yy3-$yy4]	[expr -$zz3-$zz4]		[expr -$yy1-$yy2-$yy3]		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr -$yy1-$yy2]			[expr -$zz3-$zz4]		[expr -$yy1]					[expr -$zz3]

    patch rect $unconfinedConcMatTagWall 	5   2   [expr $yy1]    				[expr -$zz3-$zz4-$zz5]		[expr $yy1+$yy2+$yy3+$yy4]      [expr -$zz3-$zz4]
    patch rect $unconfinedConcMatTagWall 	5   2   [expr -$yy1-$yy2-$yy3-$yy4]	[expr -$zz3-$zz4-$zz5]		[expr -$yy1]      [expr -$zz3-$zz4]
       
    # -------------------------------------------------------------------------------------
    # Create straight layers
    # -------------------------------------------------------------------------------------
    
    # Reinforcing steel
    layer straight $SteelMatTagWall 18  $Aswall [expr $yy1+$yy2+$yy3/2] 	[expr $zz6] [expr $yy1+$yy2+$yy3/2] 	[expr -$zz3-$zz4]
    layer straight $SteelMatTagWall 18  $Aswall [expr -$yy1-$yy2-$yy3/2] 	[expr $zz6] [expr -$yy1-$yy2-$yy3/2] 	[expr -$zz3-$zz4]
    layer straight $SteelMatTagWall 32  $Aswall [expr -$yy1] [expr $zz2+$zz1/2] [expr $yy1] [expr $zz2+$zz1/2]
    

};




# ------------------------------------------------------------------------------------
# DEFINE ELEMENT
# ------------------------------------------------------------------------------------
set eleTag 1
set secTag 3
element zeroLengthSection $eleTag $nodeTag1 $nodeTag2 $secTag -orient 0 1 0 0 1 0
# puts $modelExportFileID "element zeroLengthSection $eleTag $nodeTag1 $nodeTag2 $secTag -orient 1 0 0 0 1 0"
# close $modelExportFileID

set controlNode $nodeTag2