@# Included from rosidl_typesupport_fastrtps_c/resource/idl__type_support_c.cpp.em
@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
from rosidl_parser.definition import AbstractGenericString
from rosidl_parser.definition import AbstractNestedType
from rosidl_parser.definition import AbstractSequence
from rosidl_parser.definition import AbstractString
from rosidl_parser.definition import AbstractWString
from rosidl_parser.definition import ACTION_FEEDBACK_SUFFIX
from rosidl_parser.definition import ACTION_GOAL_SUFFIX
from rosidl_parser.definition import ACTION_RESULT_SUFFIX
from rosidl_parser.definition import Array
from rosidl_parser.definition import BasicType
from rosidl_parser.definition import BoundedSequence
from rosidl_parser.definition import NamespacedType

include_parts = [package_name] + list(interface_path.parents[0].parts) + \
    [convert_camel_case_to_lower_case_underscore(interface_path.stem)]
include_base = '/'.join(include_parts)

header_files = [
    'stdint.h',
    'stdio.h',
    # Provides the rosidl_typesupport_microxrcedds_c__identifier symbol declaration.
    'rosidl_typesupport_microxrcedds_shared/identifier.h',
    # Provides the definition of the message_type_support_callbacks_t struct.
    'rosidl_typesupport_microxrcedds_shared/message_type_support.h',
    'rosidl_typesupport_microxrcedds_c/deserialize_buffer_utility.h',
    package_name + '/msg/rosidl_typesupport_microxrcedds_c__visibility_control.h',
    include_base + '__struct.h',
    include_base + '__functions.h',
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

#ifndef _WIN32
# pragma GCC diagnostic push
# pragma GCC diagnostic ignored "-Wunused-parameter"
# ifdef __clang__
#  pragma clang diagnostic ignored "-Wdeprecated-register"
#  pragma clang diagnostic ignored "-Wreturn-type-c-linkage"
# endif
#endif
#ifndef _WIN32
# pragma GCC diagnostic pop
#endif

#define MICROXRCEDDS_PADDING sizeof(uint32_t)

// includes and forward declarations of message dependencies and their conversion functions

@# // Include the message header for each non-primitive field.
#if defined(__cplusplus)
extern "C"
{
#endif

@{
includes = {}
for member in message.structure.members:
    keys = set([])
    if isinstance(member.type, AbstractSequence) and isinstance(member.type.value_type, BasicType):
        keys.add('rosidl_generator_c/primitives_sequence.h')
        keys.add('rosidl_generator_c/primitives_sequence_functions.h')
    type_ = member.type
    if isinstance(type_, AbstractNestedType):
        type_ = type_.value_type
    if isinstance(type_, AbstractString):
        keys.add('rosidl_generator_c/string.h')
        keys.add('rosidl_generator_c/string_functions.h')
    elif isinstance(type_, AbstractWString):
        keys.add('rosidl_generator_c/u16string.h')
        keys.add('rosidl_generator_c/u16string_functions.h')
    elif isinstance(type_, NamespacedType):
        if (
            type_.name.endswith(ACTION_GOAL_SUFFIX) or
            type_.name.endswith(ACTION_RESULT_SUFFIX) or
            type_.name.endswith(ACTION_FEEDBACK_SUFFIX)
        ):
            typename = type_.name.rsplit('_', 1)[0]
        else:
            typename = type_.name
        keys.add('/'.join(type_.namespaces + [convert_camel_case_to_lower_case_underscore(typename)]) + '__functions.h')
    for key in keys:
        if key not in includes:
            includes[key] = set([])
        includes[key].add(member.name)
}@
@[for header_file in sorted(includes.keys())]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include "@(header_file)"  // @(', '.join(sorted(includes[header_file])))
@[end for]@

// forward declare type support functions
@{
forward_declares = {}
for member in message.structure.members:
    type_ = member.type
    if isinstance(type_, AbstractNestedType):
        type_ = type_.value_type
    if isinstance(type_, NamespacedType):
        key = (*type_.namespaces, type_.name)
        if key not in includes:
            forward_declares[key] = set([])
        forward_declares[key].add(member.name)
}@
@[for key in sorted(forward_declares.keys())]@
@[  if key[0] != package_name]@
ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_IMPORT_@(package_name)
@[  end if]@
size_t get_serialized_size_@('__'.join(key))(
  const void * untyped_ros_message,
  size_t current_alignment);

@[  if key[0] != package_name]@
ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_IMPORT_@(package_name)
@[  end if]@
size_t max_serialized_size_@('__'.join(key))(
  size_t current_alignment);

@[  if key[0] != package_name]@
ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_IMPORT_@(package_name)
@[  end if]@
const rosidl_message_type_support_t *
  ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join(key)))();
@[end for]@

@# // Make callback functions specific to this message type.

typedef @('__'.join(message.structure.namespaced_type.namespaced_name())) _@(message.structure.namespaced_type.name)__ros_msg_type;

static bool _@(message.structure.namespaced_type.name)__cdr_serialize(
  const void * untyped_ros_message,
  ucdrBuffer * cdr)
{
  bool rv = false;

  if (!untyped_ros_message) {
    fprintf(stderr, "ros message handle is null\n");
    return false;
  }
  const _@(message.structure.namespaced_type.name)__ros_msg_type * ros_message = (const _@(message.structure.namespaced_type.name)__ros_msg_type *)(untyped_ros_message);
@[for member in message.structure.members]@
  // Field name: @(member.name)
  {
@{
type_ = member.type
if isinstance(type_, AbstractNestedType):
  type_ = type_.value_type
}@
@[  if isinstance(type_, NamespacedType)]@
    rv = ((const message_type_support_callbacks_t *)(
      ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join(type_.namespaced_name()))
      )()->data))->cdr_serialize(&ros_message->@(member.name), cdr);
@[  end if]@
@[  if isinstance(member.type, AbstractNestedType)]@
@[    if isinstance(member.type, Array)]@
    size_t size = @(member.type.size);
@[      if isinstance(member.type.value_type, BasicType)]@
@[          if member.type.value_type.typename == 'boolean']@
    rv = ucdr_serialize_array_bool(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'octet']@
    rv = ucdr_serialize_array_uint8_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'char']@
    rv = ucdr_serialize_array_char(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int8']@
    rv = ucdr_serialize_array_int8_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint8']@
    rv = ucdr_serialize_array_uint8_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int16']@
    rv = ucdr_serialize_array_int16_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint16']@
    rv = ucdr_serialize_array_uint16_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int32']@
    rv = ucdr_serialize_array_int32_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint32']@
    rv = ucdr_serialize_array_uint32_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int64']@
    rv = ucdr_serialize_array_int64_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint64']@
    rv = ucdr_serialize_array_uint64_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'float']@
    rv = ucdr_serialize_array_float(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'double']@
    rv = ucdr_serialize_array_double(cdr, ros_message->@(member.name), size);
@[          end if]@
@[      else]@
    rv = false;
@[      end if]@
@[    end if]@
@[  elif isinstance(member.type, AbstractString)]@
    rv = ucdr_serialize_string(cdr, ros_message->@(member.name).data);
@[  elif isinstance(member.type, BasicType)]@
@[    if member.type.typename == 'boolean']@
    rv = ucdr_serialize_bool(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'octet']@
    rv = ucdr_serialize_uint8_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'char']@
    rv = ucdr_serialize_char(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'int8']@
    rv = ucdr_serialize_int8_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'uint8']@
    rv = ucdr_serialize_uint8_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'int16']@
    rv = ucdr_serialize_int16_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'uint16']@
    rv = ucdr_serialize_uint16_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'int32']@
    rv = ucdr_serialize_int32_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'uint32']@
    rv = ucdr_serialize_uint32_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'int64']@
    rv = ucdr_serialize_int64_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'uint64']@
    rv = ucdr_serialize_uint64_t(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'float']@
    rv = ucdr_serialize_float(cdr, ros_message->@(member.name));
@[    elif member.type.typename == 'double']@
    rv = ucdr_serialize_double(cdr, ros_message->@(member.name));
@[    end if]@
@[  end if]@
  }
@[end for]@
  return rv;
}

static bool _@(message.structure.namespaced_type.name)__cdr_deserialize(
  ucdrBuffer * cdr,
  void * untyped_ros_message,
  uint8_t * raw_mem_ptr,
  size_t raw_mem_size)
{
  bool rv = false;

  if (!untyped_ros_message) {
    fprintf(stderr, "ros message handle is null\n");
    return false;
  }
  _@(message.structure.namespaced_type.name)__ros_msg_type * ros_message = (_@(message.structure.namespaced_type.name)__ros_msg_type *)(untyped_ros_message);
  (void) ros_message;
  (void) cdr;
  (void) raw_mem_ptr;
  (void) raw_mem_size;

@[for member in message.structure.members]@
  // Field name: @(member.name)
  {
@{
type_ = member.type
if isinstance(type_, AbstractNestedType):
    type_ = type_.value_type
}@
@[  if isinstance(type_, NamespacedType)]@
    rv = ((const message_type_support_callbacks_t *)(
      ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join(type_.namespaced_name()))
      )()->data))->cdr_deserialize(cdr, &ros_message->@(member.name), raw_mem_ptr, raw_mem_size);
@[  end if]@
@[  if isinstance(member.type, AbstractNestedType)]@
@[    if isinstance(member.type, Array)]@
    size_t size = @(member.type.size);
@[      if isinstance(member.type.value_type, BasicType)]@
@[          if member.type.value_type.typename == 'boolean']@
    rv = ucdr_deserialize_array_bool(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'octet']@
    rv = ucdr_deserialize_array_uint8_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'char']@
    rv = ucdr_deserialize_array_char(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int8']@
    rv = ucdr_deserialize_array_int8_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint8']@
    rv = ucdr_deserialize_array_uint8_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int16']@
    rv = ucdr_deserialize_array_int16_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint16']@
    rv = ucdr_deserialize_array_uint16_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int32']@
    rv = ucdr_deserialize_array_int32_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint32']@
    rv = ucdr_deserialize_array_uint32_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'int64']@
    rv = ucdr_deserialize_array_int64_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'uint64']@
    rv = ucdr_deserialize_array_uint64_t(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'float']@
    rv = ucdr_deserialize_array_float(cdr, ros_message->@(member.name), size);
@[			elif member.type.value_type.typename == 'double']@
    rv = ucdr_deserialize_array_double(cdr, ros_message->@(member.name), size);
@[          end if]@
@[      else]@
    rv = false;
@[      end if]@
@[    end if]@
@[  elif isinstance(member.type, AbstractString)]@
    if (NULL != raw_mem_ptr) {
      uint32_t length;
      rosidl_typesupport_microxrcedds_c__align_pointer(&raw_mem_ptr, &raw_mem_size);
      rv = ucdr_deserialize_sequence_char(cdr, (char *)raw_mem_ptr, raw_mem_size, &length);
      if (rv) {
        raw_mem_ptr[length] = 0x00;
        ++length;
        raw_mem_size -= length;
        ros_message->@(member.name).data = (char *)raw_mem_ptr;
        ros_message->@(member.name).size = (size_t)length;
        ros_message->@(member.name).capacity = (size_t)length;
        raw_mem_ptr += length;
      }
    }
@[  elif isinstance(member.type, BasicType)]@
@[    if member.type.typename == 'boolean']@
    rv = ucdr_deserialize_bool(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'octet']@
    rv = ucdr_deserialize_uint8_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'char']@
    rv = ucdr_deserialize_char(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'int8']@
    rv = ucdr_deserialize_int8_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'uint8']@
    rv = ucdr_deserialize_uint8_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'int16']@
    rv = ucdr_deserialize_int16_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'uint16']@
    rv = ucdr_deserialize_uint16_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'int32']@
    rv = ucdr_deserialize_int32_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'uint32']@
    rv = ucdr_deserialize_uint32_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'int64']@
    rv = ucdr_deserialize_int64_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'uint64']@
    rv = ucdr_deserialize_uint64_t(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'float']@
    rv = ucdr_deserialize_float(cdr, &ros_message->@(member.name));
@[    elif member.type.typename == 'double']@
    rv = ucdr_deserialize_double(cdr, &ros_message->@(member.name));
@[    end if]@
@[  end if]@
  }
@[end for]@
  return rv;
}

ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_PUBLIC_@(package_name)
size_t get_serialized_size_@('__'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name]))(
  const void * untyped_ros_message,
  size_t current_alignment)
{
  const _@(message.structure.namespaced_type.name)__ros_msg_type * ros_message = (const _@(message.structure.namespaced_type.name)__ros_msg_type *)(untyped_ros_message);
  (void)ros_message;
  size_t initial_alignment = current_alignment;

@[for member in message.structure.members]@
  // field.name @(member.name)
@[  if isinstance(member.type, AbstractNestedType)]@
  {
@[    if isinstance(member.type, Array)]@
    size_t array_size = @(member.type.size);
@[      if isinstance(member.type.value_type, BasicType)]@
    size_t item_size = sizeof(&ros_message->@(member.name));
    current_alignment += ucdr_alignment(current_alignment, item_size) + (array_size * item_size);
@[      end if]@
@[    end if]@
  }
@[  elif isinstance(member.type, AbstractString)]@
  current_alignment += MICROXRCEDDS_PADDING + ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + ros_message->@(member.name).size + 1;
@[  elif isinstance(member.type, BasicType)]@
  current_alignment += sizeof(ros_message->@(member.name)) + ucdr_alignment(current_alignment, sizeof(ros_message->@(member.name)));
@[  else]@
  current_alignment += get_serialized_size_@('__'.join(member.type.namespaced_name()))(
    &(ros_message->@(member.name)), current_alignment);
@[  end if]@
@[end for]@

  return current_alignment - initial_alignment;
}

static uint32_t _@(message.structure.namespaced_type.name)__get_serialized_size(const void * untyped_ros_message)
{
  return (uint32_t)(
    get_serialized_size_@('__'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name]))(
      untyped_ros_message, 0));
}

ROSIDL_TYPESUPPORT_MICROXRCEDDS_C_PUBLIC_@(package_name)
size_t max_serialized_size_@('__'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name]))(
  size_t current_alignment)
{
  size_t initial_alignment = current_alignment;

@[for member in message.structure.members]@
  // member: @(member.name)
  {
@[  if isinstance(member.type, AbstractNestedType)]@
@[    if isinstance(member.type, Array)]@
    size_t array_size = @(member.type.size);
@[    else]@
    size_t array_size = 0;
@[    end if]@
@[  else]@
    size_t array_size = 1;
@[  end if]@
@{
type_ = member.type
if isinstance(type_, AbstractNestedType):
    type_ = type_.value_type
}@
@[  if isinstance(type_, AbstractGenericString)]@
    for (size_t index = 0; index < array_size; ++index) {
      current_alignment += MICROXRCEDDS_PADDING + ucdr_alignment(current_alignment, MICROXRCEDDS_PADDING) + 1;
    }
@[  elif isinstance(type_, BasicType)]@
@[    if type_.typename in ('boolean', 'octet', 'char', 'uint8', 'int8')]@
    current_alignment += array_size * sizeof(uint8_t);
@[    elif type_.typename in ('wchar', 'int16', 'uint16')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint16_t)) + array_size * sizeof(uint16_t);
@[    elif type_.typename in ('int32', 'uint32', 'float')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint32_t)) + array_size * sizeof(uint32_t);
@[    elif type_.typename in ('int64', 'uint64', 'double')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(uint64_t)) + array_size * sizeof(uint64_t);
@[    elif type_.typename in ('long double')]@
    current_alignment += ucdr_alignment(current_alignment, sizeof(long double)) + array_size * sizeof(long double);
@[    end if]@
@[    else]@
    for (size_t index = 0; index < array_size; ++index) {
        current_alignment +=
          max_serialized_size_@('__'.join(type_.namespaced_name()))(current_alignment);
    }
@[  end if]@
  }
@[end for]@
  return current_alignment - initial_alignment;
}

static size_t _@(message.structure.namespaced_type.name)__max_serialized_size()
{
  return max_serialized_size_@('__'.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name]))(0);
}


@
@# // Collect the callback functions and provide a function to get the type support struct.

static message_type_support_callbacks_t __callbacks_@(message.structure.namespaced_type.name) = {
  "@('::'.join([package_name] + list(interface_path.parents[0].parts)))",
  "@(message.structure.namespaced_type.name)",
  _@(message.structure.namespaced_type.name)__cdr_serialize,
  _@(message.structure.namespaced_type.name)__cdr_deserialize,
  _@(message.structure.namespaced_type.name)__get_serialized_size,
  _@(message.structure.namespaced_type.name)__max_serialized_size
};

static rosidl_message_type_support_t _@(message.structure.namespaced_type.name)__type_support = {
  ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__IDENTIFIER_VALUE,
  &__callbacks_@(message.structure.namespaced_type.name),
  get_message_typesupport_handle_function,
};

const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join([package_name] + list(interface_path.parents[0].parts) + [message.structure.namespaced_type.name])))() {
  return &_@(message.structure.namespaced_type.name)__type_support;
}

#if defined(__cplusplus)
}
#endif
