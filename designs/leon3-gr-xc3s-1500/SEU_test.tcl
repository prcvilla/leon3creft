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

set fd "unknown.log"
#create log file
proc createlog {} {
	global fd
	set timeExec [clock seconds]
	set fn [clock format $timeExec -format seu_logs/FlowRun-%Y-%m-%dT%H-%M-%S.log]
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

# Add time limit
#when
when -label timelimit { $now >= @800000ns } {
	echolog "$now >> time limit reached..."
	set progstatus -2
	stop
}

# When error is detected by flowcontrol start the recovery routine
when -label ahbreq { sim:/testbench/cpu/flowcontrol_error'event && sim:/testbench/cpu/flowcontrol_error == 1} {
	# Stop the processor execution throught an AHB request
	echolog "$now >> Requesting for the AHB bus..."
	force -deposit sim:/testbench/cpu/stp_req 1 0
	#nowhen ahbreq
}

# When the stop request is granted, start the recovery routine on both processors
when -label ahbgranted { sim:/testbench/cpu/ahb1/stp_grt'event && sim:/testbench/cpu/ahb1/stp_grt == 1 } {
	echolog "$now >> AHB granted, starting recovery..."
	force -deposit sim:/testbench/cpu/l3/u0/leon3x0/recov_pin 0 45
	#flowprocessor
	force -deposit sim:/testbench/cpu/l3/u1/leon3x0/recov_pin 0 45
}

# Finish current recovery routine
when -label recovdone { sim:/testbench/cpu/l3/u0/leon3x0/recovdone_pin'event && sim:/testbench/cpu/l3/u0/leon3x0/recovdone_pin == 1 } {
	echolog "$now >> Recovery done, continuing..."
	force -deposit sim:/testbench/cpu/l3/u0/leon3x0/recov_pin 1 0
	#flowprocessor
	force -deposit sim:/testbench/cpu/l3/u1/leon3x0/recov_pin 1 0
	force -deposit sim:/testbench/cpu/stp_req 0 45
}


####################################
## script commands begin
####################################

foreach i [find signals -internal -r sim:/testbench/cpu/l3/u0/leon3x0/vhdl/p0/iu/r.*.*] {

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

	#replace this with 'when pc>=0x40000000' >> testbench/cpu/l3/cpu/u0/leon3x0/vhdl/p0/iu/r.f.pc
	run 564215ns

	# Get the value of the signal under test
	set value [examine -value $i]
	echolog "Signal value: $value"

	#run pseudorandon time here
	set faultinj [expr {16275 + int(rand()*140000)}]

	#Force the SEU in the signal until it get overwritten
	#not sure if needed to test for -1 again
	set nvalue [testforce $value]
	if { $nvalue != -1 } {
		echolog "force in $faultinj"
		force -deposit $i $nvalue [expr {$faultinj}]
	} else {
		echolog "skipping signal..."
	}

	#run until fin or error
	run -all

	#maybe test here for progstatus==0

	msgprogstatus
	close $fd
}

echo "===================TEST END======================="

