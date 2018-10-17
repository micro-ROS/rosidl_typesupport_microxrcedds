# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()


find_package(ament_cmake_gtest REQUIRED)
find_package(ament_cmake REQUIRED)


# Node tests
set(TEST_NAME "test_typpesupport")
set(TEST_FILES "test_typpesupport.cpp")
ament_add_gtest(
  ${TEST_NAME} 
  ${TEST_FILES}
)
if(TARGET ${TEST_NAME})
  target_link_libraries(
    ${TEST_NAME} 
    ${PROJECT_NAME}
  )
  target_include_directories(
    ${TEST_NAME}
    ${PROJECT_SOURCE_DIR}
  )
endif()
