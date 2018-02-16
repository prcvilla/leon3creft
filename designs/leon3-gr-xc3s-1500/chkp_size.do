set sz 0

#IU3
#foreach i [find signals -internal -r sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/*chkp] {
#icache
#foreach i [find signals -internal -r sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/icache0/*chkp] {
#dcache
#foreach i [find signals -internal -r sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/dcache0/*chkp] {
#acache
foreach i [find signals -internal -r sim:/testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/a0/*chkp] {
	echo i:$i
	foreach j [find signals -internal -r "$i.*"] {
		echo j:$j
		set val [examine -value $j]
		echo $val
		set val [string map {" " ""} $val]
		set val [string map {"\{" ""} $val]
		set val [string map {"\}" ""} $val]
		set val [string map {"run" "00"} $val]
		echo $val
		set len [string length $val]
		echo len:$len
		set sz [expr $sz+$len]
	}
}
echo total:$sz
