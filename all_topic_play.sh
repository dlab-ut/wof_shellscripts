# 各バグファイルのパス設定する
bags=(
    "/rosbag/cmd_vel_bag" 
    "/rosbag/joy_bag"
    "/rosbag/set_feedback_bag"
)

# 各バグファイルを再生
for bag in "${bags[@]}"; do
    ros2 bag play "$bag" &
done

wait  # 全ての再生が終了するまで待機