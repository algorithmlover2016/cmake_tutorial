foreach(target foo bar)
  set(vcProjectFile "${RunCMake_TEST_BINARY_DIR}/${target}.vcxproj")
  if(NOT EXISTS "${vcProjectFile}")
    set(RunCMake_TEST_FAILED "Project file ${vcProjectFile} does not exist.")
    return()
  endif()

  set(debuggerCommandArgumentsSet FALSE)

  file(STRINGS "${vcProjectFile}" lines)
  foreach(line IN LISTS lines)
    if(line MATCHES "^ *<LocalDebuggerCommandArguments[^>]*>([^<>]+)</LocalDebuggerCommandArguments>$")
      if("${CMAKE_MATCH_1}" STREQUAL "my-debugger-command-arguments foo")
          message(STATUS "${target}.vcxproj has debugger command arguments set")
          set(debuggerCommandArgumentsSet TRUE)
      endif()
    endif()
  endforeach()

  if(NOT debuggerCommandArgumentsSet)
    set(RunCMake_TEST_FAILED "LocalDebuggerCommandArguments not found or not set correctly.")
    return()
  endif()
endforeach()
