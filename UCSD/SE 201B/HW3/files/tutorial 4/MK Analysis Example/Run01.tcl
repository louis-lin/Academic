set analysisResultsDirectory "AnalysisResults";
file mkdir $analysisResultsDirectory;
set modelDirectory "Model";
file mkdir $modelDirectory;
set modelExportFileID [open "$modelDirectory/modelData.txt" "w"];
source units.tcl;
source model2.tcl;
source loadControlStaticAnalysis01.tcl;
source dispControlStaticAnalysis.tcl;
remove recorders
wipe;
