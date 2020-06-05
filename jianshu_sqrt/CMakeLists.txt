cmake_minimum_required(VERSION 3.10)

# set the project name
project(Tutorial VERSION 2.2)

#specify the c++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

option(USE_MYMATH "USE tutorial provided math implementation" ON)

#configure a header file to pass some of the CMake settings to the source code
configure_file("${PROJECT_SOURCE_DIR}/TutorialConfig.h.in"
        "${PROJECT_BINARY_DIR}/TutorialConfig.h")

if (USE_MYMATH)
    # add the MathFunctions library
    add_subdirectory(MathFunctions)
    list(APPEND EXTRA_LIBS MathFunctions)
    list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
endif()

# add the executable
add_executable(Tutorial tutorial.cxx)

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})
target_include_directories(Tutorial PUBLIC
        "${PROJECT_BINARY_DIR}"
        "${EXTRA_INCLUDES}"
        )
