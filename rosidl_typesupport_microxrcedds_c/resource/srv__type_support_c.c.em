@# Included from rosidl_typesupport_microxrcedds_c/resource/idl__type_support_c.c.em
@{
from rosidl_generator_c import idl_structure_type_to_c_typename
from rosidl_generator_type_description import GET_DESCRIPTION_FUNC
from rosidl_generator_type_description import GET_HASH_FUNC
from rosidl_generator_type_description import GET_SOURCES_FUNC
from rosidl_parser.definition import SERVICE_EVENT_MESSAGE_SUFFIX
from rosidl_parser.definition import SERVICE_REQUEST_MESSAGE_SUFFIX
from rosidl_parser.definition import SERVICE_RESPONSE_MESSAGE_SUFFIX

TEMPLATE(
    'msg__type_support_c.c.em',
    package_name=package_name,
    interface_path=interface_path,
    message=service.request_message,
    include_directives=include_directives)
}@

@{
TEMPLATE(
    'msg__type_support_c.c.em',
    package_name=package_name,
    interface_path=interface_path,
    message=service.response_message,
    include_directives=include_directives)
}@

@{
TEMPLATE(
    'msg__type_support_c.c.em',
    package_name=package_name,
    interface_path=interface_path,
    message=service.event_message,
    include_directives=include_directives)
}@

@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore

include_parts = [package_name] + list(interface_path.parents[0].parts) + \
    [convert_camel_case_to_lower_case_underscore(interface_path.stem)]
include_base = '/'.join(include_parts)

header_files = [
    # Provides the definition of the service_type_support_callbacks_t struct.
    'rosidl_typesupport_microxrcedds_c/service_type_support.h',
    'rosidl_typesupport_microxrcedds_c/identifier.h',
    package_name + '/msg/rosidl_typesupport_microxrcedds_c__visibility_control.h',
    include_base + '.h',
]
}@
@[for header_file in header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include "@(header_file)"
@[end for]@

#if defined(__cplusplus)
extern "C"
{
#endif

static service_type_support_callbacks_t @(service.namespaced_type.name)__callbacks = {
  "@('::'.join([package_name] + list(interface_path.parents[0].parts)))",
  "@(service.namespaced_type.name)",
  ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join([package_name] + list(interface_path.parents[0].parts) + [service.namespaced_type.name]))_Request),
  ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join([package_name] + list(interface_path.parents[0].parts) + [service.namespaced_type.name]))_Response),
};

static rosidl_service_type_support_t @(service.namespaced_type.name)__handle = {
  ROSIDL_TYPESUPPORT_MICROXRCEDDS_C__IDENTIFIER_VALUE,
  &@(service.namespaced_type.name)__callbacks,
  get_service_typesupport_handle_function,

  &_@(service.namespaced_type.name)@(SERVICE_REQUEST_MESSAGE_SUFFIX)__type_support,
  &_@(service.namespaced_type.name)@(SERVICE_RESPONSE_MESSAGE_SUFFIX)__type_support,
  &_@(service.namespaced_type.name)@(SERVICE_EVENT_MESSAGE_SUFFIX)__type_support,

  ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_CREATE_EVENT_MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_c,
    @(',\n    '.join(service.namespaced_type.namespaced_name()))
  ),
  ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_DESTROY_EVENT_MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_c,
    @(',\n    '.join(service.namespaced_type.namespaced_name()))
  ),

  &@(idl_structure_type_to_c_typename(service.namespaced_type))__@(GET_HASH_FUNC),
  &@(idl_structure_type_to_c_typename(service.namespaced_type))__@(GET_DESCRIPTION_FUNC),
  &@(idl_structure_type_to_c_typename(service.namespaced_type))__@(GET_SOURCES_FUNC),
};

const rosidl_service_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_c, @(', '.join([package_name] + list(interface_path.parents[0].parts) + [service.namespaced_type.name])))() {
  return &@(service.namespaced_type.name)__handle;
}

#if defined(__cplusplus)
}
#endif
