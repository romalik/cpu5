
# Makefile.verilator_tb — build the C++ Verilator testbench
# Usage:
#   make -f /mnt/data/Makefile.verilator_tb \
#        TOP=cpu5 \
#        VSRCS="/path/cpu5.v /path/helper.v" \
#        INCLUDES="-I$(ICECHIPS_DIR)" \
#        OUT=sim_tb_like
#
# Result: ./sim_tb_like + cpu5_tb_like.vcd

TOP ?= cpu5
OUT ?= v_sim
VSRCS ?= helper.v cpu5.v
INCLUDES ?= -Iicechips/

VERILATOR_FLAGS = --trace --timescale-override 1ns/1ps -Wno-UNOPTFLAT --top-module cpu5

all:
	verilator -cc $(VSRCS) $(INCLUDES) $(VERILATOR_FLAGS) --exe v_sim.cpp --build -o $(OUT)

clean:
	rm -rf obj_dir $(OUT) *.vcd
