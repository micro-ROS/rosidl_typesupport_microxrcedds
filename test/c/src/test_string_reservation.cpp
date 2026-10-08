// Copyright 2026 Proyectos y Sistemas de Mantenimiento SL (eProsima).
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

#include <string>

#include "rosidl_runtime_c/message_type_support_struct.h"
#include "rosidl_runtime_c/primitives_sequence_functions.h"
#include "rosidl_runtime_c/string_functions.h"

// Generic MicroXRCE-DDS typesupport includes
#include <rosidl_typesupport_microxrcedds_c/identifier.h>
#include <rosidl_typesupport_microxrcedds_c/message_type_support.h>

// Specific defined types used during testing
#include "rosidl_typesupport_microxrcedds_test_msg/msg/not_enought_memory_test.h"
#include "rosidl_typesupport_microxrcedds_test_msg/msg/sequence.h"
#include "rosidl_typesupport_microxrcedds_test_msg/msg/unbounded_string.h"

/*
 * Received strings whose buffer is too small, with and without
 * ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION.
 */
static const size_t string_reservation = ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION;

static const message_type_support_callbacks_t * get_callbacks(
    const rosidl_message_type_support_t * type_support)
{
  const rosidl_message_type_support_t * handle = get_message_typesupport_handle(
    type_support, ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__IDENTIFIER_VALUE);
  return static_cast<const message_type_support_callbacks_t *>(handle->data);
}

static void assign_string(
    rosidl_runtime_c__String & str,
    const std::string & value)
{
  ASSERT_TRUE(rosidl_runtime_c__String__assignn(&str, value.c_str(), value.size()));
}

static std::string to_string(
    const rosidl_runtime_c__String & str)
{
  return std::string(str.data, str.size);
}

TEST(StringReservation, string_limit)
{
  if (string_reservation > 0 && string_reservation <= std::string("param1").size())
  {
    GTEST_SKIP() << "The reservation is too small for this test";
  }

  // Longest string that fits in the reservation, and the shortest one that does not
  const std::string longest_string = (string_reservation > 0) ?
    std::string(string_reservation - 1, 'a') : "";
  const std::string too_long_string((string_reservation > 0) ? string_reservation : 50, 'b');

  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString msg;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString__init(&msg));
  assign_string(msg.unbounded_string1, "param1");
  assign_string(msg.unbounded_string2, longest_string);
  assign_string(msg.unbounded_string3, "");
  assign_string(msg.unbounded_string4, too_long_string);

  const message_type_support_callbacks_t * callbacks = get_callbacks(
    ROSIDL_GET_MSG_TYPE_SUPPORT(rosidl_typesupport_microxrcedds_test_msg, msg, UnboundedString));

  uint8_t buffer[500];
  ucdrBuffer writer;
  ucdr_init_buffer(&writer, buffer, sizeof(buffer));
  ASSERT_TRUE(callbacks->cdr_serialize(&msg, &writer));

  // Strings left by rosidl_runtime_c__String__init(): capacity 1
  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString out;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString__init(&out));

  ucdrBuffer reader;
  ucdr_init_buffer(&reader, buffer, ucdr_buffer_length(&writer));

  // The last string never fits, so the message is always rejected
  EXPECT_FALSE(callbacks->cdr_deserialize(&reader, &out));

  if (string_reservation > 0)
  {
    EXPECT_EQ(to_string(out.unbounded_string1), "param1");
    EXPECT_EQ(out.unbounded_string1.capacity, string_reservation);
    EXPECT_EQ(to_string(out.unbounded_string2), longest_string);
    EXPECT_EQ(out.unbounded_string2.capacity, string_reservation);
  }
  else
  {
    EXPECT_EQ(out.unbounded_string1.size, 0u);
    EXPECT_EQ(out.unbounded_string1.capacity, 1u);
  }

  // An empty string fits without reserving memory
  EXPECT_EQ(out.unbounded_string3.size, 0u);
  EXPECT_EQ(out.unbounded_string3.capacity, 1u);

  // A string longer than the reservation is skipped and its buffer is not reallocated
  EXPECT_EQ(out.unbounded_string4.size, 0u);
  EXPECT_EQ(out.unbounded_string4.capacity, 1u);

  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString__fini(&msg);
  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString__fini(&out);
}

TEST(StringReservation, string_sequence)
{
  rosidl_typesupport_microxrcedds_test_msg__msg__Sequence msg;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__Sequence__init(&msg));
  ASSERT_TRUE(rosidl_runtime_c__String__Sequence__init(&msg.sequence_string_test, 2));
  assign_string(msg.sequence_string_test.data[0], "param1");
  assign_string(msg.sequence_string_test.data[1], "param2");

  const message_type_support_callbacks_t * callbacks = get_callbacks(
    ROSIDL_GET_MSG_TYPE_SUPPORT(rosidl_typesupport_microxrcedds_test_msg, msg, Sequence));

  uint8_t buffer[500];
  ucdrBuffer writer;
  ucdr_init_buffer(&writer, buffer, sizeof(buffer));
  ASSERT_TRUE(callbacks->cdr_serialize(&msg, &writer));

  // Like rclc parameter server requests: a sequence of strings left by rosidl __init
  rosidl_typesupport_microxrcedds_test_msg__msg__Sequence out;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__Sequence__init(&out));
  ASSERT_TRUE(rosidl_runtime_c__String__Sequence__init(&out.sequence_string_test, 2));

  ucdrBuffer reader;
  ucdr_init_buffer(&reader, buffer, ucdr_buffer_length(&writer));

  if (string_reservation > 0)
  {
    EXPECT_TRUE(callbacks->cdr_deserialize(&reader, &out));
    ASSERT_EQ(out.sequence_string_test.size, 2u);
    EXPECT_EQ(to_string(out.sequence_string_test.data[0]), "param1");
    EXPECT_EQ(to_string(out.sequence_string_test.data[1]), "param2");
    EXPECT_EQ(out.sequence_string_test.data[0].capacity, string_reservation);
    EXPECT_EQ(out.sequence_string_test.data[1].capacity, string_reservation);
  }
  else
  {
    EXPECT_FALSE(callbacks->cdr_deserialize(&reader, &out));
    EXPECT_EQ(out.sequence_string_test.data[0].size, 0u);
    EXPECT_EQ(out.sequence_string_test.data[0].capacity, 1u);
  }

  rosidl_typesupport_microxrcedds_test_msg__msg__Sequence__fini(&msg);
  rosidl_typesupport_microxrcedds_test_msg__msg__Sequence__fini(&out);
}

TEST(StringReservation, user_buffer_is_not_reallocated)
{
  const std::string too_long_string(30, 'c');

  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString msg;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString__init(&msg));
  assign_string(msg.unbounded_string1, too_long_string);
  assign_string(msg.unbounded_string2, "x");
  assign_string(msg.unbounded_string3, "y");
  assign_string(msg.unbounded_string4, "z");

  const message_type_support_callbacks_t * callbacks = get_callbacks(
    ROSIDL_GET_MSG_TYPE_SUPPORT(rosidl_typesupport_microxrcedds_test_msg, msg, UnboundedString));

  uint8_t buffer[500];
  ucdrBuffer writer;
  ucdr_init_buffer(&writer, buffer, sizeof(buffer));
  ASSERT_TRUE(callbacks->cdr_serialize(&msg, &writer));

  // Static buffers, as micro-ROS applications usually provide them
  char string1[20] = {0};
  char string2[20] = {0};
  char string3[20] = {0};
  char string4[20] = {0};
  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString out = {};
  out.unbounded_string1 = {string1, 0, sizeof(string1)};
  out.unbounded_string2 = {string2, 0, sizeof(string2)};
  out.unbounded_string3 = {string3, 0, sizeof(string3)};
  out.unbounded_string4 = {string4, 0, sizeof(string4)};

  ucdrBuffer reader;
  ucdr_init_buffer(&reader, buffer, ucdr_buffer_length(&writer));
  EXPECT_TRUE(callbacks->cdr_deserialize(&reader, &out));

  // Too long: skipped, the user buffer is kept
  EXPECT_EQ(out.unbounded_string1.data, string1);
  EXPECT_EQ(out.unbounded_string1.capacity, sizeof(string1));
  EXPECT_EQ(out.unbounded_string1.size, 0u);

  // The following strings are still read correctly
  EXPECT_EQ(to_string(out.unbounded_string2), "x");
  EXPECT_EQ(to_string(out.unbounded_string3), "y");
  EXPECT_EQ(to_string(out.unbounded_string4), "z");

  rosidl_typesupport_microxrcedds_test_msg__msg__UnboundedString__fini(&msg);
}

TEST(StringReservation, alignment_after_string)
{
  rosidl_typesupport_microxrcedds_test_msg__msg__NotEnoughtMemoryTest msg;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__NotEnoughtMemoryTest__init(&msg));
  msg.initial_byte = 0x42;
  assign_string(msg.string, "ABCDEF");
  ASSERT_TRUE(rosidl_runtime_c__int64__Sequence__init(&msg.int64_sequence, 3));
  for (size_t i = 0; i < msg.int64_sequence.size; i++)
  {
    msg.int64_sequence.data[i] = static_cast<int64_t>(1000 + i);
  }
  for (size_t i = 0; i < 10; i++)
  {
    msg.int16_array[i] = static_cast<int16_t>(i);
  }
  msg.end_byte = 0x24;

  const message_type_support_callbacks_t * callbacks = get_callbacks(
    ROSIDL_GET_MSG_TYPE_SUPPORT(rosidl_typesupport_microxrcedds_test_msg, msg, NotEnoughtMemoryTest));

  uint8_t buffer[500];
  ucdrBuffer writer;
  ucdr_init_buffer(&writer, buffer, sizeof(buffer));
  ASSERT_TRUE(callbacks->cdr_serialize(&msg, &writer));

  // The string is either reserved and read or skipped: the following members must be correct
  rosidl_typesupport_microxrcedds_test_msg__msg__NotEnoughtMemoryTest out;
  ASSERT_TRUE(rosidl_typesupport_microxrcedds_test_msg__msg__NotEnoughtMemoryTest__init(&out));
  ASSERT_TRUE(rosidl_runtime_c__int64__Sequence__init(&out.int64_sequence, 3));

  ucdrBuffer reader;
  ucdr_init_buffer(&reader, buffer, ucdr_buffer_length(&writer));
  EXPECT_TRUE(callbacks->cdr_deserialize(&reader, &out));

  if (string_reservation > 0)
  {
    EXPECT_EQ(to_string(out.string), "ABCDEF");
  }
  else
  {
    EXPECT_EQ(out.string.size, 0u);
  }

  EXPECT_EQ(out.initial_byte, msg.initial_byte);
  ASSERT_EQ(out.int64_sequence.size, msg.int64_sequence.size);
  for (size_t i = 0; i < msg.int64_sequence.size; i++)
  {
    EXPECT_EQ(out.int64_sequence.data[i], msg.int64_sequence.data[i]);
  }
  for (size_t i = 0; i < 10; i++)
  {
    EXPECT_EQ(out.int16_array[i], msg.int16_array[i]);
  }
  EXPECT_EQ(out.end_byte, msg.end_byte);

  rosidl_typesupport_microxrcedds_test_msg__msg__NotEnoughtMemoryTest__fini(&msg);
  rosidl_typesupport_microxrcedds_test_msg__msg__NotEnoughtMemoryTest__fini(&out);
}
