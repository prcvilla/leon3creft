echo "running for 3000ns..."
run 3000ns

echo "var initialization..."
set i 0
set forcetime 4300

when { sim:/testbench/cpu/pio(8) } {
  if { [exam sim:/testbench/cpu/pio(8)] == 1 } {
    echo "ERROR, try again."
    stop
  }
}
when { sim:/testbench/cpu/pio(7) } {
  if { [exam sim:/testbench/cpu/pio(7)] == 1 } {
    echo "prog fin."
    stop
  }
}
when { sim:/testbench/cpu/pio(6) } {
  if { [exam sim:/testbench/cpu/pio(6)] == 1 } {
    set i [expr {$i + 1}]
    echo $now " iteration no:" $i
    if { $i == 2 } {
      if {[when -label recv2] == ""} {
        echo "will force in " $forcetime "ns"
        when -label recv2 " \$now == $forcetime " {
          echo "applying force..."
          force -freeze sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin 0 0 -cancel 40ns
          nowhen recv2
        }
      }
    }
  }
}

when { $now >= @645000ns } {
  echo "time limit reached..."
  stop
}
run -all
