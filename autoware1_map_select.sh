#!/bin/bash
source ~/ros2_ws/install/setup.bash
source ~/autoware/install/local_setup.bash

# ベースのディレクトリ（デフォルトのパス）
default_map_dir="/home/door/ros2_ws/src/map/"

# 第一引数が提供されているか確認し、無ければデフォルトを使用
if [ -n "$1" ]; then
    map_dir="$1"
    # 第一引数のパスがスラッシュで終わっているか確認
    if [[ "$map_dir" != */ ]]; then
        map_dir="$map_dir/"  # 末尾に / を追加
    fi
else
    map_dir="$default_map_dir"
fi

serch_dir=$map_dir
while true; do
    search_level=$(echo "$serch_dir" | tr -cd '/' | wc -c) 
    # PCDファイルのパスを再帰的に取得
    pcd_files=($(find "$serch_dir" -name "*.pcd"))

    # PCDファイルのリストがあるかチェック
    if [ ${#pcd_files[@]} -eq 0 ]; then
        echo -e "\033[32mPCDファイルが見つかりません。\033[0m"  # 緑色で表示
        exit 1
    fi
    # 1つ下の階層を抽出して一意にする
    top_level_dirs=($(for file in "${pcd_files[@]}"; do echo "${file}" | cut -d'/' -f $((search_level + 1)) ; done | sort -u))

    # ディレクトリのリストを表示
    echo -e "\033[32m以下のディレクトリがあります：\033[0m"
    for i in "${!top_level_dirs[@]}"; do
        echo "$i: ${top_level_dirs[$i]}"
    done

    # 前の操作に戻るオプションを追加
    echo "99: 前の操作に戻る"
    # ユーザーにディレクトリを選択させる（緑色で表示）
    read -p $'\033[32mどのパスを使用しますか？: \033[0m' dir_index

    # 選択されたPCDファイルのフルパス
    if [[ "$dir_index" -eq 99 ]]; then
        echo "前の操作に戻ります..."
        serch_dir="$(echo "$serch_dir" | sed 's/\/$//' | rev | cut -d'/' -f2- | rev)/"
        echo $serch_dir
        
    # 選択されたディレクトリのフルパス
    elif [[ -n "${top_level_dirs[$dir_index]}" ]]; then
        serch_dir="$serch_dir${top_level_dirs[$dir_index]}"

        if [[ "$serch_dir" == *.pcd ]]; then #選択されたパスがさらに階層をもたないとき
            selected_pcd=$serch_dir
            echo "選択されたPCDファイル: $selected_pcd"
            break  # スクリプトを終了
        else
            echo "選択されたディレクトリ: $serch_dir"
            serch_dir="$serch_dir/"
        fi 
    else
        echo "無効な番号です。再度選択してください。"
    fi
done
# 実行確認のプロンプトを追加
read -p "このパスで実行しますか？ (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "終了します。"
    exit 1  # スクリプトを終了
fi
# ROS2 launchコマンドを実行し、選択されたPCDファイルのパスを渡す
ros2 launch py_launch_wof autoware1.launch.py pointcloud_map_path:=$selected_pcd