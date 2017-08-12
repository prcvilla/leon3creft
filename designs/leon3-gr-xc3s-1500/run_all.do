echo "running for 3000ns..."
run 3000ns

echo "var initialization..."
set i 0

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
  }
}

run -all

do create_golden.tcl
