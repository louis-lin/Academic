# SE 201B: NONLINEAR STRUCTURAL ANALYSIS
# LOAD CONTROL STATIC ANALYSIS
# ####################################################################################

# Define axial load
set axialLoadTag 1
set P [expr abs($fpc)*$colArea*$axialLoadRatio]
puts $P
pattern Plain $axialLoadTag "Linear" {
	load $controlNode -$P 0.0 0.0;
}

# Define load control integrator
set numAnalysisSteps 1
integrator LoadControl [expr 1./$numAnalysisSteps]; # Note the use of 1.

# Analyze
system BandGeneral
test NormUnbalance 1e-6 100
numberer Plain
constraints Plain
algorithm KrylovNewton
analysis Static

set ok [analyze $numAnalysisSteps]

if {$ok == 0} {
    puts "Axial load applied and analyzed"
}

# Very important to set
loadConst -time 0.0