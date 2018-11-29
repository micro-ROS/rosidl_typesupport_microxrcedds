# ROSIDL type support for Micro XRCE-DDS

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

All packages contained in this repository are a part of the Micro-ROS project stack.
For more information about Micro-ROS project click [here](https://microros.github.io/micro-ROS/).

## Packages

The repository contains the following packages:

### rmw_typesupport_microxrcedds_c

This package aims to give support to the rmw layer for ros messages in C language.

#### Includes

- Support for serialization / serialization code, generated during the build process, for each ROS 2 interface.
- Support for unbounded types for incoming messages using static memory.
- Support for building message support using ament extensions for finding not built interfaces.

Only support msg interfaces for now. ROS 2 services are not yet supported.

#### Documentation

You can access the documentation online, which is hosted on [Read the Docs]().
