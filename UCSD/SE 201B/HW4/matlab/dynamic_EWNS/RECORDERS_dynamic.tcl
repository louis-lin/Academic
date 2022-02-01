
# ###################################################################################################################################################################################################
# ################################################################################ DYNAMIC ANALYSIS RECORDERS #######################################################################################
# ###################################################################################################################################################################################################


# ###################################################################################################################################################################################################
# ################################################################################ STATIC ANALYSIS RECORDERS ########################################################################################
# ###################################################################################################################################################################################################

set controlNode [expr 1000*$nStory + 200 + $nEleFloor];

recorder Node -file $ResultsDirectory/Reaction.txt -time -node 1100 1200 -dof 1 2 3 4 5 6 reaction
recorder Node -file $ResultsDirectory/Disp.txt -time -node $controlNode -dof 1 2 disp

recorder Element -file $ResultsDirectory/SecF_W1_base.txt -ele 1101 section 1 force
recorder Element -file $ResultsDirectory/SecF_W2_base.txt -ele 1201 section 1 force

recorder Element -file $ResultsDirectory/SecD_W2_base.txt -ele 1201 section 1 deformation
recorder Element -file $ResultsDirectory/SecD_W1_base.txt -ele 1101 section 1 deformation

recorder Element -file $ResultsDirectory/EleF_CB_f15.txt -ele 15001 15003 globalForce
recorder Element -file $ResultsDirectory/EleF_CB_f8.txt -ele 8001 8003 globalForce
recorder Element -file $ResultsDirectory/EleF_CB_f1.txt -ele 1001 1003 globalForce

recorder Element -file $ResultsDirectory/AxialDef_CB_f15.txt -ele 15001 15003 deformations
recorder Element -file $ResultsDirectory/AxialDef_CB_f8.txt -ele 8001 8003 deformations
recorder Element -file $ResultsDirectory/AxialDef_CB_f1.txt -ele 1001 1003 deformations
	
recorder Node -file $ResultsDirectory/disp_FL2.txt -time -node [expr 2100 + $nEleFloor] -dof 1 2 disp;
recorder Node -file $ResultsDirectory/disp_FL6.txt -time -node [expr 6100 + $nEleFloor] -dof 1 2 disp;
recorder Node -file $ResultsDirectory/disp_FL11.txt -time -node [expr 11100 + $nEleFloor] -dof 1 2 disp;
recorder Node -file $ResultsDirectory/disp_FL15.txt -time -node [expr 15100 + $nEleFloor] -dof 1 2 disp;
	
recorder Node -file $ResultsDirectory/accel_FL2.txt -timeSeries $gmLoadTag_L -time -node [expr 2100 + $nEleFloor] -dof 1 2 accel 
recorder Node -file $ResultsDirectory/accel_FL6.txt -timeSeries $gmLoadTag_L -time -node [expr 6100 + $nEleFloor] -dof 1 2 accel 
recorder Node -file $ResultsDirectory/accel_FL11.txt -timeSeries $gmLoadTag_L -time -node [expr 11100 + $nEleFloor] -dof 1 2 accel 
recorder Node -file $ResultsDirectory/accel_FL15.txt -timeSeries $gmLoadTag_L -time -node [expr 15100 + $nEleFloor] -dof 1 2 accel 
	
# ##################################################################################################################
# ############################## PLOT DEFLECTED SHAPE IN MATLAB ####################################################
# ##################################################################################################################

for {set i 1} {$i <= [llength $Nodes]} {incr i 1} {
	set dispNodeTag [lindex $Nodes [expr $i-1]];
	set dispNodeFile "dispNode_$dispNodeTag.txt"
	recorder Node -file $DeflectedShapeDirectory/$dispNodeFile -node $dispNodeTag -dof 1 2 3 disp
}