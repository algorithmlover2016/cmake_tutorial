find_package(EnvModules REQUIRED)
message("module purge")
env_module(COMMAND purge RESULT_VARIABLE ret_var)
if(NOT ret_var EQUAL 0)
  message(FATAL_ERROR "module(purge) returned ${ret_var}")
endif()

message("module avail")
env_module_avail(avail_mods)
foreach(mod IN LISTS avail_mods)
  message("  ${mod}")
endforeach()

if(avail_mods)
  list(GET avail_mods 0 mod0)
  message("module load ${mod0}")
  env_module(load ${mod0})

  message("module list")
  env_module_list(loaded_mods)
  set(mod0_found FALSE)
  foreach(mod IN LISTS loaded_mods)
    message("  ${mod}")
    if(NOT mod0_found AND mod MATCHES "^${mod0}")
      set(mod0_found ${mod})
    endif()
  endforeach()

  if(NOT mod0_found)
    message(FATAL_ERROR "Requested module ${mod0} not found in loaded modules")
  endif()
  message("module ${mod0} found loaded as ${mod0_found}")
endif()