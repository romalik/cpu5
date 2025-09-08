TOP        ?= cpu5
VSRCS      ?= helper.v cpu5.v
INCLUDES   ?= -Iicechips/

OUT_FAST   ?= v_sim
OUT_WAVES  ?= v_sim_waves
MDIR_FAST  ?= obj_fast
MDIR_WAVES ?= obj_waves

# use all cores for inner builds
NPROC := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu || echo 4)
MAKEFLAGS += -j$(NPROC)

# core verilator flags
VERILATOR_FLAGS_COMMON = --timescale-override 1ns/1ps \
                         -Wno-UNOPTFLAT \
                         --top-module $(TOP) \
                         --output-split 15000

# final optimization (APPENDED LAST via OPT_FAST — wins over any -Os)
OFAST = -O3 -march=native -mtune=native -DNDEBUG -fomit-frame-pointer -funroll-loops -flto
# early C++ flags (safe to pass via -CFLAGS)
COPT  = -pipe -fno-exceptions -fno-rtti -pthread

.PHONY: all clean
all: $(OUT_FAST) $(OUT_WAVES)

# ---------- FAST (no trace) ----------
$(MDIR_FAST)/V$(TOP).mk: $(VSRCS) v_sim.cpp
	verilator -cc $(VSRCS) $(INCLUDES) $(VERILATOR_FLAGS_COMMON) \
	  --Mdir $(MDIR_FAST) \
	  --exe v_sim.cpp \
	  -CFLAGS "$(COPT) -DVSIM_TRACE=0" \
	  -LDFLAGS "-flto -pthread"

$(OUT_FAST): $(MDIR_FAST)/V$(TOP).mk
	+$(MAKE) -C $(MDIR_FAST) -f V$(TOP).mk V$(TOP) \
	  OPT_FAST="$(OFAST)" LDFLAGS+="-pthread"
	ln -f $(MDIR_FAST)/V$(TOP) $(OUT_FAST)

# ---------- WAVES (VCD) ----------
$(MDIR_WAVES)/V$(TOP).mk: $(VSRCS) v_sim.cpp
	verilator -cc $(VSRCS) $(INCLUDES) $(VERILATOR_FLAGS_COMMON) \
	  --trace \
	  --Mdir $(MDIR_WAVES) \
	  --exe v_sim.cpp \
	  -CFLAGS "$(COPT) -DVSIM_TRACE=1" \
	  -LDFLAGS "-flto -pthread"

$(OUT_WAVES): $(MDIR_WAVES)/V$(TOP).mk
	+$(MAKE) -C $(MDIR_WAVES) -f V$(TOP).mk V$(TOP) \
	  OPT_FAST="$(OFAST)" LDFLAGS+="-pthread"
	ln -f $(MDIR_WAVES)/V$(TOP) $(OUT_WAVES)

clean:
	rm -rf $(MDIR_FAST) $(MDIR_WAVES) $(OUT_FAST) $(OUT_WAVES) *.vcd *.fst