onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips32_tb/clk
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage1/inst_out
add wave -noupdate -radix decimal /mips32_tb/uut/stage1/PCplus4
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage1/pc_to_ins
add wave -noupdate -radix decimal /mips32_tb/uut/stage3/RsE
add wave -noupdate -radix decimal /mips32_tb/uut/stage3/RtE
add wave -noupdate -radix decimal /mips32_tb/uut/stage3/RdE
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage3/ALUoutM
add wave -noupdate -radix unsigned /mips32_tb/uut/stage4/m/temp
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage2/regfile/r
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage5/ALUoutW
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage5/ReadDataW
add wave -noupdate -radix hexadecimal /mips32_tb/uut/stage5/ResultW
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1088 ns} 0}
configure wave -namecolwidth 216
configure wave -valuecolwidth 67
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
WaveRestoreZoom {283 ns} {1261 ns}
