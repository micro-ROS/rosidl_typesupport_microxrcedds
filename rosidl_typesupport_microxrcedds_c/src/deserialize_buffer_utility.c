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

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <rosidl_typesupport_microxrcedds_c/deserialize_buffer_utility.h>

void rosidl_typesupport_microxrcedds_c__align_pointer(
  uint8_t ** pointer_to_align,
  size_t * mem_size)
{
  size_t word_size = sizeof(uint64_t);
  uint8_t * aling_pointer = (uint8_t *)((((size_t)(*pointer_to_align)) / word_size) * word_size);

  if (*pointer_to_align > aling_pointer) {
    aling_pointer += word_size;
  }

  if ((size_t)(aling_pointer - *pointer_to_align) >= *mem_size) {
    *mem_size = 0;
  } else {
    *mem_size -= (size_t)(aling_pointer - *pointer_to_align);
  }

  *pointer_to_align = aling_pointer;
}
