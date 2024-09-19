#!/bin/bash

source ~/.bashrc
# sudo chmod 777 /dev/ttyUSB0
ros2 launch whill_bringup whill_launch.py
ros2 run joy joy_node --ros-args -r /joy:=/whill/controller/joy