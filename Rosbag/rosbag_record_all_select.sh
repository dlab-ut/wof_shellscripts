#!/bin/bash
# YAMLファイルのパス
YAML_FILE="base_dirs.yaml"
# YAMLファイルから既存のディレクトリを読み込む（存在する場合）
if [[ -f $YAML_FILE ]]; then
    mapfile -t base_dirs < <(yq eval '.base_dirs[]' "$YAML_FILE")
else
    # 初期値を設定
    base_dirs=(
        "/mnt/81947752-0abf-4e5c-8303-2bcc5733f8a5/Rosbag"
        "/home/door/ros2_ws/Rosbag"
    )
fi

# 配列を表示
for i in "${!base_dirs[@]}"; do
    echo "$i: ${base_dirs[$i]}"
done
echo "99: 入力する"
# ユーザーにディレクトリを選択させる（緑色で表示）
read -p $'\033[32mどのパスを使用しますか？: \033[0m' dir_index
# 入力が99の場合、ユーザーに新しいパスを入力させる
if [[ "$dir_index" == "99" ]]; then
    # 補完の設定
    _path_completion() {
        COMPREPLY=($(compgen -o dirnames -- "${COMP_WORDS[COMP_CWORD]}"))
    }
    complete -F _path_completion read

    # ここで新しいパスの入力を促す
    read -e -p $'\033[32m追加するパスを入力してください: \033[0m' new_dir

    # 新しいパスが既存のパスと異なる場合のみ追加
    if [[ ! " ${base_dirs[@]} " =~ " ${new_dir} " ]]; then
        base_dir=$new_dir
    else
        echo "パス '$new_dir' は既に存在します。"
    fi
elif [[ -n "${base_dirs[$dir_index]}" ]]; then
    base_dir="${base_dirs[$dir_index]}"
else
    echo "無効な入力です。"
    exit 1  # 無効な入力の場合は終了
fi

echo "現在のbase_dir: $base_dir"

save_path="${base_dir}/${YMD}/${TIM}/topic"
echo bag_recorderを起動します
echo "${save_path} にbagを保存します"
mkdir -p "${save_path}"
cd ~/ros2_ws
source install/setup.bash
cd "${save_path}"
# マージ用のファイル作成
mkdir ../merge 
cat <<EOL > ../merge/merge_example.sh
ros2 bag convert -i ../topic/tf/ -i ../topic/velodyne_points/ -o tf_velodyne.yaml
EOL

cat <<EOL > ../merge/tf_velodyne.yaml
output_bags:
- uri: tf_tf_static_velodyne  # マージ後のバッグファイル名
  all_topics: true  # すべてのトピックを含む
  all_services: true  # すべてのサービスを含む
EOL

ros2 launch py_launch_wof topic_separated_record_launch.py 