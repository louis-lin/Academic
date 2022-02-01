
#              ================================
# 				  Global Coordinate System
#              ================================
#           ____________		 _____________		   ^ Y-axis
#          |  __________|=======|___________  |		   |        
#          | |                              | |		   |        
#          | |                              | |		   |          
#          | |                              | |        o-------->  X-axis
#          | | x                          x | |        
#          | |                              | |        
#          | |                              | |        
#          | |__________          __________| |        
#          |____________|========|____________|
#          

# INITIALIZATION --------------------------------------------------------------------
model BasicBuilder -ndm 3 -ndf 6;			# define the model builder, ndm=#dimension, ndf=#dofs
set analysisType "static";                  # Choose between static and dynamic 
setMaxOpenFiles 1000
set ModelDirectory "Model";
set DeflectedShapeDirectory "DeflectedShape";
set ModalAnalysisDirectory "ModalAnalysis";
set ModalAnalysisPreGravDirectory "Pre-gravity"
set ModalAnalysisPostGravDirectory "Post-gravity"
set ResultsDirectory "Results_$analysisType";

file mkdir $ModelDirectory;
file mkdir $DeflectedShapeDirectory;
file mkdir $ModalAnalysisDirectory/$ModalAnalysisPreGravDirectory
file mkdir $ModalAnalysisDirectory/$ModalAnalysisPostGravDirectory
file mkdir $ResultsDirectory;

source UNITS.tcl;

# SET MODEL PARAMETERS ----------------------------------------------------------------------------------------------------------------------------------
set nStory 15;								# number of story
set storyH1 [expr 16.0*$ft];				# Height of 1st story
set storyHup [expr 12.0*$ft];				# Height of remaining stories
set buildingHeight	[expr 1.*$storyH1 + ($nStory - 1)*$storyHup];
set eleTypeWall "forceBeamColumn";                                                            
set numIntgrPts 5;							# number of integration points
set nEleFloor 1;							# number of column elements per floor
set C_dim1 [expr 144.0*$in];				# Dimensions of Core Wall (see slide in Tutorial)
set C_dim2 [expr  97.0*$in];				# Dimensions of Core Wall (see slide in Tutorial)
set C_dim3 [expr 5.*$in];				   	# Dimensions of Core Wall (see slide in Tutorial)
set C_dim4 [expr 32.*$in];					# Dimensions of Core Wall (see slide in Tutorial)
set C_dim5 [expr 278.0*$in];				# Dimensions of Core Wall (see slide in Tutorial)
set C_dim6 [expr  84.0*$in];				# Dimensions of Core Wall (see slide in Tutorial)
set GravityAnalysisDone "No";
set gT "PDelta";						    # Choose between Linear, PDelta, and Corotational
set pushDir "NS";							# Specify push direction, EW, or NS
set maxIters 100;
set fbtol 1e-8;
set modes 8;
# MATERIAL DEFINITION ----------------------------------------------------------------------------------------------------------------------------------------------
set unconfinedConcMatTypeWall "Concrete01";		# Choose between LinearElastic, Concrete01, Concrete02
set confinedConcMatTypeWall "Concrete01"; 		# Choose between LinearElastic, Concrete01, Concrete02
set ConcMatTypeBeam "Concrete02";				# Choose between LinearElastic, Concrete01, Concrete02
set SteelMatTypeWall "Steel02"; 				# Choose between LinearElastic, Steel01, Steel02
set SteelMatTypeBeam "Steel02"; 				# Choose between LinearElastic, Steel01, Steel02

# set unconfinedConcMatTypeWall "LinearElastic";	
# set confinedConcMatTypeWall "LinearElastic"; 	
# set ConcMatTypeBeam "LinearElastic";			
# set SteelMatTypeWall "LinearElastic"; 			
# set SteelMatTypeBeam "LinearElastic"; 			

# GEOMETRY/MATERIAL/SECTIONS --------------------------------------------------------------------------
set ModelFile [open "$ModelDirectory/modelData.txt" "w"];

source "INPUT_nodes.tcl" 
puts "NODES OK"

source "INPUT_mat.tcl"
puts "MATERIALS OK"

source "INPUT_sec.tcl"
puts "SECTIONS OK"

# GEOMETRIC TRANSFORMATIONS --------------------------------------------------------------------------
source "TRANSF.tcl"
puts "TRANSFORMATIONS OK"

# ELEMENTS --------------------------------------------------------------------------
source "INPUT_elem.tcl"
puts "ELEMENTS OK"

close $ModelFile

if {$analysisType == "dynamic"} {
    source "INPUT_mass.tcl"
    puts "MASS OK"
}
