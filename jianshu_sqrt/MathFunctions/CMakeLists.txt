# generate the MathFunctions library
add_library(MathFunctions mysqrt.cxx)

#interface to remove the EXTRA_INCLUDES in top-level CMakeLists.txt 
target_include_directories(MathFunctions
        INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
        )
