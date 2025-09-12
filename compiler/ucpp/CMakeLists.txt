# CMakeLists.txt — C preprocessor (ucpp-style) build
cmake_minimum_required(VERSION 3.16)
project(ucpp C)

# Honor the root law if you set it there:
#   set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
# Belt & suspenders — ensure this target lands in build/bin even if root forgot.
#if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
#  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
#endif()

# ---- Sources ----
# If your tree has these exact files, this list will Just Work™.
set(UCPP_SOURCES
  assert.c
  cpp.c
  eval.c
  arith.c
  lexer.c
  macro.c
  mem.c
  nhash.c
)

# ---- Target ----
add_executable(ucpp ${UCPP_SOURCES})
target_compile_definitions(ucpp PRIVATE STAND_ALONE UCPP_CONFIG)

# Match your old Makefile flags
target_compile_options(ucpp PRIVATE -O0 -g)

# Put it in build/bin explicitly
set_target_properties(ucpp PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)

# If you need headers in this dir:
# target_include_directories(ucpp PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# ---- Stage-install during build ----
set(STAGE_DIR "/opt/cpu5/bin")
set(STAMP    "${CMAKE_CURRENT_BINARY_DIR}/.ucpp_staged.stamp")

add_custom_command(
  OUTPUT  "${STAMP}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${STAGE_DIR}"
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:ucpp> "${STAGE_DIR}/ucpp"
  COMMAND ${CMAKE_COMMAND} -E touch "${STAMP}"
  DEPENDS ucpp
  COMMENT "Staging ucpp into ${STAGE_DIR}"
  VERBATIM
)



# ---- Install (optional; keeps symmetry with your other tools) ----
install(TARGETS ucpp RUNTIME DESTINATION bin)

# ---- Umbrella target so other parts can depend on “the preprocessor is built” ----
add_custom_target(ucpp_tool ALL DEPENDS "${STAMP}")
