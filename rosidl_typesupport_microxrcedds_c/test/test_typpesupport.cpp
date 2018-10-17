// Copyright 2018 Proyectos y Sistemas de Mantenimiento SL (eProsima).
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


#include <rosidl_typesupport_microxrcedds_c/identifier.h>
#include <rosidl_typesupport_microxrcedds_c/message_type_support.h>


class TestTypeSupport : public ::testing::Test
{
protected:
  static void SetUpTestCase()
  {
    GTEST_DECLARE_bool_(break_on_failure);

    #ifdef _WIN32

    #else
    freopen("/dev/null", "w", stderr);
    #endif
  }


  static void TearDownTestCase()
  {
  }


  void SetUp()
  {
  }


  void TearDown()
  {
  }

  
};


/*
   Testing subscription construction and destruction.
 */
TEST_F(TestTypeSupport, serialize_and_sesserialize) {
    
    // Test 
    {
        /*
        message_type_support_callbacks_t dummy_callbacks;
        dummy_callbacks.message_name_ = "dummy";
        dummy_callbacks.package_name_ = "dummy";
        dummy_callbacks.cdr_serialize = [](const void * untyped_ros_message, ucdrBuffer * cdr){return true;};
        dummy_callbacks.cdr_deserialize = [](ucdrBuffer * cdr, void * untyped_ros_message, uint8_t* raw_mem_ptr, size_t raw_mem_size){return true;};
        dummy_callbacks.get_serialized_size = [](const void*){return (uint32_t)0;};
        dummy_callbacks.max_serialized_size = [](bool full_bounded){return (size_t)0;};


        rosidl_message_type_support_t dummy_type_support;
        dummy_type_support.typesupport_identifier = rosidl_typesupport_microxrcedds_c__identifier;
        dummy_type_support.data = &dummy_callbacks;
        dummy_type_support.func = [](const rosidl_message_type_support_t * type_support, const char * id){return type_support;};

        rmw_qos_profile_t dummy_qos_policies;
        dummy_qos_policies.avoid_ros_namespace_conventions = false;
        dummy_qos_policies.depth = 0;
        dummy_qos_policies.durability = RMW_QOS_POLICY_DURABILITY_SYSTEM_DEFAULT;
        //dummy_qos_policies.durability = RMW_QOS_POLICY_DURABILITY_TRANSIENT_LOCAL;
        //dummy_qos_policies.durability = RMW_QOS_POLICY_DURABILITY_VOLATILE;
        dummy_qos_policies.history = RMW_QOS_POLICY_HISTORY_SYSTEM_DEFAULT;
        //dummy_qos_policies.history = RMW_QOS_POLICY_HISTORY_KEEP_LAST;
        //dummy_qos_policies.history = RMW_QOS_POLICY_HISTORY_KEEP_ALL;
        dummy_qos_policies.reliability = RMW_QOS_POLICY_RELIABILITY_SYSTEM_DEFAULT;
        //dummy_qos_policies.reliability = RMW_QOS_POLICY_RELIABILITY_RELIABLE;
        //dummy_qos_policies.reliability = RMW_QOS_POLICY_RELIABILITY_BEST_EFFORT;

        bool ignore_local_publications = true;

        rmw_subscription_t * sub = rmw_create_subscription(this->node, &dummy_type_support, "topic_name", &dummy_qos_policies, ignore_local_publications);
        EXPECT_NE((void*)sub, (void*)NULL);

        rmw_ret_t ret = rmw_destroy_subscription(this->node, sub);
        EXPECT_EQ(ret,RMW_RET_OK);
        */
    }
}