# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# HOMEWORK # 1
# NONLINEAR QUASI-STATIC & TIME-HISTORY ANALYSIS OF A SDOF SYSTEM
# ####################################################################################
# Angshuman Deb

# PUSHOVER ANALYSIS (LOAD CONTROLLED) ------------------------------------------------

# SET LOAD LEVELS VECTOR -------------------------------------------------------------
set loadFileName "P.txt";           # load file name with one col (force values) (Need to set it manually)

# EXTRACT LOAD DATA ------------------------------------------------------------------
set data_fid [open $loadFileName "r"]
set data [read $data_fid]
close $data_fid
set data_new [split $data "\n"]
set P {}
for {set k 0} {$k <= [expr [llength $data_new] - 2]} {incr k 1} {
    set data_t [lindex $data_new $k]
    lappend P [lindex $data_t 0]
}
set nls [expr [llength $P] - 1]; # Number of load steps

# DEFINE TIME SERIES -----------------------------------------------------------------
set tsTag 1; # Tag for the time series
set dt 1.; # Time step of 1.0 for load application. Doesn't matter for a static analysis.

#timeSeries Path $tag   -dt $dt -values {list_of_values}
timeSeries Path $tsTag -dt 1.  -values  $P;

# DEFINE LOAD PATTERN ----------------------------------------------------------------
set loadTag 1; # Tag for the load pattern
pattern Plain $loadTag $tsTag {
	#load $nodeTag      (ndf $LoadValues)
	load  $nodeTag2     1.0;         # Reference load = 1.0 will be multiplied by the values in the list P.
}

# CREATE THE SYSTEM OF EQUATIONS -----------------------------------------------------
system BandGeneral;

# CREATE THE CONSTRAINT HANDLER ------------------------------------------------------
constraints Plain; 

# CREATE THE DOF NUMBERER ------------------------------------------------------------
numberer Plain; 

# CREATE THE CONVERGENCE TEST --------------------------------------------------------
test NormUnbalance 1.0e-5 1000; # The norm of the displacement increment with a tolerance of 1e-5 and a max number of iterations of 1000. The "1" or "0" at the end shows/doesn't show all iterations.

# CREATE SOLUTION ALGORITHM ----------------------------------------------------------
set algorithmBasic [split $algorithmString]
algorithm {*}$algorithmBasic

# CREATE THE INTEGRATION SCHEME ------------------------------------------------------
set lambda 1.; # Set the load factor increment. A value of 1 indicates no further divison of load levels into steps. A value of 0.1, for example, would mean subdivision of each load step into 10 further steps.
integrator LoadControl $lambda; # The LoadControl scheme

# CREATE THE ANALYSIS OBJECT ---------------------------------------------------------
analysis $analysisType; 

# RECORD AND SAVE OUTPUT -------------------------------------------------------------
source generateRecorders.tcl; # Call file Recorders.tcl to record desired structural responses and save as an output file

# ANALYZE ----------------------------------------------------------------------------
set nSteps 1; # Set the number of steps in which the structure is to be analyzed for each load increment. A value of 1 is used to analyze the structure for each load step at a time and not in one go.
for {set i 1} {$i <= $nls} {incr i 1} { 
	set ok [analyze $nSteps]; # Analyze the structure for each load increment (0 - 200, 200 - 300, etc.). Sets ok to 0 if successful.
	# If the solution algorithm fails, as expected at reversals, change analysis option to Newton
	if {$ok != 0} {
		puts "Solution algorithm failed! Might be a load reversal! Changing algorithm to Newton"
		algorithm Newton;
		set ok [analyze $nSteps];
		# If successful, revert to original algorithm
		if {$ok == 0} {
			puts "Changing to Newton helped. Going back to original algorithm"
			algorithm {*}$algorithmBasic
		}
	}
}
