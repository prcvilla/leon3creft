#onbreak {resume}
when -label dummywhen { sim:/testbench/clk == 0} {
	stop
}
nowhen *

#add a dummy when to remove after
proc cleanup {} {
	global progstatus
	global iter
	global execerr
	set progstatus 0
	set iter 0
	set execerr 0
	restart -force
}

set gdfn "seu_logs/FlowRun-golden.txt"
set fd 0
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
set execerr 0
set latent 0

proc msgprogstatus {} {
	global progstatus
	global iter
	global now
	global execerr
	global latent
	echolog "======================================"
	echolog "progstatus: $progstatus"
	echolog "execerr: $execerr"
	echolog "latent: $latent"
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
	foreach j [find signals -internal -r sim:/testbench/cpu/l3/u0/leon3x0/vhdl/p0/iu/r.*.*] {
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
#basic, 50 loops : 1058215
#set progtime_limit 1158215
#bubble : 5645715
#set progtime_limit 5745715
#nmea : 2637215
#set progtime_limit 2737215
#hamming : 2799665
set progtime_limit 2899665
when -label timelimit "\$now >= $progtime_limit" {
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
	incr execerr
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

#start time to main func values:
echo "program start time:"
#basic, 50 loops: 564215
#set progstart_time 564215
#bubble: 581615
#set progstart_time 581615
#nmea: 579340
#set progstart_time 579340
#hamming: 579890
set progstart_time 579890

#after main, how long does it run:
echo "program total run time:"
#basic, 50 loops: 494000
#set progtotal_time 494000
#bubble: 5064100
#set progtotal_time 5064100
#nmea: 2057875
#set progtotal_time 2057875
#hamming: 2219775
set progtotal_time 2219775

echo "# of events to finish fault injection campaign:"
set events 1
#3000
set eventcnt 0

#detection counter
set errdetected 0
set errcorrected 0
set latenterr 0

while { $eventcnt < $events } {
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

	run $progstart_time ns

	# Get the value of the signal under test
	set value [examine -value $i]
	echolog "Signal value: $value"

	#run pseudorandon time here
	set faultinj [expr {int(rand()*$progtotal_time)}]

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

	set latent [comparetogolden]
	msgprogstatus
	close $fd

	incr eventcnt
	if { $latent != 0 } {
		incr latenterr
	}
	if { $execerr > 0 } {
		incr errdetected
	}
	if { $execerr == 1 } {
		incr errcorrected
	}

#debug
if {$eventcnt >= 3} {break}

}
}

echo "Total number of faults injected: $eventcnt"
echo "Total number of latent errors: $latenterr"
echo "Total number of errors detected: $errdetected"
echo "Total number of errors corrected: $errcorrected"
echo "===================TEST END======================="

