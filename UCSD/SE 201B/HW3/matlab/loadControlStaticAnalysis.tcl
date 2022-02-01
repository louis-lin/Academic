set axialLoadTag 1;
set axialLoadRatio 0.30;
set P [expr abs($fpc)*$colArea*$axialLoadRatio];
pattern Plain $axialLoadTag "Linear" {	load $controlNode -$P 0.0 0.0;};
set numAnalysisSteps 1 ;
integrator LoadControl [expr 1./$numAnalysisSteps];
system BandGeneral ;
test NormUnbalance 1e-6 100;
numberer Plain ;
constraints Plain ;
algorithm KrylovNewton ;
analysis Static;
set ok [analyze $numAnalysisSteps];
if {$ok == 0} {puts "Axial load applied and analyzed"};
loadConst -time 0.0