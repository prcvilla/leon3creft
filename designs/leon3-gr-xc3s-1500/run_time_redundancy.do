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

# Stop execution when GPIO 8 is set (Wrong behaviour)
when -label progerr { sim:/testbench/cpu/pio(8) } {
	if { [exam sim:/testbench/cpu/pio(8)] == 1 } {
		echo "ERROR, try again."
		stop
	}
}

# Stop execution when GPIO 7 is set (Program finished)
when -label progfin { sim:/testbench/cpu/pio(7) } {
	if { [exam sim:/testbench/cpu/pio(7)] == 1 } {
		echo "prog fin."
		stop
	}
}

# Print current iteration number each time GPIO 6 is set
when -label iteration { sim:/testbench/cpu/pio(6) } {
	if { [exam sim:/testbench/cpu/pio(6)] == 1 } {
		set i [expr {$i + 1}]
		echo $now " iteration no:" $i
	}
}

# Execute normally for the initial part of the simulation
when -label normal_mode { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite } {
  force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite] 0
}

# After the 600000 mark, begin running each checkpoint interval twice, and only
# allowing writes to memory in the second iteration
when { $now >= @600000 } {
  nowhen normal_mode
  when -label redundant_mode { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite } {
    if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo_hwrite] == 1 } {
      # Store write value
      set data(run_number) [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo.hwdata]
      echo $now " run " $run_number " - addr - " [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/ahbo.haddr] " - data - " $data(run_number)
      # Control time redundancy
      if { $run_number ==  1 } {
        # Hold the processor and cache controllers
        force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/holdnx 0 0
        force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/pholdn 0 0
        force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbi2.hready 0 0
        # Initiate recovery routine (go back to the previous checkpoint)
        force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 10
        set run_number 2
      } else {
        # Allow the processor to write the data to the memory
        force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite 1 0
        set run_number 1
      }
    } else {
      force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbo2.hwrite 0 0
    }
  }
}

# Complete Recovery
when -label recovdone { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin } {
  if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin] == 1 } {
    # Lower recovery signal
    force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 1 0
    # Unhold processor and cache controllers
    noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/holdnx
    noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/pholdn
    noforce sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/ahbi2.hready
  }
}

run -all
