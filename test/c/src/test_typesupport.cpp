// Copyright 2019 Proyectos y Sistemas de Mantenimiento SL (eProsima).
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#include <gtest/gtest.h>


#include <rosidl_typesupport_microxrcedds_c/identifier.h>
#include <rosidl_typesupport_microxrcedds_c/message_type_support.h>

#include <rosidl_typesupport_microxrcedds_test_msg/msg/primitive.h>
#include \
  <rosidl_typesupport_microxrcedds_test_msg/msg/primitive__rosidl_typesupport_microxrcedds_c.h>


class TestTypeSupport : public ::testing::Test
{
protected:
  void SetUp()
  {
    rosidl_message_type_support =
      ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
      rosidl_typesupport_microxrcedds_c,
      rosidl_typesupport_microxrcedds_test_msg,
      msg,
      Primitive)();

    message_type_support_callbacks =
      (const message_type_support_callbacks_t *)rosidl_message_type_support->data;

    primitive_test.bool_test = 0x01;
    primitive_test.byte_test = 0x01;
    primitive_test.char_test = 0x01;
    primitive_test.float32_test = 100.001;
    primitive_test.double_test = 100.001;
    primitive_test.int8_test = 0x01;
    primitive_test.uint8_test = 0x01;
    primitive_test.int16_test = 0x0101;
    primitive_test.uint16_test = 0x0101;
    primitive_test.int32_test = 0x01010101;
    primitive_test.uint32_test = 0x01010101;
    primitive_test.int64_test = 0x0101010101010101;
    primitive_test.uint64_test = 0x0101010101010101;
    primitive_test.nested_test.unbounded_string1.data = const_cast<char *>("ABCDEF");
    primitive_test.nested_test.unbounded_string2.data = const_cast<char *>("TGHIJKLMNO");
    primitive_test.nested_test.unbounded_string3.data = const_cast<char *>("PQRSTVWX");
    primitive_test.nested_test.unbounded_string4.data = const_cast<char *>("TYZ0123456789");
  }

  void Compare(
    rosidl_typesupport_microxrcedds_test_msg__msg__Primitive & A,
    rosidl_typesupport_microxrcedds_test_msg__msg__Primitive & B)
  {
    EXPECT_EQ(A.bool_test, B.bool_test);
    EXPECT_EQ(A.byte_test, B.byte_test);
    EXPECT_EQ(A.char_test, B.char_test);
    EXPECT_EQ(A.float32_test, B.float32_test);
    EXPECT_EQ(A.double_test, B.double_test);
    EXPECT_EQ(A.int8_test, B.int8_test);
    EXPECT_EQ(A.uint8_test, B.uint8_test);
    EXPECT_EQ(A.int16_test, B.int16_test);
    EXPECT_EQ(A.uint16_test, B.uint16_test);
    EXPECT_EQ(A.int32_test, B.int32_test);
    EXPECT_EQ(A.uint32_test, B.uint32_test);
    EXPECT_EQ(A.int64_test, B.int64_test);
    EXPECT_EQ(A.uint64_test, B.uint64_test);

    EXPECT_EQ(A.nested_test.unbounded_string1.size, B.nested_test.unbounded_string1.size);
    EXPECT_EQ(
      strcmp(A.nested_test.unbounded_string1.data, B.nested_test.unbounded_string1.data), 0);

    EXPECT_EQ(A.nested_test.unbounded_string2.size, B.nested_test.unbounded_string2.size);
    EXPECT_EQ(
      strcmp(A.nested_test.unbounded_string2.data, B.nested_test.unbounded_string2.data), 0);

    EXPECT_EQ(A.nested_test.unbounded_string3.size, B.nested_test.unbounded_string3.size);
    EXPECT_EQ(
      strcmp(A.nested_test.unbounded_string3.data, B.nested_test.unbounded_string3.data), 0);

    EXPECT_EQ(A.nested_test.unbounded_string4.size, B.nested_test.unbounded_string4.size);
    EXPECT_EQ(
      strcmp(A.nested_test.unbounded_string4.data, B.nested_test.unbounded_string4.data), 0);
  }

  rosidl_typesupport_microxrcedds_test_msg__msg__Primitive primitive_test;
  const rosidl_message_type_support_t * rosidl_message_type_support;
  const message_type_support_callbacks_t * message_type_support_callbacks;
};

/*
   Testing subscription construction and destruction.
 */
TEST_F(TestTypeSupport, typesupport_identifier) {
  ASSERT_EQ(strcmp(rosidl_message_type_support->typesupport_identifier,
    ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__IDENTIFIER_VALUE), 0);
}


/*
   Testing subscription construction and destruction.
 */
TEST_F(TestTypeSupport, serialize_and_deserialize) {
  ucdrBuffer mb_writer;
  ucdrBuffer mb_reader;
  uint8_t mb_buffer[5000];
  ucdr_init_buffer(&mb_writer, mb_buffer, sizeof(mb_buffer));
  ucdr_init_buffer(&mb_reader, mb_buffer, sizeof(mb_buffer));

  ASSERT_EQ(message_type_support_callbacks->cdr_serialize(&primitive_test, &mb_writer), true);

  rosidl_typesupport_microxrcedds_test_msg__msg__Primitive primitive_test_out;

  char string1[100] = {0};
  primitive_test_out.nested_test.unbounded_string1.data = string1;
  primitive_test_out.nested_test.unbounded_string1.capacity = sizeof(string1);
  char string2[100] = {0};
  primitive_test_out.nested_test.unbounded_string2.data = string2;
  primitive_test_out.nested_test.unbounded_string2.capacity = sizeof(string2);
  char string3[100] = {0};
  primitive_test_out.nested_test.unbounded_string3.data = string3;
  primitive_test_out.nested_test.unbounded_string3.capacity = sizeof(string3);
  char string4[100] = {0};
  primitive_test_out.nested_test.unbounded_string4.data = string4;
  primitive_test_out.nested_test.unbounded_string4.capacity = sizeof(string4);

  ASSERT_EQ(message_type_support_callbacks->cdr_deserialize(&mb_reader, &primitive_test_out), true);

  Compare(primitive_test, primitive_test_out);
}
