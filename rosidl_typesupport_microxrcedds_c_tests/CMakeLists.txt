cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_microxrcedds_c_tests)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()


if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  # we dont use add_compile_options with pedantic in message packages
  # because the Python C extensions dont comply with it
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
endif()


find_package(ament_cmake REQUIRED)


if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

  
  find_package(builtin_interfaces REQUIRED)
  find_package(rosidl_default_generators REQUIRED)
  find_package(ament_cmake_gtest REQUIRED)

  find_package(microxrcedds_cmake_module REQUIRED)
  find_package(MicroXRCEDDS REQUIRED MODULE)


  set(msg_files
      "msg/TestMsg1.msg"
      "msg/TestMsg2.msg"
  )

  rosidl_generate_interfaces(${PROJECT_NAME}
                             ${msg_files}
                             DEPENDENCIES builtin_interfaces
                             ADD_LINTER_TESTS
  )

  



  # Node tests
  set(TEST_NAME "test_typpesupport")
  set(TEST_FILES "src/test_typpesupport.cpp")
  ament_add_gtest(
    ${TEST_NAME} 
    ${TEST_FILES}
  )
  if(TARGET ${TEST_NAME})
    ament_target_dependencies(${TEST_NAME}  
                              ${PROJECT_NAME}
                              rosidl_typesupport_microxrcedds_c
                              microcdr
    )
    target_link_libraries(${TEST_NAME}
                          microcdr
    )
  endif()


endif()


ament_package()
