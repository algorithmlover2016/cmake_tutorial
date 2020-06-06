#add Custom command and Generated File

add_executable(MakeTable MakeTable.cxx)

# add a custom command that specifies how to produce Table.h by running MakeTable.
add_custom_command(
        OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/Table.h"
        COMMAND MakeTable "${CMAKE_CURRENT_BINARY_DIR}/Table.h"
        DEPENDS MakeTable)

# let CMake know that mysqrt.cxx depends on the generated file Table.h.
# generate the MathFunctions library
add_library(MathFunctions
        mysqrt.cxx
        "${CMAKE_CURRENT_BINARY_DIR}/Table.h"
        )


# interface to remove the EXTRA_INCLUDES in top-level CMakeLists.txt 
# add the current binary directory to the list of include directories
# so that Table.h can be found and included by mysqrt.cxx.
target_include_directories(MathFunctions
        INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
        PRIVATE ${CMAKE_CURRENT_BINARY_DIR}
        )

# include(CheckSymbolExists)
# set(CMAKE_REQUIRED_LIBRARIES, "m")
# check_symbol_exists(log "math.h" HAVE_LOG)
# check_symbol_exists(exp "math.h" HAVE_EXP)
# if (HAVE_LOG AND HAVE_EXP)
#     target_compile_definitions(MathFunctions
#             PRIVATE "HAVE_LOG" "HAVE_EXP")
# endif()


install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
