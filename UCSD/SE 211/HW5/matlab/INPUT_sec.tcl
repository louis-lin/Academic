# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WALL SECTION --------------------------------------------------------------------------



#           ____________
#          |  __________|
#          | | ^ y    
#          | | |    
#          | | |    
#       z <----o    
#          | |           
#          | |           
#          | |__________ 
#          |____________|
#          

# local y-z axis defined for C - wall section (left wall)
set JWall [expr 4361130.7*$in4];
set JBeam [expr 7411.38*$in4];

# WALL SECTION
set secTagWall 1;

# Lengths used in sections
set yy1	[expr 130.*$in]
set yy2 [expr 1.*$in]
set yy3 [expr 28.*$in]
set yy4 [expr 1.*$in]

set zz1 [expr 28.*$in]
set zz2 [expr 15.*$in]
set zz3 [expr 55.*$in]
set zz4 [expr 41.*$in]
set zz5 [expr 1.*$in]
set zz6 [expr 42.*$in]

set Aswall [expr 4.*$in2]
set AsBeam [expr 12.*$in2]
set dBeam [expr 42.*$in]
set bBeam [expr 28.*$in]
set AcBeam [expr 0.362*$dBeam*$bBeam]

section Fiber $secTagWall -GJ [expr $GcWall*$JWall] {


    # -------------------------------------------------------------------------------------
    # Create rectangular patches
    # -------------------------------------------------------------------------------------
    
    # Confined concrete
    patch rect $confinedConcMatTagWall 		6  	10  [expr $yy1+$yy2]		[expr -$zz3-$zz4]	[expr $yy1+$yy2+$yy3]	[expr -$zz3]
    patch rect $confinedConcMatTagWall 		6  	10  [expr -$yy1-$yy2-$yy3]	[expr -$zz3-$zz4]	[expr -$yy1-$yy2]		[expr -$zz3]

    # Unconfined concrete
    patch rect $unconfinedConcMatTagWall 	5  	30  [expr $yy1]     				[expr -$zz3]     [expr $yy1+$yy2+$yy3+$yy4]     [expr $zz1+$zz2]
    patch rect $unconfinedConcMatTagWall 	5  	30  [expr -$yy1-$yy2-$yy3-$yy4]     [expr -$zz3]     [expr -$yy1]      				[expr $zz1+$zz2]

    patch rect $unconfinedConcMatTagWall 	60 	5  	[expr -$yy1]            [expr $zz2]             [expr $yy1]      [expr $zz1+$zz2]

    patch rect $unconfinedConcMatTagWall 	2   5   [expr $yy1+$yy2+$yy3]   	[expr -$zz3-$zz4]     	[expr $yy1+$yy2+$yy3+$yy4]    		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr $yy1]     			[expr -$zz3-$zz4]       [expr $yy1+$yy2]         		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr -$yy1-$yy2-$yy3-$yy4]	[expr -$zz3-$zz4]		[expr -$yy1-$yy2-$yy3]		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr -$yy1-$yy2]			[expr -$zz3-$zz4]		[expr -$yy1]					[expr -$zz3]

    patch rect $unconfinedConcMatTagWall 	5   2   [expr $yy1]    				[expr -$zz3-$zz4-$zz5]		[expr $yy1+$yy2+$yy3+$yy4]      [expr -$zz3-$zz4]
    patch rect $unconfinedConcMatTagWall 	5   2   [expr -$yy1-$yy2-$yy3-$yy4]	[expr -$zz3-$zz4-$zz5]		[expr -$yy1]      [expr -$zz3-$zz4]
       
    # -------------------------------------------------------------------------------------
    # Create straight layers
    # -------------------------------------------------------------------------------------
    
    # Reinforcing steel
    layer straight $SteelMatTagWall 18  $Aswall [expr $yy1+$yy2+$yy3/2] 	[expr $zz6] [expr $yy1+$yy2+$yy3/2] 	[expr -$zz3-$zz4]
    layer straight $SteelMatTagWall 18  $Aswall [expr -$yy1-$yy2-$yy3/2] 	[expr $zz6] [expr -$yy1-$yy2-$yy3/2] 	[expr -$zz3-$zz4]
    layer straight $SteelMatTagWall 32  $Aswall [expr -$yy1] [expr $zz2+$zz1/2] [expr $yy1] [expr $zz2+$zz1/2]
    

};

puts $ModelFile "section Fiber $secTagWall -GJ [expr $GcWall*$JWall] {


    # -------------------------------------------------------------------------------------
    # Create rectangular patches
    # -------------------------------------------------------------------------------------
    
    # Confined concrete
    patch rect $confinedConcMatTagWall 		6  	10  [expr $yy1+$yy2]		[expr -$zz3-$zz4]	[expr $yy1+$yy2+$yy3]	[expr -$zz3]
    patch rect $confinedConcMatTagWall 		6  	10  [expr -$yy1-$yy2-$yy3]	[expr -$zz3-$zz4]	[expr -$yy1-$yy2]		[expr -$zz3]

    # Unconfined concrete
    patch rect $unconfinedConcMatTagWall 	5  	30  [expr $yy1]     				[expr -$zz3]     [expr $yy1+$yy2+$yy3+$yy4]     [expr $zz1+$zz2]
    patch rect $unconfinedConcMatTagWall 	5  	30  [expr -$yy1-$yy2-$yy3-$yy4]     [expr -$zz3]     [expr -$yy1]      				[expr $zz1+$zz2]

    patch rect $unconfinedConcMatTagWall 	60 	5  	[expr -$yy1]            [expr $zz2]             [expr $yy1]      [expr $zz1+$zz2]

    patch rect $unconfinedConcMatTagWall 	2   5   [expr $yy1+$yy2+$yy3]   	[expr -$zz3-$zz4]     	[expr $yy1+$yy2+$yy3+$yy4]    		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr $yy1]     			[expr -$zz3-$zz4]       [expr $yy1+$yy2]         		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr -$yy1-$yy2-$yy3-$yy4]	[expr -$zz3-$zz4]		[expr -$yy1-$yy2-$yy3]		[expr -$zz3]
    patch rect $unconfinedConcMatTagWall 	2   5   [expr -$yy1-$yy2]			[expr -$zz3-$zz4]		[expr -$yy1]					[expr -$zz3]

    patch rect $unconfinedConcMatTagWall 	5   2   [expr $yy1]    				[expr -$zz3-$zz4-$zz5]		[expr $yy1+$yy2+$yy3+$yy4]      [expr -$zz3-$zz4]
    patch rect $unconfinedConcMatTagWall 	5   2   [expr -$yy1-$yy2-$yy3-$yy4]	[expr -$zz3-$zz4-$zz5]		[expr -$yy1]      [expr -$zz3-$zz4]
       
    # -------------------------------------------------------------------------------------
    # Create straight layers
    # -------------------------------------------------------------------------------------
    
    # Reinforcing steel
    layer straight $SteelMatTagWall 18  $Aswall [expr $yy1+$yy2+$yy3/2] 	[expr $zz6] [expr $yy1+$yy2+$yy3/2] 	[expr -$zz3-$zz4]
    layer straight $SteelMatTagWall 18  $Aswall [expr -$yy1-$yy2-$yy3/2] 	[expr $zz6] [expr -$yy1-$yy2-$yy3/2] 	[expr -$zz3-$zz4]
    layer straight $SteelMatTagWall 32  $Aswall [expr -$yy1] [expr $zz2+$zz1/2] [expr $yy1] [expr $zz2+$zz1/2]
    

};"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# COUPLING BEAM SECTION
set secTagCB 2;
section Fiber $secTagCB -GJ [expr $GcBeam*$JBeam] {

    # Concrete
    fiber 0 0 $AcBeam $ConcMatTagBeam 	
	
    # Reinforcing Steel
    fiber 0 0 $AsBeam $SteelMatTagBeam 	
}

puts $ModelFile "section Fiber $secTagCB -GJ [expr $GcBeam*$JBeam] {

    # Concrete
    fiber 0 0 $AcBeam $ConcMatTagBeam 	
	
    # Reinforcing Steel
    fiber 0 0 $AsBeam $SteelMatTagBeam 	
}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# RIGID LINK SECTION --------------------------------------------------------------------------
set ARigid [expr 1e10];
set JRigid [expr 1e12];
set IyRigid [expr 1e12];
set IzRigid [expr 1e12];