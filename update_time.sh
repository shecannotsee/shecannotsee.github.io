#!/bin/bash

# 检查是否提供了文件路径作为命令行参数
if [ $# -eq 0 ]; then
    echo "请提供文件路径作为命令行参数"
    exit 1
fi

file="$1"  # 使用第一个命令行参数作为文件路径

# 使用 stat 命令获取文件的更新时间并将其格式化为指定格式
update_time=$(stat -c %y "$file" | cut -d "." -f 1)

echo "文件 $file 的更新时间：$update_time"


