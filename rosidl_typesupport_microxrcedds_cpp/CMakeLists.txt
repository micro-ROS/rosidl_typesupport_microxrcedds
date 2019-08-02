cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_microxrcedds_cpp LANGUAGES CXX)

find_package(ament_cmake REQUIRED)
find_package(microcdr REQUIRED)
find_package(ament_cmake_python REQUIRED)

ament_export_dependencies(microcdr)
ament_export_dependencies(rosidl_cmake)
ament_export_dependencies(rosidl_generator_cpp)

ament_export_include_directories(include)

ament_python_install_package(${PROJECT_NAME})

add_library(${PROJECT_NAME}
  src/identifier.cpp
  )

target_compile_definitions(${PROJECT_NAME}
  PRIVATE
    $<$<PLATFORM_ID:Windows>:"ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_BUILDING_DLL">
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
  CXX_STANDARD
    14
  CXX_STANDARD_REQUIRED
    YES
  )

ament_export_libraries(${PROJECT_NAME})

ament_index_register_resource("rosidl_typesupport_cpp")

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package(
  CONFIG_EXTRAS "rosidl_typesupport_microxrcedds_cpp-extras.cmake.in"
  )

install(
  PROGRAMS
    bin/rosidl_typesupport_microxrcedds_cpp
  DESTINATION
    lib/rosidl_typesupport_microxrcedds_cpp
  )

install(
  DIRECTORY
    cmake
    resource
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
