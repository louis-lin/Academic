set Ix_SingleCWall [expr 2.0409e8*$in4];
set Iy_SingleCWall [expr 2.5111e7*$in4];

set Ip_SingleCWall [expr $Ix_SingleCWall + $Iy_SingleCWall];
set A_SingleCWall [expr 15120.0*$in2];

 ############################# WALL 1 and 2 #######################################
 
for {set i 1} {$i <= $nStory} {incr i 1} {

	if {$i == 1} {
		set iNode1 1100;
		set iNode2 1200;
	} else {
		set iNode1 $jNode1;
		set iNode2 $jNode2;
	}
	
	set jNode1 [expr 1000*$i + 100 + 1];
	set jNode2 [expr 1000*$i + 200 + 1];
	
	# First element of each floor ---------------------------------------------------------------------------------------------------------------------------
	if {$eleTypeWall == "dispBeamColumn"} {
		element dispBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto
		element dispBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto
		
		puts $ModelFile "element dispBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto"
		puts $ModelFile "element dispBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto"
		
	} elseif {$eleTypeWall == "forceBeamColumn"} {
		element forceBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto -iter $maxIters $fbtol
		element forceBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto -iter $maxIters $fbtol
		
		puts $ModelFile "element forceBeamColumn [expr 1000*$i + 100 + 1] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto -iter $maxIters $fbtol"
		puts $ModelFile "element forceBeamColumn [expr 1000*$i + 200 + 1] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto -iter $maxIters $fbtol"
		
	}
	# --------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	# Remaining elements of each floor -----------------------------------------------------------------------------------------------------------------------
	for {set j 1} {$j <= [expr $nEleFloor - 1]} {incr j 1} {
	
		set iNode1 $jNode1;
		set iNode2 $jNode2;
		
		set jNode1 [expr 1000*$i + 100 + ($j + 1)];
		set jNode2 [expr 1000*$i + 200 + ($j + 1)];
		
		if {$eleTypeWall == "dispBeamColumn"} {
		
			element dispBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto
			element dispBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto
			
			puts $ModelFile "element dispBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto"
			puts $ModelFile "element dispBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto"
		
		} elseif {$eleTypeWall == "forceBeamColumn"} {
		
			element forceBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto -iter $maxIters $fbtol
			element forceBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto -iter $maxIters $fbtol
			
			puts $ModelFile "element forceBeamColumn [expr 1000*$i + 100 + ($j + 1)] $iNode1 $jNode1 $numIntgrPts $secTagWall $transfTagVertLeft -integration Lobatto -iter $maxIters $fbtol"
			puts $ModelFile "element forceBeamColumn [expr 1000*$i + 200 + ($j + 1)] $iNode2 $jNode2 $numIntgrPts $secTagWall $transfTagVertRight -integration Lobatto -iter $maxIters $fbtol"
		
		}
		
		
	}
	# -----------------------------------------------------------------------------------------------------------------------------------------------------

	
	# Rigid elements in each floor --------------------------------------------------------------------------------------------------------------------
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 1] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 1] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 2] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 2] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 3] [expr 1000*$i + 100 + $nEleFloor + 1]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 4] [expr 1000*$i + 100 + $nEleFloor + 2]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 100 + $nEleFloor + 5]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 100 + $nEleFloor + 6]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 100 + $nEleFloor + 7]	[expr 1000*$i + 100 + $nEleFloor + 5] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 100 + $nEleFloor + 8]	[expr 1000*$i + 100 + $nEleFloor + 6] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	
	
	element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 9] [expr 1000*$i + 100 + $nEleFloor] [expr 1000*$i + 200 + $nEleFloor] [expr $Usmall] 1. 1. [expr $Usmall] [expr $Usmall] [expr $Ubig] $transfTagHorizRig
	
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 1] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 1] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 2] [expr 1000*$i + 100 + $nEleFloor]		[expr 1000*$i + 100 + $nEleFloor + 2] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 3] [expr 1000*$i + 100 + $nEleFloor + 1]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 4] [expr 1000*$i + 100 + $nEleFloor + 2]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 100 + $nEleFloor + 5]	[expr 1000*$i + 100 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig" 
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 100 + $nEleFloor + 6]	[expr 1000*$i + 100 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig" 
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 100 + $nEleFloor + 7]	[expr 1000*$i + 100 + $nEleFloor + 5] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig" 
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 100 + $nEleFloor + 8]	[expr 1000*$i + 100 + $nEleFloor + 6] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig"
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 100 + $nEleFloor + 9] [expr 1000*$i + 100 + $nEleFloor] [expr 1000*$i + 200 + $nEleFloor] [expr $Usmall] 1. 1. [expr $Usmall] [expr $Usmall] [expr $Ubig] $transfTagHorizRig"
	
	
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 1] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 1] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 2] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 2] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 3] [expr 1000*$i + 200 + $nEleFloor + 1]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 4] [expr 1000*$i + 200 + $nEleFloor + 2]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 5]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 6]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 7]	[expr 1000*$i + 200 + $nEleFloor + 5] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 8]	[expr 1000*$i + 200 + $nEleFloor + 6] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig
	
		
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 1] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 1] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 2] [expr 1000*$i + 200 + $nEleFloor]		[expr 1000*$i + 200 + $nEleFloor + 2] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig" 
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 3] [expr 1000*$i + 200 + $nEleFloor + 1]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 4] [expr 1000*$i + 200 + $nEleFloor + 2]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagHorizRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 5]	[expr 1000*$i + 200 + $nEleFloor + 3] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 6]	[expr 1000*$i + 200 + $nEleFloor + 4] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 7]	[expr 1000*$i + 200 + $nEleFloor + 5] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig"  
	puts $ModelFile "element elasticBeamColumn [expr 1000*$i + 200 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 8]	[expr 1000*$i + 200 + $nEleFloor + 6] $ARigid 1. 1. $JRigid $IyRigid $IzRigid $transfTagVertRig"
	
	

	# Truss Elements for Coupling Beam ---------------------------------------------------------------------------------------------------------
	
    if {$gT == "Linear"} {
    
        element trussSection [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $secTagCB
        element trussSection [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $secTagCB
        element trussSection [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $secTagCB
        element trussSection [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $secTagCB
        
        puts $ModelFile "element trussSection [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $secTagCB"
        puts $ModelFile "element trussSection [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $secTagCB"
        puts $ModelFile "element trussSection [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $secTagCB"
        puts $ModelFile "element trussSection [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $secTagCB"
        
    } else {
        
        element corotTrussSection [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $secTagCB
        element corotTrussSection [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $secTagCB
        element corotTrussSection [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $secTagCB
        element corotTrussSection [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $secTagCB
        
        puts $ModelFile "element corotTrussSection [expr 1000*$i + 1] [expr 1000*$i + 100 + $nEleFloor + 5] [expr 1000*$i + 200 + $nEleFloor + 7] $secTagCB"
        puts $ModelFile "element corotTrussSection [expr 1000*$i + 2] [expr 1000*$i + 100 + $nEleFloor + 6] [expr 1000*$i + 200 + $nEleFloor + 8] $secTagCB"
        puts $ModelFile "element corotTrussSection [expr 1000*$i + 3] [expr 1000*$i + 100 + $nEleFloor + 7] [expr 1000*$i + 200 + $nEleFloor + 5] $secTagCB"
        puts $ModelFile "element corotTrussSection [expr 1000*$i + 4] [expr 1000*$i + 100 + $nEleFloor + 8] [expr 1000*$i + 200 + $nEleFloor + 6] $secTagCB"
        
    }

}
