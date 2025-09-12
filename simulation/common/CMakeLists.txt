# Builds libcpu5_common.a from your reusable device impls
add_library(cpu5_common STATIC
    devices.cpp
)

target_compile_features(cpu5_common PUBLIC cxx_std_20)

# Your Makefile had: -O3 -march=native -mtune=native -DNDEBUG -fno-exceptions -fno-rtti -DVL_TWO_STATE=1
# We keep the “no exceptions / no rtti” by default here; tune per target if needed.
target_compile_options(cpu5_common PRIVATE
    -fno-exceptions -fno-rtti
)

# If common needs extra libs (SDL2, pthread, etc.), add/link here:
# find_package(PkgConfig)
# pkg_check_modules(SDL2 REQUIRED sdl2)
# target_link_libraries(cpu5_common PRIVATE ${SDL2_LIBRARIES})
# target_include_directories(cpu5_common PRIVATE ${SDL2_INCLUDE_DIRS})

# Public include dirs, if you add headers later
target_include_directories(cpu5_common PUBLIC
    ${CMAKE_SOURCE_DIR}/simulation/common
)
