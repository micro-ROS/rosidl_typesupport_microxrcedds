// generated from rosidl_typesupport_micrortps_c/resource/msg__type_support_c.c.em
// generated code does not contain a copyright notice
@##########################################################################
@# EmPy template for generating <msg>__type_support_c.cpp files for micrortps
@#
@# Context:
@#  - spec (rosidl_parser.MessageSpecification)
@#    Parsed specification of the .msg file
@#  - pkg (string)
@#    name of the containing package; equivalent to spec.base_type.pkg_name
@#  - msg (string)
@#    name of the message; equivalent to spec.msg_name
@#  - type (string)
@#    full type of the message; equivalent to spec.base_type.type
@#  - subfolder (string)
@#    The subfolder / subnamespace of the message
@#    Either 'msg' or 'srv'
@#  - get_header_filename_from_msg_name (function)
@##########################################################################
@
#include "@(spec.base_type.pkg_name)/@(subfolder)/@(get_header_filename_from_msg_name(spec.base_type.type))__rosidl_typesupport_micrortps_c.h"

#include <stdint.h>
#include <stdio.h>

// Provides the rosidl_typesupport_micrortps_c__identifier symbol declaration.
#include "rosidl_typesupport_micrortps_c/identifier.h"
// Provides the definition of the message_type_support_callbacks_t struct.
#include "rosidl_typesupport_micrortps_c/message_type_support.h"
#include "rosidl_typesupport_micrortps_c/deserialize_buffer_utility.h"

#include "@(pkg)/msg/rosidl_typesupport_micrortps_c__visibility_control.h"
@{header_file_name = get_header_filename_from_msg_name(type)}@
#include "@(pkg)/@(subfolder)/@(header_file_name)__struct.h"
#include "@(pkg)/@(subfolder)/@(header_file_name)__functions.h"


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

#define MICRORTPS_PADDING sizeof(uint32_t)


@# // Include the message header for each non-primitive field.
@{
includes = {}
for field in spec.fields:
    keys = set([])
    if field.type.is_primitive_type():
        if field.type.is_array:
            keys.add('rosidl_generator_c/primitives_array.h')
            keys.add('rosidl_generator_c/primitives_array_functions.h')
        if field.type.type == 'string':
            keys.add('rosidl_generator_c/string.h')
            keys.add('rosidl_generator_c/string_functions.h')
    else:
        header_file_name = get_header_filename_from_msg_name(field.type.type)
        keys.add('%s/msg/%s__functions.h' % (field.type.pkg_name, header_file_name))
    for key in keys:
        if key not in includes:
            includes[key] = set([])
        includes[key].add(field.name)
}@
@[if sorted(includes.keys())]@
// includes and forward declarations of message dependencies and their conversion functions
@[end if]@
@[for key in sorted(includes.keys())]@
#include "@(key)"  // @(', '.join(includes[key]))
@[end for]@
@#
@{
forward_declares = {}
for field in spec.fields:
    if not field.type.is_primitive_type():
        key = (field.type.pkg_name, field.type.type)
        if key not in includes:
            forward_declares[key] = set([])
        forward_declares[key].add(field.name)
}@
@[if sorted(forward_declares.keys())]@
// forward declare type support functions
@[end if]@
@[for key in sorted(forward_declares.keys())]@
@[  if key[0] != pkg]@
ROSIDL_TYPESUPPORT_MICRORTPS_C_IMPORT_@(pkg)
@[  end if]@
size_t get_serialized_size_@(key[0])__msg__@(key[1])(const void * untyped_ros_message, size_t current_alignment);

@[  if key[0] != pkg]@
ROSIDL_TYPESUPPORT_MICRORTPS_C_IMPORT_@(pkg)
@[  end if]@
size_t max_serialized_size_@(key[0])__msg__@(key[1])(bool full_bounded, size_t current_alignment);

@[  if key[0] != pkg]@
ROSIDL_TYPESUPPORT_MICRORTPS_C_IMPORT_@(pkg)
@[  end if]@
const rosidl_message_type_support_t *
  ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_micrortps_c, @(key[0]), msg, @(key[1]))();
@[end for]@

@# // Make callback functions specific to this message type.
@#
static bool __cdr_serialize(const void * untyped_ros_message, ucdrBuffer * cdr)
{
  bool ok = true;

  if (!untyped_ros_message) 
  {
    fprintf(stderr, "ros message handle is null\n");
    return false;
  }

@[if not spec.fields]@
  // No fields is a no-op.
  (void)cdr;
  (void)untyped_ros_message;
@[else]@
  @(pkg)__@(subfolder)__@(type) * ros_message = (@(pkg)__@(subfolder)__@(type) *)(untyped_ros_message); (void)ros_message;
@[end if]@

@[for field in spec.fields]@
  // Field name: @(field.name) (@(field.type.type))
  {
@[  if field.type.is_array]@
  // Arrays (upper bounded or unbounded) are not supported yet
  (void)cdr;
  ok = false;
@#@[    if field.type.array_size and not field.type.is_upper_bound]@
@#    size_t size = @(field.type.array_size);
@#    auto array_ptr = ros_message->@(field.name);
@#@[    else]@
@#    size_t size = ros_message->@(field.name).size;
@#    auto array_ptr = ros_message->@(field.name).data;
@#@[      if field.type.is_upper_bound]@
@#    if (size > @(field.type.array_size)) {
@#      fprintf(stderr, "array size exceeds upper bound\n");
@#      return false;
@#    }
@#@[      end if]@
@#    cdr << static_cast<uint32_t>(size);
@#@[    end if]@
@#@[    if field.type.type == 'string']@
@#    for (size_t i = 0; i < size; ++i) {
@#      const rosidl_generator_c__String * str = &array_ptr[i];
@#      if (str->capacity == 0 || str->capacity <= str->size) {
@#        fprintf(stderr, "string capacity not greater than size\n");
@#        return false;
@#      }
@#      if (str->data[str->size] != '\0') {
@#        fprintf(stderr, "string not null-terminated\n");
@#        return false;
@#      }
@#      cdr << str->data;
@#    }
@#@[    elif field.type.is_primitive_type()]@
@#    cdr.serializeArray(array_ptr, size);
@#@[    else]@
@#    for (size_t i = 0; i < size; ++i) {
@#      if (!@(field.type.pkg_name)__msg__@(field.type.type)__callbacks->cdr_serialize(
@#          &array_ptr[i], cdr))
@#      {
@#        return false;
@#      }
@#    }
@#@[    end if]@
@#@[  elif field.type.type == 'string']@
@#    const rosidl_generator_c__String * str = &ros_message->@(field.name);
@#    if (str->capacity == 0 || str->capacity <= str->size) {
@#      fprintf(stderr, "string capacity not greater than size\n");
@#      return false;
@#    }
@#    if (str->data[str->size] != '\0') {
@#      fprintf(stderr, "string not null-terminated\n");
@#      return false;
@#    }
@#    cdr << str->data;
@[  elif field.type.type == 'bool']@
    ok &= ucdr_serialize_bool(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'byte']@
    ok &= ucdr_serialize_uint8_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'char']@
    ok &= ucdr_serialize_char(cdr, (char)ros_message->@(field.name));
@[  elif field.type.type == 'float32']@
    ok &= ucdr_serialize_float(cdr, ros_message->@(field.name));  
@[  elif field.type.type == 'float64']@
    ok &= ucdr_serialize_double(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'int8']@
    ok &= ucdr_serialize_char(cdr, (char)ros_message->@(field.name));
@[  elif field.type.type == 'uint8']@
    ok &= ucdr_serialize_uint8_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'int16']@
    ok &= ucdr_serialize_int16_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'uint16']@
    ok &= ucdr_serialize_uint16_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'int32']@
    ok &= ucdr_serialize_int32_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'uint32']@
    ok &= ucdr_serialize_uint32_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'int64']@
    ok &= ucdr_serialize_int64_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'uint64']@
    ok &= ucdr_serialize_uint64_t(cdr, ros_message->@(field.name));
@[  elif field.type.type == 'string']@
    ok &= ucdr_serialize_sequence_char(cdr, ros_message->@(field.name).data, (uint32_t)ros_message->@(field.name).size);
@[  elif field.type.is_primitive_type()]@
    // Unkwnow primitive type
    ok = false;
@[  else]@
    ok &= ((const message_type_support_callbacks_t *)(ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_micrortps_c, @(field.type.pkg_name), msg, @(field.type.type))()->data))->cdr_serialize(&ros_message->@(field.name), cdr);
@[  end if]@
  }
@[end for]@
  return ok;
}

static bool __cdr_deserialize(ucdrBuffer * cdr, void * untyped_ros_message, uint8_t* raw_mem_ptr, size_t raw_mem_size)
{
  bool ok = true;
  
  if (!untyped_ros_message) 
  {
    fprintf(stderr, "ros message handle is null\n");
    return false;
  }
@{raw_mem_used = False}@
@[if not spec.fields]@
  // No fields is a no-op.
  (void)cdr;
  (void)untyped_ros_message;
@[else]@
  @(pkg)__@(subfolder)__@(type) * ros_message = (@(pkg)__@(subfolder)__@(type) *)(untyped_ros_message); (void)ros_message;
@[end if]@

@[for field in spec.fields]@
  // Field name: @(field.name) (@(field.type.type))
  {
@[  if field.type.is_array]@
    // Arrays (upper bounded or unbounded) are not supported yet
    (void)cdr;
    ok = false;
@#@[    if field.type.array_size and not field.type.is_upper_bound]@
@#    size_t size = @(field.type.array_size);
@#    auto array_ptr = ros_message->@(field.name);
@#@[    else]@
@#{
@#if field.type.type == 'string':
@#    array_init = 'rosidl_generator_c__String__Array__init'
@#    array_fini = 'rosidl_generator_c__String__Array__fini'
@#elif field.type.is_primitive_type():
@#    array_init = 'rosidl_generator_c__{field.type.type}__Array__init'.format(**locals())
@#    array_fini = 'rosidl_generator_c__{field.type.type}__Array__fini'.format(**locals())
@#else:
@#    array_init = '{field.type.pkg_name}__msg__{field.type.type}__Array__init'.format(**locals())
@#    array_fini = '{field.type.pkg_name}__msg__{field.type.type}__Array__fini'.format(**locals())
@#}@
@#    uint32_t cdrSize;
@#    cdr >> cdrSize;
@#    size_t size = static_cast<size_t>(cdrSize);
@#    if (ros_message->@(field.name).data) {
@#      @(array_fini)(&ros_message->@(field.name));
@#    }
@#    if (!@(array_init)(&ros_message->@(field.name), size)) {
@#      return "failed to create array for field '@(field.name)'";
@#    }
@#    auto array_ptr = ros_message->@(field.name).data;
@#@[    end if]@
@#@[    if field.type.type == 'string']@
@#    for (size_t i = 0; i < size; ++i) {
@#      std::string tmp;
@#      cdr >> tmp;
@#      auto & ros_i = array_ptr[i];
@#      if (!ros_i.data) {
@#        rosidl_generator_c__String__init(&ros_i);
@#      }
@#      bool succeeded = rosidl_generator_c__String__assign(
@#        &ros_i,
@#        tmp.c_str());
@#      if (!succeeded) {
@#        fprintf(stderr, "failed to assign string into field '@(field.name)'\n");
@#        return false;
@#      }
@#    }
@#@[    elif field.type.is_primitive_type()]@
@#    cdr.deserializeArray(array_ptr, size);
@#@[    else]@
@#    for (size_t i = 0; i < size; ++i) {
@#      if (!@(field.type.pkg_name)__msg__@(field.type.type)__callbacks->cdr_deserialize(
@#          cdr, &array_ptr[i]))
@#      {
@#        return false;
@#      }
@#    }
@#@[    end if]@
@#@[  elif field.type.type == 'string']@
@#    std::string tmp;
@#    cdr >> tmp;
@#    if (!ros_message->@(field.name).data) {
@#      rosidl_generator_c__String__init(&ros_message->@(field.name));
@#    }
@#    bool succeeded = rosidl_generator_c__String__assign(
@#      &ros_message->@(field.name),
@#      tmp.c_str());
@#    if (!succeeded) {
@#      fprintf(stderr, "failed to assign string into field '@(field.name)'\n");
@#      return false;
@#    }
@[  elif field.type.type == 'bool']@
    ok &= ucdr_deserialize_bool(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'byte']@
    ok &= ucdr_deserialize_uint8_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'char']@
    ok &= ucdr_deserialize_char(cdr, (char*)&ros_message->@(field.name));
@[  elif field.type.type == 'float32']@
    ok &= ucdr_deserialize_float(cdr, &ros_message->@(field.name));  
@[  elif field.type.type == 'float64']@
    ok &= ucdr_deserialize_double(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'int8']@
    ok &= ucdr_deserialize_char(cdr, (char*)&ros_message->@(field.name));
@[  elif field.type.type == 'uint8']@
    ok &= ucdr_deserialize_uint8_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'int16']@
    ok &= ucdr_deserialize_int16_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'uint16']@
    ok &= ucdr_deserialize_uint16_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'int32']@
    ok &= ucdr_deserialize_int32_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'uint32']@
    ok &= ucdr_deserialize_uint32_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'int64']@
    ok &= ucdr_deserialize_int64_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'uint64']@
    ok &= ucdr_deserialize_uint64_t(cdr, &ros_message->@(field.name));
@[  elif field.type.type == 'string']@
@{      raw_mem_used = True}
    if (raw_mem_ptr != NULL)
    { 
        uint32_t Aux_uint32;
        rosidl_typesupport_microxrcedds_c__align_pointer(&raw_mem_ptr, &raw_mem_size);
        ok &=  ucdr_deserialize_sequence_char(cdr, (char*)raw_mem_ptr, raw_mem_size, &Aux_uint32);
        raw_mem_ptr[Aux_uint32] = 0x00;
        Aux_uint32 += 1;
        raw_mem_size -= Aux_uint32;
        ros_message->@(field.name).data = (char*)raw_mem_ptr;
        ros_message->@(field.name).size = (size_t)Aux_uint32;
        ros_message->@(field.name).capacity = (size_t)Aux_uint32;
    }
    else
    {
        ok = false;
    }
@[  elif field.type.is_primitive_type()]@
    // Unkwnow primitive type
    ok = false;
@[  else]@
    ok &=  ((const message_type_support_callbacks_t *)(ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_micrortps_c, @(field.type.pkg_name), msg, @(field.type.type))()->data))->cdr_deserialize(cdr, &ros_message->@(field.name), raw_mem_ptr, raw_mem_size);
@[  end if]@
  }
@[end for]@
@[if raw_mem_used == False]@
  (void) raw_mem_ptr;
  (void) raw_mem_size;
@[end if]@
  return ok;
}

ROSIDL_TYPESUPPORT_MICRORTPS_C_PUBLIC_@(spec.base_type.pkg_name)
size_t get_serialized_size_@(spec.base_type.pkg_name)__@(subfolder)__@(spec.base_type.type)(const void * untyped_ros_message, size_t current_alignment)
{
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
@#  {
@#@[    if field.type.array_size and not field.type.is_upper_bound]@
@#    size_t array_size = @(field.type.array_size);
@#    auto array_ptr = ros_message->@(field.name);
@#@[    else]@
@#    size_t array_size = ros_message->@(field.name).size;
@#    auto array_ptr = ros_message->@(field.name).data;
@#    //current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding);
@#    current_alignment += padding + ucdr_alignment(current_alignment, padding);
@#@[    end if]@
@#@[    if field.type.type == 'string']@
@#    for (size_t index = 0; index < array_size; ++index) {
@#      //current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding) + array_ptr[index].size + 1;
@#      current_alignment += padding + ucdr_alignment(current_alignment, padding) + array_ptr[index].size + 1;
@#    }
@#@[    elif field.type.is_primitive_type()]@
@#    (void)array_ptr;
@#    size_t item_size = sizeof(array_ptr[0]);
@#    //current_alignment += array_size * item_size + eprosima::fastcdr::Cdr::alignment(current_alignment, item_size);
@#    current_alignment += array_size * item_size + ucdr_alignment(current_alignment, item_size);
@#@[    else]
@#    for (size_t index = 0; index < array_size; ++index) {
@#      current_alignment += get_serialized_size_@(field.type.pkg_name)__msg__@(field.type.type)(&array_ptr[index], current_alignment);
@#    }
@#@[    end if]@
@#  }
@[  else]@
@[    if field.type.type == 'string']@
@#  current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding) + ros_message->@(field.name).size + 1;
    current_alignment += MICRORTPS_PADDING + ucdr_alignment(current_alignment, MICRORTPS_PADDING) + ros_message->@(field.name).size + 1;
@[    elif field.type.is_primitive_type()]@
@#  {
@#    size_t item_size = sizeof(ros_message->@(field.name));
@#    current_alignment += item_size + eprosima::fastcdr::Cdr::alignment(current_alignment, item_size);
    current_alignment += sizeof(ros_message->@(field.name)) + ucdr_alignment(current_alignment, sizeof(ros_message->@(field.name)));
@#  }
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
}

static uint32_t __get_serialized_size(const void * untyped_ros_message)
{
  return (uint32_t)(get_serialized_size_@(spec.base_type.pkg_name)__@(subfolder)__@(spec.base_type.type)(untyped_ros_message, 0));
}

ROSIDL_TYPESUPPORT_MICRORTPS_C_PUBLIC_@(spec.base_type.pkg_name)
size_t max_serialized_size_@(spec.base_type.pkg_name)__@(subfolder)__@(spec.base_type.type)(bool full_bounded, size_t current_alignment)
{
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
@#@[    if field.type.array_size]@
@#    size_t array_size = @(field.type.array_size);
@#@[    else]@
@#    size_t array_size = 0;
@#@[    end if]@
@#@[    if not field.type.array_size or field.type.is_upper_bound]@
@#    full_bounded = false;
@#    //current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding);
@#    current_alignment += padding + ucdr_alignment(current_alignment, padding);
@#@[    end if]@
@[  end if]@
@[  if field.type.type == 'string']@
    full_bounded = false;
    for (size_t index = 0; index < array_size; ++index) 
    {
@[    if field.type.string_upper_bound]@
@#      current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding) + @(field.type.string_upper_bound) + 1;
      current_alignment += MICRORTPS_PADDING + ucdr_alignment(current_alignment, MICRORTPS_PADDING) + @(field.type.string_upper_bound) + 1;
@[    else]@
@#      current_alignment += padding + eprosima::fastcdr::Cdr::alignment(current_alignment, padding) + 1;
      current_alignment += MICRORTPS_PADDING + ucdr_alignment(current_alignment, MICRORTPS_PADDING) + 1;
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
}

static size_t __max_serialized_size(bool full_bounded)
{
  return max_serialized_size_@(spec.base_type.pkg_name)__@(subfolder)__@(spec.base_type.type)(full_bounded, 0);
}


@
@# // Collect the callback functions and provide a function to get the type support struct.

static message_type_support_callbacks_t __callbacks = {
  "@(pkg)",
  "@(msg)",
  __cdr_serialize,
  __cdr_deserialize,
  __get_serialized_size,
  __max_serialized_size
};

static rosidl_message_type_support_t __type_support = {
  ROSIDL_TYPESUPPORT_MICRORTPS_C__IDENTIFIER_VALUE, //rosidl_typesupport_micrortps_c__identifier,
  &__callbacks,
  get_message_typesupport_handle_function,
};

const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_micrortps_c, @(pkg), @(subfolder), @(msg))() 
{
  return &__type_support;
}

