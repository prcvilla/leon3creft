#set fn "seu_logs/FlowRun-golden.txt"
set fn "seu_logs/TMR-golden.txt"
set fd [open $fn "w"]

foreach i [find signals -internal -r sim:/testbench/cpu/l3/u0/leon3x0/vhdl/p0/iu/r.*.*] {
	set v [examine -value $i]
	puts $fd "$i:$v"
}
close $fd
