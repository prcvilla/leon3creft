onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/clk
add wave -noupdate -label rstn /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/rstn
add wave -noupdate -label holdn /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/holdn
add wave -noupdate -divider chkp
add wave -noupdate -label recovdone_pin /testbench/cpu/l3/cpu(0)/u0/leon3x0/recovdone_pin
add wave -noupdate -label recov_pin /testbench/cpu/l3/cpu(0)/u0/leon3x0/recov_pin
add wave -noupdate -label chkp_pin /testbench/cpu/l3/cpu(0)/u0/leon3x0/chkp_pin
add wave -noupdate -divider iu
add wave -noupdate -label r -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/r
add wave -noupdate -label rin -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/iu/rin
add wave -noupdate -divider icache
add wave -noupdate -label ici -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/icache0/ici
add wave -noupdate -label ico -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/icache0/ico
add wave -noupdate -label mcii -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/icache0/mcii
add wave -noupdate -label mcio -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/icache0/mcio
add wave -noupdate -label r -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/icache0/r
add wave -noupdate -divider dcache
add wave -noupdate -label dci -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/dcache0/dci
add wave -noupdate -label dco -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/dcache0/dco
add wave -noupdate -label mcdi -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/dcache0/mcdi
add wave -noupdate -label mcdo -radix hexadecimal /testbench/cpu/l3/cpu(0)/u0/leon3x0/vhdl/p0/c0mmu/dcache0/mcdo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1816901 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 140
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {23042254 ps}
