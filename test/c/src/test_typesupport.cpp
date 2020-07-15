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

#include "rosidl_runtime_c/message_type_support_struct.h"

// Generic MicroXRCE-DDS typesupport includes
#include <rosidl_typesupport_microxrcedds_c/identifier.h>
#include <rosidl_typesupport_microxrcedds_c/message_type_support.h>

// Specific defined types used during testing
#include "rosidl_typesupport_microxrcedds_test_msg/msg/primitive.h"
#include "rosidl_typesupport_microxrcedds_test_msg/msg/sequence.h"
#include "rosidl_runtime_c/string_functions.h"

/*
 * @brief TestTypeSupport class, used to automate typesupport testing for a specific type.
 */
template <typename T>
class TestTypeSupport : public ::testing::Test
{
public:
  /*
   * @brief Default constructor.
   */
  TestTypeSupport() = default;

  /*
   * @brief Lvalue copy constructor (deleted).
   * @param[in] other Test to be copied.
   */
  TestTypeSupport(
      const TestTypeSupport & other) = delete;

  /*
   * @brief Rvalue copy constructor (deleted).
   * @param[in] other Test to be copied.
   */
  TestTypeSupport(
      TestTypeSupport && other) = delete;

  /*
   * @brief Setup function.
   * @param[in] init_test_type      Initialized rvalue instance of the ROS 2 type to be tested.
   * @param[in] compare_func_handle Function used for comparing two instances of T type.
   */
  void setup(
      const rosidl_message_type_support_t * rosidl_msg_type_support,
      T && init_test_type,
      std::function <void (const T &, const T &)> & compare_func_handle)
  {
    rosidl_message_type_support_ = get_message_typesupport_handle(
      rosidl_msg_type_support, ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__IDENTIFIER_VALUE);

    message_type_support_callbacks_ = static_cast<const message_type_support_callbacks_t *>(
      rosidl_message_type_support_->data);

    tested_type_ = std::move(init_test_type);
    compare_func_handle_ = &compare_func_handle;
  }

  /*
   * @brief Checks for correctness of the retrieved typesupport's identifier.
   */
  void check_identifier()
  {
    ASSERT_EQ(strcmp(rosidl_message_type_support_->typesupport_identifier,
      ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__IDENTIFIER_VALUE), 0);
  }

    /*
   * @brief Tests serialization and deserialization of a T type message,
   *        and compares the original instance and the deserialized one
   *        in terms of equalness.
   * @param deserialize_instance Instance of the tested type, T, initialized and prepared
   *        to received the deserialized data.
   */
  void test_serialize_deserialize(
      T & deserialize_instance)
  {
    ucdrBuffer mb_writer;
    ucdrBuffer mb_reader;

    uint8_t mb_buffer[5000];
    ucdr_init_buffer(&mb_writer, mb_buffer, sizeof(mb_buffer));
    ucdr_init_buffer(&mb_reader, mb_buffer, sizeof(mb_buffer));

    ASSERT_TRUE(message_type_support_callbacks_->cdr_serialize(&tested_type_, &mb_writer));

    ASSERT_TRUE(message_type_support_callbacks_->cdr_deserialize(&mb_reader, &deserialize_instance));

    compare(tested_type_, deserialize_instance);
  }

protected:
  /*
   * @brief Compare two given instances of the same type (T), in terms of equalness.
   * @param[in] A First instance to be compared.
   * @param[in] B Second instance to be compared.
   */
  void compare(
      const T & A,
      const T & B)
  {
    (*compare_func_handle_)(A, B);
  }

  T tested_type_;
  const rosidl_message_type_support_t * rosidl_message_type_support_;
  const message_type_support_callbacks_t * message_type_support_callbacks_;
  std::function<void (const T &, const T &)> * compare_func_handle_;
};

/******************************************************************************
                      Serialize/deserialize test suites.
 *****************************************************************************/

/*
 * @brief Primitive ROS 2 types serialization and deserialization tests.
 */
template <typename T>
class PrimitivesTestTypeSupport : public TestTypeSupport<T> {};

TYPED_TEST_CASE(PrimitivesTestTypeSupport,
  testing::Types<rosidl_typesupport_microxrcedds_test_msg__msg__Primitive>);
TYPED_TEST(PrimitivesTestTypeSupport, serialize_primitive_types)
{
  std::function<void (
      const rosidl_typesupport_microxrcedds_test_msg__msg__Primitive &,
      const rosidl_typesupport_microxrcedds_test_msg__msg__Primitive &)> compare_primitives ([](
        const rosidl_typesupport_microxrcedds_test_msg__msg__Primitive & A,
        const rosidl_typesupport_microxrcedds_test_msg__msg__Primitive & B) -> void
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
    EXPECT_EQ(strcmp(A.nested_test.unbounded_string1.data, B.nested_test.unbounded_string1.data), 0);

    EXPECT_EQ(A.nested_test.unbounded_string2.size, B.nested_test.unbounded_string2.size);
    EXPECT_EQ(strcmp(A.nested_test.unbounded_string2.data, B.nested_test.unbounded_string2.data), 0);

    EXPECT_EQ(A.nested_test.unbounded_string3.size, B.nested_test.unbounded_string3.size);
    EXPECT_EQ(strcmp(A.nested_test.unbounded_string3.data, B.nested_test.unbounded_string3.data), 0);

    EXPECT_EQ(A.nested_test.unbounded_string4.size, B.nested_test.unbounded_string4.size);
    EXPECT_EQ(strcmp(A.nested_test.unbounded_string4.data, B.nested_test.unbounded_string4.data), 0);
  });

  // Initialize data to be serialized and deserialized
  rosidl_typesupport_microxrcedds_test_msg__msg__Primitive init_primitive;
  init_primitive.bool_test = 0x01;
  init_primitive.byte_test = 0x01;
  init_primitive.char_test = 0x01;
  init_primitive.float32_test = 100.001;
  init_primitive.double_test = 100.001;
  init_primitive.int8_test = 0x01;
  init_primitive.uint8_test = 0x01;
  init_primitive.int16_test = 0x0101;
  init_primitive.uint16_test = 0x0101;
  init_primitive.int32_test = 0x01010101;
  init_primitive.uint32_test = 0x01010101;
  init_primitive.int64_test = 0x0101010101010101;
  init_primitive.uint64_test = 0x0101010101010101;
  init_primitive.nested_test.unbounded_string1.data = const_cast<char *>("ABCDEF");
  init_primitive.nested_test.unbounded_string2.data = const_cast<char *>("TGHIJKLMNO");
  init_primitive.nested_test.unbounded_string3.data = const_cast<char *>("PQRSTVWX");
  init_primitive.nested_test.unbounded_string4.data = const_cast<char *>("TYZ0123456789");

  // Prepare deserialization output instance
  rosidl_typesupport_microxrcedds_test_msg__msg__Primitive out_deserialized;
  char string1[100] = {0};
  out_deserialized.nested_test.unbounded_string1.data = string1;
  out_deserialized.nested_test.unbounded_string1.capacity = sizeof(string1);
  char string2[100] = {0};
  out_deserialized.nested_test.unbounded_string2.data = string2;
  out_deserialized.nested_test.unbounded_string2.capacity = sizeof(string2);
  char string3[100] = {0};
  out_deserialized.nested_test.unbounded_string3.data = string3;
  out_deserialized.nested_test.unbounded_string3.capacity = sizeof(string3);
  char string4[100] = {0};
  out_deserialized.nested_test.unbounded_string4.data = string4;
  out_deserialized.nested_test.unbounded_string4.capacity = sizeof(string4);

  const rosidl_message_type_support_t * primitive_msg_type_support =
    ROSIDL_GET_MSG_TYPE_SUPPORT(rosidl_typesupport_microxrcedds_test_msg, msg, Primitive);
  EXPECT_NE(primitive_msg_type_support, nullptr);

  this->setup(primitive_msg_type_support, std::move(init_primitive), compare_primitives);
  this->check_identifier();
  this->test_serialize_deserialize(out_deserialized);
}

/*
 * @brief Sequence ROS 2 types serialization and deserialization tests.
 */
template <typename T>
class SequencesTestTypeSupport : public TestTypeSupport<T> {};

TYPED_TEST_CASE(SequencesTestTypeSupport,
  testing::Types<rosidl_typesupport_microxrcedds_test_msg__msg__Sequence>);
TYPED_TEST(SequencesTestTypeSupport, serialize_sequence_types)
{
  std::function<void (
      const rosidl_typesupport_microxrcedds_test_msg__msg__Sequence &,
      const rosidl_typesupport_microxrcedds_test_msg__msg__Sequence &)> compare_sequences ([](
          const rosidl_typesupport_microxrcedds_test_msg__msg__Sequence & A,
          const rosidl_typesupport_microxrcedds_test_msg__msg__Sequence & B) -> void
  {
    EXPECT_EQ(A.sequence_string_test.size, B.sequence_string_test.size);

    for (size_t i = 0; i < A.sequence_string_test.size; ++i)
    {
      EXPECT_EQ(A.sequence_string_test.data[i].size, B.sequence_string_test.data[i].size);
      EXPECT_EQ(strcmp(A.sequence_string_test.data[i].data, B.sequence_string_test.data[i].data), 0);
    }
  });

  rosidl_typesupport_microxrcedds_test_msg__msg__Sequence init_sequence;
  ASSERT_TRUE(rosidl_runtime_c__String__Sequence__init(
    &init_sequence.sequence_string_test, 4));

  // Initialize data to be serialized and deserialized
  init_sequence.sequence_string_test.data[0].data = const_cast<char *>("This");
  init_sequence.sequence_string_test.data[0].size =
    strlen(init_sequence.sequence_string_test.data[0].data);
  init_sequence.sequence_string_test.data[1].data = const_cast<char *>("is");
  init_sequence.sequence_string_test.data[1].size =
    strlen(init_sequence.sequence_string_test.data[1].data);
  init_sequence.sequence_string_test.data[2].data = const_cast<char *>("a");
  init_sequence.sequence_string_test.data[2].size =
    strlen(init_sequence.sequence_string_test.data[2].data);
  init_sequence.sequence_string_test.data[3].data = const_cast<char *>("test");
  init_sequence.sequence_string_test.data[3].size =
    strlen(init_sequence.sequence_string_test.data[3].data);

  // Prepare deserialization output instance
  rosidl_typesupport_microxrcedds_test_msg__msg__Sequence out_deserialized;
  ASSERT_TRUE(rosidl_runtime_c__String__Sequence__init(
    &out_deserialized.sequence_string_test, 4));
  char data_0[10] = {0};
  out_deserialized.sequence_string_test.data[0].data = data_0;
  out_deserialized.sequence_string_test.data[0].capacity = sizeof(data_0);
  char data_1[10] = {0};
  out_deserialized.sequence_string_test.data[1].data = data_1;
  out_deserialized.sequence_string_test.data[1].capacity = sizeof(data_1);
  char data_2[10] = {0};
  out_deserialized.sequence_string_test.data[2].data = data_2;
  out_deserialized.sequence_string_test.data[2].capacity = sizeof(data_2);
  char data_3[10] = {0};
  out_deserialized.sequence_string_test.data[3].data = data_3;
  out_deserialized.sequence_string_test.data[3].capacity = sizeof(data_3);

  const rosidl_message_type_support_t * sequence_msg_type_support =
    ROSIDL_GET_MSG_TYPE_SUPPORT(rosidl_typesupport_microxrcedds_test_msg, msg, Sequence);
  EXPECT_NE(sequence_msg_type_support, nullptr);

  this->setup(sequence_msg_type_support, std::move(init_sequence), compare_sequences);
  this->check_identifier();
  this->test_serialize_deserialize(out_deserialized);
}