# ##############################################################################################
# 						  SE 201B: NONLINEAR STRUCTURAL ANALYSIS                               #
#						                Winter 2021                                            #
# ##############################################################################################

# Don't forget to
wipe;

# DEFINE MODEL ----------------------------------------------------------------------
source model.tcl;

# ANALYSIS --------------------------------------------------------------------------
if {$analysisType == "static"} {
    source loadControlStaticAnalysis.tcl;
    source dispControlStaticAnalysis.tcl;
} elseif {$analysisType == "dynamic"} {
    source modalAnalysis.tcl
    source loadControlStaticAnalysis.tcl;
    source modalAnalysis.tcl
    source timeHistoryAnalysis.tcl;
}

# Don't forget to
wipe;
