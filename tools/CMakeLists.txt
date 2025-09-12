cmake_minimum_required(VERSION 3.16)
project(tools C)

# ===== Build artifacts =====
# 1) cpu5mkfs
add_executable(cpu5mkfs mkfs.c)

# ===== Install prefix =====
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/opt/cpu5" CACHE PATH "Install prefix" FORCE)
endif()

# ===== Install rules =====
install(TARGETS cpu5mkfs
  RUNTIME DESTINATION bin
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
              GROUP_READ GROUP_EXECUTE
              WORLD_READ WORLD_EXECUTE
)

# cpu5genfs is assumed to already exist (script or binary in this dir)
install(PROGRAMS ${CMAKE_CURRENT_SOURCE_DIR}/cpu5genfs
  DESTINATION bin
)

# ===== Phony umbrella target =====
# Lets other parts of the build depend on “tools”
add_custom_target(tools ALL
  DEPENDS cpu5mkfs
)

# (Optional) explicit clean for symmetry, though “make clean” already works
add_custom_target(clean_tools
  COMMAND ${CMAKE_COMMAND} -E rm -f cpu5mkfs
  COMMENT "Cleaning cpu5mkfs"
)
