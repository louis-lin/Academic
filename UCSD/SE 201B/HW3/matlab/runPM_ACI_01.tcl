# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# NONLINEAR FIBER SECTION ANALYSIS : PM INTERACTION DIAGRAM ANALYSIS
# ####################################################################################
#  Feb. 6th 2008. Quan and Andre
#  Revised: Feb. 2016. Angshuman Deb

# ------------------------------------------------------------------------------------
# SETUP DATA DIRECTORY FOR SAVING OUTPUTS
# ------------------------------------------------------------------------------------
set analysisResultsDirectory "AnalysisResults";	# Set up name of data directory
file mkdir $analysisResultsDirectory; # Create data directory

set modelDirectory "Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];
close $modelExportFileID

set resultsFileID [open "$analysisResultsDirectory/PM_Results.txt"  "w"];

# ------------------------------------------------------------------------------------
# DEFINE UNITS
# ------------------------------------------------------------------------------------
source units.tcl;

# ------------------------------------------------------------------------------------
# SETUP
# ------------------------------------------------------------------------------------
source model01.tcl
set criterion -0.003; # When the maximum compressed fiber reaches this value, the section fails 

# Estimate approximate yield curvature
set d [expr $colDepth - $cover]; 
set epsy [expr $fy/$Es];  # Steel yield strain
set Ky [expr ($epsy + abs($criterion))/$d];
set dK [expr 0.01*$Ky];

# Estimate Pmax
set P0 [expr 1.01*(abs($fpc)*$colWidth*$colDepth + $totNumBars*$fy*$As)]; # Estimated Axial load Capacity

# Other parameters
set P 0.0; # Initial axial load
set incrP [expr 0.01*$P0]; # Axial load increment

set Flag 1;

# ------------------------------------------------------------------------------------
# PM - ANALYSIS
# ------------------------------------------------------------------------------------
# Loop over all axial loads
while { $Flag > 0  && $P <= $P0 }  {
	source model02.tcl
	
    # Set axial load
	set axialLoad -$P
	
	# Print axial load value on the screen:
	puts "axialLoad: $P"
	
	# Define constant axial load
	set axialLoadTag 1
    pattern Plain $axialLoadTag "Linear" {
		load $controlNode $axialLoad 0.0 0.0
	}
	
	# Analyze for axial load
	set tol 1.e-10;
	set iter 2000;
	set lambda 1.0
    integrator LoadControl $lambda
	system ProfileSPD
	test NormUnbalance $tol $iter
	numberer Plain
	constraints Plain
	algorithm Newton
	analysis Static
    set nSteps [expr int(1./$lambda)];
    set ok [analyze $nSteps];
    loadConst -time 0.0
    
	if { $ok < 0 } {puts "Analysis FAILED for axial load!"}
	
	# Define reference load pattern
    set controlDOF 3
	set momentLoadTag 2
    pattern Plain $momentLoadTag "Linear" {
		load $controlNode 0.0 0.0 1.0
	}
	
	# Get axial strain and curvature
	set e1 [nodeDisp $controlNode 1]; # Get the centroid strain 
	set e3 [nodeDisp $controlNode 3]; # Get the curvature
    
	set Flag  1;
	if { abs($e1) >  abs($criterion) }  {
        # Check if axial load is too big
        puts " Oops, axial force P is too big."
	    set Flag 0  ; # end the loop
	} else {
		# Use displacement control at controlNode for section analysis
		# integrator DisplacementControl $node $dof $incr
		integrator DisplacementControl $controlNode $controlDOF $dK;
		
		set maxStrain [expr $e1 - $e3*$colDepth/2.0]; # Compute extreme concrete fiber compressive strain (negative)
		
		set step 0  
			
		while  { abs($maxStrain) < abs($criterion) } {
			set ok [analyze 1]
			# This list of alternative analysis options is not all-inclusive. You can add more to it.
			if {$ok != 0} {
				puts "Test Relative Force"
				test RelativeNormUnbalance $tol $iter 0;
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
				test RelativeEnergyIncr $tol $iter
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
			
			incr step 1 
			set e1 [nodeDisp $controlNode 1]; # Get the centroid strain
			set e3 [nodeDisp $controlNode 3]; # Get the curvature
			set maxStrain [expr $e1 - $e3*$colDepth/2.0]; # Compute extreme concrete fiber compressive strain (negative)
		}
        
		set moment [getTime]; # This a trick.. the "time" is the loadstep. See tutorial!
		puts "step: $step,  maxStrain: $maxStrain, Moment: $moment"
		
		# Write results to file
		set data "$P		$moment"
		puts $resultsFileID $data; 
		
	}   ; # End of if (p is not too big)
	
	set P [expr $P + $incrP]; # Update P
}; # End of while

close $resultsFileID;
puts "Done!"
wipe;
