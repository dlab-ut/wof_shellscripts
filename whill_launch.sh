#!/bin/bash

source ~/.bashrc

# 動かなかったら
# echo 起動待ち
# sleep 1.0s

echo whill_bringup whill_launch.pyを起動します
# sudo chmod 777 /dev/ttyUSB0
ros2 launch whill_bringup whill_launch.py

bash 