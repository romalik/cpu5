# =========[ VERILATOR + CLANG/LLD @ MAX NITRO ]=========
# Top + sources
TOP         := cpu5
RTL_TOP     := ../../schematics/cpu5/cpu5.v
RTL_HELPERS := helper.v
HARNESS     := v_sim.cpp

# Verilog include dir (you do `\`include "icechips/xxx.v"` inside RTL)
ICECHIPS_DIR := icechips

# Build dir + final binary
MDIR        := verilator_build
BIN         := v_sim

# Tools — LLVM stack only
VERILATOR   = verilator

# Host compile/link flags — MAXIMUM AGRESSION
COMMON_OPTS := -O3 -march=native -mtune=native -DNDEBUG -fno-exceptions -fno-rtti -DVL_TWO_STATE=1 
CXXSTD      := -std=c++17
THREAD_OPTS := -pthread
LTO_OPTS    := -fuse-ld=lld
CFLAGS      := $(COMMON_OPTS)
CXXFLAGS    := $(CXXSTD) $(COMMON_OPTS)
LDFLAGS     := $(THREAD_OPTS) $(LTO_OPTS)

OPT_FAST    := CXXFLAGS
OPT_SLOW    := CXXFLAGS


# Verilator flags — fast X, no asserts/coverage, keep it lean
VERI_FLAGS  := -cc --exe --build -O3 \
               --Mdir $(MDIR) --top-module $(TOP) \
               --x-assign fast --x-initial fast \
               --noassert --no-coverage  \
               -Wno-TIMESCALEMOD -Wno-WIDTH -Wno-UNOPTFLAT

# Include path for your `include "icechips/..."` lines
VERI_INC    := +incdir+$(ICECHIPS_DIR) -I$(ICECHIPS_DIR)

# Optional trace: make TRACE=1 to enable FST (kept off by default for speed)
TRACE ?= 0
ifeq ($(TRACE),1)
VERI_FLAGS  += --trace-fst --trace-structs
CXXFLAGS    += -DTRACE_FST
endif

# Default: build the simulator
.PHONY: all
all: $(BIN)

# The one true build rule
$(BIN): $(RTL_TOP) $(RTL_HELPERS) $(HARNESS)
	@mkdir -p $(MDIR)

	$(VERILATOR) $(VERI_FLAGS) $(VERI_INC) \
	$(RTL_HELPERS) $(RTL_TOP) \
	--exe $(HARNESS) \
	-CFLAGS    "$(CXXFLAGS) $(LTO_OPTS)" \
	-LDFLAGS   "$(LDFLAGS)"

# Clean the abyss
.PHONY: clean
clean:
	rm -rf $(MDIR)

# Nuclear option
.PHONY: rebuild
rebuild: clean all
