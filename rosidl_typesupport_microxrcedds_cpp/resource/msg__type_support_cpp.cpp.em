// generated from rosidl_typesupport_microxrcedds_cpp/resource/msg__type_support.cpp.em
// generated code does not contain a copyright notice

@#######################################################################
@# EmPy template for generating <msg>__type_support.cpp files
@#
@# Context:
@#  - spec (rosidl_parser.MessageSpecification)
@#    Parsed specification of the .msg file
@#  - subfolder (string)
@#    The subfolder / subnamespace of the message
@#    Either 'msg' or 'srv'
@#  - get_header_filename_from_msg_name (function)
@#######################################################################
@
#include "@(spec.base_type.pkg_name)/@(subfolder)/@(get_header_filename_from_msg_name(spec.base_type.type))__rosidl_typesupport_microxrcedds_cpp.hpp"

#include <limits>
#include <stdexcept>
#include <string>

#include "rosidl_typesupport_cpp/message_type_support.hpp"

#include "rosidl_typesupport_microxrcedds_cpp/identifier.hpp"
#include "rosidl_typesupport_microxrcedds_cpp/message_type_support.h"
#include "rosidl_typesupport_microxrcedds_cpp/message_type_support_decl.hpp"

#include <ucdr/microcdr.h>

// forward declaration of message dependencies and their conversion functions
@[for field in spec.fields]@
@[  if not field.type.is_primitive_type()]@
namespace @(field.type.pkg_name)
{
namespace msg
{
namespace typesupport_microxrcedds_cpp
{
bool cdr_serialize(
  const @(field.type.pkg_name)::msg::@(field.type.type) &,
  ucdrBuffer *);
bool cdr_deserialize(
  ucdrBuffer * ,
  @(field.type.pkg_name)::msg::@(field.type.type) &);
size_t get_serialized_size(
  const @(field.type.pkg_name)::msg::@(field.type.type) &,
  size_t current_alignment);
size_t
max_serialized_size_@(field.type.type)(
  bool & full_bounded,
  size_t current_alignment);
}  // namespace typesupport_microxrcedds_cpp
}  // namespace msg
}  // namespace @(field.type.pkg_name)

@[  end if]@
@[end for]@

namespace @(spec.base_type.pkg_name)
{

namespace @(subfolder)
{

namespace typesupport_microxrcedds_cpp
{

bool
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(spec.base_type.pkg_name)
cdr_serialize(
  const @(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type) & ros_message,
  ucdrBuffer * cdr)
{
bool ok = true;

@[if not spec.fields]@
  // No fields is a no-op.
  (void)cdr;
  (void)ros_message;
@[end if]@

@[for field in spec.fields]@
  // Field name: @(field.name) (@(field.type.type))
  {
@[  if field.type.is_array]@
  // Arrays (upper bounded or unbounded) are not supported yet
  (void)cdr;
  ok = false;
@[  elif field.type.type == 'bool']@
    ok &= ucdr_serialize_bool(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'byte']@
    ok &= ucdr_serialize_uint8_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'char']@
    ok &= ucdr_serialize_char(cdr, (char)ros_message.@(field.name));
@[  elif field.type.type == 'float32']@
    ok &= ucdr_serialize_float(cdr, ros_message.@(field.name));  
@[  elif field.type.type == 'float64']@
    ok &= ucdr_serialize_double(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'int8']@
    ok &= ucdr_serialize_char(cdr, (char)ros_message.@(field.name));
@[  elif field.type.type == 'uint8']@
    ok &= ucdr_serialize_uint8_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'int16']@
    ok &= ucdr_serialize_int16_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'uint16']@
    ok &= ucdr_serialize_uint16_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'int32']@
    ok &= ucdr_serialize_int32_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'uint32']@
    ok &= ucdr_serialize_uint32_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'int64']@
    ok &= ucdr_serialize_int64_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'uint64']@
    ok &= ucdr_serialize_uint64_t(cdr, ros_message.@(field.name));
@[  elif field.type.type == 'string']@
    //ok &= ucdr_serialize_sequence_char(cdr, ros_message.@(field.name).data, (uint32_t)ros_message.@(field.name).size());
    ok = false; // String types are not supported yet in C++ typesupport
@[  elif field.type.is_primitive_type()]@
    // Unkwnow primitive type
    ok = false;
@[  else]@
    //ok &= ((const message_type_support_callbacks_t *)(ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(field.type.pkg_name), msg, @(field.type.type))()->data))->cdr_serialize(ros_message.@(field.name), cdr);
    ok = false; // Nested types are not supported yet in C++ typesupport
@[  end if]@
  }
@[end for]@
return ok;
}

bool
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(spec.base_type.pkg_name)
cdr_deserialize(
  ucdrBuffer * cdr,
  @(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type) & ros_message)
{
  bool ok = true;
  
@[if not spec.fields]@
  // No fields is a no-op.
  (void)cdr;
  (void)ros_message;
@[end if]@

@[for field in spec.fields]@
  // Field name: @(field.name) (@(field.type.type))
  {
@[  if field.type.is_array]@
    // Arrays (upper bounded or unbounded) are not supported yet
    (void)cdr;
    ok = false;
@[  elif field.type.type == 'bool']@
    ok &= ucdr_deserialize_bool(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'byte']@
    ok &= ucdr_deserialize_uint8_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'char']@
    ok &= ucdr_deserialize_char(cdr, (char*)&ros_message.@(field.name));
@[  elif field.type.type == 'float32']@
    ok &= ucdr_deserialize_float(cdr, &ros_message.@(field.name));  
@[  elif field.type.type == 'float64']@
    ok &= ucdr_deserialize_double(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'int8']@
    ok &= ucdr_deserialize_char(cdr, (char*)&ros_message.@(field.name));
@[  elif field.type.type == 'uint8']@
    ok &= ucdr_deserialize_uint8_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'int16']@
    ok &= ucdr_deserialize_int16_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'uint16']@
    ok &= ucdr_deserialize_uint16_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'int32']@
    ok &= ucdr_deserialize_int32_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'uint32']@
    ok &= ucdr_deserialize_uint32_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'int64']@
    ok &= ucdr_deserialize_int64_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'uint64']@
    ok &= ucdr_deserialize_uint64_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'string']@
    //uint32_t Aux_uint32;
    //size_t available_buffer_bytes;
    //void* buffer_write_pointer = GetWritePointer(&available_buffer_bytes);
    //if (buffer_write_pointer != NULL)
    if (false)// String types are not supported yet in C++ typesupport
    {
        //ok &=  ucdr_deserialize_sequence_char(cdr, buffer_write_pointer, available_buffer_bytes, &Aux_uint32);
        // Set max deserialized
        //Aux_uint32 += 1;
        //ros_message.@(field.name).data = buffer_write_pointer;
        //ros_message.@(field.name).size = (size_t)Aux_uint32;
        //ros_message.@(field.name).capacity = (size_t)Aux_uint32;
        //DecreaseAvailableBuffer(Aux_uint32);
    }
    else
    {
        ok = false;
    }
@[  elif field.type.is_primitive_type()]@
    // Unkwnow primitive type
    ok = false;
@[  else]@
    //ok &=  ((const message_type_support_callbacks_t *)(ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(field.type.pkg_name), msg, @(field.type.type))()->data))->cdr_deserialize(cdr, ros_message.@(field.name));
    ok = false; // Nested types are not supported yet in C++ typesupport
@[  end if]@
  }
@[end for]@
  return ok;
}

size_t
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(spec.base_type.pkg_name)
get_serialized_size(
  const @(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type) & ros_message,
  size_t current_alignment)
{
/*
@[if not spec.fields]@
  (void)untyped_ros_message;
  (void)current_alignment;
@[else]@
  @(pkg)__@(subfolder)__@(type) * ros_message = (@(pkg)__@(subfolder)__@(type) *)(untyped_ros_message);
  size_t initial_alignment = current_alignment;
@[end if]@

@[for field in spec.fields]@
  // field.name @(field.name) (@(field.type.type))
  {
@[  if field.type.is_array]@
    // Arrays (upper bounded or unbounded) are not supported yet
    (void) ros_message;
    return 0;
@[  else]@
@[    if field.type.type == 'string']@
    current_alignment += MICROXRCEDDS_PADDING + ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + ros_message->@(field.name).size + 1;
@[    elif field.type.is_primitive_type()]@
    current_alignment += sizeof(ros_message->@(field.name)) + ucdr_alignment(current_alignment, sizeof(ros_message->@(field.name)));
@[    else]
    current_alignment += get_serialized_size_@(field.type.pkg_name)__msg__@(field.type.type)(&(ros_message->@(field.name)), current_alignment);
@[    end if]@
@[  end if]@
  }
@[end for]@

@[if not spec.fields]@
  return 0;
@[else]@
  return current_alignment - initial_alignment;
@[end if]@
*/
}

size_t
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(spec.base_type.pkg_name)
max_serialized_size_@(spec.base_type.type)(
  bool & full_bounded,
  size_t current_alignment)
{
/*
@{full_bounded_Used = False}@
@[if spec.fields]@
  size_t initial_alignment = current_alignment;
  size_t array_size = 1;
@[end if]@

@[for field in spec.fields]@
  // field.name @(field.name) (@(field.type.type))
  {
@[  if field.type.is_array]@
    // Arrays (upper bounded or unbounded) are not supported yet
    return 0;
@[  end if]@
@[  if field.type.type == 'string']@
    full_bounded = false;
    for (size_t index = 0; index < array_size; ++index) 
    {
@[    if field.type.string_upper_bound]@
@#      current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding) + @(field.type.string_upper_bound) + 1;
      current_alignment += MICROXRCEDDS_PADDING + ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + @(field.type.string_upper_bound) + 1;
@[    else]@
@#      current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding) + 1;
      current_alignment += MICROXRCEDDS_PADDING + ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + 1;
@[    end if]@
    }
@[  elif field.type.is_primitive_type()]@
@[    if field.type.type == 'bool' or field.type.type == 'byte' or field.type.type == 'char' or field.type.type == 'uint8' or field.type.type == 'int8' ]@
    current_alignment += array_size * sizeof(uint8_t);
@[    elif field.type.type == 'int16' or field.type.type == 'uint16']@
@#    current_alignment += array_size * sizeof(uint16_t) + eprosima::fastcdr::Cdr::alignment(current_alignment, sizeof(uint16_t));
    current_alignment += array_size * sizeof(uint16_t) + ucdr_alignment(current_alignment, sizeof(uint16_t));
@[    elif field.type.type == 'int32' or field.type.type == 'uint32' or field.type.type == 'float32']@
@#    current_alignment += array_size * sizeof(uint32_t) + eprosima::fastcdr::Cdr::alignment(current_alignment, sizeof(uint32_t));
    current_alignment += array_size * sizeof(uint32_t) + ucdr_alignment(current_alignment, sizeof(uint32_t));
@[    elif field.type.type == 'int64' or field.type.type == 'uint64' or field.type.type == 'float64']@
@#    current_alignment += array_size * sizeof(uint64_t) + eprosima::fastcdr::Cdr::alignment(current_alignment, sizeof(uint64_t));
    current_alignment += array_size * sizeof(uint64_t) + ucdr_alignment(current_alignment, sizeof(uint64_t));
@[    end if]@
@[  else]@
@{    full_bounded_Used = True}@
    for (size_t index = 0; index < array_size; ++index) 
    {
      current_alignment += max_serialized_size_@(field.type.pkg_name)__msg__@(field.type.type)(full_bounded, current_alignment);
    }
@[  end if]@
  }
@[end for]@

@[if full_bounded_Used == False]@
  (void) full_bounded;
@[end if]@
@[if not spec.fields]@
  (void) current_alignment;
  return 0;
@[else]@
  return current_alignment - initial_alignment;
@[end if]@
*/
}

static bool __cdr_serialize(
  const void * untyped_ros_message,
  ucdrBuffer * cdr)
{
  auto typed_message =
    static_cast<const @(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type) *>(
    untyped_ros_message);
  return cdr_serialize(*typed_message, cdr);
}

static bool __cdr_deserialize(
  ucdrBuffer * cdr,
  void * untyped_ros_message)
{
  auto typed_message =
    static_cast<@(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type) *>(
    untyped_ros_message);
  return cdr_deserialize(cdr, *typed_message);
}

static uint32_t __get_serialized_size(
  const void * untyped_ros_message)
{

  auto typed_message =
    static_cast<const @(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type) *>(
    untyped_ros_message);
  return static_cast<uint32_t>(get_serialized_size(*typed_message, 0));
  
}

static size_t __max_serialized_size(bool & full_bounded)
{
  return max_serialized_size_@(spec.base_type.type)(full_bounded, 0);
}

static message_type_support_callbacks_t callbacks = {
  "@(spec.base_type.pkg_name)",
  "@(spec.base_type.type)",
  __cdr_serialize,
  __cdr_deserialize,
  __get_serialized_size,
  __max_serialized_size
};

static rosidl_message_type_support_t handle = {
  rosidl_typesupport_microxrcedds_cpp::typesupport_identifier,
  &callbacks,
  get_message_typesupport_handle_function,
};

}  // namespace typesupport_microxrcedds_cpp

}  // namespace @(subfolder)

}  // namespace @(spec.base_type.pkg_name)

namespace rosidl_typesupport_microxrcedds_cpp
{

template<>
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_EXPORT_@(spec.base_type.pkg_name)
const rosidl_message_type_support_t *
get_message_type_support_handle<@(spec.base_type.pkg_name)::@(subfolder)::@(spec.base_type.type)>()
{
  return &@(spec.base_type.pkg_name)::@(subfolder)::typesupport_microxrcedds_cpp::handle;
}

}  // namespace rosidl_typesupport_microxrcedds_cpp

#ifdef __cplusplus
extern "C"
{
#endif

const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(spec.base_type.pkg_name), @(subfolder), @(spec.base_type.type))() {
  return &@(spec.base_type.pkg_name)::@(subfolder)::typesupport_microxrcedds_cpp::handle;
}

#ifdef __cplusplus
}
#endif
