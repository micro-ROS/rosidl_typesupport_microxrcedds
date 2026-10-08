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

#ifndef ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__MESSAGE_TYPE_SUPPORT_H_
#define ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__MESSAGE_TYPE_SUPPORT_H_

#include "rosidl_runtime_c/message_type_support_struct.h"
#include "rosidl_runtime_c/string.h"

#include <rcutils/allocator.h>
#include <ucdr/microcdr.h>

// Bytes (null terminator included) reserved for a received string whose buffer is still in the
// state left by rosidl_runtime_c__String__init() (capacity 1)
#ifndef ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION
#define ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION 50
#endif

typedef struct message_type_support_callbacks_t
{
  const char * message_namespace_;
  const char * message_name_;

  // Function for message serialization
  bool (* cdr_serialize)(
    const void * untyped_ros_message,
    ucdrBuffer * cdr);

  // Function for message deserialization
  bool (* cdr_deserialize)(
    ucdrBuffer * cdr,
    void * untyped_ros_message);

  // Function to get size of data
  uint32_t (* get_serialized_size)(
    const void *);

  // Function to get size of data with initial alignment
  size_t (* get_serialized_size_with_initial_alignment)(
    const void *,
    size_t);

  // Function for type support initialization
  size_t (* max_serialized_size)();

} message_type_support_callbacks_t;

/**
 * Deserializes a string into the memory already owned by `str`.
 *
 * If the received string does not fit, it is skipped, `str` is left empty and false is
 * returned, so the message is rejected.
 *
 * If `str` is still in the state left by rosidl_runtime_c__String__init() (capacity 1), its
 * buffer is reallocated once with the rcutils default allocator to
 * ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION bytes.
 * Buffers provided by the user always have a larger capacity, so they are never reallocated.
 */
static inline bool rosidl_typesupport_microxrcedds_c__deserialize_string(
  ucdrBuffer * cdr,
  rosidl_runtime_c__String * str)
{
  const size_t capacity = str->capacity;
  uint32_t length = 0;  // CDR length, null terminator included

  // When the string does not fit, micro-CDR only consumes its length and sets the error flag
  bool rv = ucdr_deserialize_sequence_char(cdr, str->data, capacity, &length);

  if (!rv && length > capacity && 1 == capacity &&
    length <= ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION)
  {
    rcutils_allocator_t allocator = rcutils_get_default_allocator();
    char * data = (char *)allocator.reallocate(
      str->data, ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION, allocator.state);
    if (NULL != data) {
      str->data = data;
      str->capacity = ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_STRING_RESERVATION;
      cdr->error = false;
      rv = ucdr_deserialize_array_char(cdr, str->data, length);
    }
  }

  if (rv) {
    str->size = (length == 0) ? 0 : length - 1;
  } else if (length > str->capacity) {
    // Skip the string, keeping the buffer aligned for the next member
    cdr->error = false;
    cdr->last_data_size = 1;
    str->size = 0;
    ucdr_align_to(cdr, sizeof(char));
    ucdr_advance_buffer(cdr, length);
  }

  return rv;
}

#endif  // ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__MESSAGE_TYPE_SUPPORT_H_
