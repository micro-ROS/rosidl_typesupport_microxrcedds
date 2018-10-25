cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_microxrcedds_c_tests)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()


if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
endif()


find_package(ament_cmake REQUIRED)


if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

  find_package(rosidl_typesupport_microxrcedds_test_msg REQUIRED)
  find_package(ament_cmake_gtest REQUIRED)

  # Node tests
  set(TEST_NAME "test_typpesupport")
  set(TEST_FILES "src/test_typpesupport.cpp")
  ament_add_gtest(
    ${TEST_NAME}
    ${TEST_FILES}
  )
  if(TARGET ${TEST_NAME})
    ament_target_dependencies(
      ${TEST_NAME}
      rosidl_typesupport_microxrcedds_test_msg
      rosidl_typesupport_microxrcedds_c
      rosidl_typesupport_microxrcedds_shared
      microcdr
    )

    target_link_libraries(${TEST_NAME}
                          microcdr
    )
  endif()


endif()



ament_package()
