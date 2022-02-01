set analysisResultsDirectory "AnalysisResults";
file mkdir $analysisResultsDirectory;
set modelDirectory "Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];
source units.tcl;
source modelLI1.tcl;
source loadControlStaticAnalysis.tcl;
source dispControlAnalysis.tcl;
remove recorders
wipe;
