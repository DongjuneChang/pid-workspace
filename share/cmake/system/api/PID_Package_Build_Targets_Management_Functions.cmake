#########################################################################################
#       This file is part of the program PID                                            #
#       Program description : build system supportting the PID methodology              #
#       Copyright (C) Robin Passama, LIRMM (Laboratoire d'Informatique de Robotique     #
#       et de Microelectronique de Montpellier). All Right reserved.                    #
#                                                                                       #
#       This software is free software: you can redistribute it and/or modify           #
#       it under the terms of the CeCILL-C license as published by                      #
#       the CEA CNRS INRIA, either version 1                                            #
#       of the License, or (at your option) any later version.                          #
#       This software is distributed in the hope that it will be useful,                #
#       but WITHOUT ANY WARRANTY; without even the implied warranty of                  #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                    #
#       CeCILL-C License for more details.                                              #
#                                                                                       #
#       You can find the complete license description on the official website           #
#       of the CeCILL licenses family (http://www.cecill.info/index.en.html)            #
#########################################################################################

##########################################################################################
############################ Guard for optimization of configuration process #############
##########################################################################################
if(PID_PACKAGE_BUILD_TARGETS_MANAGEMENT_FUNCTIONS_INCLUDED)
  return()
endif()
set(PID_PACKAGE_BUILD_TARGETS_MANAGEMENT_FUNCTIONS_INCLUDED TRUE)
##########################################################################################

############################################################################
####################### build command creation auxiliary function ##########
############################################################################

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Global_Build_Command| replace:: ``create_Global_Build_Command``
#  .. _create_Global_Build_Command:
#
#  create_Global_Build_Command
#  -------------------------------------
#
#   .. command:: create_Global_Build_Command(privileges gen_install gen_build gen_package gen_doc gen_test_or_cover)
#
#     Create the global build target for current native package.
#
#     :privileges: the OS command to get privileged (root) permissions. Useful to run tests with root privileges if required.
#
#     :gen_install: if TRUE the build command launch installation.
#
#     :gen_build: if TRUE the build command launch compilation.
#
#     :gen_doc: if TRUE the build command generates API documentation.
#
#     :gen_test_or_cover: if value is "coverage" the build command generates coverage report after launching tests, if value is "test" the build command launch tests.
#
function(create_Global_Build_Command privileges gen_install gen_build gen_package gen_doc gen_test_or_cover)
if(gen_install)
	if(gen_build) #build package
		if(gen_package) #generate and install a binary package
			if(gen_doc) # documentation generated
				#this is the complete scenario
				if(NOT gen_test_or_cover)
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
						add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				endif()
			else() # no documentation generated
				#this is the complete scenario without documentation
				if(NOT gen_test_or_cover)
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				endif()
			endif()
		else()#no binary package
			if(gen_doc) # documentation generated
				if(NOT gen_test_or_cover)#no test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				endif()
			else() # no documentation generated
				if(NOT gen_test_or_cover)
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} ${PARALLEL_JOBS_FLAG}
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				endif()
			endif()
		endif()
	else()#package not built !!
		if(gen_package)#package binary archive is built
			if(gen_doc)#documentation is built
				if(NOT gen_test_or_cover) # no test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				endif()
			else()#no documentation generated
				if(NOT gen_test_or_cover)
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
						COMMAND ${CMAKE_MAKE_PROGRAM} package
						COMMAND ${CMAKE_MAKE_PROGRAM} package_install
					)
				endif()
			endif()
		else()#no package binary generated
			if(gen_doc) #but with doc
				if(NOT gen_test_or_cover) #without test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} doc
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				endif()
			else()#no doc
				if(NOT gen_test_or_cover) #without test
					add_custom_target(build
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				elseif(gen_test_or_cover STREQUAL "coverage")#coverage test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} coverage ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				else()# basic test
					add_custom_target(build
						COMMAND ${privileges} ${CMAKE_MAKE_PROGRAM} test ${PARALLEL_JOBS_FLAG}
						COMMAND ${CMAKE_MAKE_PROGRAM} install
					)
				endif()
			endif()
		endif()
	endif()
else()
	add_custom_target(build
		COMMAND ${CMAKE_COMMAND} -E echo "[PID] Nothing to be done. Build process aborted."
	)
endif()
endfunction(create_Global_Build_Command)

#.rst:
#
# .. ifmode:: internal
#
#  .. |initialize_Build_System| replace:: ``initialize_Build_System``
#  .. _initialize_Build_System:
#
#  initialize_Build_System
#  -----------------------
#
#   .. command:: initialize_Build_System()
#
#     Initialize current package with specific PID properties used to manage language standards.
#
function(initialize_Build_System)

	## create a property to deal with language standard in targets (created for compatibility with CMake 3.0.2 and CMake version < 3.8 when c++17 is used)
	define_property(TARGET PROPERTY PID_CXX_STANDARD
	                BRIEF_DOCS "Determine the C++ Language standard version to use"
								 	FULL_DOCS "Determine the C++ Language standard version to use")
	#standard for C
	define_property(TARGET PROPERTY PID_C_STANDARD
              BRIEF_DOCS "Determine the C Language standard version to use"
						 	FULL_DOCS "Determine the C Language standard version to use")

endfunction(initialize_Build_System)

#.rst:
#
# .. ifmode:: internal
#
#  .. |resolve_Component_Language| replace:: ``resolve_Component_Language``
#  .. _resolve_Component_Language:
#
#  resolve_Component_Language
#  --------------------------
#
#   .. command:: resolve_Component_Language(component_target)
#
#     Set adequate language standard properties or compilation flags for a component, depending on CMake version.
#
#     :component_target: name of the target used for a given component.
#
function(resolve_Component_Language component_target)
	if(CMAKE_VERSION VERSION_LESS 3.1)#this is only usefll if CMake does not automatically deal with standard related properties
		get_target_property(STD_C ${component_target} PID_C_STANDARD)
		get_target_property(STD_CXX ${component_target} PID_CXX_STANDARD)
		translate_Standard_Into_Option(RES_C_STD_OPT RES_CXX_STD_OPT "${STD_C}" "${STD_CXX}")
		#direclty setting the option, without using CMake mechanism as it is not available for these versions
		target_compile_options(${component_target} PUBLIC "${RES_CXX_STD_OPT}")
    if(RES_C_STD_OPT)#the std C is let optional as using a standard may cause error with posix includes
		    target_compile_options(${component_target} PUBLIC "${RES_C_STD_OPT}")
    endif()
    return()
	elseif(CMAKE_VERSION VERSION_LESS 3.8)#if cmake version is less than 3.8 than the c++ 17 language is unknown
		get_target_property(STD_CXX ${component_target} PID_CXX_STANDARD)
		is_CXX_Version_Less(IS_LESS ${STD_CXX} 17)
		if(NOT IS_LESS)#cxx standard 17 or more
			target_compile_options(${component_target} PUBLIC "-std=c++17")
			return()
		endif()
	endif()

	#default case that can be managed directly by CMake
	get_target_property(STD_C ${component_target} PID_C_STANDARD)
	get_target_property(STD_CXX ${component_target} PID_CXX_STANDARD)
  if(STD_C)#the std C is let optional as using a standard may cause error with posix includes
  	set_target_properties(${component_target} PROPERTIES
  			C_STANDARD ${STD_C}
  			C_STANDARD_REQUIRED YES
  			C_EXTENSIONS NO
  	)#setting the standard in use locally
  endif()
	set_target_properties(${component_target} PROPERTIES
			CXX_STANDARD ${STD_CXX}
			CXX_STANDARD_REQUIRED YES
			CXX_EXTENSIONS NO
	)#setting the standard in use locally
endfunction(resolve_Component_Language)

#.rst:
#
# .. ifmode:: internal
#
#  .. |resolve_Compile_Options_For_Targets| replace:: ``resolve_Compile_Options_For_Targets``
#  .. _resolve_Compile_Options_For_Targets:
#
#  resolve_Compile_Options_For_Targets
#  -----------------------------------
#
#   .. command:: resolve_Compile_Options_For_Targets(mode)
#
#     Set compile option for all components that are build given some info not directly managed by CMake.
#
#     :mode: the given buildmode for components (Release or Debug).
#
function(resolve_Compile_Options_For_Targets mode)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
foreach(component IN LISTS ${PROJECT_NAME}_COMPONENTS)
	is_Built_Component(IS_BUILT_COMP ${PROJECT_NAME} ${component})
	if(IS_BUILT_COMP)
		resolve_Component_Language(${component}${TARGET_SUFFIX})
	endif()
endforeach()
endfunction(resolve_Compile_Options_For_Targets)

#.rst:
#
# .. ifmode:: internal
#
#  .. |filter_Compiler_Options| replace:: ``filter_Compiler_Options``
#  .. _filter_Compiler_Options:
#
#  filter_Compiler_Options
#  -----------------------
#
#   .. command:: filter_Compiler_Options(STD_C_OPT STD_CXX_OPT FILTERED_OPTS opts)
#
#     Filter the options to get those related to language standard used.
#
#     :opts: the list of compilation options.
#
#     :STD_C_OPT: the output variable containg the C language standard used, if any.
#
#     :STD_CXX_OPT: the output variable containg the C++ language standard used, if any.
#
#     :FILTERED_OPTS: the output variable containg the options fromopts not related to language standard, if any.
#
function(filter_Compiler_Options STD_C_OPT STD_CXX_OPT FILTERED_OPTS opts)
set(RES_FILTERED)
foreach(opt IN LISTS opts)
	unset(STANDARD_NUMBER)
	#checking for CXX_STANDARD
	is_CXX_Standard_Option(STANDARD_NUMBER ${opt})
	if(STANDARD_NUMBER)
		set(${STD_CXX_OPT} ${STANDARD_NUMBER} PARENT_SCOPE)
	else()#checking for C_STANDARD
		is_C_Standard_Option(STANDARD_NUMBER ${opt})
		if(STANDARD_NUMBER)
			set(${STD_C_OPT} ${STANDARD_NUMBER} PARENT_SCOPE)
		else()
			list(APPEND RES_FILTERED ${opt})#keep the option unchanged
		endif()
	endif()
endforeach()
set(${FILTERED_OPTS} ${RES_FILTERED} PARENT_SCOPE)
endfunction(filter_Compiler_Options)

############################################################################
############### API functions for internal targets management ##############
############################################################################

#.rst:
#
# .. ifmode:: internal
#
#  .. |manage_Python_Scripts| replace:: ``manage_Python_Scripts``
#  .. _manage_Python_Scripts:
#
#  manage_Python_Scripts
#  ---------------------
#
#   .. command:: manage_Python_Scripts(c_name dirname)
#
#     Create a target for intalling python code.
#
#     :c_name: the name of component that provide python code (MODULE or SCRIPT).
#
#     :dirname: the nameof the folder that contains python code.
#
function(manage_Python_Scripts c_name dirname)
	if(${PROJECT_NAME}_${c_name}_TYPE STREQUAL "MODULE")
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES PREFIX "")#specific requirement for python, not lib prefix at beginning of the module
		# simply copy directory containing script at install time into a specific folder, but select only python script
		# Important notice: the trailing / at end of DIRECTORY argument is to allow the renaming of the directory into c_name
		install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${dirname}/
						DESTINATION ${${PROJECT_NAME}_INSTALL_SCRIPT_PATH}/${c_name}
						FILES_MATCHING PATTERN "*.py"
						PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)
	else()
		# simply copy directory containing script at install time into a specific folder, but select only python script
		# Important notice: the trailing / at end of DIRECTORY argument is to allow the renaming of the directory into c_name
		install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/script/${dirname}/
						DESTINATION ${${PROJECT_NAME}_INSTALL_SCRIPT_PATH}/${c_name}
						FILES_MATCHING PATTERN "*.py"
						PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)
	endif()

	install(#install symlinks that target the python module either in install directory and (undirectly) in the python install dir
			CODE
			"execute_process(
					COMMAND ${CMAKE_COMMAND}
					-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
					-DCMAKE_COMMAND=${CMAKE_COMMAND}
					-DWORKSPACE_DIR=${WORKSPACE_DIR}
					-DTARGET_PACKAGE=${PROJECT_NAME}
					-DTARGET_VERSION=${${PROJECT_NAME}_VERSION}
					-DTARGET_MODULE=${c_name}
					-DTARGET_COMPONENT_TYPE=${${PROJECT_NAME}_${c_name}_TYPE}
					-P ${WORKSPACE_DIR}/share/cmake/system/commands/Install_PID_Python_Script.cmake
			)
			"
	)
endfunction(manage_Python_Scripts)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Module_Lib_Target| replace:: ``create_Module_Lib_Target``
#  .. _create_Module_Lib_Target:
#
#  create_Module_Lib_Target
#  ------------------------
#
#   .. command:: create_Module_Lib_Target(c_name c_standard cxx_standard sources internal_inc_dirs internal_defs internal_compiler_options internal_links)
#
#     Create a target for a module library (shared object without a specific header and supposed to be used only at runtime to implement plugin like mechanism). Modules export nothing as they do not have public headers.
#
#     :c_name: the name of the library.
#
#     :c_standard: the C language standard used for that library.
#
#     :cxx_standard: the C++ language standard used for that library.
#
#     :sources: the source files of the library.
#
#     :internal_inc_dirs: list of additional include path to use when building the library.
#
#     :internal_defs: list of private definitions to use when building the library.
#
#     :internal_compiler_options: list of private compiler options to use when building the library.
#
#     :internal_links: list of private linker options to use when building the library.
#
function(create_Module_Lib_Target c_name c_standard cxx_standard sources internal_inc_dirs internal_defs internal_compiler_options internal_links)
	add_library(${c_name}${INSTALL_NAME_SUFFIX} MODULE ${sources})
	install(TARGETS ${c_name}${INSTALL_NAME_SUFFIX}
		LIBRARY DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_PATH}
	)
	#setting the default rpath for the target (rpath target a specific folder of the binary package for the installed version of the component)
	if(APPLE)
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_RPATH};@loader_path/../.rpath/${c_name}${INSTALL_NAME_SUFFIX}") #the library targets a specific folder that contains symbolic links to used shared libraries
	elseif(UNIX)
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_RPATH};\$ORIGIN/../.rpath/${c_name}${INSTALL_NAME_SUFFIX}") #the library targets a specific folder that contains symbolic links to used shared libraries
	endif()
	manage_Additional_Component_Internal_Flags(${c_name} "${c_standard}" "${cxx_standard}" "${INSTALL_NAME_SUFFIX}" "${internal_inc_dirs}" "" "${internal_defs}" "${internal_compiler_options}" "${internal_links}")
endfunction(create_Module_Lib_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Shared_Lib_Target| replace:: ``create_Shared_Lib_Target``
#  .. _create_Shared_Lib_Target:
#
#  create_Shared_Lib_Target
#  ------------------------
#
#   .. command:: create_Shared_Lib_Target(c_name c_standard cxx_standard sources exported_inc_dirs internal_inc_dirs exported_defs internal_defs exported_compiler_options internal_compiler_options exported_links internal_links)
#
#     Create a target for a shared library.
#
#     :c_name: the name of the library.
#
#     :c_standard: the C language standard used for that library.
#
#     :cxx_standard: the C++ language standard used for that library.
#
#     :sources: the source files of the library.
#
#     :exported_inc_dirs: list of include path exported by the library.
#
#     :internal_inc_dirs: list of additional include path to use when building the library.
#
#     :exported_defs: list of definitions exported by the library.
#
#     :internal_defs: list of private definitions to use when building the library.
#
#     :exported_compiler_options: list of compiler options exported by the library.
#
#     :internal_compiler_options: list of private compiler options to use when building the library.
#
#     :exported_links: list of linker options exported by the library.
#
#     :internal_links: list of private linker options to use when building the library.
#
function(create_Shared_Lib_Target c_name c_standard cxx_standard sources exported_inc_dirs internal_inc_dirs exported_defs internal_defs exported_compiler_options internal_compiler_options exported_links internal_links)
	add_library(${c_name}${INSTALL_NAME_SUFFIX} SHARED ${sources})

    if(WIN32)
    	install(TARGETS ${c_name}${INSTALL_NAME_SUFFIX} RUNTIME DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_PATH}) # for .dll
    	install(TARGETS ${c_name}${INSTALL_NAME_SUFFIX} ARCHIVE DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_PATH}) # for .lib
    else()
        install(TARGETS ${c_name}${INSTALL_NAME_SUFFIX} LIBRARY DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_PATH})
    endif()
	#setting the default rpath for the target (rpath target a specific folder of the binary package for the installed version of the component)
	if(APPLE)
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_RPATH};@loader_path/../.rpath/${c_name}${INSTALL_NAME_SUFFIX}") #the library targets a specific folder that contains symbolic links to used shared libraries
	elseif(UNIX)
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_RPATH};\$ORIGIN/../.rpath/${c_name}${INSTALL_NAME_SUFFIX}") #the library targets a specific folder that contains symbolic links to used shared libraries
	endif()
	set(INC_DIRS ${internal_inc_dirs} ${exported_inc_dirs})
	set(DEFS ${internal_defs} ${exported_defs})
	set(LINKS ${exported_links} ${internal_links})
	set(COMP_OPTS ${exported_compiler_options} ${internal_compiler_options})
	manage_Additional_Component_Internal_Flags(${c_name} "${c_standard}" "${cxx_standard}" "${INSTALL_NAME_SUFFIX}" "${INC_DIRS}" "" "${DEFS}" "${COMP_OPTS}" "${LINKS}")
	manage_Additional_Component_Exported_Flags(${c_name} "${INSTALL_NAME_SUFFIX}" "${exported_inc_dirs}" "" "${exported_defs}" "${exported_compiler_options}" "${exported_links}")
endfunction(create_Shared_Lib_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Static_Lib_Target| replace:: ``create_Static_Lib_Target``
#  .. _create_Static_Lib_Target:
#
#  create_Static_Lib_Target
#  ------------------------
#
#   .. command:: create_Static_Lib_Target(c_name c_standard cxx_standard sources exported_inc_dirs internal_inc_dirs exported_defs internal_defs exported_compiler_options internal_compiler_options exported_links)
#
#     Create a target for a static library (they export all their links by construction)
#
#     :c_name: the name of the library.
#
#     :c_standard: the C language standard used for that library.
#
#     :cxx_standard: the C++ language standard used for that library.
#
#     :sources: the source files of the library.
#
#     :exported_inc_dirs: list of include path exported by the library.
#
#     :internal_inc_dirs: list of additional include path to use when building the library.
#
#     :exported_defs: list of definitions exported by the library.
#
#     :internal_defs: list of private definitions to use when building the library.
#
#     :exported_compiler_options: list of compiler options exported by the library.
#
#     :internal_compiler_options: list of private compiler options to use when building the library.
#
#     :exported_links: list of linker options exported by the library.
#
function(create_Static_Lib_Target c_name c_standard cxx_standard sources exported_inc_dirs internal_inc_dirs exported_defs internal_defs exported_compiler_options internal_compiler_options exported_links)
	add_library(${c_name}${INSTALL_NAME_SUFFIX} STATIC ${sources})
	install(TARGETS ${c_name}${INSTALL_NAME_SUFFIX}
		ARCHIVE DESTINATION ${${PROJECT_NAME}_INSTALL_AR_PATH}
	)
	set(INC_DIRS ${internal_inc_dirs} ${exported_inc_dirs})
	set(DEFS ${internal_defs} ${exported_defs})
	set(COMP_OPTS ${exported_compiler_options} ${internal_compiler_options})
	manage_Additional_Component_Internal_Flags(${c_name} "${c_standard}" "${cxx_standard}" "${INSTALL_NAME_SUFFIX}" "${INC_DIRS}" "" "${DEFS}" "${COMP_OPTS}" "")#no linking with static libraries so do not manage internal_flags
	manage_Additional_Component_Exported_Flags(${c_name} "${INSTALL_NAME_SUFFIX}" "${exported_inc_dirs}" "" "${exported_defs}" "${exported_compiler_options}" "${exported_links}")
endfunction(create_Static_Lib_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Header_Lib_Target| replace:: ``create_Header_Lib_Target``
#  .. _create_Header_Lib_Target:
#
#  create_Header_Lib_Target
#  ------------------------
#
#   .. command:: create_Header_Lib_Target(c_name c_standard cxx_standard exported_inc_dirs exported_defs exported_compiler_options exported_links)
#
#     Create a target for a header only library (they export everything by construction and have no sources).
#
#     :c_name: the name of the library.
#
#     :c_standard: the C language standard used for that library.
#
#     :cxx_standard: the C++ language standard used for that library.
#
#     :exported_inc_dirs: list of include path exported by the library.
#
#     :exported_defs: list of definitions exported by the library.
#
#     :exported_compiler_options: list of compiler options exported by the library.
#
#     :exported_links: list of links exported by the library.
#
function(create_Header_Lib_Target c_name c_standard cxx_standard exported_inc_dirs exported_defs exported_compiler_options exported_links)
	add_library(${c_name}${INSTALL_NAME_SUFFIX} INTERFACE)
	manage_Additional_Component_Exported_Flags(${c_name} "${INSTALL_NAME_SUFFIX}" "${exported_inc_dirs}" "" "${exported_defs}" "${exported_compiler_options}" "${exported_links}")
endfunction(create_Header_Lib_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Executable_Target| replace:: ``create_Executable_Target``
#  .. _create_Executable_Target:
#
#  create_Executable_Target
#  ------------------------
#
#   .. command:: create_Executable_Target(c_name c_standard cxx_standard sources internal_inc_dirs internal_defs internal_compiler_options internal_links)
#
#     Create a target for a executable (applications and examples). Applications export nothing as they do not have public headers.
#
#     :c_name: the name of executable.
#
#     :c_standard: the C language standard used for that executable.
#
#     :cxx_standard: the C++ language standard used for that executable.
#
#     :sources: the source files of the executable.
#
#     :internal_inc_dirs: list of additional include path to use when building the executable.
#
#     :internal_defs: list of private definitions to use when building the executable.
#
#     :internal_compiler_options: list of private compiler options to use when building the executable.
#
#     :internal_links: list of private links to use when building the executable.
#
function(create_Executable_Target c_name c_standard cxx_standard sources internal_inc_dirs internal_defs internal_compiler_options internal_links)
	add_executable(${c_name}${INSTALL_NAME_SUFFIX} ${sources})
	manage_Additional_Component_Internal_Flags(${c_name} "${c_standard}" "${cxx_standard}" "${INSTALL_NAME_SUFFIX}" "${internal_inc_dirs}" "" "${internal_defs}" "${internal_compiler_options}" "${internal_links}")
	# adding the application to the list of installed components when make install is called (not for test applications)
	install(TARGETS ${c_name}${INSTALL_NAME_SUFFIX}
		RUNTIME DESTINATION ${${PROJECT_NAME}_INSTALL_BIN_PATH}
	)
	#setting the default rpath for the target
	if(APPLE)
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_RPATH};@loader_path/../.rpath/${c_name}${INSTALL_NAME_SUFFIX}") #the application targets a specific folder that contains symbolic links to used shared libraries
	elseif(UNIX)
		set_target_properties(${c_name}${INSTALL_NAME_SUFFIX} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_RPATH};\$ORIGIN/../.rpath/${c_name}${INSTALL_NAME_SUFFIX}") #the application targets a specific folder that contains symbolic links to used shared libraries
    elseif(WIN32)
        install(FILES ${WORKSPACE_DIR}/share/patterns/packages/run.bat DESTINATION ${${PROJECT_NAME}_INSTALL_BIN_PATH})
	endif()
endfunction(create_Executable_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_TestUnit_Target| replace:: ``create_TestUnit_Target``
#  .. _create_TestUnit_Target:
#
#  create_TestUnit_Target
#  ----------------------
#
#   .. command:: create_TestUnit_Target(c_name c_standard cxx_standard sources internal_inc_dirs internal_defs internal_compiler_options internal_links)
#
#     Create a target for an executable test unit. Test units export nothing as they do not have public headers. Difference with other applications is that test units are not installed (not useful for end users only for developers).
#
#     :c_name: the name of executable.
#
#     :c_standard: the C language standard used for that executable.
#
#     :cxx_standard: the C++ language standard used for that executable.
#
#     :sources: the source files of the executable.
#
#     :internal_inc_dirs: list of additional include path to use when building the executable.
#
#     :internal_defs: list of private definitions to use when building the executable.
#
#     :internal_compiler_options: list of private compiler options to use when building the executable.
#
#     :internal_links: list of private links to use when building the executable.
#
function(create_TestUnit_Target c_name c_standard cxx_standard sources internal_inc_dirs internal_defs internal_compiler_options internal_links)
	add_executable(${c_name}${INSTALL_NAME_SUFFIX} ${sources})
	manage_Additional_Component_Internal_Flags(${c_name} "${c_standard}" "${cxx_standard}" "${INSTALL_NAME_SUFFIX}" "${internal_inc_dirs}" "" "${internal_defs}" "${internal_compiler_options}" "${internal_links}")
endfunction(create_TestUnit_Target)


#.rst:
#
# .. ifmode:: internal
#
#  .. |collect_Links_And_Flags_For_External_Component| replace:: ``collect_Links_And_Flags_For_External_Component``
#  .. _collect_Links_And_Flags_For_External_Component:
#
#  collect_Links_And_Flags_For_External_Component
#  ----------------------------------------------
#
#   .. command:: collect_Links_And_Flags_For_External_Component(dep_package dep_component RES_INCS RES_DEFS RES_OPTS RES_LINKS_STATIC RES_LINKS_SHARED RES_C_STANDARD RES_CXX_STANDARD RES_RUNTIME)
#
#     Get all required options needed to use an external component.
#
#     :dep_package: the name of the external package that contains the external component.
#
#     :dep_component: the name of the target external component.
#
#     :RES_INCS: output variable containing include path to use when using dep_component.
#
#     :RES_DEFS: output variable containing preprocessor definitions to use when using dep_component.
#
#     :RES_OPTS: output variable containing compiler options to use when using dep_component.
#
#     :RES_LINKS_STATIC: output variable containing the list of path to static libraries to use when using dep_component.
#
#     :RES_LINKS_SHARED: output variable containing the list of path to shared libraries and linker options to use when using dep_component.
#
#     :RES_C_STANDARD: output variable containing the C language standard to use when using dep_component.
#
#     :RES_CXX_STANDARD: output variable containing the C++ language standard to use when using dep_component.
#
#     :RES_RUNTIME: output variable containing the list of path to files or folder used at runtime by dep_component.
#
function(collect_Links_And_Flags_For_External_Component dep_package dep_component
RES_INCS RES_LIB_DIRS RES_DEFS RES_OPTS RES_LINKS_STATIC RES_LINKS_SHARED RES_C_STANDARD RES_CXX_STANDARD RES_RUNTIME)
set(INCS_RESULT)
set(LIBDIRS_RESULT)
set(DEFS_RESULT)
set(OPTS_RESULT)
set(STATIC_LINKS_RESULT)
set(SHARED_LINKS_RESULT)
set(RUNTIME_RESULT)

if(${dep_package}_${dep_component}_C_STANDARD${USE_MODE_SUFFIX})#initialize with current value
	set(C_STD_RESULT ${${dep_package}_${dep_component}_C_STANDARD${USE_MODE_SUFFIX}})
else()
	set(C_STD_RESULT 90)#take lowest value
endif()
if(${dep_package}_${dep_component}_CXX_STANDARD${USE_MODE_SUFFIX})#initialize with current value
	set(CXX_STD_RESULT ${${dep_package}_${dep_component}_CXX_STANDARD${USE_MODE_SUFFIX}})
else()
	set(CXX_STD_RESULT 98)#take lowest value
endif()


## collecting internal dependencies (recursive call on internal dependencies first)
if(${dep_package}_${dep_component}_INTERNAL_DEPENDENCIES${USE_MODE_SUFFIX})
	foreach(comp IN LISTS ${dep_package}_${dep_component}_INTERNAL_DEPENDENCIES${USE_MODE_SUFFIX})
		collect_Links_And_Flags_For_External_Component(${dep_package} ${comp} INCS LDIRS DEFS OPTS LINKS_ST LINKS_SH C_STD CXX_STD RUNTIME_RES)
		if(${dep_package}_${dep_component}_INTERNAL_EXPORT_${comp}${USE_MODE_SUFFIX})
			if(INCS)
				list (APPEND INCS_RESULT ${INCS})
			endif()
			if(DEFS)
				list (APPEND DEFS_RESULT ${DEFS})
			endif()
		endif()

		if(OPTS)
			list (APPEND OPTS_RESULT ${OPTS})
		endif()
		if(LDIRS)
			list (APPEND LIBDIRS_RESULT ${LDIRS})
		endif()
		if(LINKS_ST)
			list (APPEND STATIC_LINKS_RESULT ${LINKS_ST})
		endif()
		if(LINKS_SH)
			list (APPEND SHARED_LINKS_RESULT ${LINKS_SH})
		endif()
		if(C_STD)#always take the greater standard number
			is_C_Version_Less(IS_LESS ${C_STD_RESULT} "${${dep_package}_${comp}_C_STANDARD${VAR_SUFFIX}}")
			if(IS_LESS)
				set(C_STD_RESULT ${${dep_package}_${comp}_C_STANDARD${VAR_SUFFIX}})
			endif()
		endif()
		if(CXX_STD)#always take the greater standard number
			is_CXX_Version_Less(IS_LESS ${CXX_STD_RESULT} "${${dep_package}_${comp}_CXX_STANDARD${VAR_SUFFIX}}")
			if(IS_LESS)
				set(CXX_STD_RESULT ${${dep_package}_${comp}_CXX_STANDARD${VAR_SUFFIX}})
			endif()
		endif()
		if(RUNTIME_RES)
			list (APPEND RUNTIME_RESULT ${RUNTIME_RES})
		endif()
	endforeach()
endif()

#1. Manage dependencies of the component
if(${dep_package}_EXTERNAL_DEPENDENCIES${USE_MODE_SUFFIX}) #if the external package has dependencies we have to resolve those needed by the component
	#some checks to verify the validity of the declaration
	if(NOT ${dep_package}_COMPONENTS${USE_MODE_SUFFIX})
		message (FATAL_ERROR "[PID] CRITICAL ERROR declaring dependency to ${dep_component} in package ${dep_package} : component ${dep_component} is unknown in ${dep_package}.")
		return()
	endif()
	list(FIND ${dep_package}_COMPONENTS${USE_MODE_SUFFIX} ${dep_component} INDEX)
	if(INDEX EQUAL -1)
		message (FATAL_ERROR "[PID] CRITICAL ERROR declaring dependency to ${dep_component} in package ${dep_package} : component ${dep_component} is unknown in ${dep_package}.")
		return()
	endif()

	## collecting external dependencies (recursive call on external dependencies - the corresponding external package must exist)
	foreach(dep IN LISTS ${dep_package}_${dep_component}_EXTERNAL_DEPENDENCIES${USE_MODE_SUFFIX})
		foreach(comp IN LISTS ${dep_package}_${dep_component}_EXTERNAL_DEPENDENCY_${dep}_COMPONENTS${USE_MODE_SUFFIX})#if no component defined this is not an errror !
			collect_Links_And_Flags_For_External_Component(${dep} ${comp} INCS LDIRS DEFS OPTS LINKS_ST LINKS_SH C_STD CXX_STD RUNTIME_RES)
			if(${dep_package}_${dep_component}_EXTERNAL_EXPORT_${dep}_${comp}${USE_MODE_SUFFIX})
				if(INCS)
					list (APPEND INCS_RESULT ${INCS})
				endif()
				if(DEFS)
					list (APPEND DEFS_RESULT ${DEFS})
				endif()
			endif()

			if(OPTS)
				list (APPEND OPTS_RESULT ${OPTS})
			endif()
			if(LDIRS)
				list (APPEND LIBDIRS_RESULT ${LDIRS})
			endif()
			if(LINKS_ST)
				list (APPEND STATIC_LINKS_RESULT ${LINKS_ST})
			endif()
			if(LINKS_SH)
				list (APPEND SHARED_LINKS_RESULT ${LINKS_SH})
			endif()

			is_C_Version_Less(IS_LESS ${C_STD_RESULT} "${C_STD}")#always take the greater standard number
			if(IS_LESS)
				set(C_STD_RESULT ${C_STD})
			endif()
			is_CXX_Version_Less(IS_LESS ${CXX_STD_RESULT} "${CXX_STD}")
			if(IS_LESS)
				set(CXX_STD_RESULT ${CXX_STD})
			endif()

			if(RUNTIME_RES)
				list (APPEND RUNTIME_RESULT ${RUNTIME_RES})
			endif()
		endforeach()
	endforeach()
endif()

#2. Manage the component properties and return the result
if(${dep_package}_${dep_component}_INC_DIRS${USE_MODE_SUFFIX})
	list(APPEND INCS_RESULT ${${dep_package}_${dep_component}_INC_DIRS${USE_MODE_SUFFIX}})
endif()
if(${dep_package}_${dep_component}_DEFS${USE_MODE_SUFFIX})
	list(APPEND DEFS_RESULT ${${dep_package}_${dep_component}_DEFS${USE_MODE_SUFFIX}})
endif()
if(${dep_package}_${dep_component}_LIB_DIRS${USE_MODE_SUFFIX})
	list(APPEND LIBDIRS_RESULT ${${dep_package}_${dep_component}_LIB_DIRS${USE_MODE_SUFFIX}})
endif()
if(${dep_package}_${dep_component}_OPTS${USE_MODE_SUFFIX})
	list(APPEND OPTS_RESULT ${${dep_package}_${dep_component}_OPTS${USE_MODE_SUFFIX}})
endif()
if(${dep_package}_${dep_component}_STATIC_LINKS${USE_MODE_SUFFIX})
	list(APPEND STATIC_LINKS_RESULT ${${dep_package}_${dep_component}_STATIC_LINKS${USE_MODE_SUFFIX}})
endif()
if(${dep_package}_${dep_component}_SHARED_LINKS${USE_MODE_SUFFIX})
	list(APPEND SHARED_LINKS_RESULT ${${dep_package}_${dep_component}_SHARED_LINKS${USE_MODE_SUFFIX}})
endif()
if(${dep_package}_${dep_component}_RUNTIME_RESOURCES${USE_MODE_SUFFIX})
	list(APPEND RUNTIME_RESULT ${${dep_package}_${dep_component}_RUNTIME_RESOURCES${USE_MODE_SUFFIX}})
endif()

#3. clearing the lists
if(INCS_RESULT)
	list(REMOVE_DUPLICATES INCS_RESULT)
endif()
if(DEFS_RESULT)
	list(REMOVE_DUPLICATES DEFS_RESULT)
endif()
if(OPTS_RESULT)
	list(REMOVE_DUPLICATES OPTS_RESULT)
endif()
if(LIBDIRS_RESULT)
	list(REMOVE_DUPLICATES LIBDIRS_RESULT)
endif()
if(STATIC_LINKS_RESULT)
	list(REMOVE_DUPLICATES STATIC_LINKS_RESULT)
endif()
if(SHARED_LINKS_RESULT)
	list(REMOVE_DUPLICATES SHARED_LINKS_RESULT)
endif()
if(RUNTIME_RESULT)
	list(REMOVE_DUPLICATES RUNTIME_RESULT)
endif()

#4. return the values
set(${RES_INCS} ${INCS_RESULT} PARENT_SCOPE)
set(${RES_LIB_DIRS} ${LIBDIRS_RESULT} PARENT_SCOPE)
set(${RES_DEFS} ${DEFS_RESULT} PARENT_SCOPE)
set(${RES_OPTS} ${OPTS_RESULT} PARENT_SCOPE)
set(${RES_LINKS_STATIC} ${STATIC_LINKS_RESULT} PARENT_SCOPE)
set(${RES_LINKS_SHARED} ${SHARED_LINKS_RESULT} PARENT_SCOPE)
set(${RES_RUNTIME} ${RUNTIME_RESULT} PARENT_SCOPE)
set(${RES_C_STANDARD} ${C_STD_RESULT} PARENT_SCOPE)
set(${RES_CXX_STANDARD} ${CXX_STD_RESULT} PARENT_SCOPE)
endfunction(collect_Links_And_Flags_For_External_Component)

#.rst:
#
# .. ifmode:: internal
#
#  .. |manage_Additional_Component_Exported_Flags| replace:: ``manage_Additional_Component_Exported_Flags``
#  .. _manage_Additional_Component_Exported_Flags:
#
#  manage_Additional_Component_Exported_Flags
#  ------------------------------------------
#
#   .. command:: manage_Additional_Component_Exported_Flags(component_name mode_suffix inc_dirs defs options links)
#
#     Configure a component target with exported flags (cflags and ldflags).
#
#     :component_name: the name of the component.
#
#     :mode_suffix: the build mode of the target.
#
#     :inc_dirs: the list of includes to export.
#
#     :lib_dirs: the list of library search folders.
#
#     :defs: the list of preprocessor definitions to export.
#
#     :options: the list of compiler options to export.
#
#     :links: list of links to export.
#
function(manage_Additional_Component_Exported_Flags component_name mode_suffix inc_dirs lib_dirs defs options links)
#message("manage_Additional_Component_Exported_Flags comp=${component_name} include dirs=${inc_dirs} defs=${defs} links=${links}")
# managing compile time flags (-I<path>)
foreach(dir IN LISTS inc_dirs)
	target_include_directories(${component_name}${mode_suffix} INTERFACE "${dir}")
endforeach()

# managing compile time flags (-D<preprocessor_defs>)
foreach(def IN LISTS defs)
	target_compile_definitions(${component_name}${mode_suffix} INTERFACE "${def}")
endforeach()

foreach(opt IN LISTS options)
	target_compile_options(${component_name}${mode_suffix} INTERFACE "${opt}")#keep the option unchanged
endforeach()

# managing link time flags
foreach(dir IN LISTS lib_dirs)#always putting library dirs flags before other links  (enfore resolution of library path before resolving library links)
  target_link_libraries(${component_name}${mode_suffix} INTERFACE "-L${dir}")#generate -L linker flags for library dirs
endforeach()

foreach(link IN LISTS links)
	target_link_libraries(${component_name}${mode_suffix} INTERFACE ${link})
endforeach()

endfunction(manage_Additional_Component_Exported_Flags)

#.rst:
#
# .. ifmode:: internal
#
#  .. |manage_Additional_Component_Internal_Flags| replace:: ``manage_Additional_Component_Internal_Flags``
#  .. _manage_Additional_Component_Internal_Flags:
#
#  manage_Additional_Component_Internal_Flags
#  ------------------------------------------
#
#   .. command:: manage_Additional_Component_Internal_Flags(component_name mode_suffix inc_dirs lib_dirs defs options links)
#
#     Configure a component target with internal flags (cflags and ldflags).
#
#     :component_name: the name of the component.
#
#     :c_standard: the C language standard to use.
#
#     :cxx_standard: the C++ language standard to use.
#
#     :mode_suffix: the build mode of the target.
#
#     :inc_dirs: the list of includes to use.
#
#     :lib_dirs: the list of library search folders.
#
#     :defs: the list of preprocessor definitions to use.
#
#     :options: the list of compiler options to use.
#
#     :links: list of links to use.
#
function(manage_Additional_Component_Internal_Flags component_name c_standard cxx_standard mode_suffix inc_dirs lib_dirs defs options links)
# managing compile time flags
foreach(dir IN LISTS inc_dirs)
	target_include_directories(${component_name}${mode_suffix} PRIVATE "${dir}")
endforeach()

# managing compile time flags
foreach(def IN LISTS defs)
	target_compile_definitions(${component_name}${mode_suffix} PRIVATE "${def}")
endforeach()

foreach(opt IN LISTS options)
	target_compile_options(${component_name}${mode_suffix} PRIVATE "${opt}")
endforeach()

# managing link time flags
foreach(dir IN LISTS lib_dirs) #put library dirs flags BEFORE library flags in link libraries !!
  target_link_libraries(${component_name}${mode_suffix} PRIVATE "-L${dir}")#generate -L linker flags for library dirs
endforeach()

foreach(link IN LISTS links)
	target_link_libraries(${component_name}${mode_suffix} PRIVATE ${link})
endforeach()

#management of standards (setting minimum standard at beginning)
get_target_property(STD_C ${component_name}${mode_suffix} PID_C_STANDARD)
is_C_Version_Less(IS_LESS "${STD_C}" "${c_standard}")
if(IS_LESS)
	set_target_properties(${component_name}${mode_suffix} PROPERTIES PID_C_STANDARD ${c_standard})
endif()

get_target_property(STD_CXX ${component_name}${mode_suffix} PID_CXX_STANDARD)
is_CXX_Version_Less(IS_LESS "${STD_CXX}" "${cxx_standard}")
if(IS_LESS)
	set_target_properties(${component_name}${mode_suffix} PROPERTIES PID_CXX_STANDARD ${cxx_standard})
endif()
endfunction(manage_Additional_Component_Internal_Flags)

#.rst:
#
# .. ifmode:: internal
#
#  .. |manage_Additional_Component_Inherited_Flags| replace:: ``manage_Additional_Component_Inherited_Flags``
#  .. _manage_Additional_Component_Inherited_Flags:
#
#  manage_Additional_Component_Inherited_Flags
#  --------------------------------------------
#
#   .. command:: manage_Additional_Component_Inherited_Flags(component dep_component mode_suffix export)
#
#     Configure a component target with flags (cflags and ldflags) inherited from a dependency.
#
#     :component_name: the name of the component to configure.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode_suffix: the build mode of the target.
#
#     :export: TRUE if component exports dep_component.
#
function(manage_Additional_Component_Inherited_Flags component dep_component mode_suffix export)
	if(export)
		target_include_directories(	${component}${mode_suffix}
						INTERFACE
						$<TARGET_PROPERTY:${dep_component}${mode_suffix},INTERFACE_INCLUDE_DIRECTORIES>
				)
		target_compile_definitions(	${component}${INSTALL_NAME_SUFFIX}
						INTERFACE
						$<TARGET_PROPERTY:${dep_component}${mode_suffix},INTERFACE_COMPILE_DEFINITIONS>
				)
		target_compile_options(		${component}${INSTALL_NAME_SUFFIX}
						INTERFACE
						$<TARGET_PROPERTY:${dep_component}${mode_suffix},INTERFACE_COMPILE_OPTIONS>
				)
	endif()
	is_Built_Component(IS_BUILT_COMP ${PROJECT_NAME} ${component})
	if(IS_BUILT_COMP)
		target_include_directories(	${component}${INSTALL_NAME_SUFFIX}
						PRIVATE
						$<TARGET_PROPERTY:${dep_component}${mode_suffix},INTERFACE_INCLUDE_DIRECTORIES>
					)
		target_compile_definitions(	${component}${INSTALL_NAME_SUFFIX}
						PRIVATE
						$<TARGET_PROPERTY:${dep_component}${mode_suffix},INTERFACE_COMPILE_DEFINITIONS>
					)
		target_compile_options(		${component}${INSTALL_NAME_SUFFIX}
						PRIVATE
						$<TARGET_PROPERTY:${dep_component}${mode_suffix},INTERFACE_COMPILE_OPTIONS>
		)
	endif()
endfunction(manage_Additional_Component_Inherited_Flags)

#.rst:
#
# .. ifmode:: internal
#
#  .. |fill_Component_Target_With_Internal_Dependency| replace:: ``fill_Component_Target_With_Internal_Dependency``
#  .. _fill_Component_Target_With_Internal_Dependency:
#
#  fill_Component_Target_With_Internal_Dependency
#  ----------------------------------------------
#
#   .. command:: fill_Component_Target_With_Internal_Dependency(component dep_component export comp_defs comp_exp_defs dep_defs)
#
#     Configure a component target to link with another component target from current package.
#
#     :component: the name of the component to configure.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :export: TRUE if component exports dep_component.
#
#     :comp_defs: preprocessor definitions defined in implementation of component.
#
#     :comp_exp_defs: preprocessor definitions defined in interface (public headers) of component.
#
#     :dep_defs: preprocessor definitions used in interface of dep_component but defined by implementation of component.
#
function (fill_Component_Target_With_Internal_Dependency component dep_component export comp_defs comp_exp_defs dep_defs)
is_HeaderFree_Component(DEP_IS_HF ${PROJECT_NAME} ${dep_component})
if(NOT DEP_IS_HF)#the required internal component is a library with an interface, so we may get information from it
	if(export)
		set(${PROJECT_NAME}_${component}_TEMP_DEFS ${comp_exp_defs} ${dep_defs})
		manage_Additional_Component_Internal_Flags(${component} "" "" "${INSTALL_NAME_SUFFIX}" "" "" "${comp_defs}" "")
		manage_Additional_Component_Exported_Flags(${component} "${INSTALL_NAME_SUFFIX}" "" "" "${${PROJECT_NAME}_${component}_TEMP_DEFS}" "${dep_component}${INSTALL_NAME_SUFFIX}")
		manage_Additional_Component_Inherited_Flags(${component} ${dep_component} "${INSTALL_NAME_SUFFIX}" TRUE)
	else()
		set(${PROJECT_NAME}_${component}_TEMP_DEFS ${comp_defs} ${dep_defs})
		manage_Additional_Component_Internal_Flags(${component} "" "" "${INSTALL_NAME_SUFFIX}" "" "" "${${PROJECT_NAME}_${component}_TEMP_DEFS}" "${dep_component}${INSTALL_NAME_SUFFIX}")
		manage_Additional_Component_Exported_Flags(${component} "${INSTALL_NAME_SUFFIX}" "" "" "${comp_exp_defs}" "")
		manage_Additional_Component_Inherited_Flags(${component} ${dep_component} "${INSTALL_NAME_SUFFIX}" FALSE)
	endif()
endif()#else, it is an application or a module => runtime dependency declaration
endfunction(fill_Component_Target_With_Internal_Dependency)

#.rst:
#
# .. ifmode:: internal
#
#  .. |fill_Component_Target_With_Package_Dependency| replace:: ``fill_Component_Target_With_Package_Dependency``
#  .. _fill_Component_Target_With_Package_Dependency:
#
#  fill_Component_Target_With_Package_Dependency
#  ---------------------------------------------
#
#   .. command:: fill_Component_Target_With_Package_Dependency(component dep_package dep_component export comp_defs comp_exp_defs dep_defs)
#
#     Configure a component target to link with another component target from another native package.
#
#     :component: the name of the component to configure.
#
#     :dep_package: the name of the native package that contains the dependency.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :export: TRUE if component exports dep_component.
#
#     :comp_defs: preprocessor definitions defined in implementation of component.
#
#     :comp_exp_defs: preprocessor definitions defined in interface (public headers) of component.
#
#     :dep_defs: preprocessor definitions used in interface of dep_component but defined by implementation of component.
#
function (fill_Component_Target_With_Package_Dependency component dep_package dep_component export comp_defs comp_exp_defs dep_defs)
is_HeaderFree_Component(DEP_IS_HF ${dep_package} ${dep_component})
if(NOT DEP_IS_HF)#the required package component is a library

	if(export)
		set(EXPORTED_DEFS ${comp_exp_defs} ${dep_defs})
		manage_Additional_Component_Internal_Flags(${component} "" "" "${INSTALL_NAME_SUFFIX}" "" "" "${comp_defs}" "")
		manage_Additional_Component_Exported_Flags(${component} "${INSTALL_NAME_SUFFIX}" "" "" "${EXPORTED_DEFS}" "")
	else()
		set(INTERNAL_DEFS ${comp_defs} ${dep_defs})
		manage_Additional_Component_Internal_Flags(${component} "" "" "${INSTALL_NAME_SUFFIX}" "" "" "${INTERNAL_DEFS}" "")
		manage_Additional_Component_Exported_Flags(${component} "${INSTALL_NAME_SUFFIX}" "" "" "${comp_exp_defs}" "")
	endif()
endif()	#else, it is an application or a module => runtime dependency declaration
endfunction(fill_Component_Target_With_Package_Dependency)

#.rst:
#
# .. ifmode:: internal
#
#  .. |fill_Component_Target_With_External_Dependency| replace:: ``fill_Component_Target_With_External_Dependency``
#  .. _fill_Component_Target_With_External_Dependency:
#
#  fill_Component_Target_With_External_Dependency
#  ----------------------------------------------
#
#   .. command:: fill_Component_Target_With_External_Dependency(component export comp_defs comp_exp_defs dep_defs)
#
#     Configure a component target to link with external content (from external packages or operating system).
#
#     :component: the name of the component to configure.
#
#     :export: TRUE if component exports the content.
#
#     :comp_defs: preprocessor definitions defined in implementation of component.
#
#     :comp_exp_defs: preprocessor definitions defined in interface (public headers) of component.
#
#     :dep_defs: preprocessor definitions used in interface of dep_component but defined by implementation of component.
#
#     :ext_inc_dirs: list of include path, either absolute or relative to external packages.
#
#     :ext_lib_dirs: list of path, either absolute or relative to external packages, to folders that contain libraries to use at build time.
#
#     :ext_links: list of path to libraries, either absolute or relative to external packages, or linker options.
#
#     :c_standard: C language standard to use when using these dependencies.
#
#     :cxx_standard: C++ language standard to use when using these dependencies.
#
function(fill_Component_Target_With_External_Dependency component export comp_defs comp_exp_defs ext_defs ext_inc_dirs ext_lib_dirs ext_links c_standard cxx_standard)
if(ext_links)
  evaluate_Variables_In_List(EVAL_LNKS ext_links) #first evaluate element of the list => if they are variables they are evaluated
	resolve_External_Libs_Path(COMPLETE_LINKS_PATH "${EVAL_LNKS}" ${CMAKE_BUILD_TYPE})
	if(COMPLETE_LINKS_PATH)
		foreach(link IN LISTS COMPLETE_LINKS_PATH)
			create_External_Dependency_Target(EXT_TARGET_NAME ${link} ${CMAKE_BUILD_TYPE})
			if(EXT_TARGET_NAME)
				list(APPEND EXT_LINKS_TARGETS ${EXT_TARGET_NAME})
			else()
				list(APPEND EXT_LINKS_OPTIONS ${link})
			endif()
		endforeach()
	endif()
	list(APPEND EXT_LINKS ${EXT_LINKS_TARGETS} ${EXT_LINKS_OPTIONS})
endif()
if(ext_inc_dirs)
  evaluate_Variables_In_List(EVAL_INCS ext_inc_dirs)#first evaluate element of the list => if they are variables they are evaluated
	resolve_External_Includes_Path(COMPLETE_INCLUDES_PATH "${EVAL_INCS}" ${CMAKE_BUILD_TYPE})
endif()
if(ext_lib_dirs)
  evaluate_Variables_In_List(EVAL_LDIRS ext_lib_dirs)
	resolve_External_Libs_Path(COMPLETE_LIB_DIRS_PATH "${EVAL_LDIRS}" ${CMAKE_BUILD_TYPE})
endif()
if(ext_defs)
  evaluate_Variables_In_List(EVAL_DEFS ext_defs)#first evaluate element of the list => if they are variables they are evaluated
endif()
if(c_standard)
  evaluate_Variables_In_List(EVAL_CSTD c_standard)
endif()
if(cxx_standard)
  evaluate_Variables_In_List(EVAL_CXXSTD cxx_standard)
endif()

# setting compile/linkage definitions for the component target
if(export)
	if(NOT ${${PROJECT_NAME}_${component}_TYPE} STREQUAL "HEADER")#if component is a not header, everything is used to build
		set(INTERNAL_DEFS ${comp_exp_defs} ${EVAL_DEFS} ${comp_defs})
		manage_Additional_Component_Internal_Flags(${component} "${EVAL_CSTD}" "${EVAL_CXXSTD}" "${INSTALL_NAME_SUFFIX}" "${COMPLETE_INCLUDES_PATH}" "${COMPLETE_LIB_DIRS_PATH}" "${INTERNAL_DEFS}" "" "${EXT_LINKS}")
	endif()
	set(EXPORTED_DEFS ${comp_exp_defs} ${EVAL_DEFS})#only definitions belonging to interfaces are exported (interface of current component + interface of exported component) also all linker options are exported
	manage_Additional_Component_Exported_Flags(${component} "${INSTALL_NAME_SUFFIX}" "${COMPLETE_INCLUDES_PATH}" "${COMPLETE_LIB_DIRS_PATH}" "${EXPORTED_DEFS}" "" "${EXT_LINKS}")

else()#otherwise only definitions for interface of the current component is exported
	set(INTERNAL_DEFS ${comp_defs} ${EVAL_DEFS} ${comp_defs})#everything define for building current component
	manage_Additional_Component_Internal_Flags(${component} "${EVAL_CSTD}" "${EVAL_CXXSTD}" "${INSTALL_NAME_SUFFIX}" "${COMPLETE_INCLUDES_PATH}" "${COMPLETE_LIB_DIRS_PATH}" "${INTERNAL_DEFS}" "" "${EXT_LINKS}")
	manage_Additional_Component_Exported_Flags(${component} "${INSTALL_NAME_SUFFIX}" "" "${COMPLETE_LIB_DIRS_PATH}" "${comp_exp_defs}" "" "${EXT_LINKS}")#only linker options and exported definitions are in the public interface
endif()
endfunction(fill_Component_Target_With_External_Dependency)

############################################################################
############### API functions for imported targets management ##############
############################################################################

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_All_Imported_Dependency_Targets| replace:: ``create_All_Imported_Dependency_Targets``
#  .. _create_All_Imported_Dependency_Targets:
#
#  create_All_Imported_Dependency_Targets
#  --------------------------------------
#
#   .. command:: create_All_Imported_Dependency_Targets(package component mode)
#
#     Create imported targets in current package project for a given component belonging to another package. This may ends up in defining multiple target if this component also has dependencies.
#
#     :package: the name of the package that contains the component.
#
#     :component: the name of the component for which a target has to be created.
#
#     :mode: the build mode for the imported target.
#
function (create_All_Imported_Dependency_Targets package component mode)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
#collect only the package dependencies, not the internal ones
foreach(a_dep_component IN LISTS ${package}_${component}_INTERNAL_DEPENDENCIES${VAR_SUFFIX})
	#for all direct internal dependencies
	create_Dependency_Target(${package} ${a_dep_component} ${mode})
	bind_Imported_Target(${package} ${component} ${package} ${a_dep_component} ${mode})
endforeach()
foreach(a_dep_package IN LISTS ${package}_${component}_DEPENDENCIES${VAR_SUFFIX})
	foreach(a_dep_component IN LISTS ${package}_${component}_DEPENDENCY_${a_dep_package}_COMPONENTS${VAR_SUFFIX})
		#for all direct package dependencies
		create_Dependency_Target(${a_dep_package} ${a_dep_component} ${mode})
		bind_Imported_Target(${package} ${component} ${a_dep_package} ${a_dep_component} ${mode})
	endforeach()
endforeach()
endfunction(create_All_Imported_Dependency_Targets)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_External_Dependency_Target| replace:: ``create_External_Dependency_Target``
#  .. _create_External_Dependency_Target:
#
#  create_External_Dependency_Target
#  ---------------------------------
#
#   .. command:: create_External_Dependency_Target(EXT_TARGET_NAME link mode)
#
#     Create an imported target for an external dependency (external components or OS dependencies).
#
#     :link: the name of the link option. If this is a real linker option and not a library then no target is created.
#
#     :mode: the build mode for the imported target.
#
#     :EXT_TARGET_NAME: the output variable that contains the created target name.
#
function (create_External_Dependency_Target EXT_TARGET_NAME link mode)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
get_Link_Type(RES_TYPE ${link})
if(RES_TYPE STREQUAL OPTION) #for options there is no need to define a target (options also include -l options)
	set(${EXT_TARGET_NAME} PARENT_SCOPE)
elseif(RES_TYPE STREQUAL SHARED)
	get_filename_component(LIB_NAME ${link} NAME)
	if(NOT TARGET ext-${LIB_NAME}${TARGET_SUFFIX})#target does not exist
		add_library(ext-${LIB_NAME}${TARGET_SUFFIX} SHARED IMPORTED GLOBAL)
		set_target_properties(ext-${LIB_NAME}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${link}")
	endif()
	set(${EXT_TARGET_NAME} ext-${LIB_NAME}${TARGET_SUFFIX} PARENT_SCOPE)
else(RES_TYPE STREQUAL STATIC)
	get_filename_component(LIB_NAME ${link} NAME)
	if(NOT TARGET ext-${LIB_NAME}${TARGET_SUFFIX})#target does not exist
		add_library(ext-${LIB_NAME}${TARGET_SUFFIX} STATIC IMPORTED GLOBAL)
		set_target_properties(ext-${LIB_NAME}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${link}")
	endif()
	set(${EXT_TARGET_NAME} ext-${LIB_NAME}${TARGET_SUFFIX} PARENT_SCOPE)
endif()
endfunction(create_External_Dependency_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Dependency_Target| replace:: ``create_Dependency_Target``
#  .. _create_Dependency_Target:
#
#  create_Dependency_Target
#  ------------------------
#
#   .. command:: create_Dependency_Target(dep_package dep_component mode)
#
#     Create an imported target for a dependency that is a native component belonging to another package than currently built one. This ends up in creating all targets required by this dependency if it has dependencies (recursion).
#
#     :dep_package: the name of the package that contains the dependency.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode: the build mode for the imported target.
#
function (create_Dependency_Target dep_package dep_component mode)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
if(NOT TARGET ${dep_package}-${dep_component}${TARGET_SUFFIX})#check that this target does not exist, otherwise naming conflict
#create the dependent target (#may produce recursion to build undirect dependencies of targets
	if(${dep_package}_${dep_component}_TYPE STREQUAL "APP"
		OR ${dep_package}_${dep_component}_TYPE STREQUAL "EXAMPLE")
		create_Imported_Executable_Target(${dep_package} ${dep_component} ${mode})
	elseif(${dep_package}_${dep_component}_TYPE STREQUAL "MODULE")
		create_Imported_Module_Library_Target(${dep_package} ${dep_component} ${mode})
	elseif(${dep_package}_${dep_component}_TYPE STREQUAL "SHARED")
		create_Imported_Shared_Library_Target(${dep_package} ${dep_component} ${mode})
	elseif(${dep_package}_${dep_component}_TYPE STREQUAL "STATIC")
		create_Imported_Static_Library_Target(${dep_package} ${dep_component} ${mode})
	elseif(${dep_package}_${dep_component}_TYPE STREQUAL "HEADER")
		create_Imported_Header_Library_Target(${dep_package} ${dep_component} ${mode})
	endif()
	create_All_Imported_Dependency_Targets(${dep_package} ${dep_component} ${mode})
endif()
endfunction(create_Dependency_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |manage_Additional_Imported_Component_Flags| replace:: ``manage_Additional_Imported_Component_Flags``
#  .. _manage_Additional_Imported_Component_Flags:
#
#  manage_Additional_Imported_Component_Flags
#  ------------------------------------------
#
#   .. command:: manage_Additional_Imported_Component_Flags(package component mode inc_dirs defs options public_links private_links)
#
#     Setting the build properties of an imported target of a component. This may ends up in creating new targets if the component has external dependencies.
#
#     :package: the name of the package that contains the component.
#
#     :component: the name of the component whose target properties has to be set.
#
#     :mode: the build mode for the imported target.
#
#     :inc_dirs: the list of path to include folders to set.
#
#     :defs: the list of preprocessor definitions to set.
#
#     :options: the list of compiler options to set.
#
#     :public_links: the list of path to linked libraries that are exported by component, or exported linker options.
#
#     :private_links: the list of path to linked libraries that are internal to component, or internal linker options.
#
function(manage_Additional_Imported_Component_Flags package component mode inc_dirs defs options public_links private_links)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
# managing include folders (-I<path>)
foreach(dir IN LISTS inc_dirs)
	set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${dir}")
endforeach()

# managing compile time flags (-D<preprocessor_defs>)
foreach(def IN LISTS defs)
	set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "${def}")
endforeach()

foreach(opt IN LISTS options)
	#checking for CXX_STANDARD
	is_CXX_Standard_Option(STANDARD_NUMBER ${opt})
	if(STANDARD_NUMBER)
		message("[PID] WARNING: directly using option -std=c++${STANDARD_NUMBER} is not recommanded, use the CXX_STANDARD keywork in component description instead. PID performs corrective action.")
		is_CXX_Version_Less(IS_LESS "${${package}_${component}_CXX_STANDARD${VAR_SUFFIX}}" "${STANDARD_NUMBER}")
		if(IS_LESS)
			set(${package}_${component}_CXX_STANDARD${VAR_SUFFIX} ${STANDARD_NUMBER} CACHE INTERNAL "")
		endif()
	else()#checking for C_STANDARD
		is_C_Standard_Option(STANDARD_NUMBER ${opt})
		if(STANDARD_NUMBER)
			message("[PID] WARNING: directly using option -std=c${STANDARD_NUMBER} is not recommanded, use the C_STANDARD keywork in component description instead. PID performs corrective action.")
			is_C_Version_Less(IS_LESS "${${package}_${component}_C_STANDARD${VAR_SUFFIX}}" "${STANDARD_NUMBER}")
			if(IS_LESS)
				set(${package}_${component}_C_STANDARD${VAR_SUFFIX} ${STANDARD_NUMBER} CACHE INTERNAL "")
			endif()
		else()
			set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_COMPILE_OPTIONS "${opt}")
		endif()
	endif()
endforeach()

# managing link time flags (public links are always put in the interface
foreach(link IN LISTS public_links)
	create_External_Dependency_Target(EXT_TARGET_NAME ${link} ${mode})
	if(EXT_TARGET_NAME) #this is a library
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${EXT_TARGET_NAME})
	else()#this is an option => simply pass it to the link interface
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${link})
	endif()
endforeach()

# managing link time flags (public links are always put in the interface
foreach(link IN LISTS private_links)
	create_External_Dependency_Target(EXT_TARGET_NAME ${link} ${mode})
	if(EXT_TARGET_NAME) #this is a library
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${EXT_TARGET_NAME})
	else() #this is an option => simply pass it to the link interface
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${link})
	endif()
endforeach()
endfunction(manage_Additional_Imported_Component_Flags)

#.rst:
#
# .. ifmode:: internal
#
#  .. |get_Imported_Target_Mode| replace:: ``get_Imported_Target_Mode``
#  .. _get_Imported_Target_Mode:
#
#  get_Imported_Target_Mode
#  ------------------------
#
#   .. command:: get_Imported_Target_Mode(MODE_TO_IMPORT imported_package imported_binary_location build_mode)
#
#     Deduce which mode to use depending on the build mode required for the imported target. Release mode implies using Release binary ; Debug mode implies using Debug mode binaries or Release mode binaries if component is Closed source or whenever no Debug binary available.
#
#     :imported_package: the name of the package that contains the imported target.
#
#     :imported_binary_location: the path to the binary that is imported.
#
#     :build_mode: the build mode for the imported target.
#
#     :MODE_TO_IMPORT: the output variable that contains the build mode to finally use for the imported target.
#
function(get_Imported_Target_Mode MODE_TO_IMPORT imported_package imported_binary_location build_mode)
	if(mode MATCHES Debug)
			is_Closed_Source_Dependency_Package(CLOSED ${imported_package})
			if(CLOSED AND NOT EXISTS ${imported_binary_location})#if package is closed source and no debug code available (this is a normal case)
				set(${MODE_TO_IMPORT} Release PARENT_SCOPE) #we must use the Release code
			else() #use default mode
				set(${MODE_TO_IMPORT} Debug PARENT_SCOPE)
			endif()
	else() #use default mode
				set(${MODE_TO_IMPORT} Release PARENT_SCOPE)
	endif()
endfunction(get_Imported_Target_Mode)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Imported_Header_Library_Target| replace:: ``create_Imported_Header_Library_Target``
#  .. _create_Imported_Header_Library_Target:
#
#  create_Imported_Header_Library_Target
#  -------------------------------------
#
#   .. command:: create_Imported_Header_Library_Target(package component mode)
#
#     Create the imported target for a header only library belonging to a given native package.
#
#     :package: the name of the package that contains the library.
#
#     :component: the name of the header library.
#
#     :mode: the build mode for the imported target.
#
function(create_Imported_Header_Library_Target package component mode) #header libraries are never closed by definition
	get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})#get variables related to the current build mode
	add_library(${package}-${component}${TARGET_SUFFIX} INTERFACE IMPORTED GLOBAL)#suffix used only for target name
	list_Public_Includes(INCLUDES ${package} ${component} ${mode})
	list_Public_Links(LINKS ${package} ${component} ${mode})
	list_Public_Definitions(DEFS ${package} ${component} ${mode})
	list_Public_Options(OPTS ${package} ${component} ${mode})
	manage_Additional_Imported_Component_Flags(${package} ${component} ${mode} "${INCLUDES}" "${DEFS}" "${OPTS}" "${LINKS}" "")
	# check that C/C++ languages are defined or set them to default
	manage_Language_Standards(${package} ${component} ${mode})
endfunction(create_Imported_Header_Library_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Imported_Static_Library_Target| replace:: ``create_Imported_Static_Library_Target``
#  .. _create_Imported_Static_Library_Target:
#
#  create_Imported_Static_Library_Target
#  -------------------------------------
#
#   .. command:: create_Imported_Static_Library_Target(package component mode)
#
#     Create the imported target for a static library belonging to a given native package.
#
#     :package: the name of the package that contains the library.
#
#     :component: the name of the header library.
#
#     :mode: the build mode for the imported target.
#
function(create_Imported_Static_Library_Target package component mode)
	get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode}) #get variables related to the current build mode
	add_library(${package}-${component}${TARGET_SUFFIX} STATIC IMPORTED GLOBAL) #create the target for the imported library

	get_Binary_Location(LOCATION_RES ${package} ${component} ${mode})
	get_Imported_Target_Mode(MODE_TO_IMPORT ${package} ${LOCATION_RES} ${mode})#get the adequate mode to use for dependency
	if(NOT MODE_TO_IMPORT MATCHES mode)
		get_Binary_Location(LOCATION_RES ${package} ${component} ${MODE_TO_IMPORT})#find the adequate release binary
	endif()
	set_target_properties(${package}-${component}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${LOCATION_RES}")#Debug mode: we keep the suffix as-if we werre building using dependent debug binary even if not existing

	list_Public_Includes(INCLUDES ${package} ${component} ${MODE_TO_IMPORT})
	list_Public_Links(LINKS ${package} ${component} ${MODE_TO_IMPORT})
	list_Private_Links(PRIVATE_LINKS ${package} ${component} ${MODE_TO_IMPORT})
	list_Public_Definitions(DEFS ${package} ${component} ${MODE_TO_IMPORT})
	list_Public_Options(OPTS ${package} ${component} ${MODE_TO_IMPORT})

	manage_Additional_Imported_Component_Flags(${package} ${component} ${mode} "${INCLUDES}" "${DEFS}" "${OPTS}" "${LINKS}" "${PRIVATE_LINKS}")
	# check that C/C++ languages are defined or defult them
	manage_Language_Standards(${package} ${component} ${mode})
endfunction(create_Imported_Static_Library_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Imported_Shared_Library_Target| replace:: ``create_Imported_Shared_Library_Target``
#  .. _create_Imported_Shared_Library_Target:
#
#  create_Imported_Shared_Library_Target
#  -------------------------------------
#
#   .. command:: create_Imported_Shared_Library_Target(package component mode)
#
#     Create the imported target for a shared library belonging to a given native package.
#
#     :package: the name of the package that contains the library.
#
#     :component: the name of the header library.
#
#     :mode: the build mode for the imported target.
#
function(create_Imported_Shared_Library_Target package component mode)
	get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})#get variables related to the current build mode
    if(WIN32)
        add_library(${package}-${component}${TARGET_SUFFIX} STATIC IMPORTED GLOBAL)#create the target for the imported library
    else()
    	add_library(${package}-${component}${TARGET_SUFFIX} SHARED IMPORTED GLOBAL)#create the target for the imported library
    endif()
	get_Binary_Location(LOCATION_RES ${package} ${component} ${mode})#find the binary to use depending on build mode
	get_Imported_Target_Mode(MODE_TO_IMPORT ${package} ${LOCATION_RES} ${mode})#get the adequate mode to use for dependency
	if(NOT MODE_TO_IMPORT MATCHES mode)
		get_Binary_Location(LOCATION_RES ${package} ${component} ${MODE_TO_IMPORT})#find the adequate release binary
	endif()
  if(WIN32)#in windows a shared librairy is specific because it has two parts : a dll and an interface static library
    #we need to link againts the statis library while the "real" component is the dll
    #so we transform the name of the dll object into a .lib object
    string(REPLACE ".dll" ".lib" STATIC_LOCATION_RES "${LOCATION_RES}")
    set_target_properties(${package}-${component}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${STATIC_LOCATION_RES}")
  else()#for UNIX system everything is automatic
    set_target_properties(${package}-${component}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${LOCATION_RES}")#Debug mode: we keep the suffix as-if we werre building using dependent debug binary even if not existing
  endif()

	list_Public_Includes(INCLUDES ${package} ${component} ${MODE_TO_IMPORT})
	list_Public_Links(LINKS ${package} ${component} ${MODE_TO_IMPORT})
	list_Private_Links(PRIVATE_LINKS ${package} ${component} ${MODE_TO_IMPORT})
	list_Public_Definitions(DEFS ${package} ${component} ${MODE_TO_IMPORT})
	list_Public_Options(OPTS ${package} ${component} ${MODE_TO_IMPORT})
	manage_Additional_Imported_Component_Flags(${package} ${component} ${mode} "${INCLUDES}" "${DEFS}" "${OPTS}" "${LINKS}" "${PRIVATE_LINKS}")

	# check that C/C++ languages are defined or default them
	manage_Language_Standards(${package} ${component} ${mode})
endfunction(create_Imported_Shared_Library_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Imported_Module_Library_Target| replace:: ``create_Imported_Module_Library_Target``
#  .. _create_Imported_Module_Library_Target:
#
#  create_Imported_Module_Library_Target
#  -------------------------------------
#
#   .. command:: create_Imported_Module_Library_Target(package component mode)
#
#     Create the imported target for a module library belonging to a given native package.
#
#     :package: the name of the package that contains the library.
#
#     :component: the name of the header library.
#
#     :mode: the build mode for the imported target.
#
function(create_Imported_Module_Library_Target package component mode)
	get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})#get variables related to the current build mode
	add_library(${package}-${component}${TARGET_SUFFIX} MODULE IMPORTED GLOBAL)#create the target for the imported library

	get_Binary_Location(LOCATION_RES ${package} ${component} ${mode})#find the binary to use depending on build mode
	get_Imported_Target_Mode(MODE_TO_IMPORT ${package} ${LOCATION_RES} ${mode})#get the adequate mode to use for dependency
	if(NOT MODE_TO_IMPORT MATCHES mode)
		get_Binary_Location(LOCATION_RES ${package} ${component} ${MODE_TO_IMPORT})#find the adequate release binary
	endif()

	set_target_properties(${package}-${component}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${LOCATION_RES}")#Debug mode: we keep the suffix as-if we werre building using dependent debug binary even if not existing
	#no need to do more, a module is kind of an executable so it stops build recursion
endfunction(create_Imported_Module_Library_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |create_Imported_Executable_Target| replace:: ``create_Imported_Executable_Target``
#  .. _create_Imported_Executable_Target:
#
#  create_Imported_Executable_Target
#  ---------------------------------
#
#   .. command:: create_Imported_Executable_Target(package component mode)
#
#     Create the imported target for an executable belonging to a given native package.
#
#     :package: the name of the package that contains the executable.
#
#     :component: the name of the executable.
#
#     :mode: the build mode for the imported target.
#
function(create_Imported_Executable_Target package component mode)
	get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})#get variables related to the current build mode
	add_executable(${package}-${component}${TARGET_SUFFIX} IMPORTED GLOBAL)#create the target for the imported executable

	get_Binary_Location(LOCATION_RES ${package} ${component} ${mode})
	get_Imported_Target_Mode(MODE_TO_IMPORT ${package} ${LOCATION_RES} ${mode})#get the adequate mode to use for dependency
	if(NOT MODE_TO_IMPORT MATCHES mode)
		get_Binary_Location(LOCATION_RES ${package} ${component} ${MODE_TO_IMPORT})#find the adequate release binary
	endif()

	set_target_properties(${package}-${component}${TARGET_SUFFIX} PROPERTIES IMPORTED_LOCATION "${LOCATION_RES}")#Debug mode: we keep the suffix as-if we werre building using dependent debug binary even if not existing
	#no need to do more, executable will not be linked in the build process (it stops build recursion)
endfunction(create_Imported_Executable_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |resolve_Standard_Before_Linking| replace:: ``resolve_Standard_Before_Linking``
#  .. _resolve_Standard_Before_Linking:
#
#  resolve_Standard_Before_Linking
#  -------------------------------
#
#   .. command:: resolve_Standard_Before_Linking(package component dep_package dep_component mode configure_build)
#
#    Resolve the final language standard to use for a component of the current native package depending on the standard used in one of its dependencies.
#
#     :package: the name of the package that contains the component that HAS a dependency (package currenlty built).
#
#     :component: the name of the component that HAS a dependency.
#
#     :dep_package: the name of the package that contains the dependency.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode: the build mode for the imported target.
#
#     :configure_build: if TRUE then set component's target properties adequately.
#
function(resolve_Standard_Before_Linking package component dep_package dep_component mode configure_build)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})

#get the languages standard in use for both components
get_Language_Standards(STD_C STD_CXX ${package} ${component} ${mode})
get_Language_Standards(DEP_STD_C DEP_STD_CXX ${dep_package} ${dep_component} ${mode})

is_C_Version_Less(IS_LESS "${STD_C}" "${DEP_STD_C}")
if( IS_LESS )#dependency has greater or equal level of standard required
	set(${package}_${component}_C_STANDARD${VAR_SUFFIX} ${DEP_STD_C} CACHE INTERNAL "")
	if(configure_build)# the build property is set for a target that is built locally (otherwise would produce errors)
		set_target_properties(${component}${TARGET_SUFFIX} PROPERTIES PID_C_STANDARD ${DEP_STD_C}) #the minimal value in use file is set adequately
	endif()
endif()

is_CXX_Version_Less(IS_LESS "${STD_CXX}" "${DEP_STD_CXX}")
if( IS_LESS )#dependency has greater or equal level of standard required
	set(${package}_${component}_CXX_STANDARD${VAR_SUFFIX} ${DEP_STD_CXX} CACHE INTERNAL "")#the minimal value in use file is set adequately
	if(configure_build)# the build property is set for a target that is built locally (otherwise would produce errors)
		set_target_properties(${component}${TARGET_SUFFIX} PROPERTIES PID_CXX_STANDARD ${DEP_STD_CXX})
	endif()
endif()
endfunction(resolve_Standard_Before_Linking)

#.rst:
#
# .. ifmode:: internal
#
#  .. |bind_Target| replace:: ``bind_Target``
#  .. _bind_Target:
#
#  bind_Target
#  -----------
#
#   .. command:: bind_Target(component dep_package dep_component mode export comp_defs comp_exp_defs dep_defs)
#
#   Bind the target of a component build locally to the target of a component belonging to another package.
#
#     :component: the name of the component whose target has to be bound to another target.
#
#     :dep_package: the name of the package that contains the dependency.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode: the build mode for the targets.
#
#     :export: if TRUE then set component's target export dep_component's target.
#
#     :comp_defs: the preprocessor definitions defined in component implementation that conditionate the use of dep_component.
#
#     :comp_exp_defs: the preprocessor definitions defined in component interface that conditionate the use of dep_component.
#
#     :dep_defs: the preprocessor definitions used in dep_component interface that are defined by dep_component.
#
function(bind_Target component dep_package dep_component mode export comp_defs comp_exp_defs dep_defs)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
is_Built_Component(COMP_IS_BUILT ${PROJECT_NAME} ${component})
is_HeaderFree_Component(DEP_IS_HF ${dep_package} ${dep_component})
if(COMP_IS_BUILT)
	#use definitions and links for building the target
	set(internal_defs ${comp_defs} ${comp_exp_defs} ${dep_defs})
	manage_Additional_Component_Internal_Flags(${component} "" "" "${TARGET_SUFFIX}" "" "" "${internal_defs}" "" "")

	if(NOT DEP_IS_HF)
		target_link_libraries(${component}${TARGET_SUFFIX} PRIVATE ${dep_package}-${dep_component}${TARGET_SUFFIX})

    target_include_directories(${component}${TARGET_SUFFIX} PRIVATE
			$<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_INCLUDE_DIRECTORIES>)

		target_compile_definitions(${component}${TARGET_SUFFIX} PRIVATE
			$<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_DEFINITIONS>)

		target_compile_options(${component}${TARGET_SUFFIX} PRIVATE
			$<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_OPTIONS>)
	endif()

	# set adequately language standard for component depending on the value of dep_component
	resolve_Standard_Before_Linking(${PROJECT_NAME} ${component} ${dep_package} ${dep_component} ${mode} TRUE)
else()#for headers lib do not set the language standard build property (othewise CMake complains on recent versions)
	# set adequately language standard for component depending on the value of dep_component
	resolve_Standard_Before_Linking(${PROJECT_NAME} ${component} ${dep_package} ${dep_component} ${mode} FALSE)
endif()

if(NOT DEP_IS_HF)#the required package component is a library with header it can export something
	if(export)#the library export something
		set(exp_defs ${comp_exp_defs} ${dep_defs})
		manage_Additional_Component_Exported_Flags(${component} "${TARGET_SUFFIX}" "" "" "${exp_defs}" "" "")

		target_include_directories(${component}${TARGET_SUFFIX} INTERFACE
			$<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_INCLUDE_DIRECTORIES>)

		target_compile_definitions(${component}${TARGET_SUFFIX} INTERFACE
			$<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_DEFINITIONS>)

		target_compile_options(${component}${TARGET_SUFFIX} INTERFACE
			$<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_OPTIONS>)

		target_link_libraries(${component}${TARGET_SUFFIX} INTERFACE ${dep_package}-${dep_component}${TARGET_SUFFIX})

	else()#the library do not export anything
		manage_Additional_Component_Exported_Flags(${component} "${TARGET_SUFFIX}" "" "" "${comp_exp_defs}" "" "")
		if(NOT ${PROJECT_NAME}_${component}_TYPE STREQUAL "SHARED")#static OR header lib always export private links
			target_link_libraries(${component}${TARGET_SUFFIX} INTERFACE  ${dep_package}-${dep_component}${TARGET_SUFFIX})
		endif()
	endif()
endif()	#else, it is an application or a module => runtime dependency declaration only
endfunction(bind_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |bind_Internal_Target| replace:: ``bind_Internal_Target``
#  .. _bind_Internal_Target:
#
#  bind_Internal_Target
#  --------------------
#
#   .. command:: bind_Internal_Target(component dep_component mode export comp_defs comp_exp_defs dep_defs)
#
#   Bind the targets of two components built in current package.
#
#     :component: the name of the component whose target has to be bound to another target.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode: the build mode for the targets.
#
#     :export: if TRUE then set component's target export dep_component's target.
#
#     :comp_defs: the preprocessor definitions defined in component implementation that conditionate the use of dep_component.
#
#     :comp_exp_defs: the preprocessor definitions defined in component interface that conditionate the use of dep_component.
#
#     :dep_defs: the preprocessor definitions used in dep_component interface that are defined by dep_component.
#
function(bind_Internal_Target component dep_component mode export comp_defs comp_exp_defs dep_defs)

get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
is_Built_Component(COMP_IS_BUILT ${PROJECT_NAME} ${component})
is_HeaderFree_Component(DEP_IS_HF ${PROJECT_NAME} ${dep_component})
if(COMP_IS_BUILT)# interface library cannot receive PRIVATE PROPERTIES
	#use definitions and links for building the target
	set(internal_defs ${comp_defs} ${comp_exp_defs} ${dep_defs})
	manage_Additional_Component_Internal_Flags(${component} "" "" "${TARGET_SUFFIX}" "" "" "${internal_defs}" "" "")

	if(NOT DEP_IS_HF)#the dependency may export some things, so we need to bind definitions
		target_link_libraries(${component}${TARGET_SUFFIX} PRIVATE ${dep_component}${TARGET_SUFFIX})

		target_include_directories(${component}${TARGET_SUFFIX} PRIVATE
			$<TARGET_PROPERTY:${dep_component}${TARGET_SUFFIX},INTERFACE_INCLUDE_DIRECTORIES>)

		target_compile_definitions(${component}${TARGET_SUFFIX} PRIVATE
			$<TARGET_PROPERTY:${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_DEFINITIONS>)

		target_compile_options(${component}${TARGET_SUFFIX} PRIVATE
			$<TARGET_PROPERTY:${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_OPTIONS>)
	endif()

		# set adequately language standard for component depending on the value of dep_component
		resolve_Standard_Before_Linking(${PROJECT_NAME} ${component} ${PROJECT_NAME} ${dep_component} ${mode} TRUE)
else() #for header lib do not set the build property to avoid troubles
		# set adequately language standard for component depending on the value of dep_component
		resolve_Standard_Before_Linking(${PROJECT_NAME} ${component} ${PROJECT_NAME} ${dep_component} ${mode} FALSE)
endif()


if(NOT DEP_IS_HF)#the required package component is a library with header it can export something
	if(export)
		set(internal_defs ${comp_exp_defs} ${dep_defs})
		manage_Additional_Component_Exported_Flags(${component} "${TARGET_SUFFIX}" "" "" "${internal_defs}" "" "")

		target_include_directories(${component}${TARGET_SUFFIX} INTERFACE
			$<TARGET_PROPERTY:${dep_component}${TARGET_SUFFIX},INTERFACE_INCLUDE_DIRECTORIES>)

		target_compile_definitions(${component}${TARGET_SUFFIX} INTERFACE
			$<TARGET_PROPERTY:${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_DEFINITIONS>)

		target_compile_options(${component}${TARGET_SUFFIX} INTERFACE
			$<TARGET_PROPERTY:${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_OPTIONS>)

		target_link_libraries(${component}${TARGET_SUFFIX} INTERFACE ${dep_component}${TARGET_SUFFIX})

	else()
		manage_Additional_Component_Exported_Flags(${component} "${TARGET_SUFFIX}" "" "" "${comp_exp_defs}" "" "")
		if(NOT ${PROJECT_NAME}_${component}_TYPE STREQUAL "SHARED")#static OR header lib always export links
			target_link_libraries(${component}${TARGET_SUFFIX} INTERFACE ${dep_component}${TARGET_SUFFIX})
		endif()
		#else non exported shared
	endif()

endif()	#else, it is an application or a module => runtime dependency declaration only
endfunction(bind_Internal_Target)

#.rst:
#
# .. ifmode:: internal
#
#  .. |bind_Imported_Target| replace:: ``bind_Imported_Target``
#  .. _bind_Imported_Target:
#
#  bind_Imported_Target
#  --------------------
#
#   .. command:: bind_Imported_Target(package component dep_package dep_component mode)
#
#   Bind two imported targets.
#
#     :package: the name of the package that contains the component whose target depends on another imported target.
#
#     :component: the name of the component whose target depends on another imported target.
#
#     :dep_package: the name of the package that contains the dependency.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode: the build mode for the targets.
#
function(bind_Imported_Target package component dep_package dep_component mode)
get_Mode_Variables(TARGET_SUFFIX VAR_SUFFIX ${mode})
export_Component(IS_EXPORTING ${package} ${component} ${dep_package} ${dep_component} ${mode})
is_HeaderFree_Component(DEP_IS_HF ${dep_package} ${dep_component})
if(NOT DEP_IS_HF)#the required package component is a library with header it can export something
	if(IS_EXPORTING)

		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY
			INTERFACE_INCLUDE_DIRECTORIES $<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_INCLUDE_DIRECTORIES>
		)
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY
			INTERFACE_COMPILE_DEFINITIONS $<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_DEFINITIONS>
		)
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY
			INTERFACE_COMPILE_OPTIONS $<TARGET_PROPERTY:${dep_package}-${dep_component}${TARGET_SUFFIX},INTERFACE_COMPILE_OPTIONS>
		)
		set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY
			INTERFACE_LINK_LIBRARIES ${dep_package}-${dep_component}${TARGET_SUFFIX}
		)
	else()
		if(NOT ${package}_${component}_TYPE STREQUAL "SHARED")#static OR header lib always export links
			set_property(TARGET ${package}-${component}${TARGET_SUFFIX} APPEND PROPERTY
				INTERFACE_LINK_LIBRARIES ${dep_package}-${dep_component}${TARGET_SUFFIX}
			)
		endif()
	endif()#exporting the linked libraries in any case

	# set adequately language standard for component depending on the value of dep_component
	resolve_Standard_Before_Linking(${package} ${component} ${dep_package} ${dep_component} ${mode} FALSE)

endif()	#else, it is an application or a module => runtime dependency declaration only (build recursion is stopped)
endfunction(bind_Imported_Target)


#.rst:
#
# .. ifmode:: internal
#
#  .. |fill_Component_Target_With_Dependency| replace:: ``fill_Component_Target_With_Dependency``
#  .. _fill_Component_Target_With_Dependency:
#
#  fill_Component_Target_With_Dependency
#  -------------------------------------
#
#   .. command:: fill_Component_Target_With_Dependency(component dep_package dep_component mode export comp_defs comp_exp_defs dep_defs)
#
#   Fill a component's target of the package currently built with information coming from another component (from same or another package). Subsidiary function that perform adeqaute actions depending on the package containing the dependency.
#
#     :component: the name of the component whose target depends on another component.
#
#     :dep_package: the name of the package that contains the dependency.
#
#     :dep_component: the name of the component that IS the dependency.
#
#     :mode: the build mode for the targets.
#
#     :export: if TRUE then set component's target export dep_component's target.
#
#     :comp_defs: the preprocessor definitions defined in component implementation that conditionate the use of dep_component.
#
#     :comp_exp_defs: the preprocessor definitions defined in component interface that conditionate the use of dep_component.
#
#     :dep_defs: the preprocessor definitions used in dep_component interface that are defined by dep_component.
#
function (fill_Component_Target_With_Dependency component dep_package dep_component mode export comp_defs comp_exp_defs dep_defs)
if(PROJECT_NAME STREQUAL ${dep_package})#target already created elsewhere since internal target
	bind_Internal_Target(${component} ${dep_component} ${mode} ${export} "${comp_defs}" "${comp_exp_defs}" "${dep_defs}")
else()# it is a dependency to another package
	create_Dependency_Target(${dep_package} ${dep_component} ${mode})
	bind_Target(${component} ${dep_package} ${dep_component} ${mode} ${export} "${comp_defs}" "${comp_exp_defs}" "${dep_defs}")
endif()
endfunction(fill_Component_Target_With_Dependency)
