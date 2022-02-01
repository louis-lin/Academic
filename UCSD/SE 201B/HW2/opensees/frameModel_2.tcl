# ####################################################################################
# SE 201B: NONLINEAR STRUCTURAL ANALYSIS (WI 2021)
# OpenSees Tutorial # 3
# 2D FRAME ANALYSIS (LINEAR MATERIAL + NONLINEAR GEOMETRY) EXAMPLE
# ####################################################################################

# ------------------------------------------------------------------------------------
# DEFINE NODES
# ------------------------------------------------------------------------------------
set beamLength [expr 10.*$ft];
set numEleBeam 10.;
set eleLengthBeam [expr $beamLength/$numEleBeam];

set colLength [expr 8.*$ft];
set numEleCol 10.;
set eleLengthCol [expr $colLength/$numEleCol];

set nodeList {};
set nodeCtr 0;
for {set i 1} {$i <= [expr $numEleCol + 1]} {incr i 1} {
    incr nodeCtr 1
	node $nodeCtr 0.0 [expr ($i-1)*$eleLengthCol];
	puts $modelExportFileID "node $nodeCtr 0.0 [expr ($i-1)*$eleLengthCol];"
	lappend nodeList $nodeCtr
}
for {set i 1} {$i <= $numEleBeam} {incr i 1} {
    incr nodeCtr 1
	node $nodeCtr [expr $i*$eleLengthBeam] $colLength;
	puts $modelExportFileID "node $nodeCtr [expr $i*$eleLengthBeam] $colLength;"
	lappend nodeList $nodeCtr
}
for {set i 1} {$i <= $numEleCol} {incr i 1} {
    incr nodeCtr 1
	node $nodeCtr $beamLength [expr $colLength - $i*$eleLengthCol];
	puts $modelExportFileID "node $nodeCtr $beamLength [expr $colLength - $i*$eleLengthCol];"
	lappend nodeList $nodeCtr
}

# ------------------------------------------------------------------------------------
# DEFINE CONSTRAINTS
# ------------------------------------------------------------------------------------
fix [lindex $nodeList 0]   1 1 1;
fix [lindex $nodeList end] 1 1 1;

# ------------------------------------------------------------------------------------
# DEFINE MATERIAL & SECTION PARAMETERS
# ------------------------------------------------------------------------------------
set b		[expr 4.5*$in];
set d		[expr 2.2*$in];

set E		[expr 29000.0*$ksi];
set ABeam 	[expr $b*$d];
set ACol 	[expr $b*$d];
set IzBeam 	[expr $b*$d**3/12.];
set IzCol   [expr $b*$d**3/12.];

# ------------------------------------------------------------------------------------
# DEFINE GEOMETERIC TRANSFORMATION FOR ELEMENTS
# ------------------------------------------------------------------------------------
set transfTypeBeam "PDelta"; # Corotational, Linear, PDelta
set transfTypeCol "PDelta";
set transfTagBeam 1;
set transfTagCol 2;
# For a two-dimensional problem:
# geomTransf $transfType $transfTag <-jntOffset $dXi $dYi $dXj $dYj>
geomTransf $transfTypeBeam $transfTagBeam;
geomTransf $transfTypeCol $transfTagCol;

# ------------------------------------------------------------------------------------
# DEFINE ELEMENT
# ------------------------------------------------------------------------------------
# For a two-dimensional problem:
# element elasticBeamColumn $eleTag $iNode $jNode $A $E $Iz $transfTag
set nodeCtr 0;
set eleCtr 0;
for {set i 1} {$i <= [expr $numEleCol]} {incr i 1} {
    incr nodeCtr 1
    incr eleCtr 1
	element elasticBeamColumn $eleCtr $nodeCtr [expr $nodeCtr + 1] $ACol $E $IzCol $transfTagCol;
	puts $modelExportFileID "element elasticBeamColumn $eleCtr $nodeCtr [expr $nodeCtr + 1] $ACol $E $IzCol $transfTagCol;"
}
for {set i 1} {$i <= [expr $numEleBeam]} {incr i 1} {
    incr nodeCtr 1
    incr eleCtr 1
	element elasticBeamColumn $eleCtr $nodeCtr [expr $nodeCtr + 1] $ABeam $E $IzBeam $transfTagBeam;
	puts $modelExportFileID "element elasticBeamColumn $eleCtr $nodeCtr [expr $nodeCtr + 1] $ABeam $E $IzBeam $transfTagBeam;"
}
for {set i 1} {$i <= [expr $numEleCol]} {incr i 1} {
    incr nodeCtr 1
    incr eleCtr 1
	element elasticBeamColumn $eleCtr $nodeCtr [expr $nodeCtr + 1] $ACol $E $IzCol $transfTagCol;
	puts $modelExportFileID "element elasticBeamColumn $eleCtr $nodeCtr [expr $nodeCtr + 1] $ACol $E $IzCol $transfTagCol;"
}
close $modelExportFileID

# ------------------------------------------------------------------------------------
# DEFINE TIME SERIES AND LOAD PATTERN
# ------------------------------------------------------------------------------------
set tsTag 1; # Tag for the time series
timeSeries Linear $tsTag

set patternTag 1; # Tag for the load pattern
pattern Plain $patternTag $tsTag {
	load [expr int($numEleCol + 1)]               0. -25. 0.;
	load [expr int($numEleCol + $numEleBeam + 1)] 50. -25. 0.;
}
