# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# OpenSees Tutorial # 3
# 2D FRAME ANALYSIS (LINEAR MATERIAL + NONLINEAR GEOMETRY) EXAMPLE
# ####################################################################################


for {set i 1} {$i <= [llength $nodeList]} {incr i 1} {
	set dispNodeTag [lindex $nodeList [expr $i-1]];
	set dispNodeFile "dispNode_$dispNodeTag.txt"
	recorder Node -file $deflectedShapeDirectory/$dispNodeFile -node $dispNodeTag -dof 1 2 disp
}