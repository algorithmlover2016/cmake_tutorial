# generate the MathFunctions library
add_library(MathFunctions MathFunctions.cxx)


#interface to remove the EXTRA_INCLUDES in top-level CMakeLists.txt 
target_include_directories(MathFunctions
        INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
        )

option(USE_MYMATH "Use tutorial provided math implementation" ON)
if (USE_MYMATH) 
    target_compile_definitions(MathFunctions PRIVATE "USE_MYMATH")

    include(CheckSymbolExists)
    set(CMAKE_REQUIRED_LIBRARIES, "m")
    check_symbol_exists(log "math.h" HAVE_LOG)
    check_symbol_exists(exp "math.h" HAVE_EXP)
    
    option(USE_LOG_EXP "Use exp and log functions in math.h to compute sqrt" ON)
    if (HAVE_LOG AND HAVE_EXP AND USE_LOG_EXP)
        add_library(SqrtLibrary STATIC
                mysqrt.cxx
                )

        target_compile_definitions(SqrtLibrary
                PRIVATE "HAVE_LOG" "HAVE_EXP" "USE_LOG_EXP")
    else ()
        # first we add the executable that generates the table
        add_executable(MakeTable MakeTable.cxx)
    
        # add the command to generate the source code
        add_custom_command(
                OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/Table.h"
                COMMAND MakeTable "${CMAKE_CURRENT_BINARY_DIR}/Table.h"
                DEPENDS MakeTable
                )
        # library that just does sqrt
        add_library(SqrtLibrary STATIC
                mysqrt.cxx
                "${CMAKE_CURRENT_BINARY_DIR}/Table.h"
                )
    
        # state that we depend on our binary dir to find Table.h
        target_include_directories(SqrtLibrary PRIVATE
                ${CMAKE_CURRENT_BINARY_DIR}
                )

    endif()

    # state that SqrtLibrary need PIC when the default is shared libraries
    set_target_properties(SqrtLibrary PROPERTIES
            POSITION_INDEPENDENT_CODE ${BUILD_SHARED_LIBS})

    target_link_libraries(MathFunctions PRIVATE SqrtLibrary)
endif()

#define the symbol stating we are using the declspec(dllexport) when
# building on windows
target_compile_definitions(MathFunctions PRIVATE "EXPORTING_MYMATH")



install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
