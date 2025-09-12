cmake_minimum_required(VERSION 3.16)
project(cpu5mc_compiler_proj CXX)

# 1) Build the microcode compiler
add_executable(cpu5mc_compiler mc_compiler.cpp)

# 2) Inputs/outputs
set(MC_INPUT_TXT "${CMAKE_CURRENT_SOURCE_DIR}/cpu5.txt")

# These land in the root build's firmware dir (parent defines FIRMWARE_DIR)
set(MC0_BIN "${FIRMWARE_DIR}/microcode_0.bin")
set(MC1_BIN "${FIRMWARE_DIR}/microcode_1.bin")

# Directory where the compiled binary lives at build time
set(GEN_DIR "$<TARGET_FILE_DIR:cpu5mc_compiler>")

# 3) Run compiler IN ITS OWN DIR with cpu5.txt, then stage outputs to FIRMWARE_DIR
add_custom_command(
  OUTPUT  "${MC0_BIN}" "${MC1_BIN}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${FIRMWARE_DIR}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${GEN_DIR}"
  # Run compiler with the source text as argument
  COMMAND ${CMAKE_COMMAND} -E chdir "${GEN_DIR}" $<TARGET_FILE:cpu5mc_compiler> "${MC_INPUT_TXT}"
  # Move results into firmware dir (rename = move; use copy_if_different if you prefer)
  COMMAND ${CMAKE_COMMAND} -E rename "${GEN_DIR}/microcode_0.bin" "${MC0_BIN}"
  COMMAND ${CMAKE_COMMAND} -E rename "${GEN_DIR}/microcode_1.bin" "${MC1_BIN}"
  DEPENDS cpu5mc_compiler "${MC_INPUT_TXT}"
  COMMENT "Compiling microcode (cpu5.txt) → ${FIRMWARE_DIR}/microcode_[0,1].bin"
  VERBATIM
)

# 4) Make them part of default build; other targets can depend on this
add_custom_target(microcode_firmware ALL
  DEPENDS "${MC0_BIN}" "${MC1_BIN}"
)