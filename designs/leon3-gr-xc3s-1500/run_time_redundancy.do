when -label dummywhen { sim:/testbench/clk == 0} {
	stop
}
restart -sim -force
nowhen *

echo "var initialization..."
set i 0
set run_number 1
set data(1) 0
set data(2) 0
set data(3) 0

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
	# Hold the processor, and set the recovery signal
	hold_processor
	force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 10
}

proc finish_recovery {} {
	# Unset the recovery signal and unhold the processor
	force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 1 0
	unhold_processor
}

# Stop execution when GPIO 8 is set (Wrong behaviour)
when -fast -label progerr { sim:/testbench/cpu/pio(8) } {
	if { [exam sim:/testbench/cpu/pio(8)] == 1 } {
		echo "ERROR, try again."
		stop
	}
}

# Stop execution when GPIO 7 is set (Program finished)
when -fast -label progfin { sim:/testbench/cpu/pio(7) } {
	if { [exam sim:/testbench/cpu/pio(7)] == 1 } {
		echo "prog fin."
		stop
	}
}

# Print current iteration number each time GPIO 6 is set
when -fast -label iteration { sim:/testbench/cpu/pio(6) } {
	uivar i
	if { [exam sim:/testbench/cpu/pio(6)] == 1 } {
		set i [expr {$i + 1}]
		echo $now " iteration no:" $i
	}
}

# Execute normally for the initial part of the simulation
when -fast -label normal_mode { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite } {
  force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite] 0
}

# After the 600000 mark, begin running each checkpoint interval twice, and only
# allowing writes to memory in the second iteration
when -fast { $now >= @600000 } {
  nowhen normal_mode
  when -fast -label redundant_mode { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite } {
		uivar run_number
		uivar data(1)
		uivar data(2)
		uivar data(3)
    if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite] == 1 } {
      # Keep the write data in a variable to compare with others iterations
      set data($run_number) [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo.hwdata]
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
		        force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite 1 0
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
		        force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite 1 0
						# Set next state
						set run_number 1
					} else {
						# The third iteration do not match previous iterations
						echo "Recovery Failed -> Stopping execution"
						stop
					}
				}
				default {
					# invalid value
					stop
				}
			}
    } else {
      force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite 0 0
    }
  }
}

# Complete Recovery
when -fast -label recovdone { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin } {
  if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin] == 1 } {
    finish_recovery
  }
}

run -all
