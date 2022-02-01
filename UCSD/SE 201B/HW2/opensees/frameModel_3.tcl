# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# OpenSees Tutorial # 3
# 2D FRAME ANALYSIS (LINEAR MATERIAL + NONLINEAR GEOMETRY) EXAMPLE
# ####################################################################################

# ------------------------------------------------------------------------------------
# DEFINE NODES
# ------------------------------------------------------------------------------------
set beamLength [expr 5.*$ft];
set numEleBeam 10.;
set eleLengthBeam [expr $beamLength/$numEleBeam];

set nodeList {};
for {set i 1} {$i <= [expr $numEleBeam + 1]} {incr i 1} {
	node $i [expr ($i-1)*$eleLengthBeam] 0.0;
	puts $modelExportFileID "node $i [expr ($i-1)*$eleLengthBeam] 0.0;"
	lappend nodeList $i
}

node $i [expr $beamLength + 0.5*$ft] 0.
puts $modelExportFileID "node $i [expr $beamLength + 0.5*$ft] 0."
lappend nodeList $i
# ------------------------------------------------------------------------------------
# DEFINE CONSTRAINTS
# ------------------------------------------------------------------------------------
fix 1 1 1 1;

# ------------------------------------------------------------------------------------
# DEFINE MATERIAL & SECTION PARAMETERS
# ------------------------------------------------------------------------------------
set b		[expr 4.5*$in];
set d		[expr 2.2*$in];

set E		[expr 29000.0*$ksi];
set A 		[expr $b*$d];
set Iz	 	[expr $b*$d**3/12.];

# ------------------------------------------------------------------------------------
# DEFINE GEOMETERIC TRANSFORMATION FOR ELEMENTS
# ------------------------------------------------------------------------------------
set transfTypeBeam "PDelta";
set transfTagBeam 1;
# For a two-dimensional problem:
# geomTransf $transfType $transfTag <-jntOffset $dXi $dYi $dXj $dYj>
geomTransf $transfTypeBeam $transfTagBeam;

# ------------------------------------------------------------------------------------
# DEFINE ELEMENT
# ------------------------------------------------------------------------------------
# For a two-dimensional problem:
# element elasticBeamColumn $eleTag $iNode $jNode $A $E $Iz $transfTag
for {set i 1} {$i <= [expr $numEleBeam]} {incr i 1} {
	element elasticBeamColumn $i $i [expr $i + 1] $A $E $Iz $transfTagBeam;
	puts $modelExportFileID "element elasticBeamColumn $i $i [expr $i + 1] $A $E $Iz $transfTagBeam;"
}

# element elasticBeamColumn $i $i [expr $i + 1] [expr 1000000.] 1. [expr 1000000000.] $transfTagBeam;
# puts $modelExportFileID "element elasticBeamColumn $i $i [expr $i + 1] [expr 1000000.] 1. [expr 1000000000.] $transfTagBeam;"

rigidLink beam $i [expr $i + 1]
equalDOF $i [expr $i + 1] 1 2 3
puts $modelExportFileID "rigidLink beam $i [expr $i + 1]"

close $modelExportFileID

# ------------------------------------------------------------------------------------
# DEFINE TIME SERIES AND LOAD PATTERN
# ------------------------------------------------------------------------------------
set tsTag 1; # Tag for the time series
timeSeries Linear $tsTag

set patternTag 1; # Tag for the load pattern
pattern Plain $patternTag $tsTag {
	load [expr int($numEleBeam + 1)] 0. -100. 0.;
	# load [expr int($numEleBeam + 1)] 0. 0. 2500.;
}
