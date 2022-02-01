
# ##############################################################################################################################################################################################
# ########################################################################	WALL - UNCONFINED CONCRETE  ########################################################################################
# ##############################################################################################################################################################################################
set unconfinedConcMatTagWall 1;

if {$unconfinedConcMatTypeWall == "LinearElastic"} {
        
	set fpc     [expr -9.1*$ksi];					# Unconfined Concrete strength.
	set EcWall		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
	set nuc 0.2; 												 # Poisson's Ratio of Concrete
	set GcWall 	[expr $EcWall/(2.0*(1.0+$nuc))];						 # Shear Modulus of Concrete
	set epsc0 [expr 2*$fpc/$EcWall];
	set fpcU [expr 0.2*$fpc];
	set epsU -0.006;
	set lambda 0.25;
	# set ft [expr 0.236*$ksi];
	set Ets [expr 0.1*$EcWall];

	uniaxialMaterial Elastic $unconfinedConcMatTagWall    $EcWall

} elseif {$unconfinedConcMatTypeWall == "Concrete01"} {

	set fpc     [expr -9.1*$ksi];					# Unconfined Concrete strength.
	set EcWall		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
	set nuc 0.2; 												 # Poisson's Ratio of Concrete
	set GcWall 	[expr $EcWall/(2.0*(1.0+$nuc))];						 # Shear Modulus of Concrete
	set epsc0 [expr 2*$fpc/$EcWall];
	set fpcU [expr 0.2*$fpc];
	set epsU -0.006;
	set lambda 0.25;
	# set ft [expr 0.236*$ksi];
	set Ets [expr 0.1*$EcWall];

    uniaxialMaterial Concrete01 $unconfinedConcMatTagWall  $fpc $epsc0 $fpcU $epsU
	
} elseif {$unconfinedConcMatTypeWall == "Concrete02"} {

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

}
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ##############################################################################################################################################################################################
# ########################################################################	WALL - CONFINED CONCRETE  ##########################################################################################
# ##############################################################################################################################################################################################
set confinedConcMatTagWall 2;

if {$confinedConcMatTypeWall == "LinearElastic"} {

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
    
	uniaxialMaterial Elastic $confinedConcMatTagWall    $EccWall

} elseif {$confinedConcMatTypeWall == "Concrete01"} {

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
	
    uniaxialMaterial Concrete01 $confinedConcMatTagWall  $fpcc $epscc0 $fpccU $epscU

} elseif {$confinedConcMatTypeWall == "Concrete02"} {

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

    uniaxialMaterial Concrete02 $unconfinedConcMatTagWall  $fpcc $epscc0 $fpccU $epscU $lambdac $ftc $Etsc

}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ##############################################################################################################################################################################################
# #################################################################################	BEAM CONCRETE  #############################################################################################
# ##############################################################################################################################################################################################
set ConcMatTagBeam 3; 

if {$ConcMatTypeBeam == "LinearElastic"} {

	set fr_eq   [expr 0.236*$ksi];
	set	fpc		[expr -10.*$fr_eq];									# Compressive concrete strength
	set EcBeam		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
	set nuc 0.2; 												 # Poisson's Ratio of Concrete
	set GcBeam 	[expr $EcBeam/(2.0*(1.0+$nuc))];						 # Shear Modulus of Concrete
	set epsc0 [expr 2*$fpc/$EcBeam];
	set fpcU [expr 0.2*$fpc];
	set epsU -0.006;
	set lambda 0.25;
	# set ft [expr 0.236*$ksi];
	set Ets [expr 0.1*$EcBeam];
    
	uniaxialMaterial Elastic $ConcMatTagBeam $EcBeam
		

} elseif {$ConcMatTypeBeam == "Concrete01"} {

	set fr_eq   [expr 0.236*$ksi];
	set	fpc		[expr -10.*$fr_eq];									# Compressive concrete strength
	set EcBeam		[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];		# Concrete Initial Young's Modulus
	set nuc 0.2; 												 # Poisson's Ratio of Concrete
	set GcBeam 	[expr $EcBeam/(2.0*(1.0+$nuc))];						 # Shear Modulus of Concrete
	set epsc0 [expr 2*$fpc/$EcBeam];
	set fpcU [expr 0.2*$fpc];
	set epsU -0.006;
	set lambda 0.25;

	set Ets [expr 0.1*$EcBeam];

    uniaxialMaterial Concrete01 $ConcMatTagBeam  $fpc $epsc0 $fpcU $epsU
$ft

} elseif {$ConcMatTypeBeam == "Concrete02"} {

	set fr		[expr 0.236*$ksi];							# Adjusted concrete tensile strength
	set fpc 	[expr -9.1*$ksi];							# Compressive concrete strength
	set EcBeam	[expr 57000.0*sqrt(-1.0*$fpc/$psi)*$psi];	# Young's Modulus of Concrete
	set epsc0	[expr 2.*$fpc/$EcBeam];						# Concrete strength at maximum strength
	set fpcu	[expr 0.2*$fpc];							# Concrete crushing strength
	set epsu	-0.006;										# Concrete strain at crushing strength
	set lambda	0.25;										# Ratio between unloading slope at $epscu and initial slope
	set Ets		[expr 0.1*$EcBeam];							# Tension softening stiffness
	set nuc 0.2;											# Poisson's Ratio of Concrete
	set GcBeam 	[expr $EcBeam/(2.0*(1.0+$nuc))];			# Shear Modulus of Concrete
	
	uniaxialMaterial Concrete02 $ConcMatTagBeam	$fpc $epsc0 $fpcu $epsu $lambda $fr $Ets

}

# ##############################################################################################################################################################################################
# #################################################################################### WALL STEEL ##############################################################################################
# ##############################################################################################################################################################################################
set SteelMatTagWall 4

if {$SteelMatTypeWall == "LinearElastic"} {

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
	uniaxialMaterial Elastic $SteelMatTagWall $Es
		

} elseif {$SteelMatTypeWall == "Steel02"} {

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

}
 # ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# ##############################################################################################################################################################################################
# #################################################################################### BEAM STEEL ##############################################################################################
# ##############################################################################################################################################################################################
set SteelMatTagBeam 5
if {$SteelMatTypeBeam == "LinearElastic"} {

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
	uniaxialMaterial Elastic $SteelMatTagBeam $Es
		

} elseif {$SteelMatTypeBeam == "Steel02"} {

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
}