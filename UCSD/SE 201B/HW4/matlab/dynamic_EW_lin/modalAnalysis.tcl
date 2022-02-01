
# ##############################################################################################################################
# ###################################################### MODAL ANALYSIS ########################################################
# ##############################################################################################################################

set omega {};
set F {};
set T {};
set lambda [eigen $modes];
foreach lam $lambda {
         lappend omega [expr sqrt($lam)];
         lappend F [expr sqrt($lam)/(2.*$pi)];
         lappend T [expr (2.0*$pi)/sqrt($lam)];
}

# ##########################################################################################################
# ####################################### SAVE TIME PERIODS ################################################
# ##########################################################################################################

if {$GravityAnalysisDone == "No" || $GravityAnalysisDone == "no"} {
	set PeriodFile [open "$ModalAnalysisDirectory/$ModalAnalysisPreGravDirectory/periods.txt" "w"];
	puts $PeriodFile "$T";
} else {
	set PeriodFile [open "$ModalAnalysisDirectory/$ModalAnalysisPostGravDirectory/periods.txt" "w"];
	puts $PeriodFile "$T";
}
close $PeriodFile;

# ###########################################################################################################

for {set iMode 1} {$iMode <= $modes} {incr iMode} {

	if {$GravityAnalysisDone == "No" || $GravityAnalysisDone == "no"} {
		set modeFile [open "$ModalAnalysisDirectory/$ModalAnalysisPreGravDirectory/modeShape_$iMode.txt" "w"];
	} else {
		set modeFile [open "$ModalAnalysisDirectory/$ModalAnalysisPostGravDirectory/modeShape_$iMode.txt" "w"];	
	}
    
	for {set i 1} {$i <= [llength $Nodes]} {incr i} {
		puts $modeFile "[lindex $Nodes [expr $i - 1]] [nodeEigenvector [lindex $Nodes [expr $i - 1]] $iMode]";
	}
	close $modeFile;
}

puts "----------------------"
puts "Modal Analysis Results"
puts "----------------------"
for {set i 1} {$i <= $modes} {incr i 1} {
	puts "T$i = [lindex $T [expr $i-1]]";
}