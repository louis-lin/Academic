
# ################################################################################################################
# ######################################## GRAVITY ANALYSIS ######################################################
# ################################################################################################################

set topFloorLoad 	[expr {151.2*$kip+94.5*$kip}];			# Total gravity load for roof per wall
set floorLoad 		[expr {$topFloorLoad+94.5*$kip}];		# Total gravity load for typical floor per wall
set botFloorLoad 	[expr {$topFloorLoad+126.*$kip}];		# Total gravity load for first floor per wall

set patternTagGravity 1;


#load $nodeTag (ndf $LoadValues)
pattern Plain $patternTagGravity "Constant" {

	for {set i 1} {$i <= $nStory} {incr i} {
		if {$i == 1} {
			set floorGravityLoad $botFloorLoad;
		} elseif {$i== $nStory} {
			set floorGravityLoad $topFloorLoad;
		} else {
			set floorGravityLoad $floorLoad;
		} ;
		load [expr 1000*$i + 100 + $nEleFloor] 0.0 0.0 [expr -$floorGravityLoad] 0.0 0.0 0.0 ; #Wall 1 
		load [expr 1000*$i + 200 + $nEleFloor] 0.0 0.0 [expr -$floorGravityLoad] 0.0 0.0 0.0 ; #Wall 2 
	}
}

# Define load control integrator
set numAnalysisSteps 1 
integrator LoadControl [expr 1./$numAnalysisSteps]; # Note the use of 1.

# Analyze
system ProfileSPD
test RelativeNormUnbalance 1.0e-3 500 1
numberer RCM
constraints Transformation
algorithm Newton
analysis Static

set ok [analyze $numAnalysisSteps]

if {$ok == 0} {
    puts "Gravity Analysis COMPLETE!"
    set GravityAnalysisDone "Yes";
} else {
    puts "Gravity Analysis FAILED!"
	exit
}

# Very important to set
loadConst -time 0.0
