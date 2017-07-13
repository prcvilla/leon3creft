when -label dummywhen { sim:/testbench/clk == 0} {
	stop
}
restart -sim -force
nowhen *

echo "var initialization..."
set i 0

# Stop execution after simulation time has exceeded timelimit
#when -label timelimit { $now >= @5000000ns } {
#	echo "time limit reached..."
#	stop
#}

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

# Execute the recovery routine for the first time
when -label firstrecov { $now >= @600000 } {
  # Stop the processor execution throught an AHB request
  force -deposit sim:/testbench/cpu/stp_req 1 0
}

# Notify every time the ahb stop is requested
when -label stpreq { sim:/testbench/cpu/stp_req } {
  if { [exam sim:/testbench/cpu/stp_req] == 1 } {
    echo $now "requesting for the AHB..."
  }
}

# When the stop request is granted, start the recovery routine
when -label reqgranted { sim:/testbench/cpu/ahb1/stp_grt } {
  if { [exam sim:/testbench/cpu/ahb1/stp_grt] == 1 } {
    echo $now "AHB granted, starting recovery..."
    force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 45
  }
}


# Finish current recovery routine and schedule the next recovery
when -label recovdone { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin } {
  if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin] == 1 } {
    echo $now "recovery done, continuing..."
    force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 1 0
    force -deposit sim:/testbench/cpu/stp_req 0 45
    # Generate the time for the next recovery execution
    set nextrecov [expr {20000 + int(rand()*50000)}]
    echo "next recovery: " $nextrecov
    # Start next recovery routine
    force -deposit sim:/testbench/cpu/stp_req 1 [expr {$nextrecov}]
  }
}

run -all
