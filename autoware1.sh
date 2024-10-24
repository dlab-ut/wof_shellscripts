cd ~/ros2_ws
source install/setup.bash
source ~/autoware/install/local_setup.bash
ros2 launch py_launch_wof autoware1.launch.py
# ros2 launch py_launch_wof autoware1.launch.py pointcloud_map_path:=$1
