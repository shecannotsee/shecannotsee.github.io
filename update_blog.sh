#!/bin/bash

for file in ./notes/*.md; do
    if [[ "$file" =~ ^./notes/[0-9]{4}-[0-9]{2}-[0-9]{2}- ]]; then
        # 文件名已经有日期了，提取出日期部分
        date_part=$(echo "$file" | grep -o "^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}")
        modified_date=$(stat -c %y "$file" | cut -d " " -f 1)
        new_name="./_posts/${modified_date}-${file#./notes/${date_part}-}"
    else
        # 文件名没有日期，直接添加日期
        modified_date=$(stat -c %y "$file" | cut -d " " -f 1)
        new_name="./_posts/${modified_date}-${file#./notes/}"
    fi

    # 检查是否存在同名文件
    if [[ -f "$new_name" ]]; then
        read -p "文件 $new_name 已经存在，是否覆盖？[y/n] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            continue
        fi
    fi

    # 创建新文件，包含添加的信息和原始文件内容
    echo "---" > "$new_name"
    echo "layout: post" >> "$new_name"
    echo "---" >> "$new_name"
    cat "$file" >> "$new_name"
done
