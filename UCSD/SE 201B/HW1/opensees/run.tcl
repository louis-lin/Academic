# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# HOMEWORK # 1
# NONLINEAR QUASI-STATIC & TIME-HISTORY ANALYSIS OF A SDOF SYSTEM
# ####################################################################################
# Angshuman Deb

# UNITS: kip, in, sec (OpenSees doesn't have units. So be consistent!)

# INITIALIZATION ---------------------------------------------------------------------
wipe; # Clear memory of all past model definitions
model BasicBuilder -ndm 1 -ndf 1; # Define the model builder, ndm=#dimension, ndf=#dofs

# SETUP DATA DIRECTORY FOR SAVING OUTPUTS --------------------------------------------
set dataDir "Results";	# Set up name of data directory
file mkdir $dataDir; # Create data directory

# SET ANALYSIS TYPE ------------------------------------------------------------------
set analysisType "Static"; # Change between Static & Transient
set algorithmString "Newton"; # Change between Newton, ModifiedNewton and ModifiedNewton -initial

# SOURCE MODEL -----------------------------------------------------------------------
source "trussModel.tcl"

# ANALYSIS ---------------------------------------------------------------------------
if {$analysisType == "Static"} {
	source analysisPushover.tcl;
} elseif {$analysisType == "Transient"} {
	source analysisTimeHistory.tcl
}

if {$ok == 0} {
	puts "ANALYSIS DONE!"; # Spit out a success message	
} else {
	puts "ANALYSIS FAILED!"; # Spit out a failure message
}

# DON'T FORGET TO -------------------------------------------------------------------- 
remove recorders;
# AND/OR
wipe;