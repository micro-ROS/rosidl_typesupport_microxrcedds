// Copyright 2016 Open Source Robotics Foundation, Inc.
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

#ifndef ROSIDL_TYPESUPPORT_MICRORTPS_C__BUFFER_UTILITY_H_
#define ROSIDL_TYPESUPPORT_MICRORTPS_C__BUFFER_UTILITY_H_


#include <stddef.h>


/**
 * @brief Reset temporat 
 * 
 * @param buffer 
 * @param buffer_size 
 */
void ResetBuffer(void* buffer, size_t buffer_size);


/**
 * @brief Bytes left in the desserialized buffer
 * 
 */
void* GetWritePointer(size_t* bytes_available);


/**
 * @brief 
 * 
 * @param used_bytes 
 */
void DecreaseAvailableBuffer(size_t used_bytes);


#endif  // ROSIDL_TYPESUPPORT_MICRORTPS_C__IDENTIFIER_H_