# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# DISPLACEMENT CONTROL STATIC ANALYSIS
# ####################################################################################

# ###############################################################################################################################################################################
# ###################################################################  DEFINE REFERENCE LOAD PATTERN  ###########################################################################
# ###############################################################################################################################################################################				

set controlDOF 3
set dispControlLoadTag 2
# Define reference moment
pattern Plain $dispControlLoadTag "Linear" {
	load $controlNode 0.0 0.0 1.0
}

# ###############################################################################################################################################################################
# ###################################################################  DEFINE DISPLACEMENT CYCLES  ##############################################################################
# ###############################################################################################################################################################################

set peakDisp {};
lappend peakDisp [expr 0.005/$colDepth]
lappend peakDisp [expr -0.005/$colDepth]
lappend peakDisp [expr 0.01/$colDepth]
lappend peakDisp [expr -0.01/$colDepth]
lappend peakDisp [expr 0.02/$colDepth]
lappend peakDisp [expr -0.02/$colDepth]
lappend peakDisp [expr 0.03/$colDepth]
lappend peakDisp [expr -0.03/$colDepth]
lappend peakDisp 0


set numCycles [llength $peakDisp]
set cyclelabel {};
for {set i 1} {$i <= $numCycles} {incr i 1} {
    lappend cyclelabel $i
}

set maxDisp [expr 0.03/$colDepth];
set du [expr 0.0001*$maxDisp];	

#set du [expr 0.01*0.005/$colDepth];			# Disp increment to be set
set ok 0; 
set currentDisp 0.; # This is the current value of the displacement at the control DOF.
set tol 1e-6;
set iter 250;

# ###############################################################################################################################################################################
# #########################################################################  SOURCE RECORDERS  ##################################################################################
# ###############################################################################################################################################################################

recorder Node -file $analysisResultsDirectory/MK.txt -time -node $controlNode -dof 1 $controlDOF disp

recorder Element -file $analysisResultsDirectory/ConcFib1_SS.txt  -time -ele 1 section fiber -$y1  0. $matTagConcCover stressStrain
recorder Element -file $analysisResultsDirectory/ConcFib2_SS.txt  -time -ele 1 section fiber  $y1  0. $matTagConcCover stressStrain
recorder Element -file $analysisResultsDirectory/SteelFib1_SS.txt -time -ele 1 section fiber -$y1  0. $matTagSteel     stressStrain
recorder Element -file $analysisResultsDirectory/SteelFib2_SS.txt -time -ele 1 section fiber  $y1  0. $matTagSteel     stressStrain
recorder Element -file $analysisResultsDirectory/Centroid_SS.txt -time -ele 1 section fiber  $y1  0. $matTagConcCore     stressStrain

record; # This is to record the state before the analysis starts

# ###############################################################################################################################################################################
# #########################################################################  START ANALYSIS  ####################################################################################
# ###############################################################################################################################################################################

# Loop over the peak of cycles
for {set ii 1} {$ii<=[llength $peakDisp]} {incr ii} {
    # Convergence check
	if {$ok == 0} { 
		set cycleDisp [expr [lindex $peakDisp [expr $ii-1]] - $currentDisp]; # the total deformation of the loading cycle
		# determine the sign of loading:
		if {$cycleDisp>0} {
			set sign 1.;
		} else {
			set sign -1.;
		};
		set dU [expr $du*$sign];
		# General analysis properties
		constraints Transformation;     			
		numberer Plain;			
		system BandGeneral;
		integrator DisplacementControl $controlNode $controlDOF $dU;
		test RelativeNormDispIncr $tol $iter;
		algorithm KrylovNewton;
		analysis Static;
		set NSteps [expr int(abs($cycleDisp/$dU))];
		puts "";
		puts "Starting Cycle # [lindex $cyclelabel [expr $ii-1]] with target displacement of [expr [lindex $peakDisp [expr $ii-1]]]"
		puts "======================================================"
		puts "---> Running $NSteps steps with step size = $dU in. to go from displ. = $currentDisp to displ. = [expr [lindex $peakDisp [expr $ii-1]]]"
		set ok1 [analyze $NSteps];
		set currentDisp [nodeDisp $controlNode $controlDOF];
		#If it does not converge, change strategies
		if {$ok1 !=0 } {
			set ok 0;
			puts "		Try stuff, peak disp = [expr [lindex $peakDisp [expr $ii-1]]]";
			puts "	    Current disp = $currentDisp";
			puts "		Cycle disp  = $cycleDisp";
			set counter 1;
			while {( ( ([expr $currentDisp] <= [expr [lindex $peakDisp [expr $ii-1]]]) && ($sign == 1)  ) || (  ([expr $currentDisp] >= [expr [lindex $peakDisp [expr $ii-1]]]) && ($sign == -1)   ) )&&($ok==0)} {
				set ok 1;
				while {$ok!=0} {
					if {$counter == 0} {
						# return to initial conditions
						set dU [expr $du*$sign*1.00];
						test NormDispIncr $tol $iter 0;
						set counter 1;
					} elseif {$counter == 1} {
						# increase load stepsize
						set dU [expr $du*$sign*1.5];
						#puts "dU = $du*$sign*1.5 = $dU";
						set counter 2;
					} elseif {$counter == 2} {
						# increase load stepsize
						set dU [expr $du*$sign*2.00];
						#puts "dU = $du*$sign*2.0 = $dU";
						set counter 3;
					} elseif {$counter == 3} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.5];
						#puts "dU = $du*$sign*0.5 = $dU";
						set counter 4;
					} elseif {$counter == 4} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.1];
						#puts "dU = $du*$sign*0.1 = $dU";
						set counter 5;
					} elseif {$counter == 5} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.05];
						#puts "dU = $du*$sign*0.05 = $dU";
						set counter 6;
					} elseif {$counter == 6} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.01];
						#puts "dU = $du*$sign*0.01 = $dU";
						set counter 7;
					} elseif {$counter == 7} {
						# decrease load stepsize
						set dU [expr $du*$sign*0.001];
						#puts "dU = $du*$sign*0.001 = $dU";
						set counter 8;
					};
					integrator DisplacementControl $controlNode  $controlDOF  $dU;
					set ok [analyze 1]
					if {$ok != 0} {
						puts "Try Newton Initial"
						algorithm Newton -initial
						test NormDispIncr $tol $iter 0;
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Displacement"
						test RelativeNormDispIncr $tol $iter 0;
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "ModifiedNewton"
						algorithm ModifiedNewton
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Energy"
						algorithm Newton -initial;
						test RelativeEnergyIncr $tol $iter 0;
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Newton Modified -initial"
						algorithm ModifiedNewton -initial
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Force"
						algorithm Newton -initial;
						test RelativeNormUnbalance $tol $iter 0
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Test Relative Displ"
						test RelativeNormDispIncr $tol $iter 0
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Broyden"
						algorithm Broyden 8
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "Newton Line Search"
						algorithm NewtonLineSearch .8
						set ok [analyze 1];
					};
					if {$ok != 0} {
						puts "BFGS"
						algorithm BFGS
						set ok [analyze 1];
					};
				};
				set counter 0;
				set currentDisp [nodeDisp $controlNode $controlDOF];
                #puts $currentDisp
			};
			puts "Cycle # [lindex $cyclelabel [expr $ii-1]] successfully finished!"
			puts "target displ.  = [expr [lindex $peakDisp [expr $ii-1]]]"
			puts "current displ. = [nodeDisp $controlNode $controlDOF]"
			puts "---------------------------------x---------------------------------------";
		} else {
			puts "Cycle # [lindex $cyclelabel [expr $ii-1]] successfully finished!"
			puts "target displ.  = [expr [lindex $peakDisp [expr $ii-1]]]"
			puts "current displ. = [nodeDisp $controlNode $controlDOF]"
			puts "---------------------------------x---------------------------------------";
		};
	};
};
if { $ok<0 } {
   puts "FAILED TO CONVERGE!!" 
} else {
   puts "";
   puts "ALL SUCCESSFUL!!"
   puts $modelnum
}
