when -label dummywhen { sim:/testbench/clk == 0} {
	stop
}
restart -sim -force
nowhen *

#start time to main func values:
#basic, 50 loops: 579090
echo "program start time:"
set progstart_time 579090

#after main, how long does it run:
#basic, 50 loops: (total_run_time - progstart_time)
echo "program total run time:"
set progtotal_time [expr {1615640 - 579090}]

# time limit value
#basic, 50 loops : (total_run_time + extra_recovery_time)
echo "program time limit"
set progtime_limit [expr {$progtotal_time + $progstart_time + 100000}]

#add a dummy when to remove after
proc cleanup {} {
	global progstatus
	global iter
	global execerr
	global latent
	set progstatus 0
	set iter 0
	set execerr 0
	set latent 0
	restart -force
}

set gdfn "seu_logs/TimeRun-golden.txt"
set fd 0
#create log file
proc createlog {} {
	global fd
	set timeExec [clock seconds]
	set fn [clock format $timeExec -format seu_logs/TimeRun-%Y-%m-%dT%H-%M-%S.log]
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

###############################################################################
## Simulation control
###############################################################################

# Stop execution when GPIO 7 is set (Program finished)
when -label progfin { sim:/testbench/cpu/pio(7)'event && sim:/testbench/cpu/pio(7) == 1 } {
	echolog "$Now >> prog fin."
	set progstatus 1
	stop
}
# Stop execution when GPIO 8 is set (Wrong behaviour)
when -label progerr { sim:/testbench/cpu/pio(8)'event && sim:/testbench/cpu/pio(8) == 1 } {
	echolog "$Now >> prog exec ERROR."
	set progstatus -1
	stop
}
# Print current iteration number each time GPIO 6 is set
when -label progiter { sim:/testbench/cpu/pio(6)'event && sim:/testbench/cpu/pio(6) == 1 } {
	echolog "$Now >> iteration no: $iter"
	set iter [expr {$iter + 1}]
}

when -label timelimit "\$now >= $progtime_limit" {
	echolog "$Now >> time limit reached..."
	set progstatus -2
	stop
}

###############################################################################
## Time Redundancy Implementation
###############################################################################

# Var initialisation
set run_number 1
set data(1) 0
set data(2) 0
set data(3) 0
set ahbo_hwrite_sig sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite
set ahbo_hwrite sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite
set ahbo_data sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo.hwdata

# Hold the processor + cache controllers
proc hold_processor {} {
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/holdnx 0 0
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/pholdn 0 0
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbi2.hready 0 0
}

# Unhold processor and cache controllers
proc unhold_processor {} {
	noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/holdnx
	noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/pholdn
	noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbi2.hready
}

# Hold the processor, and set the recovery signal
proc start_recovery {} {
	hold_processor
	force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 10
}

# Unset the recovery signal and unhold the processor
proc finish_recovery {} {
	force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 1 0
	unhold_processor
}

when -label ahbo_hwrite_high "$ahbo_hwrite_sig'event and $ahbo_hwrite_sig='1'" {
	if {[gtTime $Now $progstart_time]} {
		# Keep the write data in a variable to compare with others iterations
		set data($run_number) [exam $ahbo_data]
		# State machine
		switch -exact -- $run_number {
			1 {
				start_recovery
				# Set next state
				set run_number 2
			}
			2 {
				if { $data(1) == $data(2) } {
					#echo $run_number $data(1) $data(2) $data($run_number)
					# The data from both iterations match
					# Allow the processor to progress and write the data to the memory
					force -freeze $ahbo_hwrite 1 0
					# Set next state
					set run_number 1
				} else {
					# The data from both iterations don't match
					echolog "Error detected -> Trying to recover"
					incr execerr
					start_recovery
					# Set next state
					set run_number 3
				}
			}
			3 {
				if { ($data(3) == $data(2)) || ($data(3) == $data(1)) } {
					# The third iteration result match with one of the other iterations
					echolog "Successful recovery -> Returning to normal execution"
					# Allow the processor to progress and write the data to the memory
					force -freeze $ahbo_hwrite 1 0
					# Set next state
					set run_number 1
				} else {
					# The third iteration do not match previous iterations
					echolog "Recovery Failed -> Stopping execution"
					set progstatus -1
					stop
				}
			}
			default {
				# invalid value
				stop
			}
		}
	} else {
		# Before reaching the 600000ns mark, just copy the signal
		force -freeze $ahbo_hwrite 1 0
	}
}

when -label ahbo_hwrite_low "$ahbo_hwrite_sig'event and $ahbo_hwrite_sig='0'" {
	force -freeze $ahbo_hwrite 0 0
}

# Complete Recovery
when -fast -label recovdone { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin } {
  if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin] == 1 } {
    finish_recovery
  }
}

###############################################################################
## Fault Injection Implementation
###############################################################################

echo "# of events to finish fault injection campaign:"
set events 3000

#detection counter
set eventcnt 0
set errdetected 0
set errcorrected 0
set latenterr 0

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

		#run pseudorandon time here
		set faultinj [expr {int(rand()*$progtotal_time)}]
		echolog "force in $faultinj"
		run $faultinj
		
		# Get the value of the signal under test
		set value [examine -value $i]
		echolog "Signal value: $value"

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
		echolog "compare to golden: $latent"
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
	}
}

echo "Total number of faults injected: $eventcnt"
echo "Total number of latent errors: $latenterr"
echo "Total number of errors detected: $errdetected"
echo "Total number of errors corrected: $errcorrected"
echo "===================TEST END======================="
