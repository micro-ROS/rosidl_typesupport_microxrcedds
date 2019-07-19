cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_microxrcedds_test_msg)

find_package(ament_cmake REQUIRED)

if(BUILD_TESTING)
  
  find_package(builtin_interfaces REQUIRED)
  find_package(rosidl_default_generators REQUIRED)

  set(msg_files
      "msg/UnboundedString.msg"
      "msg/Primitive.msg"
      )

  rosidl_generate_interfaces(${PROJECT_NAME}
      ${msg_files}
      DEPENDENCIES
        builtin_interfaces
      ADD_LINTER_TESTS
      )

  ament_export_dependencies(rosidl_default_runtime)

endif()

ament_package()
