#!/bin/bash
cd ~/ros2_ws
source install/setup.bash
source ~/autoware/install/local_setup.bash
ros2 launch py_launch_wof autoware2.launch.py
