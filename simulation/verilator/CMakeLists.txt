# Variables (as you had)
set(VERI_TOP "cpu5" CACHE STRING "Top module name")
set(RTL_TOP "${CMAKE_SOURCE_DIR}/schematics/cpu5/cpu5.v" CACHE FILEPATH "Top-level RTL")
set(RTL_HELPERS "${CMAKE_CURRENT_SOURCE_DIR}/helper.v" CACHE FILEPATH "Helper RTL file")
set(ICECHIPS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/icechips" CACHE PATH "Verilog include dir for icechips")
set(DEVICE_INC "-I${CMAKE_SOURCE_DIR}/simulation/common/")
set(VERI_MDIR "${CMAKE_CURRENT_BINARY_DIR}/verilator_build" CACHE PATH "Verilator output dir")
set(VERI_HARNESS "${CMAKE_CURRENT_SOURCE_DIR}/v_sim.cpp" CACHE FILEPATH "C++ harness")
set(CPU5_HOST_OPTS "-O3;-march=native;-mtune=native;-DNDEBUG;-fno-exceptions;-fno-rtti;-DVL_TWO_STATE=1")
set(VERI_FLAGS
  -O3
  --x-assign fast --x-initial fast
  --noassert --no-coverage
  -Wno-TIMESCALEMOD -Wno-WIDTH -Wno-UNOPTFLAT
)
set(VERI_INCLUDES +incdir+${ICECHIPS_DIR})

# 1) Generate Verilator makefile
add_custom_command(
  OUTPUT  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/v_sim
  COMMAND ${CMAKE_COMMAND} -E rm -f ${VERI_MDIR}/v_sim
  COMMAND ${CMAKE_COMMAND} -E make_directory ${VERI_MDIR}
  COMMAND verilator --cc ${VERI_FLAGS}
          --build
          ${VERI_INCLUDES}
          ${RTL_HELPERS} ${RTL_TOP}
          --top-module ${VERI_TOP}
          --Mdir ${VERI_MDIR}
          --exe ${VERI_HARNESS}
          --trace
          -CFLAGS "$<JOIN:${CPU5_HOST_OPTS}, > ${DEVICE_INC}"
          -LDFLAGS "$<TARGET_FILE:cpu5_common>"
          -o v_sim
  COMMAND ${CMAKE_COMMAND} -E copy ${VERI_MDIR}/v_sim ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/v_sim
  DEPENDS ${RTL_TOP} ${RTL_HELPERS} ${VERI_HARNESS} $<TARGET_FILE:cpu5_common>
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Verilating ${VERI_TOP} -> ${VERI_MDIR}"
  VERBATIM
)
add_custom_target(v_sim ALL DEPENDS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/v_sim)
add_dependencies(v_sim cpu5_common)

