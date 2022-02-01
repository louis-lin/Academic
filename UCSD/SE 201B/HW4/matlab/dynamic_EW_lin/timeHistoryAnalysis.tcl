
# NLTHA PARAMETERS
set scaleFac_L 1.0;
set scaleFac_T 0.0;
set algorithmBasic [split "KrylovNewton"];
set testBasic "NormDispIncr";
set showTestBasic 0;
set tolDynBasic 1e-8;
set maxNumIterDynBasic 500;

# NLTHA PARAMETERS FOR NON-CONVERGENCE
set showTest 0;
set tolDynDisp 1e-11;
set tolDynUnb 1e-05;
set maxNumIterDyn 2500;

# READ GROUND MOTION INPUT
set gm_dirctn_L 1;			# ground-motion direction
set gm_dirctn_T 2;			# ground-motion direction

# set up ground-motion-analysis parameters
set gmDataFile_L [open "NORTHR_SYL360.txt" "r"];
set gmDataFile_T [open "NORTHR_SYL090.txt" "r"];

set gmData_L [read $gmDataFile_L]; 
set gmData_T [read $gmDataFile_T];

close $gmDataFile_L;
close $gmDataFile_T;

set npts_L [lindex $gmData_L 0]; 
set npts_T [lindex $gmData_T 0];

set npts $npts_L

set dtRec_L [lindex $gmData_L 1]; 
set dtRec_T [lindex $gmData_T 1];

set dtRec $dtRec_L
set dtAnalysis [expr $dtRec/1.];

set gmDataInput_L {}
for {set i 1} {$i <= $npts} {incr i} {
    lappend gmDataInput_L [lindex $gmData_L [expr $i + 1]]
}

set gmDataInput_T {}
for {set i 1} {$i <= $npts} {incr i} {
    lappend gmDataInput_T [lindex $gmData_T [expr $i + 1]]
}

set totalAnalysisTime		[expr $npts*$dtRec];

# ###################################################################################################################################################################################################
# ################################################################################# RAYLEIGH DAMPING ################################################################################################
# ###################################################################################################################################################################################################

set w1 [lindex $omega 1];
set w2 [lindex $omega 3];

set ksi 0.020; # 2.5% damping ratio
set alphaM    [expr 2.*$ksi*$w1*$w2/($w1+$w2)];	
set betaKinit [expr 2.*$ksi/($w1+$w2)];
set betaKcurr 0.0; 			
set betaKcomm 0.0;
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm


# ###################################################################################################################################################################################################
# ################################################################################# SET LOAD PATTERN ################################################################################################
# ###################################################################################################################################################################################################

#  perform Dynamic Ground-Motion Analysis
set gmLoadTag_L 2;	# LoadTag for Uniform ground motion excitation
set gmLoadTag_T 3;	# LoadTag for Uniform ground motion excitation

set gmFact_L [expr $g*$scaleFac_L];		# data in input file is in units of g
set gmFact_T [expr $g*$scaleFac_T];		# data in input file is in units of g

set tsTag_L $gmLoadTag_L;
set tsTag_T $gmLoadTag_T;

timeSeries Path $tsTag_L -dt $dtRec -values $gmDataInput_L -factor $gmFact_L;
timeSeries Path $tsTag_T -dt $dtRec -values $gmDataInput_T -factor $gmFact_T;

pattern UniformExcitation  $gmLoadTag_L  $gm_dirctn_L -accel  $tsTag_L;		# create Uniform excitation
pattern UniformExcitation  $gmLoadTag_T  $gm_dirctn_T -accel  $tsTag_T;		# create Uniform excitation

# ###################################################################################################################################################################################################
# ############################################################################### SET ANALYSIS PARAMETERS ###########################################################################################
# ###################################################################################################################################################################################################

set NewmarkGamma 0.50;	# Newmark-integrator gamma parameter (also HHT)
set NewmarkBeta  0.25;	# Newmark-integrator beta parameter
test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;   
algorithm {*}$algorithmBasic;      
integrator Newmark $NewmarkGamma $NewmarkBeta
analysis Transient

# ###############################################################################################################################################################################
# #########################################################################  SOURCE RECORDERS  ##################################################################################
# ###############################################################################################################################################################################

source "RECORDERS_dynamic.tcl";
puts "Recorders OK"
record

# ###################################################################################################################################################################################################
# ############################################################################### RUN ANALYSIS ######################################################################################################
# ###################################################################################################################################################################################################

set nSteps [expr int($totalAnalysisTime/$dtAnalysis)];
set tCurrent [getTime];
set ok 0;
while {$ok == 0 && $tCurrent <= $totalAnalysisTime} {
	set ok [analyze 1 $dtAnalysis];
	if {$ok == 0} { puts "TIME: $tCurrent ($totalAnalysisTime) >> CONVERGED!" }
	#####################################################################################################
	############################################# DISP INCR #############################################
	#####################################################################################################
	if {$ok != 0} {
		puts "Try Krylov Newton with DispIncr"
		test NormDispIncr $tolDynDisp $maxNumIterDyn $showTest;
		algorithm KrylovNewton;
		set ok [analyze 1 $dtAnalysis];
		if {$ok == 0} {
			test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;
			algorithm {*}$algorithmBasic; 
		}
	};
	if {$ok != 0} {
		puts "Try Newton initial with DispIncr"
		test NormDispIncr $tolDynDisp $maxNumIterDyn $showTest;
		algorithm Newton -initial
		set ok [analyze 1 $dtAnalysis];
		if {$ok == 0} {
			test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;
			algorithm {*}$algorithmBasic; 
		}
	};
	if {$ok != 0} {
		puts "Try Krylov Newton with RelativeNormDispIncr"
		test RelativeNormDispIncr 1e-05 2500 $showTest;
		algorithm KrylovNewton
		set ok [analyze 1 $dtAnalysis];
		if {$ok == 0} {
			test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;
			algorithm {*}$algorithmBasic; 
		}
	};
	#####################################################################################################
	############################################# UNBALANCE #############################################
	#####################################################################################################
	if {$ok != 0} {
		puts "Try Newton -Hall 50-50 with Unbalance"
		test NormUnbalance $tolDynUnb $maxNumIterDyn $showTest;
		algorithm Newton -Hall 0.5 0.5;
		set ok [analyze 1 $dtAnalysis];
		if {$ok == 0} {
			test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;
			algorithm {*}$algorithmBasic; 
		}
	};
	if {$ok != 0} {
		puts "Try NewtonLineSearch with Unbalance"
		test NormUnbalance $tolDynUnb $maxNumIterDyn $showTest;
		algorithm NewtonLineSearch
		set ok [analyze 1 $dtAnalysis];
		if {$ok == 0} {
			test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;
			algorithm {*}$algorithmBasic; 
		}
	};
		if {$ok != 0} {
		puts "Try Krylov Newton with RelativeNormUnbalance"
		test RelativeNormUnbalance 1e-04 2500 $showTest;
		algorithm KrylovNewton
		set ok [analyze 1 $dtAnalysis];
		if {$ok == 0} {
			test $testBasic $tolDynBasic $maxNumIterDynBasic $showTestBasic;
			algorithm {*}$algorithmBasic; 
		}
	};
	set tCurrent [getTime];
}


if {$ok == 0} {
    puts "Time History Analysis COMPLETE!"
} else {
    puts "Time History Analysis FAILED!"
}

# Don't forget to
remove recorders