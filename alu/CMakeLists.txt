cmake_minimum_required(VERSION 3.16)
project(alu_generator_proj C)

# 1) Build the generator
add_executable(alu_generator alu_generator.c)

# 2) Output directory for blobs

set(ALU_HIGH_BIN "${FIRMWARE_DIR}/alu_high.bin")
set(ALU_LOW_BIN  "${FIRMWARE_DIR}/alu_low.bin")

# Directory where alu_generator lives at build time
set(GEN_DIR "$<TARGET_FILE_DIR:alu_generator>")

add_custom_command(
  OUTPUT  "${ALU_HIGH_BIN}" "${ALU_LOW_BIN}"
  # Ensure both dirs exist
  COMMAND ${CMAKE_COMMAND} -E make_directory "${FIRMWARE_DIR}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${GEN_DIR}"
  # Run generator IN ITS OWN DIR (so it drops alu_high.bin / alu_low.bin there)
  COMMAND ${CMAKE_COMMAND} -E chdir "${GEN_DIR}" $<TARGET_FILE:alu_generator>
  # Stage/copy results into firmware dir
  COMMAND ${CMAKE_COMMAND} -E rename "${GEN_DIR}/alu_high.bin" "${ALU_HIGH_BIN}"
  COMMAND ${CMAKE_COMMAND} -E rename "${GEN_DIR}/alu_low.bin"  "${ALU_LOW_BIN}"
  DEPENDS alu_generator
  COMMENT "Running alu_generator in ${GEN_DIR} → staging to ${FIRMWARE_DIR}"
  VERBATIM
)

add_custom_target(alu_firmware ALL
  DEPENDS "${ALU_HIGH_BIN}" "${ALU_LOW_BIN}"
)