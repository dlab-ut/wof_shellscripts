#!/bin/bash

YMD=`date "+%y-%m-%d"`
TIM=`date "+%T"`

source ~/.bashrc
cd ~/ros2_ws
source install/setup.bash

base_dir="/mnt/81947752-0abf-4e5c-8303-2bcc5733f8a5/Rosbag" #hddのパスに変更
save_path="${base_dir}/${YMD}/${TIM}"
echo bag_recorderを起動します
echo "${save_path} にbagを保存します"
mkdir -p "${save_path}"
cd "${save_path}"
ros2 launch whill_bringup bag_recoder_launch.py

bash


# 参考にしたプログラム
# tsukuba_challenge2022_kerberos2/terminator_config/scripts/bag_recorder_type_auto.sh

# #!/bin/bash
# #waypoint_publisher起動開始後にbag_recorderを起動する

# #bagを保存するディレクトリの指定（絶対パス）
# #record_dir=~/bagrecord/
# YMD=`date "+%y-%m-%d"`
# TIM=`date "+%T"`
# #source /opt/ros/*/setup.bash
# #source ~/catkin_ws/devel/setup.bash

# source ~/.bashrc

# echo kerberos_waypoint_publisher_cpmode起動待ち
# # sleep 18.0s
# # sleep 4.0s
# # sleep 9.0s
# ~/catkin_ws/src/tsukuba_challenge2022_kerberos2/terminator_config/scripts/next_prg.sh /tf

# echo bag_recorder_type_autoを起動します
# echo /mnt/d819d21e-af6c-4984-8857-6ea7139aaa17/bagrecord/${YMD}/${TIM} にbagを保存します
# mkdir -p /mnt/d819d21e-af6c-4984-8857-6ea7139aaa17/bagrecord/${YMD}/${TIM}
# cd /mnt/d819d21e-af6c-4984-8857-6ea7139aaa17/bagrecord/${YMD}/${TIM}

# roslaunch tsukuba_challenge2019_kerberos2 bag_recorder_type_auto.launch

# bash