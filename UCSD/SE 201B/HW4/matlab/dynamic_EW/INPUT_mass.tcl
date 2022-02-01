
# MASS ASSIGNMENT -----------------------------------------------------------------------------------------
set topFloorMass 	[expr 33734.8*$lbf*pow($sec,2)/$ft];
set floorMass 		[expr 41734.8*$lbf*pow($sec,2)/$ft];
set botFloorMass 	[expr 87727.8*$lbf*pow($sec,2)/$ft];

set fCentr 0.65;	# Percentage of mass in the centroid
set fSouth 0.35;	# Percentage of mass in the south node
set fNorth [expr 1.0 - $fCentr - $fSouth];	# Percentage of mass in the north node


set factorYdir 1.;

# Mass in the Y direction assigned to core walls
for {set i 1} {$i <= $nStory} {incr i} {
	if {$i == 1} {
		set MassC [expr $botFloorMass*$fCentr/2.]
		set MassN [expr $botFloorMass*$fNorth/2.]
		set MassS [expr $botFloorMass*$fSouth/2.]
		
		mass [expr 1000*$i+100+$nEleFloor] $MassC [expr $factorYdir*$MassC] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor] $MassC [expr $factorYdir*$MassC] 0. 0. 0. 0.
		
		mass [expr 1000*$i+100+$nEleFloor + 1] $MassN [expr $factorYdir*$MassN] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor + 1] $MassN [expr $factorYdir*$MassN] 0. 0. 0. 0.
		
		mass [expr 1000*$i+100+$nEleFloor + 2] $MassS [expr $factorYdir*$MassS] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor + 2] $MassS [expr $factorYdir*$MassS] 0. 0. 0. 0.
		
	} elseif {$i == $nStory} {
		set MassC [expr $topFloorMass*$fCentr/2.]
		set MassN [expr $topFloorMass*$fNorth/2.]
		set MassS [expr $topFloorMass*$fSouth/2.]
		
		mass [expr 1000*$i+100+$nEleFloor] $MassC [expr $factorYdir*$MassC] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor] $MassC [expr $factorYdir*$MassC] 0. 0. 0. 0.
		
		mass [expr 1000*$i+100+$nEleFloor + 1] $MassN [expr $factorYdir*$MassN] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor + 1] $MassN [expr $factorYdir*$MassN] 0. 0. 0. 0.
		
		mass [expr 1000*$i+100+$nEleFloor + 2] $MassS [expr $factorYdir*$MassS] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor + 2] $MassS [expr $factorYdir*$MassS] 0. 0. 0. 0.
		
	} else {
		set MassC [expr $floorMass*$fCentr/2.]
		set MassN [expr $floorMass*$fNorth/2.]
		set MassS [expr $floorMass*$fSouth/2.]
		
		mass [expr 1000*$i+100+$nEleFloor] $MassC [expr $factorYdir*$MassC] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor] $MassC [expr $factorYdir*$MassC] 0. 0. 0. 0.
		
		mass [expr 1000*$i+100+$nEleFloor + 1] $MassN [expr $factorYdir*$MassN] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor + 1] $MassN [expr $factorYdir*$MassN] 0. 0. 0. 0.
		
		mass [expr 1000*$i+100+$nEleFloor + 2] $MassS [expr $factorYdir*$MassS] 0. 0. 0. 0.
		mass [expr 1000*$i+200+$nEleFloor + 2] $MassS [expr $factorYdir*$MassS] 0. 0. 0. 0.
	}
}