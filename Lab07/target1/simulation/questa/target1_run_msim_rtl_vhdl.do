transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/joshb/micro2026/Lab07/target1/adder_pkg.vhd}
vcom -93 -work work {C:/Users/joshb/micro2026/Lab07/target1/shift_reg_pkg.vhd}
vcom -93 -work work {C:/Users/joshb/micro2026/Lab07/target1/sevenseg_pkg.vhd}
vcom -93 -work work {C:/Users/joshb/micro2026/Lab07/target1/divider_pkg.vhd}
vcom -93 -work work {C:/Users/joshb/micro2026/Lab07/target1/target1.vhd}

