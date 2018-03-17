transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/user/CA_Projects/Snake_v0.1 {/home/user/CA_Projects/Snake_v0.1/snake.v}

