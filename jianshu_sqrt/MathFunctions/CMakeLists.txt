# generate the MathFunctions library
add_library(MathFunctions mysqrt.cxx)


#interface to remove the EXTRA_INCLUDES in top-level CMakeLists.txt 
target_include_directories(MathFunctions
        INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
        )

include(CheckSymbolExists)
set(CMAKE_REQUIRED_LIBRARIES, "m")
check_symbol_exists(log "math.h" HAVE_LOG)
check_symbol_exists(exp "math.h" HAVE_EXP)
if (HAVE_LOG AND HAVE_EXP)
    target_compile_definitions(MathFunctions
            PRIVATE "HAVE_LOG" "HAVE_EXP")
endif()


install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
