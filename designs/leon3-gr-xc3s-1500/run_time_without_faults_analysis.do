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
set progtotal_time [expr {5403615 - 579090}]

# time limit value
#basic, 50 loops : (total_run_time + extra_recovery_time)
echo "program time limit"
set progtime_limit [expr {5403615 + 100000}]

###############################################################################
## Simulation control
###############################################################################

# Var initialisation
set iter 0

# Stop execution when GPIO 7 is set (Program finished)
when -label progfin { sim:/testbench/cpu/pio(7)'event && sim:/testbench/cpu/pio(7) == 1 } {
	echo "$Now >> prog fin."
	stop
}
# Stop execution when GPIO 8 is set (Wrong behaviour)
when -label progerr { sim:/testbench/cpu/pio(8)'event && sim:/testbench/cpu/pio(8) == 1 } {
	echo "$Now >> prog exec ERROR."
	stop
}
# Print current iteration number each time GPIO 6 is set
when -label progiter { sim:/testbench/cpu/pio(6)'event && sim:/testbench/cpu/pio(6) == 1 } {
	echo "$Now >> iteration no: $iter"
	set iter [expr {$iter + 1}]
}

when -label timelimit "\$now >= $progtime_limit" {
	echo "$Now >> time limit reached..."
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

set stackavg 10
set recvtavg 300000
set recovt 0

proc hold_processor {} {
	# Hold the processor + cache controllers
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/holdnx 0 0
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/pholdn 0 0
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbi2.hready 0 0
}

proc unhold_processor {} {
	# Unhold processor and cache controllers
	noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/holdnx
	noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/pholdn
	noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbi2.hready
}

proc start_recovery {} {
	global stackavg
	global stacksz
	global recovt
	global now
	# Hold the processor, and set the recovery signal
	hold_processor
	set stacksz [examine -value "sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/chkregfile0/stack0/stack_ptr"]
	set stacksz [expr 64-$stacksz]
	set stackavg [expr ($stackavg+$stacksz)/2]
	set recovt $now
	force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 10
}

proc finish_recovery {} {
	global recovt
	global recvtavg
	global now
	# Unset the recovery signal and unhold the processor
	force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 1 0
	set recovt [expr $now-$recovt]
	set recvtavg [expr ($recvtavg+$recovt)/2]
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
					echo "Error detected -> Trying to recover"
					start_recovery
					# Set next state
					set run_number 3
				}
			}
			3 {
				if { ($data(3) == $data(2)) || ($data(3) == $data(1)) } {
					# The third iteration result match with one of the other iterations
					echo "Successful recovery -> Returning to normal execution"
					# Allow the processor to progress and write the data to the memory
					force -freeze $ahbo_hwrite 1 0
					# Set next state
					set run_number 1
				} else {
					# The third iteration do not match previous iterations
					echo "Recovery Failed -> Stopping execution"
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



run -all
echo "recov time avg: $recvtavg"
echo "stack sz avg: $stackavg"
