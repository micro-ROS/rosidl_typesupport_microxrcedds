cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_microxrcedds_cpp_tests LANGUAGES CXX)

find_package(ament_cmake REQUIRED)

if(BUILD_TESTING)
    find_package(ament_lint_auto REQUIRED)
    ament_lint_auto_find_test_dependencies()

    find_package(rosidl_typesupport_microxrcedds_shared REQUIRED)
    find_package(rosidl_typesupport_microxrcedds_cpp REQUIRED)
    find_package(rosidl_typesupport_microxrcedds_test_msg REQUIRED)
    find_package(ament_cmake_gtest REQUIRED)

    set(TEST_NAME test_typesupport)
    ament_add_gtest(${TEST_NAME}
        src/test_typesupport.cpp
        )

    ament_target_dependencies(${TEST_NAME}
        rosidl_typesupport_microxrcedds_test_msg
        rosidl_typesupport_microxrcedds_cpp
        rosidl_typesupport_microxrcedds_shared
        )

    target_link_libraries(${TEST_NAME}
        microcdr
        )

    target_compile_options(${TEST_NAME}
        PRIVATE
            $<$<C_COMPILER_ID:GNU>:-Wall>
            $<$<C_COMPILER_ID:GNU>:-Wextra>
            $<$<C_COMPILER_ID:GNU>:-pedantic>
        )

    set_target_properties(${TEST_NAME} PROPERTIES
        CXX_STANDARD
            14
        CXX_STANDARD_REQUIRED
            YES
        )
endif()

ament_package()
