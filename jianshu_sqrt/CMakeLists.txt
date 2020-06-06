cmake_minimum_required(VERSION 3.10)

# set the project name
project(Tutorial VERSION 2.2)

set(CMAKE_DEBUG_POSTFIX d)

# #specify the c++ standard
# set(CMAKE_CXX_STANDARD 11)
# set(CMAKE_CXX_STANDARD_REQUIRED True)
# replaled with
add_library(tutorial_compiler_flags INTERFACE)
target_compile_features(tutorial_compiler_flags INTERFACE cxx_std_11)
set(gcc_like_cxx "$<COMPILE_LANG_AND_ID:CXX,ARMClang,AppleClang,Clang,GNU>")
set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")
target_compile_options(tutorial_compiler_flags INTERFACE
        "$<${gcc_like_cxx}:$<BUILD_INTERFACE:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused>>"
        "$<${msvc_cxx}:$<BUILD_INTERFACE:-W3>>"
        )


#configure a header file to pass some of the CMake settings to the source code
configure_file("${PROJECT_SOURCE_DIR}/TutorialConfig.h.in"
        "${PROJECT_BINARY_DIR}/TutorialConfig.h")

# option(USE_MYMATH "USE tutorial provided math implementation" OFF)
# if (USE_MYMATH)
#     # add the MathFunctions library
#     add_subdirectory(MathFunctions)
#     list(APPEND EXTRA_LIBS MathFunctions)
#     # add the target_include_directories in MathFunctions CMakeLists.txt, so no need writing the follow
#     # list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
# endif()

# control where the static and shared libraries are built so that on windows
# we don't need to tinker with the path to run the executable
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
add_subdirectory(MathFunctions)
list(APPEND EXTRA_LIBS MathFunctions)

# add the executable
add_executable(Tutorial tutorial.cxx)

# for debug
set_target_properties(Tutorial PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})
target_include_directories(Tutorial PUBLIC
        "${PROJECT_BINARY_DIR}"
        )
# "${EXTRA_INCLUDES}"


include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENCE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "${Tutorial_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${Tutorial_VERSION_MINOR}")
include(CPack)

# run those tests and submit them to a dashboard. To include support for dashboards we include the CTest module
# enable_testing()
include(CTest)

# does the application run
add_test(NAME Runs COMMAND Tutorial 25)

# does the usage message work?
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
        PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number"
        )

#define a function to simplify adding tests
function(do_test target arg result)
    add_test(NAME Comp${arg} COMMAND ${target} ${arg})
    set_tests_properties(Comp${arg}
            PROPERTIES PASS_REGULAR_EXPRESSION ${result}
            )
endfunction(do_test)

# do a bunch of result based tests
do_test(Tutorial 4 "4 is 2")
do_test(Tutorial 9 "9 is 3")
do_test(Tutorial 5 "5 is 2.236")
do_test(Tutorial 7 "7 is 2.645")
do_test(Tutorial 25 "25 is 5")
do_test(Tutorial -25 "-25 is [-nan|nan|0]")
do_test(Tutorial 0.0001 "0.0001 is 0.01")

install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h"
        DESTINATION include)

install(EXPORT MathFunctionsTargets
        FILE MathFunctionsTargets.cmake
        DESTINATION lib/cmake/MathFunctions
        )
include(CMakePackageConfigHelpers)

# generate the config file that is includes the exports
configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
        "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake"
        INSTALL_DESTINATION "lib/cmake/example"
        NO_SET_AND_CHECK_MACRO
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
        )

#generate the version file for the config file
write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/MathFucntionsConfigVersion.cmake"
        VERSION "${Tutorial_VERSION_MAJOR}.${Tutorial_VERSION_MINOR}"
        COMPATIBILITY AnyNewerVersion
        )

# install the configuration file
install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsConfig.cmake"
        DESTINATION "lib/cmake/MathFunctioins"
       )

export(EXPORT MathFunctionsTargets
        FILE "${CMAKE_CURRENT_BINARY_DIR}/MathFunctionsTargets.cmake"
      )
