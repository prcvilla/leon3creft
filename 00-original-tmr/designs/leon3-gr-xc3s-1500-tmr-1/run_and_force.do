#echo "force initializations..."
#force -deposit sim:/testbench/cpu/stp_req 0 0
#force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 0

echo "running for 3000ns..."
run 3000ns

echo "var initialization..."
set i 0
#set reqtime 1400

when -label progerr { sim:/testbench/cpu/pio(8) } {
	if { [exam sim:/testbench/cpu/pio(8)] == 1 } {
		echo "ERROR, try again."
		stop
	}
}

when -label timelimit { $now >= @800000ns } {
	echo "time limit reached..."
	stop
}

when -label progfin { sim:/testbench/cpu/pio(7) } {
	if { [exam sim:/testbench/cpu/pio(7)] == 1 } {
		echo "prog fin."
		stop
	}
}

when -label iteration { sim:/testbench/cpu/pio(6) } {
	if { [exam sim:/testbench/cpu/pio(6)] == 1 } {
		set i [expr {$i + 1}]
		echo $now " iteration no:" $i
		if { $i == 2 } {
			if {[when -label recv2] == ""} {
				echo "will request for the AHB in " $reqtime "ns"
				when -label reqahb " \$now == $reqtime " {
					echo $now "requesting for the AHB..."
					force -deposit sim:/testbench/cpu/stp_req 1 0
					nowhen reqahb
				}
			}
		}
	}
}

when -label reqgranted { sim:/testbench/cpu/ahb1/stp_grt } {
	if { [exam sim:/testbench/cpu/ahb1/stp_grt] == 1 } {
		echo $now "AHB granted, starting recovery..."
#		stop
		force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 45
		nowhen reqgranted
	}
}

when -label recovdone { sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin } {
	if { [exam sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin] == 1 } {
		echo $now "recovery done, continuing..."
		force -deposit sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 1 0
		force -deposit sim:/testbench/cpu/stp_req 0 45
		nowhen recovdone
	}
}


run -all
