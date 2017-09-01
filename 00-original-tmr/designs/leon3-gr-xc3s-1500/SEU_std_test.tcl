#onbreak {resume}
when -label dummywhen { sim:/testbench/clk == 0} {
	stop
}
nowhen *

#add a dummy when to remove after
proc cleanup {} {
	global progstatus
	global iter
	set progstatus 0
	set iter 0
	restart -force
}

set gdfn "seu_logs/Base-golden.txt"
set fd 0
#create log file
proc createlog {} {
	global fd
	set timeExec [clock seconds]
	set fn [clock format $timeExec -format seu_logs/Base-%Y-%m-%dT%H-%M-%S.log]
	set fd [open $fn "w+"]
}

proc echolog {msg} {
	global fd
	echo $msg
	puts $fd $msg
}

#progstatus is used to inform the return of execution
#-1 = gpio error signal activated
# 0 = default - not set anywhere else
# 1 = gpio finish signal activated
set progstatus 0
set iter 0

proc msgprogstatus {} {
	global progstatus
	global iter
	global now
	echolog "======================================"
	echolog "progstatus: $progstatus"
	switch $progstatus {
		-2 {
			echolog "time limit!"
		}
		-1 {
			echolog "program error!"
		}
		 0 {
			echolog "progstatus default value, probably error!"
		}
		 1 {
			echolog "program execution success!"
			echolog "total iterations: $iter"
		}
		default {
			echolog "Unknown progstatus: $progstatus"
		}
	}
	echolog ">>>>>>>>>>>>>>> $now"
	echolog "======================================"
}


proc testforce {val} {
	if { [string first \{ $val] == -1 } {
		set old $val
		echolog "oldval = $old"
		set pos1 [string last 1 $val]
		set pos0 [string last 0 $val]
		set posU [string last U $val]
		echolog "pos1: $pos1 pos0: $pos0 posU: $posU"
		if {$pos1 != -1} {
			set nval [string replace $val $pos1 $pos1 0]
		} elseif {$pos0 != -1}  {
			set nval [string replace $val $pos0 $pos0 1]
		} else {
			set nval [string replace $val $posU $posU 1]
		}
		echolog "newval = $nval"
	} else {
		echolog "This signal cannot be modified!"
		set nval -1
	}
	return $nval
}

proc comparetogolden {} {
	global fd
	global fn
	set tmpfn "currentsigs.tmp"
	set tmpfd [open $tmpfn "w"]
	foreach j [find signals -internal -r sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/r.*.*] {
		set v [examine -value $j]
		puts $tmpfd "$j:$v"
		puts $fd "$j:$v"
	}
	close $tmpfd
	set status [catch {exec diff $gdfn $tmpfn} result]
	return $status
}

# Stop execution when GPIO 7 is set (Program finished)
when -label progfin { sim:/testbench/cpu/pio(7)'event && sim:/testbench/cpu/pio(7) == 1 } {
	echolog "$now >> prog fin."
	set progstatus 1
	stop
}
# Stop execution when GPIO 8 is set (Wrong behaviour)
when -label progerr { sim:/testbench/cpu/pio(8)'event && sim:/testbench/cpu/pio(8) == 1 } {
	echolog "$now >> prog exec ERROR."
	set progstatus -1
	stop
}
# Print current iteration number each time GPIO 6 is set
when -label progiter { sim:/testbench/cpu/pio(6)'event && sim:/testbench/cpu/pio(6) == 1 } {
	echolog "$now >> iteration no: $iter"
	set iter [expr {$iter + 1}]
}

# time limit values
echo "program time limit"
set progtime_limit 1158215
when -label timelimit "\$now >= $progtime_limit" {
	echolog "$now >> time limit reached..."
	set progstatus -2
	stop
}


####################################
## script commands begin
####################################

#start time to main func values:
echo "program start time:"
set progstart_time 579090

#after main, how long does it run:
echo "program total run time:"
set progtotal_time 479125

echo "# of events to finish fault injection campaign:"
set events 1
#3000
set eventcnt 0

while { $eventcnt < $events } {
foreach i [find signals -internal -r sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/r.*.*] {

	createlog

	# Signal Under Test
	echolog "Test signal = $i"

	set value [examine -value $i]
	set nvalue [testforce $value]
	if { $nvalue == -1 } {
		echolog "skipping signal $i"
		close $fd
		continue
	}

	cleanup

	run $progstart_time ns

	# Get the value of the signal under test
	set value [examine -value $i]
	echolog "Signal value: $value"

	#run pseudorandon time here
	set faultinj [expr {int(rand()*$progtotal_time)}]
	echolog "force in $faultinj"
	run $faultinj ns

	#Force the SEU in the signal until it get overwritten
	#not sure if needed to test for -1 again
	set nvalue [testforce $value]
	if { $nvalue != -1 } {
		force -deposit $i $nvalue 0
	} else {
		echolog "skipping signal..."
	}

	#run until fin or error
	run -all

	#maybe test here for progstatus==0

	set latent [comparetogolden]
	msgprogstatus
	close $fd

	incr eventcnt

#debug
if {$eventcnt >= 3} {break}

}
}

echo "Total number of faults injected: $eventcnt"
echo "===================TEST END======================="

