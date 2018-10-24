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

#include <limits>
#include <stdexcept>
#include <string>
#include <cstring>
#include <iostream>

#include "@(spec.base_type.pkg_name)/@(subfolder)/@(get_header_filename_from_msg_name(spec.base_type.type))__rosidl_typesupport_microxrcedds_cpp.hpp"

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
  ucdrBuffer *,
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
  (void)ros_message;
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
    ok &= ucdr_serialize_string(cdr, ros_message.@(field.name).c_str());
@[  elif field.type.is_primitive_type()]@
    // Unkwnow primitive type
    ok = false;
@[  else]@
    ok &= @(field.type.pkg_name)::msg::typesupport_microxrcedds_cpp::cdr_serialize(
    ros_message.@(field.name),
    cdr);
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
    (void)ros_message;
    ok = false;
@[  elif field.type.type == 'bool']@
    ok &= ucdr_deserialize_bool(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'byte']@
    ok &= ucdr_deserialize_uint8_t(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'char']@
    ok &= ucdr_deserialize_char(cdr, (char *)&ros_message.@(field.name));
@[  elif field.type.type == 'float32']@
    ok &= ucdr_deserialize_float(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'float64']@
    ok &= ucdr_deserialize_double(cdr, &ros_message.@(field.name));
@[  elif field.type.type == 'int8']@
    ok &= ucdr_deserialize_char(cdr, (char *)&ros_message.@(field.name));
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
    ros_message.@(field.name).resize(ros_message.@(field.name).capacity());
    ok &= ucdr_deserialize_string(cdr, &ros_message.@(field.name)[0], ros_message.@(field.name).capacity());
    ros_message.@(field.name).resize(strlen(&ros_message.@(field.name)[0]));
@[  elif field.type.is_primitive_type()]@
    // Unkwnow primitive type
    ok = false;
@[  else]@
    ok &= @(field.type.pkg_name)::msg::typesupport_microxrcedds_cpp::cdr_deserialize(
      cdr, ros_message.@(field.name));
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
@[if not spec.fields]@
  (void)ros_message;
  (void)current_alignment;
@[else]@
  size_t initial_alignment = current_alignment;

  const size_t padding = 4;
  (void)padding;

@[end if]@
@[for field in spec.fields]@
  // field.name @(field.name)
@[  if field.type.is_array]@
  {
@[    if field.type.array_size and not field.type.is_upper_bound]@
    size_t array_size = @(field.type.array_size);
@[    else]@
    size_t array_size = ros_message.@(field.name).size();
@[      if field.type.is_upper_bound]@
    if (array_size > @(field.type.array_size)) {
      throw std::runtime_error("array size exceeds upper bound");
    }
@[      end if]@

    current_alignment += padding +
      ucdr_alignment(current_alignment, padding);
@[    end if]@
@[    if field.type.type == 'string']@
    for (size_t index = 0; index < array_size; ++index) {
      current_alignment += padding +
        ucdr_alignment(current_alignment, padding) +
        ros_message.@(field.name)[index].size() + 1;
    }
@[    elif field.type.is_primitive_type()]@
    size_t item_size = sizeof(ros_message.@(field.name)[0]);
    current_alignment += array_size * item_size +
      ucdr_alignment(current_alignment, item_size);
@[    else]
    for (size_t index = 0; index < array_size; ++index) {
      current_alignment +=
        @(field.type.pkg_name)::msg::typesupport_microxrcedds_cpp::get_serialized_size(
        ros_message.@(field.name)[index], current_alignment);
    }
@[    end if]@
  }
@[  else]@
@[    if field.type.type == 'string']@
  current_alignment += padding +
    ucdr_alignment(current_alignment, padding) +
    ros_message.@(field.name).size() + 1;
@[    elif field.type.is_primitive_type()]@
  {
    size_t item_size = sizeof(ros_message.@(field.name));
    current_alignment += item_size +
      ucdr_alignment(current_alignment, item_size);
  }
@[    else]
  current_alignment +=
    @(field.type.pkg_name)::msg::typesupport_microxrcedds_cpp::get_serialized_size(
    ros_message.@(field.name), current_alignment);
@[    end if]@
@[  end if]@
@[end for]@

@[if not spec.fields]@
  return 0;
@[else]@
  return current_alignment - initial_alignment;
@[end if]@
}

size_t
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(spec.base_type.pkg_name)
max_serialized_size_@(spec.base_type.type)(
  bool & full_bounded,
  size_t current_alignment)
{
  size_t initial_alignment = current_alignment;

  const size_t padding = 4;
  (void)padding;
  (void)full_bounded;

@[for field in spec.fields]@
  // field.name @(field.name)
  {
@[  if field.type.is_array]@
@[    if field.type.array_size]@
    size_t array_size = @(field.type.array_size);
@[    else]@
    size_t array_size = 0;
@[    end if]@
@[    if not field.type.array_size or field.type.is_upper_bound]@
    full_bounded = false;
    current_alignment += padding +
      ucdr_alignment(current_alignment, padding);
@[    end if]@
@[  else]@
    size_t array_size = 1;
@[  end if]@

@[  if field.type.type == 'string']@
    full_bounded = false;
    for (size_t index = 0; index < array_size; ++index) {
      current_alignment += padding +
@[    if field.type.string_upper_bound]@
        ucdr_alignment(current_alignment, padding) +
        @(field.type.string_upper_bound) + 1;
@[    else]@
        ucdr_alignment(current_alignment, padding) + 1;
@[    end if]@
    }
@[  elif field.type.is_primitive_type()]@
@[    if field.type.type == 'bool' or field.type.type == 'byte' or field.type.type == 'char' or field.type.type == 'uint8' or field.type.type == 'int8' ]
    current_alignment += array_size * sizeof(uint8_t);
@[    elif field.type.type == 'int16' or field.type.type == 'uint16']
    current_alignment += array_size * sizeof(uint16_t) +
      ucdr_alignment(current_alignment, sizeof(uint16_t));
@[    elif field.type.type == 'int32' or field.type.type == 'uint32' or field.type.type == 'float32']
    current_alignment += array_size * sizeof(uint32_t) +
      ucdr_alignment(current_alignment, sizeof(uint32_t));
@[    elif field.type.type == 'int64' or field.type.type == 'uint64' or field.type.type == 'float64']
    current_alignment += array_size * sizeof(uint64_t) +
      ucdr_alignment(current_alignment, sizeof(uint64_t));
@[    end if]@
@[  else]
    for (size_t index = 0; index < array_size; ++index) {
      current_alignment +=
        @(field.type.pkg_name)::msg::typesupport_microxrcedds_cpp::max_serialized_size_@(field.type.type)(
        full_bounded, current_alignment);
    }
@[  end if]@
  }
@[end for]@

  return current_alignment - initial_alignment;
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
