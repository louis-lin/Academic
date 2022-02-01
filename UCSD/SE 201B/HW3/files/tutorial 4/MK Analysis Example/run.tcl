# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# NONLINEAR FIBER SECTION ANALYSIS
# ####################################################################################

# ------------------------------------------------------------------------------------
# SETUP DATA DIRECTORY FOR SAVING OUTPUTS
# ------------------------------------------------------------------------------------
set analysisResultsDirectory "AnalysisResults";	# Set up name of data directory
file mkdir $analysisResultsDirectory; # Create data directory

set modelDirectory "Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];

# ------------------------------------------------------------------------------------
# DEFINE UNITS
# ------------------------------------------------------------------------------------
source units.tcl;

# ------------------------------------------------------------------------------------
# DEFINE MODEL WITH LOADS
# ------------------------------------------------------------------------------------
source model.tcl;

# ------------------------------------------------------------------------------------
# ANALYSIS
# ------------------------------------------------------------------------------------
source loadControlStaticAnalysis01.tcl;
source dispControlStaticAnalysis.tcl;

# Don't forget to
remove recorders
# and
wipe;
