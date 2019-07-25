# Copyright 2019 Proyectos y Sistemas de Mantenimiento SL (eProsima).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_microxrcedds_c LANGUAGES C)

set(microxrcedds_STATIC_DISABLE $ENV{microxrcedds_STATIC_DISABLE}
  CACHE BOOL "If Micro XRCE-DDS Static should be disabled.")

find_package(ament_cmake REQUIRED)

find_package(rosidl_typesupport_microxrcedds_shared REQUIRED CONFIG)
find_package(microxrcedds_cmake_module REQUIRED)
find_package(MicroXRCEDDS REQUIRED MODULE)

find_package(ament_cmake_python REQUIRED)

ament_export_dependencies(rosidl_typesupport_microxrcedds_shared)
ament_export_dependencies(rosidl_cmake)
ament_export_dependencies(rosidl_generator_c)
ament_export_dependencies(microcdr)

ament_export_include_directories(include)

ament_python_install_package(${PROJECT_NAME})

add_library(${PROJECT_NAME} src/identifier.c src/deserialize_buffer_utility.c)

ament_target_dependencies(${PROJECT_NAME}
    rosidl_typesupport_microxrcedds_shared
    )

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        $<$<PLATFORM_ID:Windows>:"ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_BUILDING_DLL">
    )

target_compile_options(${PROJECT_NAME}
    PRIVATE
        $<$<C_COMPILER_ID:GNU>:-Wall>
        $<$<C_COMPILER_ID:GNU>:-Wextra>
        $<$<C_COMPILER_ID:GNU>:-Wpedantic>
    )

target_include_directories(${PROJECT_NAME}
    PUBLIC
        include
    )

set_target_properties(${PROJECT_NAME} PROPERTIES
    C_STANDARD
        99
    C_STANDARD_REQUIRED
        YES
    )

ament_export_libraries(${PROJECT_NAME})

ament_index_register_resource("rosidl_typesupport_c")

if(BUILD_TESTING)
    find_package(ament_lint_auto REQUIRED)
    ament_lint_auto_find_test_dependencies()
endif()

ament_package(
    CONFIG_EXTRAS "rosidl_typesupport_microxrcedds_c-extras.cmake.in"
    )

install(
    PROGRAMS
        bin/rosidl_typesupport_microxrcedds_c
    DESTINATION
        lib/rosidl_typesupport_microxrcedds_c
    )

install(
    DIRECTORY
        cmake resource
    DESTINATION
        share/${PROJECT_NAME}
    )

install(
    DIRECTORY
        include/
    DESTINATION
        include
    )

install(
    TARGETS
        ${PROJECT_NAME}
    ARCHIVE DESTINATION
        lib
    LIBRARY DESTINATION
        lib
    RUNTIME DESTINATION
        bin
    )
