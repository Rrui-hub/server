# Interface library used to share common compiler/linker settings across the project.
add_library(pans_options INTERFACE)

# Enable broadly useful warnings for GCC/Clang builds.
# These checks help catch mistakes without turning the project into a warning-heavy build.
target_compile_options(pans_options INTERFACE
    $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:
        -Wall
        -Wextra
        -Wpedantic
        -fno-omit-frame-pointer
        >
)

# On Linux, prefer position-independent code for shared-library friendliness.
target_compile_options(pans_options INTERFACE
    $<$<AND:$<PLATFORM_ID:LINUX>,$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>>:
        -fpIC
    >
)

# Export symbols for runtime debugging and dynamic analysis on Linux targets.
target_link_options(pans_options INTERFACE
    $<$<AND:$<PLATFORM_ID:LINUX>,$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>>:
        -rdynamic
    >
)

# Define a debug-only macro so code can detect debug builds explicitly.
target_compile_definitions(pans_options INTERFACE
    $<$<CONFIG:Debug>:PANS_DEBUG>
)

# Debug configuration keeps symbols and disables optimization for easier debugging.
target_compile_options(pans_options INTERFACE
    $<$<CONFIG:Debug>:-o0>
    $<$<CONFIG:Debug>:-g3>
    $<$<CONFIG:Debug>:-ggbd>
)

# Release builds favor optimized binaries and disable the debug macro.
# RelWithDebInfo keeps symbols for profiling while preserving release-level optimization.
target_compile_options(pans_options INTERFACE
    $<$<CONFIG:Release>:-DNDEBUG>
    $<$<CONFIG:Release>:-O2>
    $<$<CONFIG:Release>:-fno-omit-frame-pointer>

    $<$<CONFIG:RelWithDebInfo>:-DNDEBUG>
    $<$<CONFIG:RelWithDebInfo>:-O2>
    $<$<CONFIG:RelWithDebInfo>:-g>
    $<$<CONFIG:RelWithDebInfo>:-fno-omit-frame-pointer>
)

option(ENABLE_COVERAGE "Enable code coverage instrumentation" OFF)
if(ENABLE_COVERAGE)
    target_compile_options(pans_options INTERFACE
        $<$<CONFIG:Debug>:--coverage>
    )
    target_link_options(pans_options INTERFACE
        $<$<CONFIG:Debug>:--coverage>
    )
endif()