vlib work
vlog fifo.v fifo_tb.v 
vsim -voptargs=+acc work.fifo_tb
add wave *
add wave -position insertpoint  \
sim:/fifo_tb/tb/fifo
run -all
#quit -sim