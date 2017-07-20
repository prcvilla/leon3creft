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
	echo "======================================"
	echo "======================================"
	switch $progstatus {
		-1 {
			echo "program error!"
		}
		 0 {
			echo "progstatus default value, probably error!"
		}
		 1 {
			echo "program execution success!"
			echo "total iterations: $iter"
		}
		default {
			echo "Unknown progstatus: $progstatus"
		}
	}
	echo "======================================"
	echo ">>>>>>>>>>>>>>> $now"
	echo "======================================"
}


proc testforce {val} {
	if { [string first \{ $val] == -1 } {
		set old $val
		echo "oldval = $old"
		set pos1 [string last 1 $val]
		set pos0 [string last 0 $val]
		set posU [string last U $val]
		echo "pos1: $pos1   pos0: $pos0 posU: $posU"
		if {$pos1 != -1} {
			set nval [string replace $val $pos1 $pos1 0]
		} elseif {$pos0 != -1}  {
			set nval [string replace $val $pos0 $pos0 1]
		} else {
			set nval [string replace $val $posU $posU 1]
		}
		echo "newval = $nval"
	} else {
		echo "This signal cannot be modified!"
		set nval -1
	}
	return $nval
}

# Stop execution when GPIO 7 is set (Program finished)
when -label progfin { sim:/testbench/cpu/pio(7)'event && sim:/testbench/cpu/pio(7) == 1 } {
	echo $now ">> prog fin."
	set progstatus 1
	stop
}
# Stop execution when GPIO 8 is set (Wrong behaviour)
when -label progerr { sim:/testbench/cpu/pio(8)'event && sim:/testbench/cpu/pio(8) == 1 } {
	echo $now ">> prog exec ERROR."
	set progstatus -1
	stop
}
# Print current iteration number each time GPIO 6 is set
when -label progiter { sim:/testbench/cpu/pio(6)'event && sim:/testbench/cpu/pio(6) == 1 } {
	echo $now ">> iteration no:" $iter
	set iter [expr {$iter + 1}]
}

#when recovery
# flowerr = 1
# >> force ahbstop
# >> force rollback
# >> release

####################################
## script commands begin
####################################
cleanup

foreach i [find signals -internal -r sim:/testbench/cpu/l3/u0/*] {
	set value [examine -value $i]
	set nvalue [testforce $value]
	if { $nvalue == -1 } {
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
		echo "skipping signal $i"
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
		continue
	}

	#replace this with 'when pc>=0x40000000' >> testbench/cpu/l3/cpu/u0/leon3x0/vhdl/p0/iu/r.f.pc
	run 550000ns

	# Signal Under Test
	echo "Test signal = $i"
	
	# Get the value of the signal under test	
	set value [examine -value $i]
	echo "Signal value: $value"

	#runt pseudorandon time here
	set faultinj [expr {20000 + int(rand()*50000)}]

	#Force the SEU in the signal until it get overwritten
	#not sure if needed to test for -1 again
	set nvalue [testforce $value]
	if { $nvalue != -1 } {
		echo "force -deposit $i $nvalue [expr {$faultinj}]"
	} else {
		echo "skipping signal..."
	}

	#run until fin or error
	run -all

	#maybe test here for progstatus==0

	msgprogstatus

	cleanup
}
