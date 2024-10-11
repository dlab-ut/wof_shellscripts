#!/bin/bash

# 全ノードリストを取得
nodes=$(ros2 node list)

# ノードごとにパラメータをダンプしてファイルに保存
for node in $nodes
do
    # ノード名に基づいたYAMLファイルを作成
    sanitized_node_name=$(echo $node | tr '/' '_')  # '/'を'_'に置換
    output_file="${sanitized_node_name}_params.yaml"
    
    echo "Dumping parameters for node: $node"
    
    # パラメータを標準出力にダンプし、それをファイルに保存
    ros2 param dump $node > $output_file
done
