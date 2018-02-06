set arrPos {0x40002970}
set arrSz {20}
set elfName "main.exe"
set gfn "output/gold.t"
set iruns 102
set errMax 200

proc formatMemToHex {str} {
	set a [split $str { }]
	set first 1
	foreach ab $a {
		if {$first} {
			set first 0
			set formated "[format %.2X $ab]"
		} else {
			set formated "$formated [format %.2X $ab]"
		}
	}
	return $formated
}

proc setupTest {fn} {
  puts "Loading $fn ..."
   silent load $fn
   if { [silent verify $fn] == 0 } {
    puts "Prog $fn loaded."
    bp delete
	silent bp bubblelog
	return 1
  } else {
    puts "Verify program error!"
    return 0
  }
}

proc initTest {} {
  silent go
}

proc runTest {i} {
	global arrPos
	global arrSz
	while { $i > 0 } {
		set vet [silent memb $arrPos $arrSz]
		puts $vet
		set sig [silent cont]
		if { $sig == {SIGTERM} } { 
			puts "SIGTERM! Prog Fin."
			break
		}
		set i [expr $i - 1]    
	}      
}

proc generateGolden {} {
	global arrPos
	global arrSz
	global gfn
	reset
	set fileId [open $gfn "w"]
	puts "Generating golden file in $gfn"
	set f "main.exe"
    setupTest $f
    initTest
	set testEnd 1
	array set goldArr {}
	set i 0
	while { $testEnd } {
		puts -nonewline stdout {.}
		flush stdout
		set vet [silent memb $arrPos $arrSz]
		set goldArr($i) [formatMemToHex $vet]
		set i [expr $i + 1]
#   	set vet [memb 0x40002970 20]
#		puts $vet
		set sig [silent cont]
#    	set sig [cont]
		if { $sig == {SIGTERM} } {
			set testEnd 0
			puts "\nSIGTERM! Prog Fin."
#			break
		}
	}
	set goldSize [array size goldArr]
	puts "#iterations: $goldSize"
	set i 0
	while { $i < $goldSize } {
		puts -nonewline $fileId "$goldArr($i)\n"
		set i [expr $i + 1]
	}
	set i 0
	while { $i < 100 } {
		puts -nonewline $fileId "\n"
		set i [expr $i + 1]
	}
	close $fileId	
}

proc compareToGolden {} {
	global gfn
	global arrPos
	global arrSz
	global errMax
	set tini 0
	set tfin 0
	set ok 1
	reset
	set f "main.exe"
	set loadOK [setupTest $f]
    if { $loadOK == 1 } {
		set fileId [open $gfn "r"]
		puts "Comparing execution to golden in $gfn"
		initTest
		set testEnd 1
		array set goldArr {}
		array set execArr {}
		set tini [clock seconds]
		set i 0
		set errCnt 0
		set iErr 0
		while { $testEnd } {
			set vet [silent memb $arrPos $arrSz]
			set execArr($i) [formatMemToHex $vet]
			if { [gets $fileId line] >= 0 } {
				if { $line == $execArr($i) && $ok == 1 } {
					puts -nonewline stdout {.}
					flush stdout
				} else {
					if { $ok == 1 } {
						puts "data mismatch!!!"
						puts "golden: $line"
						puts "exec:   $execArr($i)"
						set iErr $i
						set ok 0
	#					para se der erro com break
						break
					} else {
						set errCnt [expr $errCnt + 1]
						puts -nonewline stdout "x"
						flush stdout
						if { $errCnt > $errMax } {
							puts "Too many errors during the execution..."
							break
						}
					}
				}
			} else {
				if { [eof $fileId] } {
					puts "EOF: $gfn"
				} else {
					puts "Error reading file: $gfn"
				}
				set ok 0
				break
			}
			set i [expr $i + 1]
			set sig [silent cont]
			if { $sig == {SIGTERM} } {
				set testEnd 0
				puts "\nSIGTERM! Prog Fin."
			}
		}
		close $fileId
	}
	set timeExec [clock seconds]
	set execFn leon
	if { $ok && $loadOK } {
		 set execFn [clock format $timeExec -format output/leon%Y-%m-%dT%H-%M-%S.log]
	} else {
		set execFn [clock format $timeExec -format output/leonFAIL%Y-%m-%dT%H-%M-%S.log]
	}
	set fileExec [open $execFn "w"]
	if { $loadOK == 1 } {
		set execSize [array size execArr]
		puts -nonewline $fileExec "index error: $iErr\n"
		set i 0
		while { $i < $execSize } {
			puts -nonewline $fileExec "$execArr($i)\n"
			set i [expr $i + 1]
		}
	} else {
		puts -nonewline $fileExec "Error verify program.\n"
	}
	close $fileExec
	set tfin [clock seconds]
	puts "\n--> Execution time:[expr $tfin-$tini]s"
	if { $ok && $loadOK } {
		puts "Execution finished equal to golden."
		return 1
	} else {
		puts "Something went wrong... look up..."
		return 0
	}
}

proc debugit {} {
	setupTest "main.exe"
	initTest
	runTest 10
}
#debugit

proc runBubbleTest {} {
	global elfName
	global gfn
	global iruns
	#verificar se existe golden
	if { [file isfile $gfn] == 0 } {
		puts "Golden not found..."
		generateGolden
	} else {
		puts "Golden file in use: $gfn"
	}
	set i $iruns
	set errRuns 0
	while { $i > 0 } {
		puts "\n\n#################"
		puts "Round no. [expr $iruns-$i]"
#		compareToGolden
		if  { [compareToGolden] == 0 } {
			set errRuns [expr $errRuns + 1]
		}
		set i [expr $i - 1]
	}
	puts "\n\nTest finished:"
	puts "--> With error: $errRuns"
	puts "--> Total runs: $iruns"
}
#runBubbleTest
