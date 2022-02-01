# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# OpenSees Tutorial # 3
# Lee Frame
# ####################################################################################

#Always start with
wipe; # Clear memory of all past model definitions
model BasicBuilder -ndm 2 -ndf 3; # Define the model builder, ndm=#dimension, ndf=#dofs

# ------------------------------------------------------------------------------------
# DEFINE UNITS
# ------------------------------------------------------------------------------------
source units.tcl;

set loading -18000.;
# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------
set analysis2 "PDelta";
# ------------------------------------------------------------------------------------
# SETUP DATA DIRECTORY FOR SAVING OUTPUTS
# ------------------------------------------------------------------------------------
set analysisResultsDirectory "$analysis2/AnalysisResults";	# Set up name of data directory
file mkdir $analysisResultsDirectory; # Create data directory

set modelDirectory "$analysis2/Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];

set deflectedShapeDirectory "$analysis2/DeflectedShape"
file mkdir $deflectedShapeDirectory;

# ------------------------------------------------------------------------------------
# DEFINE MODEL WITH LOADS
# ------------------------------------------------------------------------------------
source Lee_frame_PDelta.tcl;
# ------------------------------------------------------------------------------------
# ANALYSIS
# ------------------------------------------------------------------------------------
source analysisPushover.tcl;


# Don't forget to
remove recorders
# and
wipe;
reset;

set analysis1 "Corotational";
# ------------------------------------------------------------------------------------
# SETUP DATA DIRECTORY FOR SAVING OUTPUTS
# ------------------------------------------------------------------------------------
set analysisResultsDirectory "$analysis1/AnalysisResults";	# Set up name of data directory
file mkdir $analysisResultsDirectory; # Create data directory

set modelDirectory "$analysis1/Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];

set deflectedShapeDirectory "$analysis1/DeflectedShape"
file mkdir $deflectedShapeDirectory;

# ------------------------------------------------------------------------------------
# DEFINE MODEL WITH LOADS
# ------------------------------------------------------------------------------------
source Lee_frame_Corotational.tcl;
# ------------------------------------------------------------------------------------
# ANALYSIS
# ------------------------------------------------------------------------------------
source analysisPushover.tcl;


# Don't forget to
remove recorders
# and
wipe;
reset;


# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------
set analysis3 "Linear";
# ------------------------------------------------------------------------------------
# SETUP DATA DIRECTORY FOR SAVING OUTPUTS
# ------------------------------------------------------------------------------------
set analysisResultsDirectory "$analysis3/AnalysisResults";	# Set up name of data directory
file mkdir $analysisResultsDirectory; # Create data directory

set modelDirectory "$analysis3/Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];

set deflectedShapeDirectory "$analysis3/DeflectedShape"
file mkdir $deflectedShapeDirectory;

# ------------------------------------------------------------------------------------
# DEFINE MODEL WITH LOADS
# ------------------------------------------------------------------------------------
source Lee_frame_Linear.tcl;
# ------------------------------------------------------------------------------------
# ANALYSIS
# ------------------------------------------------------------------------------------
source analysisPushover.tcl;


# Don't forget to
remove recorders
# and
wipe;
reset;