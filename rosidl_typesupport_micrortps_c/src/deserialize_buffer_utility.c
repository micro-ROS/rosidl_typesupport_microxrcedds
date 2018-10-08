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

#include <stdint.h>
#include <stdio.h>
#include <string.h>


static size_t buffer_size_ = 0;
static uint8_t* buffer_ = NULL;
static uint8_t* write_pointer_ = NULL;


static uint8_t* AlignPointer(uint8_t* intput_pointer)
{
	size_t word_size = sizeof(int);
	uint8_t* aling_pointer = (uint8_t*)(((size_t)intput_pointer / word_size) * word_size);

	if (intput_pointer > aling_pointer)
	{
			aling_pointer += word_size;
	}

	return aling_pointer; 
}



void ResetBuffer(void* buffer, size_t buffer_size)
{
	buffer_size_ = buffer_size;
	buffer_ = buffer;
	write_pointer_ = AlignPointer(buffer);
}


void* GetWritePointer(size_t* bytes_available)
{
	// Check if there is a buffer
	if (buffer_ == NULL)
	{
		return NULL;
	}

	
	if (bytes_available != NULL)
	{
		*bytes_available = (buffer_ + buffer_size_) - write_pointer_;
	}

	
	return write_pointer_;
}


void DecreaseAvailableBuffer(size_t used_bytes)
{
	write_pointer_ += (used_bytes);
	write_pointer_ = AlignPointer(write_pointer_);
}


