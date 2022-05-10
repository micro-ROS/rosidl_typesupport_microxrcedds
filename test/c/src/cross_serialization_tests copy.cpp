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

#include <gtest/gtest.h>

#include <cstdbool>

#include "rosidl_runtime_c/message_type_support_struct.h"

#include <rosidl_typesupport_microxrcedds_c/identifier.h>
#include <rosidl_typesupport_fastrtps_c/identifier.h>
#include <rosidl_typesupport_introspection_c/identifier.h>

// Workaround for having two coexistent message_type_support_callbacks_t structs
#define message_type_support_callbacks_t message_type_support_callbacks_fast_t
#include <rosidl_typesupport_fastrtps_cpp/message_type_support.h>
#undef message_type_support_callbacks_t
#define message_type_support_callbacks_t message_type_support_callbacks_xrce_t
#include <rosidl_typesupport_microxrcedds_c/message_type_support.h>
#undef message_type_support_callbacks_t

#include "rosidl_typesupport_introspection_c/message_introspection.h"
#include "rosidl_typesupport_introspection_c/field_types.h"

#include <rosidl_runtime_c/string.h>
#include <rosidl_runtime_c/string_functions.h>

typedef struct genericSequence
{
  void * data;
  size_t size;
  size_t capacity;
} genericSequence;

template <typename T>
class CrossSerialization {
  public:

  #define QUICK_RETURN(x) if(!(x)) return x;

  CrossSerialization(const rosidl_message_type_support_t * type_support_c) :
    xrce_buffer(nullptr),
    xrce_size(0),
    fast_buffer(nullptr),
    fast_size(0)
  {
    xrce_typesupport = get_message_typesupport_handle(type_support_c, rosidl_typesupport_microxrcedds_c__identifier);
    fast_typesupport = get_message_typesupport_handle(type_support_c, rosidl_typesupport_fastrtps_c__identifier);
    introspection_typesupport = get_message_typesupport_handle(type_support_c, rosidl_typesupport_introspection_c__identifier);

    xrce_callbacks = static_cast<const message_type_support_callbacks_xrce_t *>(xrce_typesupport->data);
    fast_callbacks = static_cast<const message_type_support_callbacks_fast_t *>(fast_typesupport->data);
    introspection = (rosidl_typesupport_introspection_c__MessageMembers*) introspection_typesupport->data;
  };

  bool check() {
    bool ret = true;
    ret &= xrce_typesupport != nullptr;
    ret &= fast_typesupport != nullptr;
    ret &= introspection_typesupport != nullptr;
    ret &= xrce_callbacks != nullptr;
    ret &= fast_callbacks != nullptr;
    ret &= introspection != nullptr;
    return ret;
  }

  ~CrossSerialization() {
    if(nullptr != xrce_buffer) {
      free(xrce_buffer);
    }
    if(nullptr != fast_buffer) {
      free(fast_buffer);
    }
  }

  bool serialize_and_compare_buffers(T & msg) {
    xrce_size = xrce_callbacks->get_serialized_size(&msg);
    fast_size = fast_callbacks->get_serialized_size(&msg);
    QUICK_RETURN(xrce_size == fast_size);

    // size_t xrce_max_size = xrce_callbacks->max_serialized_size();
    // bool full_bounded;
    // size_t fast_max_size = fast_callbacks->max_serialized_size(full_bounded);
    // QUICK_RETURN(xrce_max_size == fast_max_size);

    xrce_buffer = (uint8_t *) calloc(xrce_size, sizeof(uint8_t));
    ucdrBuffer xrce_cdr;
    ucdr_init_buffer(&xrce_cdr, xrce_buffer, xrce_size);
    QUICK_RETURN(xrce_callbacks->cdr_serialize(&msg, &xrce_cdr));

    fast_buffer = (uint8_t *) calloc(fast_size, sizeof(uint8_t));
    eprosima::fastcdr::FastBuffer fast_cdr_buffer((char *) fast_buffer, fast_size);
    eprosima::fastcdr::Cdr fast_cdr(fast_cdr_buffer);
    QUICK_RETURN(fast_callbacks->cdr_serialize(&msg, fast_cdr));

    QUICK_RETURN(xrce_cdr.offset == fast_cdr.getSerializedDataLength());

    bool equal_buffers = true;
    for(size_t i = 0; i < xrce_size && equal_buffers; ++i){
      equal_buffers &= xrce_buffer[i] == fast_buffer[i];
      if(!equal_buffers) {
        std::cout << "Error at position " << i << std::endl;
      }
    }
    QUICK_RETURN(equal_buffers);

    return true;
  }

  bool deserialize_with_fastcdr_and_compare(uint8_t * buff, size_t size, T & original_msg) {
    eprosima::fastcdr::FastBuffer input_buffer((char *) buff, size);
    eprosima::fastcdr::Cdr cdr(input_buffer);

    T out = {};
    this->introspection->init_function(&out, ROSIDL_RUNTIME_C_MSG_INIT_ALL);
    QUICK_RETURN(fast_callbacks->cdr_deserialize(cdr, &out));
    QUICK_RETURN(introspect_and_compare(&original_msg, &out));
    this->introspection->fini_function(&out);

    return true;
  }

  bool deserialize_with_microcdr_and_compare(uint8_t * buff, size_t size, T & original_msg) {
    ucdrBuffer cdr;
    ucdr_init_buffer(&cdr, buff, size);

    T out = {};
    this->introspection->init_function(&out, ROSIDL_RUNTIME_C_MSG_INIT_ALL);
    QUICK_RETURN(xrce_callbacks->cdr_deserialize(&cdr, &out));
    QUICK_RETURN(introspect_and_compare(&original_msg, &out));
    this->introspection->fini_function(&out);

    return true;
  }

  using recursive_callback = std::function<bool(const void * msg1, const void * msg2, const rosidl_typesupport_introspection_c__MessageMember m, size_t level)>;

  bool introspect_and_execute(const void * msg1, const void * msg2, recursive_callback cb, const rosidl_typesupport_introspection_c__MessageMembers * members = nullptr, size_t rec = 0) {
    members = (nullptr == members) ? introspection : members;
    bool return_value = true;

    for (uint32_t m = 0; m < members->member_count_; m++) {
      bool member_check = true;

      auto member = members->members_[m];
      bool is_array = member.is_array_ && member.array_size_ != 0;
      bool is_sequence = member.is_array_ && member.array_size_ == 0;

      if (is_sequence || is_array) {
        member_check &= cb(((uint8_t *) msg1) + member.offset_, ((uint8_t *) msg2) + member.offset_, member, rec);
        size_t count = 1;

        uint8_t * msg1_ptr = nullptr;
        uint8_t * msg2_ptr = nullptr;

        if (is_sequence) {
          genericSequence * seq1 = (msg1 != nullptr) ? (genericSequence *) ((uint8_t *) msg1) + member.offset_ : nullptr;
          genericSequence * seq2 = (msg2 != nullptr) ? (genericSequence *) ((uint8_t *) msg2) + member.offset_ : nullptr;
          count = (seq1 != nullptr) ? seq1->capacity : 0;

          msg1_ptr = (seq1 != nullptr) ? (uint8_t *) seq1->data : nullptr;
          msg2_ptr = (seq2 != nullptr) ? (uint8_t *) seq2->data : nullptr;
        } else if (is_array) {
          count = member.array_size_;
          msg1_ptr = ((uint8_t *) msg1) + member.offset_;
          msg2_ptr = ((uint8_t *) msg2) + member.offset_;
        }


        if(member.type_id_ == rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE){
          const rosidl_message_type_support_t * aux_introspection_typesupport = get_message_typesupport_handle(member.members_, rosidl_typesupport_introspection_c__identifier);
          const rosidl_typesupport_introspection_c__MessageMembers * introspection_members = (rosidl_typesupport_introspection_c__MessageMembers*) aux_introspection_typesupport->data;
          for (size_t i = 0; i < count; i++) {
              member_check &= introspect_and_execute(((uint8_t *) msg1_ptr) + i * introspection_members->size_of_, ((uint8_t *) msg2_ptr) + i * introspection_members->size_of_, cb, introspection_members, rec + 1);
          }
        }
      } else {
        member_check &= cb(((uint8_t *) msg1) + member.offset_, ((uint8_t *) msg2) + member.offset_, member, rec);

        if(member.type_id_ == rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE){
          const rosidl_message_type_support_t * aux_introspection_typesupport = get_message_typesupport_handle(member.members_, rosidl_typesupport_introspection_c__identifier);
          const rosidl_typesupport_introspection_c__MessageMembers * introspection_members = (rosidl_typesupport_introspection_c__MessageMembers*) aux_introspection_typesupport->data;
          member_check &= introspect_and_execute(((uint8_t *) msg1) + member.offset_, ((uint8_t *) msg2) + member.offset_, cb, introspection_members, rec + 1);
        }
      }

      // if(member.type_id_ == rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE){
      //   // Nested type
      //   const rosidl_message_type_support_t * aux_introspection_typesupport = get_message_typesupport_handle(member.members_, rosidl_typesupport_introspection_c__identifier);
      //   const rosidl_typesupport_introspection_c__MessageMembers * introspection_members = (rosidl_typesupport_introspection_c__MessageMembers*) aux_introspection_typesupport->data;
      //   size_t count = (is_array) ? member.array_size_ : 1;
      //   member_check &= cb(((uint8_t *) msg1) + member.offset_, ((uint8_t *) msg2) + member.offset_, member, rec);
      //   for (size_t i = 0; i < count; i++) {
      //     member_check &= introspect_and_execute(((uint8_t *) msg1) + member.offset_ + i * introspection_members->size_of_, ((uint8_t *) msg2) + member.offset_ + i * introspection_members->size_of_, cb, introspection_members, rec + 1);
      //   }
      // } else {
      //   // Basic type
      //   member_check &= cb(((uint8_t *) msg1) + member.offset_, ((uint8_t *) msg2) + member.offset_, member, rec);
      // }

      return_value &= member_check;
    }

    return return_value;
  }

  void print_type_info() {
    char * names[20] = {};
    names[1] = "rosidl_typesupport_introspection_c__ROS_TYPE_FLOAT";
    names[2] = "rosidl_typesupport_introspection_c__ROS_TYPE_DOUBLE";
    names[3] = "rosidl_typesupport_introspection_c__ROS_TYPE_LONG_DOUBLE";
    names[4] = "rosidl_typesupport_introspection_c__ROS_TYPE_CHAR";
    names[5] = "rosidl_typesupport_introspection_c__ROS_TYPE_WCHAR";
    names[6] = "rosidl_typesupport_introspection_c__ROS_TYPE_BOOLEAN";
    names[7] = "rosidl_typesupport_introspection_c__ROS_TYPE_OCTET";
    names[8] = "rosidl_typesupport_introspection_c__ROS_TYPE_UINT8";
    names[9] = "rosidl_typesupport_introspection_c__ROS_TYPE_INT8";
    names[10] = "rosidl_typesupport_introspection_c__ROS_TYPE_UINT16";
    names[11] = "rosidl_typesupport_introspection_c__ROS_TYPE_INT16";
    names[12] = "rosidl_typesupport_introspection_c__ROS_TYPE_UINT32";
    names[13] = "rosidl_typesupport_introspection_c__ROS_TYPE_INT32";
    names[14] = "rosidl_typesupport_introspection_c__ROS_TYPE_UINT64";
    names[15] = "rosidl_typesupport_introspection_c__ROS_TYPE_INT64";
    names[16] = "rosidl_typesupport_introspection_c__ROS_TYPE_STRING";
    names[17] = "rosidl_typesupport_introspection_c__ROS_TYPE_WSTRING";
    names[18] = "rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE";

    introspect_and_execute(nullptr, nullptr, [&](const void * /* msg1 */, const void * /* msg2 */, const rosidl_typesupport_introspection_c__MessageMember m, size_t level) -> bool {
      char tabs[100] = "";
      for (size_t i = 0; i < level; i++){tabs[i] = '\t';}

      std::cout << tabs << "member " << m.name_ << " [" << names[m.type_id_] << "]" << std::endl;
      return true;
    });
  }

  static bool compare_basic_type_field(const void * field1, const void * field2, const uint32_t type, const size_t count) {
    uint8_t size = 0;
    switch (type)
    {
    case rosidl_typesupport_introspection_c__ROS_TYPE_INT8:
    case rosidl_typesupport_introspection_c__ROS_TYPE_UINT8:
    case rosidl_typesupport_introspection_c__ROS_TYPE_BOOLEAN:
    case rosidl_typesupport_introspection_c__ROS_TYPE_CHAR:
    case rosidl_typesupport_introspection_c__ROS_TYPE_OCTET:
      size = 1;
      break;
    case rosidl_typesupport_introspection_c__ROS_TYPE_UINT16:
    case rosidl_typesupport_introspection_c__ROS_TYPE_INT16:
      size = 2;
      break;
    case rosidl_typesupport_introspection_c__ROS_TYPE_UINT32:
    case rosidl_typesupport_introspection_c__ROS_TYPE_INT32:
    case rosidl_typesupport_introspection_c__ROS_TYPE_FLOAT:
      size = 4;
      break;
    case rosidl_typesupport_introspection_c__ROS_TYPE_UINT64:
    case rosidl_typesupport_introspection_c__ROS_TYPE_INT64:
    case rosidl_typesupport_introspection_c__ROS_TYPE_DOUBLE:
      size = 8;
      break;
    case rosidl_typesupport_introspection_c__ROS_TYPE_STRING:
    case rosidl_typesupport_introspection_c__ROS_TYPE_LONG_DOUBLE:
    case rosidl_typesupport_introspection_c__ROS_TYPE_WCHAR:
    case rosidl_typesupport_introspection_c__ROS_TYPE_WSTRING:
    default:
      break;
    }

    return (!size) ? false : memcmp(field1, field2, size * count) == 0;
  }

  bool introspect_and_compare(const void * msg1, const void * msg2) {
    return introspect_and_execute(msg1, msg2, [&](const void * msg_inner_1, const void * msg_inner_2, const rosidl_typesupport_introspection_c__MessageMember m, size_t /* level */) -> bool {
        if (m.type_id_ == rosidl_typesupport_introspection_c__ROS_TYPE_STRING) {
          rosidl_runtime_c__String * str1 = (rosidl_runtime_c__String *) msg_inner_1;
          rosidl_runtime_c__String * str2 = (rosidl_runtime_c__String *) msg_inner_2;
          bool str_eq = strcmp(str1->data, str2->data) == 0;
          bool size_eq = str1->size == str2->size;
          bool capacity_eq = str1->capacity == str2->capacity;
          if (!(str_eq && size_eq && capacity_eq)) {
            std::cout << "compare string failed for member " << m.name_ << "string size:" << str1->data << std::endl;
          }
          return str_eq && size_eq && capacity_eq;
        } else if (m.type_id_ != rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE && !m.is_array_) {
          size_t count = (m.is_array_) ? m.array_size_ : 1;
          bool com = compare_basic_type_field(msg1, msg2, m.type_id_, count);
          if (!com) {
            std::cout << "compare_basic_type_field failed for member " << m.name_ << std::endl;
          }
          return com;
        }
        return true;
    });
  }

  void init_strings(const void * msg, size_t string_size) {
    introspect_and_execute(msg, nullptr, [&](const void * msg1, const void * /* msg2 */, const rosidl_typesupport_introspection_c__MessageMember m, size_t /* level */) -> bool {
        if (m.type_id_ == rosidl_typesupport_introspection_c__ROS_TYPE_STRING) {
          rosidl_runtime_c__String * str = (rosidl_runtime_c__String *) msg1;
          std::string str_sample(string_size, 'a');
          rosidl_runtime_c__String__assign(str, str_sample.c_str());
        }
        return true;
    });
  }

  void randomize_strings(const void * msg) {
    introspect_and_execute(msg, nullptr, [&](const void * msg1, const void * /* msg2 */, const rosidl_typesupport_introspection_c__MessageMember m, size_t /* level */) -> bool {
        if (m.type_id_ == rosidl_typesupport_introspection_c__ROS_TYPE_STRING) {
          rosidl_runtime_c__String * str = (rosidl_runtime_c__String *) msg1;
          std::string str_sample(rand() % 100, 'a');
          rosidl_runtime_c__String__assign(str, str_sample.c_str());
        }
        return true;
    });
  }

  void init_sequences(const void * msg, size_t sequence_size) {
    introspect_and_execute(msg, nullptr, [&](const void * msg1, const void * /* msg2 */, const rosidl_typesupport_introspection_c__MessageMember m, size_t /* level */) -> bool {
        bool is_sequence = m.is_array_ && m.array_size_ == 0;
        if (is_sequence) {
          if (m.resize_function)
          {
            m.resize_function((void*) msg1, sequence_size);
          }

          // rosidl_runtime_c__String * str = (rosidl_runtime_c__String *) msg1;
          // std::string str_sample(string_size, 'a');
          // rosidl_runtime_c__String__assign(str, str_sample.c_str());
        }
        return true;
    });
  }

  uint8_t * xrce_buffer;
  uint8_t * fast_buffer;

  size_t xrce_size;
  size_t fast_size;

  const rosidl_message_type_support_t * xrce_typesupport;
  const rosidl_message_type_support_t * fast_typesupport;
  const rosidl_message_type_support_t * introspection_typesupport;

  const message_type_support_callbacks_xrce_t * xrce_callbacks;
  const message_type_support_callbacks_fast_t * fast_callbacks;

  rosidl_typesupport_introspection_c__MessageMembers * introspection;
};

#include <example_interfaces/msg/u_int64_multi_array.h>
TEST(SerDesTests, Example) {
  using DataType = example_interfaces__msg__UInt64MultiArray;
  CrossSerialization<DataType> serdes(ROSIDL_GET_MSG_TYPE_SUPPORT(example_interfaces, msg, UInt64MultiArray));

  ASSERT_TRUE(serdes.check());
  std::array<DataType, 8> msgs = {};

  uint8_t string_size = 0;
  for (auto msg : msgs) {
    serdes.introspection->init_function(&msg, ROSIDL_RUNTIME_C_MSG_INIT_ALL);

    if (string_size != 0) {
      serdes.init_strings(&msg, string_size);
    }

    EXPECT_TRUE(serdes.serialize_and_compare_buffers(msg));

    if (string_size == 0) {
      EXPECT_TRUE(serdes.deserialize_with_microcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg));
      EXPECT_TRUE(serdes.deserialize_with_microcdr_and_compare(serdes.fast_buffer, serdes.fast_size, msg));
    }

    EXPECT_TRUE(serdes.deserialize_with_fastcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg));
    serdes.introspection->fini_function(&msg);
    string_size++;
  }

  for (size_t i = 0; i < 10; i++)
  {
    DataType msg = {};
    serdes.introspection->init_function(&msg, ROSIDL_RUNTIME_C_MSG_INIT_ALL);
    serdes.randomize_strings(&msg);

    EXPECT_TRUE(serdes.serialize_and_compare_buffers(msg));
    EXPECT_TRUE(serdes.deserialize_with_fastcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg));
    serdes.introspection->fini_function(&msg);
  }

  {
    DataType msg = {};
    serdes.introspection->init_function(&msg, ROSIDL_RUNTIME_C_MSG_INIT_ALL);
    serdes.init_strings(&msg, 10);
    serdes.init_sequences(&msg, 10);

    EXPECT_TRUE(serdes.serialize_and_compare_buffers(msg));
    EXPECT_TRUE(serdes.deserialize_with_fastcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg));
    serdes.introspection->fini_function(&msg);
  }
}

#define TEST_TYPE(pkg, name_capitalized) \
  TEST(SerDesTests, pkg ## _ ## name_capitalized) { \
    using DataType = pkg##__msg__##name_capitalized; \
    CrossSerialization<DataType> serdes(ROSIDL_GET_MSG_TYPE_SUPPORT(pkg, msg, name_capitalized));  \
    ASSERT_TRUE(serdes.check()); \
    std::array<DataType, 8> msgs = {}; \
 \
    uint8_t string_size = 0; \
    for (auto msg : msgs) { \
      serdes.introspection->init_function(&msg, ROSIDL_RUNTIME_C_MSG_INIT_ALL); \
 \
      if (string_size != 0) { \
        serdes.init_strings(&msg, string_size); \
      } \
 \
      EXPECT_TRUE(serdes.serialize_and_compare_buffers(msg)); \
 \
      if (string_size == 0) { \
        EXPECT_TRUE(serdes.deserialize_with_microcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg)); \
        EXPECT_TRUE(serdes.deserialize_with_microcdr_and_compare(serdes.fast_buffer, serdes.fast_size, msg)); \
      } \
 \
      EXPECT_TRUE(serdes.deserialize_with_fastcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg)); \
      serdes.introspection->fini_function(&msg); \
      string_size++; \
    } \
 \
    for (size_t i = 0; i < 10; i++) \
    { \
      DataType msg = {}; \
      serdes.introspection->init_function(&msg, ROSIDL_RUNTIME_C_MSG_INIT_ALL); \
      serdes.randomize_strings(&msg); \
 \
      EXPECT_TRUE(serdes.serialize_and_compare_buffers(msg)); \
      EXPECT_TRUE(serdes.deserialize_with_fastcdr_and_compare(serdes.xrce_buffer, serdes.xrce_size, msg)); \
      serdes.introspection->fini_function(&msg); \
    } \
  } \

// #include <geometry_msgs/msg/accel.h>
// TEST_TYPE(geometry_msgs, Accel)

// #include <geometry_msgs/msg/accel_stamped.h>
// TEST_TYPE(geometry_msgs, AccelStamped)

// #include <geometry_msgs/msg/accel_with_covariance.h>
// TEST_TYPE(geometry_msgs, AccelWithCovariance)

// #include <geometry_msgs/msg/accel_with_covariance_stamped.h>
// TEST_TYPE(geometry_msgs, AccelWithCovarianceStamped)

// #include <geometry_msgs/msg/inertia.h>
// TEST_TYPE(geometry_msgs, Inertia)

// #include <geometry_msgs/msg/inertia_stamped.h>
// TEST_TYPE(geometry_msgs, InertiaStamped)

// #include <geometry_msgs/msg/point.h>
// TEST_TYPE(geometry_msgs, Point)

// #include <geometry_msgs/msg/point32.h>
// TEST_TYPE(geometry_msgs, Point32)

// #include <geometry_msgs/msg/point_stamped.h>
// TEST_TYPE(geometry_msgs, PointStamped)

// #include <geometry_msgs/msg/polygon.h>
// TEST_TYPE(geometry_msgs, Polygon)

// #include <geometry_msgs/msg/polygon_stamped.h>
// TEST_TYPE(geometry_msgs, PolygonStamped)

// #include <geometry_msgs/msg/pose.h>
// TEST_TYPE(geometry_msgs, Pose)

// #include <geometry_msgs/msg/pose2_d.h>
// TEST_TYPE(geometry_msgs, Pose2D)

// #include <geometry_msgs/msg/pose_array.h>
// TEST_TYPE(geometry_msgs, PoseArray)

// #include <geometry_msgs/msg/pose_stamped.h>
// TEST_TYPE(geometry_msgs, PoseStamped)

// #include <geometry_msgs/msg/pose_with_covariance.h>
// TEST_TYPE(geometry_msgs, PoseWithCovariance)

// #include <geometry_msgs/msg/pose_with_covariance_stamped.h>
// TEST_TYPE(geometry_msgs, PoseWithCovarianceStamped)

// #include <geometry_msgs/msg/quaternion.h>
// TEST_TYPE(geometry_msgs, Quaternion)

// #include <geometry_msgs/msg/quaternion_stamped.h>
// TEST_TYPE(geometry_msgs, QuaternionStamped)

// #include <geometry_msgs/msg/transform.h>
// TEST_TYPE(geometry_msgs, Transform)

// #include <geometry_msgs/msg/transform_stamped.h>
// TEST_TYPE(geometry_msgs, TransformStamped)

// #include <geometry_msgs/msg/twist.h>
// TEST_TYPE(geometry_msgs, Twist)

// #include <geometry_msgs/msg/twist_stamped.h>
// TEST_TYPE(geometry_msgs, TwistStamped)

// #include <geometry_msgs/msg/twist_with_covariance.h>
// TEST_TYPE(geometry_msgs, TwistWithCovariance)

// #include <geometry_msgs/msg/twist_with_covariance_stamped.h>
// TEST_TYPE(geometry_msgs, TwistWithCovarianceStamped)

// #include <geometry_msgs/msg/vector3.h>
// TEST_TYPE(geometry_msgs, Vector3)

// #include <geometry_msgs/msg/vector3_stamped.h>
// TEST_TYPE(geometry_msgs, Vector3Stamped)

// #include <geometry_msgs/msg/wrench.h>
// TEST_TYPE(geometry_msgs, Wrench)

// #include <geometry_msgs/msg/wrench_stamped.h>
// TEST_TYPE(geometry_msgs, WrenchStamped)


// #include <example_interfaces/msg/bool.h>
// TEST_TYPE(example_interfaces, Bool)

// #include <example_interfaces/msg/byte.h>
// TEST_TYPE(example_interfaces, Byte)

// #include <example_interfaces/msg/byte_multi_array.h>
// TEST_TYPE(example_interfaces, ByteMultiArray)

// #include <example_interfaces/msg/char.h>
// TEST_TYPE(example_interfaces, Char)

// #include <example_interfaces/msg/empty.h>
// TEST_TYPE(example_interfaces, Empty)

// #include <example_interfaces/msg/float32.h>
// TEST_TYPE(example_interfaces, Float32)

// #include <example_interfaces/msg/float32_multi_array.h>
// TEST_TYPE(example_interfaces, Float32MultiArray)

// #include <example_interfaces/msg/float64.h>
// TEST_TYPE(example_interfaces, Float64)

// #include <example_interfaces/msg/float64_multi_array.h>
// TEST_TYPE(example_interfaces, Float64MultiArray)

// #include <example_interfaces/msg/int16.h>
// TEST_TYPE(example_interfaces, Int16)

// #include <example_interfaces/msg/int16_multi_array.h>
// TEST_TYPE(example_interfaces, Int16MultiArray)

// #include <example_interfaces/msg/int32.h>
// TEST_TYPE(example_interfaces, Int32)

// #include <example_interfaces/msg/int32_multi_array.h>
// TEST_TYPE(example_interfaces, Int32MultiArray)

// #include <example_interfaces/msg/int64.h>
// TEST_TYPE(example_interfaces, Int64)

// #include <example_interfaces/msg/int64_multi_array.h>
// TEST_TYPE(example_interfaces, Int64MultiArray)

// #include <example_interfaces/msg/int8.h>
// TEST_TYPE(example_interfaces, Int8)

// #include <example_interfaces/msg/int8_multi_array.h>
// TEST_TYPE(example_interfaces, Int8MultiArray)

// #include <example_interfaces/msg/multi_array_dimension.h>
// TEST_TYPE(example_interfaces, MultiArrayDimension)

// #include <example_interfaces/msg/multi_array_layout.h>
// TEST_TYPE(example_interfaces, MultiArrayLayout)

// #include <example_interfaces/msg/string.h>
// TEST_TYPE(example_interfaces, String)

// #include <example_interfaces/msg/u_int16.h>
// TEST_TYPE(example_interfaces, UInt16)

// #include <example_interfaces/msg/u_int16_multi_array.h>
// TEST_TYPE(example_interfaces, UInt16MultiArray)

// #include <example_interfaces/msg/u_int32.h>
// TEST_TYPE(example_interfaces, UInt32)

// #include <example_interfaces/msg/u_int32_multi_array.h>
// TEST_TYPE(example_interfaces, UInt32MultiArray)

// #include <example_interfaces/msg/u_int64.h>
// TEST_TYPE(example_interfaces, UInt64)

// #include <example_interfaces/msg/u_int64_multi_array.h>
// TEST_TYPE(example_interfaces, UInt64MultiArray)

// #include <example_interfaces/msg/u_int8.h>
// TEST_TYPE(example_interfaces, UInt8)

// #include <example_interfaces/msg/u_int8_multi_array.h>
// TEST_TYPE(example_interfaces, UInt8MultiArray)

// #include <example_interfaces/msg/w_string.h>
// TEST_TYPE(example_interfaces, WString)
