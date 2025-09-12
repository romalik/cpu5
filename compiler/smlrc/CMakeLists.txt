cmake_minimum_required(VERSION 3.16)
project(smlrc C)

# Put binaries into build/bin
if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
endif()

# ---- Build the binary ----
add_executable(smlrc smlrc.c)

set_target_properties(smlrc PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)

# ---- Stage-install during build ----
set(STAGE_DIR "/opt/cpu5/bin")
set(STAMP    "${CMAKE_CURRENT_BINARY_DIR}/.smlrc_staged.stamp")

add_custom_command(
  OUTPUT  "${STAMP}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${STAGE_DIR}"
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:smlrc> "${STAGE_DIR}/smlrc"
  COMMAND ${CMAKE_COMMAND} -E touch "${STAMP}"
  DEPENDS smlrc
  COMMENT "Staging smlrc into ${STAGE_DIR}"
  VERBATIM
)

add_custom_target(smlrc_tool ALL DEPENDS "${STAMP}")

# ---- Normal install rule (optional, keeps symmetry) ----
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/opt/cpu5" CACHE PATH "Install prefix" FORCE)
endif()
install(TARGETS smlrc RUNTIME DESTINATION bin)