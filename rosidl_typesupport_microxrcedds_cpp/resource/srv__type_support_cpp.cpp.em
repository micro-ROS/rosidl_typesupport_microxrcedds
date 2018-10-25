// generated from rosidl_typesupport_microxrcedds_cpp/resource/srv__type_support.cpp.em
// generated code does not contain a copyright notice

@#######################################################################
@# EmPy template for generating <srv>__type_support.cpp files
@#
@# Context:
@#  - spec (rosidl_parser.ServiceSpecification)
@#    Parsed specification of the .srv file
@#  - get_header_filename_from_msg_name (function)
@#######################################################################
@
#include "@(spec.pkg_name)/srv/@(get_header_filename_from_msg_name(spec.srv_name))__rosidl_typesupport_microxrcedds_cpp.hpp"

#include "rmw/error_handling.h"
#include "rosidl_typesupport_microxrcedds_cpp/identifier.hpp"
#include "rosidl_typesupport_microxrcedds_cpp/service_type_support_decl.hpp"
#include "rosidl_typesupport_microxrcedds_shared/service_type_support.h"

#include "@(spec.pkg_name)/srv/@(get_header_filename_from_msg_name(spec.srv_name))__struct.hpp"
#include "@(spec.pkg_name)/srv/@(get_header_filename_from_msg_name(spec.srv_name + '_Request'))__rosidl_typesupport_microxrcedds_cpp.hpp"
#include "@(spec.pkg_name)/srv/@(get_header_filename_from_msg_name(spec.srv_name + '_Response'))__rosidl_typesupport_microxrcedds_cpp.hpp"

namespace @(spec.pkg_name)
{

namespace srv
{

namespace typesupport_microxrcedds_cpp
{

static service_type_support_callbacks_t callbacks = {
  "@(spec.pkg_name)",
  "@(spec.srv_name)",
  ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(spec.pkg_name), srv, @(spec.srv_name)_Request),
  ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(spec.pkg_name), srv, @(spec.srv_name)_Response),
};

static rosidl_service_type_support_t handle = {
  rosidl_typesupport_microxrcedds_cpp::typesupport_identifier,
  &callbacks,
  get_service_typesupport_handle_function,
};

}  // namespace typesupport_microxrcedds_cpp

}  // namespace srv

}  // namespace @(spec.pkg_name)

namespace rosidl_typesupport_microxrcedds_cpp
{

template<>
ROSIDL_TYPESUPPORT_MICROXRCEDDS_CPP_EXPORT_@(spec.pkg_name)
const rosidl_service_type_support_t *
get_service_type_support_handle<@(spec.pkg_name)::srv::@(spec.srv_name)>()
{
  return &@(spec.pkg_name)::srv::typesupport_microxrcedds_cpp::handle;
}

}  // namespace rosidl_typesupport_microxrcedds_cpp

#ifdef __cplusplus
extern "C"
{
#endif

const rosidl_service_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(rosidl_typesupport_microxrcedds_cpp, @(spec.pkg_name), @(spec.srv_name))() {
  return &@(spec.pkg_name)::srv::typesupport_microxrcedds_cpp::handle;
}

#ifdef __cplusplus
}
#endif
