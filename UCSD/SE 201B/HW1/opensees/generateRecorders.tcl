# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# HOMEWORK # 1
# NONLINEAR QUASI-STATIC & TIME-HISTORY ANALYSIS OF A SDOF SYSTEM
# ####################################################################################
# Angshuman Deb

if {$analysisType == "Static"} {
	set dispfile "disp_$analysisType\_$algorithmString.txt";
	recorder Node -file $dataDir/$dispfile -node $nodeTag2 -dof 1 disp; # Record nodal displacements
	
	set resfile "res_$analysisType\_$algorithmString.txt";
	# ############# Since it is the reaction, note that in order to get the F - d plot, you need to take the negative of each value of the reaction. ###############
	recorder Node -file $dataDir/$resfile -node $nodeTag1 -dof 1 reaction; # Record reaction
	
} elseif {$analysisType == "Transient"} {
	set dispfile "disp_$analysisType\_$algorithmString.txt";
	recorder Node -file $dataDir/$dispfile -time -node $nodeTag2 -dof 1 disp; # Record nodal displacements (relative)
	
	set resfile "res_$analysisType\_$algorithmString.txt";
	# ############# Since it is the reaction, note that in order to get the F - d plot, you need to take the negative of each value of the reaction. ###############
	recorder Node -file $dataDir/$resfile -time -node $nodeTag1 -dof 1 reaction; # Record reaction 
	
	set velfile "vel_$analysisType\_$algorithmString.txt";
	recorder Node -file $dataDir/$velfile -time -node $nodeTag2 -dof 1 vel; # Record nodal velocities (relative)
	
	set accfile "acc_$analysisType\_$algorithmString.txt";
	recorder Node -file $dataDir/$accfile -timeSeries $tsTag -time -node $nodeTag2 -dof 1 accel; # Record nodal accelerations (for absolute accel, need to provide timeSeries tag) 
}