@# Included from rosidl_typesupport_microxrcedds_cpp/resource/idl__type_support.cpp.em
@{
from rosidl_parser.definition import AbstractGenericString
from rosidl_parser.definition import AbstractNestedType
from rosidl_parser.definition import AbstractSequence
from rosidl_parser.definition import AbstractString
from rosidl_parser.definition import BoundedString
from rosidl_parser.definition import AbstractWString
from rosidl_parser.definition import Array
from rosidl_parser.definition import BasicType
from rosidl_parser.definition import BoundedSequence
from rosidl_parser.definition import UnboundedSequence
from rosidl_parser.definition import NamespacedType

header_files = [
    'limits',
    'algorithm',
    'stdexcept',
    'string',
    'cstring',
    'rosidl_typesupport_cpp/message_type_support.hpp',
    'rosidl_typesupport_microxrcedds_cpp/identifier.hpp',
    'rosidl_typesupport_microxrcedds_shared/message_type_support.h',
    'rosidl_typesupport_microxrcedds_cpp/message_type_support_decl.hpp',
    'ucdr/microcdr.h',
]
}@
@[for header_file in header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
@[    if '/' not in header_file]@
#include <@(header_file)>
@[    else]@
#include "@(header_file)"
@[    end if]@
@[end for]@

#define MICROXRCEDDS_PADDING sizeof(uint32_t)

// forward declaration of message dependencies and their conversion functions
@[for member in message.structure.members]@
@{
type_ = member.type
if isinstance(type_, AbstractNestedType):
    type_ = type_.value_type
}@
@[  if isinstance(type_, NamespacedType)]@
@[    for ns in type_.namespaces]@
namespace @(ns)
{
@[    end for]@
namespace typesupport_microxrcedds_cpp
{
bool cdr_serialize(
  const @('::'.join(type_.namespaced_name())) &,
  ucdrBuffer *);

bool cdr_deserialize(
  ucdrBuffer *,
  @('::'.join(type_.namespaced_name())) &);

size_t get_serialized_size(
  const @('::'.join(type_.namespaced_name())) &,
  size_t current_alignment);

size_t
max_serialized_size_@(type_.name)(
  bool * full_bounded,
  size_t current_alignment);
}  // namespace typesupport_microxrcedds_cpp
@[    for ns in reversed(type_.namespaces)]@
}  // namespace @(ns)
@[    end for]@

@[  end if]@
@[end for]@
@
@[  for ns in message.structure.namespaced_type.namespaces]@

namespace @(ns)
{
@[  end for]@

namespace typesupport_microxrcedds_cpp
{

bool
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(package_name)
cdr_serialize(
  const @('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])) & ros_message,
  ucdrBuffer * cdr)
{
  (void) ros_message;
  (void) cdr;
  bool rv = false;

@[for member in message.structure.members]@
  // Member: @(member.name)
@[  if isinstance(member.type, AbstractNestedType)]@
  {
@[    if isinstance(member.type, Array)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    size_t size = ros_message.@(member.name).size();
@[        if member.type.value_type.typename == 'boolean']@
    rv = ucdr_serialize_array_bool(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'octet']@
    rv = ucdr_serialize_array_uint8_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'char']@
    rv = ucdr_serialize_array_char(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int8']@
    rv = ucdr_serialize_array_int8_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint8']@
    rv = ucdr_serialize_array_uint8_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int16']@
    rv = ucdr_serialize_array_int16_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint16']@
    rv = ucdr_serialize_array_uint16_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int32']@
    rv = ucdr_serialize_array_int32_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint32']@
    rv = ucdr_serialize_array_uint32_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int64']@
    rv = ucdr_serialize_array_int64_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint64']@
    rv = ucdr_serialize_array_uint64_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'float']@
    rv = ucdr_serialize_array_float(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'double']@
    rv = ucdr_serialize_array_double(cdr, ros_message.@(member.name).data(), size);
@[        end if]@
@[      else]@
    // Micro CDR only support arrays of basic types.
@[      end if]@
@[    elif isinstance(member.type, AbstractSequence)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    size_t size = ros_message.@(member.name).size();
@[        if member.type.value_type.typename == 'boolean']@
@[          if isinstance(member.type, BoundedSequence)]@
    bool temp[@(member.type.maximum_size)] = {0};
    std::copy(ros_message.@(member.name).begin(), ros_message.@(member.name).end(), std::begin(temp));
    rv = ucdr_serialize_sequence_bool(cdr, temp, size);
@[          else]@
    bool * temp = new bool[size];
    std::copy(ros_message.@(member.name).begin(), ros_message.@(member.name).end(), temp);
    rv = ucdr_serialize_sequence_bool(cdr, temp, size);
    delete[] temp;
@[          end if]@
@[        elif member.type.value_type.typename == 'octet']@
    rv = ucdr_serialize_sequence_uint8_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'char']@
    rv = ucdr_serialize_sequence_char(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'int8']@
    rv = ucdr_serialize_sequence_int8_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'uint8']@
    rv = ucdr_serialize_sequence_uint8_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'int16']@
    rv = ucdr_serialize_sequence_int16_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'uint16']@
    rv = ucdr_serialize_sequence_uint16_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'int32']@
    rv = ucdr_serialize_sequence_int32_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'uint32']@
    rv = ucdr_serialize_sequence_uint32_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'int64']@
    rv = ucdr_serialize_sequence_int64_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'uint64']@
    rv = ucdr_serialize_sequence_uint64_t(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'float']@
    rv = ucdr_serialize_sequence_float(cdr, &ros_message.@(member.name)[0], size);
@[        elif member.type.value_type.typename == 'double']@
    rv = ucdr_serialize_sequence_double(cdr, &ros_message.@(member.name)[0], size);
@[        end if]@
@[      end if]@
@[    end if]@
  }
@[  elif isinstance(member.type, BasicType)]@
@[    if member.type.typename == 'boolean']@
  rv = ucdr_serialize_bool(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'octet']@
  rv = ucdr_serialize_uint8_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'char']@
  rv = ucdr_serialize_char(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'int8']@
  rv = ucdr_serialize_int8_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'uint8']@
  rv = ucdr_serialize_uint8_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'int16']@
  rv = ucdr_serialize_int16_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'uint16']@
  rv = ucdr_serialize_uint16_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'int32']@
  rv = ucdr_serialize_int32_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'uint32']@
  rv = ucdr_serialize_uint32_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'int64']@
  rv = ucdr_serialize_int64_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'uint64']@
  rv = ucdr_serialize_uint64_t(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'float']@
  rv = ucdr_serialize_float(cdr, ros_message.@(member.name));
@[    elif member.type.typename == 'double']@
  rv = ucdr_serialize_double(cdr, ros_message.@(member.name));
@[    end if]@
@[  elif isinstance(member.type, AbstractString)]@
  rv = ucdr_serialize_string(cdr, ros_message.@(member.name).c_str());
@[  elif isinstance(member.type, AbstractWString)]@
  // Micro CDR does not support WString type.
@[  elif isinstance(member.type, NamespacedType)]@
  rv = @('::'.join(member.type.namespaces))::typesupport_microxrcedds_cpp::cdr_serialize(
    ros_message.@(member.name),
    cdr);
@[  else]@
  // Micro CDR does not support this type.
@[  end if]@
@[end for]@

  return rv;
}

bool
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(package_name)
cdr_deserialize(
  ucdrBuffer * cdr,
  @('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])) & ros_message)
{
  (void) cdr;
  (void) ros_message;
  bool rv = false;

@[for member in message.structure.members]@
  // Member: @(member.name)
@[  if isinstance(member.type, AbstractNestedType)]@
  {
@[    if isinstance(member.type, Array)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    const size_t size = ros_message.@(member.name).size();
@[        if member.type.value_type.typename == 'boolean']@
    rv = ucdr_deserialize_array_bool(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'octet']@
    rv = ucdr_deserialize_array_uint8_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'char']@
    rv = ucdr_deserialize_array_char(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int8']@
    rv = ucdr_deserialize_array_int8_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint8']@
    rv = ucdr_deserialize_array_uint8_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int16']@
    rv = ucdr_deserialize_array_int16_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint16']@
    rv = ucdr_deserialize_array_uint16_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int32']@
    rv = ucdr_deserialize_array_int32_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint32']@
    rv = ucdr_deserialize_array_uint32_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'int64']@
    rv = ucdr_deserialize_array_int64_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'uint64']@
    rv = ucdr_deserialize_array_uint64_t(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'float']@
    rv = ucdr_deserialize_array_float(cdr, ros_message.@(member.name).data(), size);
@[        elif member.type.value_type.typename == 'double']@
    rv = ucdr_deserialize_array_double(cdr, ros_message.@(member.name).data(), size);
@[        end if]@
@[      else]@
    // Micro CDR only support arrays of basic types.
@[      end if]@
@[    elif isinstance(member.type, AbstractSequence)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    uint32_t size;
    const size_t capacity = ros_message.@(member.name).capacity();
    ros_message.@(member.name).resize(capacity);
@[        if member.type.value_type.typename == 'boolean']@
@[          if isinstance(member.type, BoundedSequence)]@
    bool temp[@(member.type.maximum_size)] = {0};
    rv = ucdr_deserialize_sequence_bool(cdr, temp, @(member.type.maximum_size), &size);
    if (rv) {
      std::copy(std::begin(temp), std::begin(temp) + size, ros_message.@(member.name).begin());
    }
@[          else]@
    bool * temp = new bool[capacity];
    rv = ucdr_deserialize_sequence_bool(cdr, temp, capacity, &size);
    if (rv) {
      std::copy(temp, temp + size, ros_message.@(member.name).begin());
    }
    delete[] temp;
@[          end if]@
@[        elif member.type.value_type.typename == 'octet']@
    rv = ucdr_deserialize_sequence_uint8_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'char']@
    rv = ucdr_deserialize_sequence_char(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'int8']@
    rv = ucdr_deserialize_sequence_int8_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'uint8']@
    rv = ucdr_deserialize_sequence_uint8_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'int16']@
    rv = ucdr_deserialize_sequence_int16_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'uint16']@
    rv = ucdr_deserialize_sequence_uint16_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'int32']@
    rv = ucdr_deserialize_sequence_int32_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'uint32']@
    rv = ucdr_deserialize_sequence_uint32_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'int64']@
    rv = ucdr_deserialize_sequence_int64_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'uint64']@
    rv = ucdr_deserialize_sequence_uint64_t(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'float']@
    rv = ucdr_deserialize_sequence_float(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        elif member.type.value_type.typename == 'double']@
    rv = ucdr_deserialize_sequence_double(cdr, &ros_message.@(member.name)[0], capacity, &size);
@[        end if]@
    if (rv) {
      ros_message.@(member.name).resize(size);
    }
@[      end if]@
@[    end if]@
  }
@[  elif isinstance(member.type, BasicType)]@
@[    if member.type.typename == 'boolean']@
  rv = ucdr_deserialize_bool(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'octet']@
  rv = ucdr_deserialize_uint8_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'char']@
  rv = ucdr_deserialize_char(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'int8']@
  rv = ucdr_deserialize_int8_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'uint8']@
  rv = ucdr_deserialize_uint8_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'int16']@
  rv = ucdr_deserialize_int16_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'uint16']@
  rv = ucdr_deserialize_uint16_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'int32']@
  rv = ucdr_deserialize_int32_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'uint32']@
  rv = ucdr_deserialize_uint32_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'int64']@
  rv = ucdr_deserialize_int64_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'uint64']@
  rv = ucdr_deserialize_uint64_t(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'float']@
  rv = ucdr_deserialize_float(cdr, &ros_message.@(member.name));
@[    elif member.type.typename == 'double']@
  rv = ucdr_deserialize_double(cdr, &ros_message.@(member.name));
@[    end if]@
@[  elif isinstance(member.type, AbstractString)]@
  ros_message.@(member.name).resize(ros_message.@(member.name).capacity());
  rv = ucdr_deserialize_string(cdr, &ros_message.@(member.name)[0], ros_message.@(member.name).capacity());
  if (rv) {
    ros_message.@(member.name).resize(std::strlen(&ros_message.@(member.name)[0]));
  }
@[  elif isinstance(member.type, AbstractWString)]@
  // Micro CDR does not support WString type.
@[  elif isinstance(member.type, NamespacedType)]@
  rv = @('::'.join(member.type.namespaces))::typesupport_microxrcedds_cpp::cdr_deserialize(
    cdr,
    ros_message.@(member.name));
@[  else]@
  // Micro CDR does not support this type.
@[  end if]@
@[end for]@

  return rv;
}

size_t
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(package_name)
get_serialized_size(
  const @('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])) & ros_message,
  size_t current_alignment)
{
  (void) current_alignment;
  (void) ros_message;

  const size_t initial_alignment = current_alignment;

@[for member in message.structure.members]@
  // Member: @(member.name)
@[  if isinstance(member.type, AbstractNestedType)]@
  {
@[    if isinstance(member.type, Array)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    const size_t array_size = @(member.type.size);
    const size_t item_size = sizeof(ros_message.@(member.name)[0]);
    current_alignment += ucdr_alignment(current_alignment, item_size) + (array_size * item_size);
@[      end if]@
@[    elif isinstance(member.type, AbstractSequence)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    size_t sequence_size = ros_message.@(member.name).size();
    size_t item_size = sizeof(ros_message.@(member.name)[0]);
    current_alignment += ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + MICROXRCEDDS_PADDING;
    current_alignment += ucdr_alignment(current_alignment, item_size) + (sequence_size * item_size);
@[      end if]@
@[    end if]@
  }
@[  elif isinstance(member.type, BasicType)]@
  {
    const size_t item_size = sizeof(ros_message.@(member.name));
    current_alignment += ucdr_alignment(current_alignment, item_size) + item_size;
  }
@[  elif isinstance(member.type, AbstractString)]@
  current_alignment += ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + MICROXRCEDDS_PADDING;
  current_alignment += ros_message.@(member.name).size() + 1;
@[  elif isinstance(member.type, NamespacedType)]@
  current_alignment += @('::'.join(member.type.namespaces))::typesupport_microxrcedds_cpp::get_serialized_size(
    ros_message.@(member.name),
    current_alignment);
@[  end if]@
@[end for]@

  return current_alignment - initial_alignment;
}

size_t
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_PUBLIC_@(package_name)
max_serialized_size_@(message.structure.namespaced_type.name)(
  bool * full_bounded,
  size_t current_alignment)
{
  (void) current_alignment;
  *full_bounded = true;

  const size_t initial_alignment = current_alignment;

@[for member in message.structure.members]@
  // Member: @(member.name)
@[  if isinstance(member.type, AbstractNestedType)]@
  {
@[    if isinstance(member.type, Array)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    const size_t array_size = @(member.type.size);
@[        if member.type.value_type.typename in ('boolean', 'octet', 'char', 'uint8', 'int8')]@
    current_alignment += array_size * sizeof(uint8_t);
@[        elif member.type.value_type.typename in ('int16', 'uint16')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint16_t)) + (array_size * sizeof(uint16_t));
@[        elif member.type.value_type.typename in ('int32', 'uint32', 'float')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint32_t)) + (array_size * sizeof(uint32_t));
@[        elif member.type.value_type.typename in ('int64', 'uint64', 'double')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint64_t)) + (array_size * sizeof(uint64_t));
@[        elif member.type.value_type.typename in ('long double')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(long double)) + (array_size * sizeof(long double));
@[        end if]@
@[      else]@
    *full_bounded = false;
@[      end if]@
@[    elif isinstance(member.type, BoundedSequence)]@
@[      if isinstance(member.type.value_type, BasicType)]@
    const size_t max_sequence_size = @(member.type.maximum_size);
    current_alignment += ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + MICROXRCEDDS_PADDING;
@[        if member.type.value_type.typename in ('boolean', 'octet', 'char', 'uint8', 'int8')]@
    current_alignment += max_sequence_size * sizeof(uint8_t);
@[        elif member.type.value_type.typename in ('int16', 'uint16')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint16_t)) + (max_sequence_size * sizeof(uint16_t));
@[        elif member.type.value_type.typename in ('int32', 'uint32', 'float')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint32_t)) + (max_sequence_size * sizeof(uint32_t));
@[        elif member.type.value_type.typename in ('int64', 'uint64', 'double')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint64_t)) + (max_sequence_size * sizeof(uint64_t));
@[        elif member.type.value_type.typename in ('long double')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(long double)) + (max_sequence_size * sizeof(long double));
@[        end if]@
@[      else]@
    *full_bounded = false;
@[      end if]@
@[    elif isinstance(member.type, UnboundedSequence)]@
    *full_bounded = false;
@[    end if]@
  }
@[  elif isinstance(member.type, BasicType)]@
@[    if member.type.typename in ('boolean', 'octet', 'char', 'uint8', 'int8')]@
  current_alignment += sizeof(uint8_t);
@[    elif member.type.typename in ('int16', 'uint16')]@
  current_alignment += ucdr_alignment(current_alignment, sizeof(uint16_t)) + sizeof(uint16_t);
@[    elif member.type.typename in ('int32', 'uint32', 'float')]@
  current_alignment += ucdr_alignment(current_alignment, sizeof(uint32_t)) + sizeof(uint32_t);
@[    elif member.type.typename in ('int64', 'uint64', 'double')]@
  current_alignment += ucdr_alignment(current_alignment, sizeof(uint64_t)) + sizeof(uint64_t);
@[    elif member.type.typename in ('long double')]@
  current_alignment += ucdr_alignment(current_alignment, sizeof(long double)) + sizeof(long double);
@[    end if]@
@[  elif isinstance(member.type, BoundedString)]@
  current_alignment += ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING);
  current_alignment += @(member.type.maximum_size) + 1;
@[  elif isinstance(member.type, NamespacedType)]@
  current_alignment += @('::'.join(member.type.namespaces))::typesupport_microxrcedds_cpp::max_serialized_size_@(member.type.name)(
    full_bounded,
    current_alignment);
@[  else]@
  *full_bounded = false;
@[  end if]@
@[end for]@

  return current_alignment - initial_alignment;
}

static bool _@(message.structure.namespaced_type.name)__cdr_serialize(
  const void * untyped_ros_message,
  ucdrBuffer * cdr)
{
  auto typed_message =
    static_cast<const @('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])) *>(
    untyped_ros_message);
  return cdr_serialize(*typed_message, cdr);
}

static bool _@(message.structure.namespaced_type.name)__cdr_deserialize(
  ucdrBuffer * cdr,
  void * untyped_ros_message,
  uint8_t * raw_mem_ptr,
  size_t raw_mem_size)
{
  (void) raw_mem_ptr;
  (void) raw_mem_size;

  auto typed_message =
    static_cast<@('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])) *>(
    untyped_ros_message);
  return cdr_deserialize(cdr, *typed_message);
}

static uint32_t _@(message.structure.namespaced_type.name)__get_serialized_size(
  const void * untyped_ros_message)
{
  auto typed_message =
    static_cast<const @('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])) *>(
    untyped_ros_message);
  return static_cast<uint32_t>(get_serialized_size(*typed_message, 0));
}

static size_t _@(message.structure.namespaced_type.name)__max_serialized_size()
{
  bool full_bounded;
  return max_serialized_size_@(message.structure.namespaced_type.name)(&full_bounded, 0);
}

static message_type_support_callbacks_t _@(message.structure.namespaced_type.name)__callbacks = {
  "@('::'.join([package_name] + list(interface_path.parents[0].parts)))",
  "@(message.structure.namespaced_type.name)",
  _@(message.structure.namespaced_type.name)__cdr_serialize,
  _@(message.structure.namespaced_type.name)__cdr_deserialize,
  _@(message.structure.namespaced_type.name)__get_serialized_size,
  _@(message.structure.namespaced_type.name)__max_serialized_size
};

static rosidl_message_type_support_t _@(message.structure.namespaced_type.name)__handle = {
  rosidl_typesupport_microxrcedds_cpp::typesupport_identifier,
  &_@(message.structure.namespaced_type.name)__callbacks,
  get_message_typesupport_handle_function,
};

}  // namespace typesupport_microxrcedds_cpp
@[  for ns in reversed(message.structure.namespaced_type.namespaces)]@

}  // namespace @(ns)
@[  end for]@

namespace rosidl_typesupport_microxrcedds_cpp
{

template<>
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_EXPORT_@(package_name)
const rosidl_message_type_support_t *
get_message_type_support_handle<@('::'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name]))>()
{
  return &@('::'.join([package_name] + list(interface_path.parents[0].parts)))::typesupport_microxrcedds_cpp::_@(message.structure.namespaced_type.name)__handle;
}

}  // namespace rosidl_typesupport_microxrcedds_cpp

#ifdef __cplusplus
extern "C"
{
#endif

const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(', '.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])))() {
  return &@('::'.join([package_name] + list(interface_path.parents[0].parts)))::typesupport_microxrcedds_cpp::_@(message.structure.namespaced_type.name)__handle;
}

#ifdef __cplusplus
}
#endif
