
# Build the logic simulator executable
add_executable(l_sim
    l_sim.cpp
)

# Link against the shared common static lib
target_link_libraries(l_sim
    PRIVATE cpu5_common
)

# Respect the root law:
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
# Still, belt & suspenders per-target:
set_target_properties(l_sim PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)

# If you need threads at some point, uncomment:
find_package(Threads REQUIRED)
target_link_libraries(l_sim PRIVATE Threads::Threads)