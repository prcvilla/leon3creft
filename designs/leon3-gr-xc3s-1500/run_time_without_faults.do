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

when -label timelimit "\$now >= $progstart_time" {
	force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/trctrl0/en 1 0
}

run -all
