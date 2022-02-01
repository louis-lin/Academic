
# ###################################################################################################################################################################################################
# ################################################################################ STATIC ANALYSIS RECORDERS ########################################################################################
# ###################################################################################################################################################################################################

recorder Node -file $ResultsDirectory/Reaction.txt -time -node 1100 1200 -dof $controlDOF reaction
recorder Node -file $ResultsDirectory/Disp.txt -time -node $controlNode -dof $controlDOF disp

recorder Element -file $ResultsDirectory/SecF_W1_base.txt -ele 1101 section 1 force
recorder Element -file $ResultsDirectory/SecD_W1_base.txt -ele 1101 section 1 deformation

recorder Element -file $ResultsDirectory/SecF_W2_base.txt -ele 1201 section 1 force
recorder Element -file $ResultsDirectory/SecD_W2_base.txt -ele 1201 section 1 deformation

recorder Element -file $ResultsDirectory/EleF_CB_f15.txt -ele 15001 15003 globalForce
recorder Element -file $ResultsDirectory/EleF_CB_f8.txt -ele 10001 10003 globalForce
recorder Element -file $ResultsDirectory/EleF_CB_f1.txt -ele 1001 1003 globalForce

recorder Element -file $ResultsDirectory/AxialDef_CB_f15.txt -ele 15001 15003 deformations
recorder Element -file $ResultsDirectory/AxialDef_CB_f8.txt -ele 10001 10003 deformations
recorder Element -file $ResultsDirectory/AxialDef_CB_f1.txt -ele 1001 1003 deformations

# For N - and M - diagrams
for {set i 1} {$i <= $nStory} {incr i 1} {
	for {set j 1} {$j <= $nEleFloor} {incr j 1} {
		
		set eleTag [expr 1000*$i + 200 + $j];
		set filename1 "SecF_$eleTypeWall$eleTag.txt"
		set filename2 "LocEleF_$eleTypeWall$eleTag.txt"
		set filename3 "GlobEleF_$eleTypeWall$eleTag.txt"
		set filename4 "IntPts_$eleTypeWall$eleTag.txt"
		
		recorder Element -file $ResultsDirectory/$filename1 -ele $eleTag section force
		recorder Element -file $ResultsDirectory/$filename2 -ele $eleTag localForce
		recorder Element -file $ResultsDirectory/$filename3 -ele $eleTag globalForce
		recorder Element -file $ResultsDirectory/$filename4 -ele $eleTag integrationPoints
        
        set eleTag [expr 1000*$i + 100 + $j];
		set filename1 "SecF_$eleTypeWall$eleTag.txt"
		set filename2 "LocEleF_$eleTypeWall$eleTag.txt"
		set filename3 "GlobEleF_$eleTypeWall$eleTag.txt"
		set filename4 "IntPts_$eleTypeWall$eleTag.txt"
		
		recorder Element -file $ResultsDirectory/$filename1 -ele $eleTag section force
		recorder Element -file $ResultsDirectory/$filename2 -ele $eleTag localForce
		recorder Element -file $ResultsDirectory/$filename3 -ele $eleTag globalForce
		recorder Element -file $ResultsDirectory/$filename4 -ele $eleTag integrationPoints
	}
};

# ##################################################################################################################
# ##################################################################################################################
# ############################## PLOT DEFLECTED SHAPE IN MATLAB ####################################################
# ##################################################################################################################

for {set i 1} {$i <= [llength $Nodes]} {incr i 1} {
	set dispNodeTag [lindex $Nodes [expr $i-1]];
	set dispNodeFile "dispNode_$dispNodeTag.txt"
	recorder Node -file $DeflectedShapeDirectory/$dispNodeFile -node $dispNodeTag -dof 1 2 3 disp
}
