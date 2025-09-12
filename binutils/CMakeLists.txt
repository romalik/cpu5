cmake_minimum_required(VERSION 3.18)
project(cpu5_binutils C)

# Build-time staging prefix (where we copy freshly-built tools so the rest can use them)
set(CPU5_PREFIX "/opt/cpu5" CACHE PATH "Stage-install prefix used during the build")

# Where the python helper lives (adjust if different)
set(CPU5BUILD_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/cpu5build")

# ====== INSTALL PREFIX LAW (defaults to /opt/cpu5) ======
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/opt/cpu5" CACHE PATH "Install prefix" FORCE)
endif()

# ====== COMPILER SANITY (optional spice) ======
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
add_compile_options(-O0 -g)

# ====== SOURCES FOR cpu5as / cpu5ld ======
# Try conventional names; if absent, fall back to globbing like feral wolves.
set(CPU5AS_SRC)
set(CPU5LD_SRC)

list(APPEND CPU5AS_SRC asm.c labels.c token.c util.c sections.c constants.c)
list(APPEND CPU5LD_SRC link.c util.c labels.c sections.c)


# ====== EXECUTABLES ======
add_executable(cpu5as ${CPU5AS_SRC})
add_executable(cpu5ld ${CPU5LD_SRC})



# ====== CRT OBJECTS via freshly built assembler ======
# Inputs
set(CRT_SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/kcrt0.s
  ${CMAKE_CURRENT_SOURCE_DIR}/crt0.s
  ${CMAKE_CURRENT_SOURCE_DIR}/crt1.s
  ${CMAKE_CURRENT_SOURCE_DIR}/crt_end.s
)

foreach(SRC IN LISTS CRT_SOURCES)
  get_filename_component(BN "${SRC}" NAME_WE) # e.g., kcrt0
  set(OUT "${CMAKE_CURRENT_BINARY_DIR}/${BN}.o")

  add_custom_command(
    OUTPUT "${OUT}"
    COMMAND $<TARGET_FILE:cpu5as> "${SRC}" "${OUT}"
    DEPENDS cpu5as "${SRC}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    COMMENT "Assembling ${BN}.o with cpu5as"
    VERBATIM
  )
  list(APPEND CRT_OBJECTS "${OUT}")
endforeach()

# Build them by default (like your Makefile's 'all')
add_custom_target(crt_objs ALL DEPENDS ${CRT_OBJECTS})

# ====== STAGE-INSTALL DURING BUILD ======
# We stage-copy to ${CPU5_PREFIX} *while building*, so the rest of the project can use latest tools.

# Stamp file to represent "toolchain staged".
set(STAMP "${CMAKE_CURRENT_BINARY_DIR}/.toolchain_staged.stamp")

add_custom_command(
  OUTPUT "${STAMP}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${CPU5_PREFIX}/bin"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${CPU5_PREFIX}/lib"
  
  # Stage assembler & linker
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:cpu5as> "${CPU5_PREFIX}/bin/cpu5as"
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:cpu5ld> "${CPU5_PREFIX}/bin/cpu5ld"

  # Stage CRT objects
  COMMAND ${CMAKE_COMMAND} -E copy ${CRT_OBJECTS} "${CPU5_PREFIX}/lib/"
  # Stage python helper
  COMMAND ${CMAKE_COMMAND} -E copy "${CPU5BUILD_SCRIPT}" "${CPU5_PREFIX}/bin/cpu5build"

  # Stamp
  COMMAND ${CMAKE_COMMAND} -E touch "${STAMP}"

  DEPENDS cpu5as cpu5ld crt_objs "${CPU5BUILD_SCRIPT}"
  COMMENT "Staging CPU5 toolchain into ${CPU5_PREFIX} (build-time install)"
  VERBATIM
)

# Phony target others can depend on
add_custom_target(cpu5_toolchain ALL DEPENDS "${STAMP}")

# ====== IMPORTED TARGETS POINTING AT STAGED BINARIES ======
# These let other directories use $<TARGET_FILE:cpu5as_staged> in commands and also depend on cpu5_toolchain.

add_executable(cpu5as_staged IMPORTED GLOBAL)
set_target_properties(cpu5as_staged PROPERTIES
  IMPORTED_LOCATION "${CPU5_PREFIX}/bin/cpu5as")
add_dependencies(cpu5as_staged cpu5_toolchain)

add_executable(cpu5ld_staged IMPORTED GLOBAL)
set_target_properties(cpu5ld_staged PROPERTIES
  IMPORTED_LOCATION "${CPU5_PREFIX}/bin/cpu5ld")
add_dependencies(cpu5ld_staged cpu5_toolchain)

# Convenience variables for downstream CMakeLists
set(CPU5_TOOLCHAIN_BIN "${CPU5_PREFIX}/bin" CACHE PATH "Where staged cpu5 tools live" FORCE)
set(CPU5_TOOLCHAIN_LIB "${CPU5_PREFIX}/lib" CACHE PATH "Where staged crt objects live" FORCE)




# ====== INSTALL CRT OBJECTS TO /opt/cpu5/ ======
install(TARGETS cpu5as cpu5ld
  RUNTIME DESTINATION bin
)
install(FILES ${CRT_OBJECTS} DESTINATION lib)
install(PROGRAMS "${CPU5BUILD_SCRIPT}" DESTINATION bin)
# ====== QUALITY OF LIFE: 'make install' prints where it goes ======
message(STATUS "CPU5 toolchain will install to: ${CMAKE_INSTALL_PREFIX}/bin and ${CMAKE_INSTALL_PREFIX}/lib")
