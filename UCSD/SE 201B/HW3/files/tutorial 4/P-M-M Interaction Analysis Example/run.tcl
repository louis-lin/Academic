# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# NONLINEAR FIBER SECTION ANALYSIS : PMM INTERACTION DIAGRAM ANALYSIS
# ####################################################################################
#  PMM Interaction Diagram
#  Sept 15th 2011. Andre Barbosa
#  Revised: Feb. 2016. Angshuman Deb

# ------------------------------------------------------------------------------------
# SETUP DATA DIRECTORY FOR SAVING OUTPUTS
# ------------------------------------------------------------------------------------
set analysisResultsDirectory "AnalysisResults";	# Set up name of data directory
file mkdir $analysisResultsDirectory; # Create data directory

# ------------------------------------------------------------------------------------
# DEFINE UNITS
# ------------------------------------------------------------------------------------
source units.tcl

# ------------------------------------------------------------------------------------
# SETUP
# ------------------------------------------------------------------------------------
source model.tcl
set criterion -0.003; # When the maximum compressed fiber reaches this value, the section fails 

# Estimate approximate yield curvature
set d [expr $colDepth - $cover]; 
set epsy [expr $fy/$Es];  # Steel yield strain
set Ky [expr ($epsy + abs($criterion))/$d];
set dK [expr 0.01*$Ky];

# Estimate Pmax
set P0 [expr 1.01*(abs($fpc)*$colWidth*$colDepth + $totNumBars*$fy*$As)]; # Estimated Axial load Capacity

foreach {iCase iMy iMz} { 
	1	1.0	0.0
	2	1.0	0.1
	3	1.0	0.2
	4	1.0	0.3
	5	1.0	0.4
	6	1.0	0.5
	7	1.0	0.6
	8	1.0	0.7
	9	1.0	0.8
	10	1.0	0.9
	
	11	1.0	1.0
	12	0.9	1.0
	13	0.8	1.0
	14	0.7	1.0
	15	0.6	1.0
	16	0.5	1.0
	17	0.4	1.0
	18	0.3	1.0
	19	0.2	1.0
	20	0.1	1.0
	21	0.0	1.0
} { 
	
	set resultsFileID [open "$analysisResultsDirectory/PM$iCase.txt"  "w"]
	
    # Other parameters
    set P  0.0;
	set Mz 0.0;
	set My 0.0;
    set incrP [expr 0.01*$P0]; # Axial load increment
    
    set Flag 1;
    
    # ------------------------------------------------------------------------------------
    # PMM - ANALYSIS
    # ------------------------------------------------------------------------------------
    # Loop over all axial loads
	while { $Flag > 0  && $P <= $P0 && $Mz >=  -0.1 && $My >= -0.1}  {
		source model.tcl
		
		# Set axial load
        set axialLoad -$P
        
        # Define constant axial load
        set axialLoadTag 1
        pattern Plain $axialLoadTag "Linear" {
            load $controlNode $axialLoad 0.0 0.0 0.0 0.0 0.0 
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
		
		if { $ok < 0 } { puts "Analysis FAILED for axial load!!";}
		
		# Define reference load pattern
        if {$iMy >= $iMz} {
			set controlDOF 5;
		} else {
			set controlDOF 6;
		}
        set momentLoadTag 2
        pattern Plain $momentLoadTag "Linear" {
			load $controlNode 0.0 0.0 0.0 0.0 $iMy $iMz
		}
		
		# Get axial strain and curvature
		set e1 [nodeDisp $controlNode 1]
		set e2 [nodeDisp $controlNode 5]
		set e3 [nodeDisp $controlNode 6]
	
		set Flag 1;
	
		if { abs($e1) >  abs($criterion) }  { 
			# Check if axial load is too big
			puts "Oops, axial force P is too big."
			set Flag 0  ; # end the loop
	
		} else {
			# Use displacement control at controlNode for section analysis
			integrator DisplacementControl $controlNode $controlDOF $dK;
			
			set maxStrain [expr $e1 - $e2*$colWidth/2.0 - $e3*$colDepth/2.0]; # Compute extreme concrete fiber compressive strain (negative)
			
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
				# Get axial strain and curvature
                set e1 [nodeDisp $controlNode 1]
				set e2 [nodeDisp $controlNode 5]
				set e3 [nodeDisp $controlNode 6]
                # Compute extreme concrete fiber compressive strain (negative)
				set maxStrain [expr $e1 - $e2*$colWidth/2.0 - $e3*$colDepth/2.0]
			}
			set forces [eleResponse 1 forces]
			set My [lindex $forces 10]
			set Mz [lindex $forces 11]
			puts "Axial Load: $P .... Steps: $step .... dK: $dK ... My: $My Mz: $Mz"
            
			# Write results to file
			set data "$forces"
			puts $resultsFileID $data;
		}   ; # End of if (p is not too big)
	
		set P [expr $P + $incrP]; # Update P
	}  ; # End of while
	
	close $resultsFileID
	puts "Done Case: $iCase! "
}; # End of foreach Loop
wipe;