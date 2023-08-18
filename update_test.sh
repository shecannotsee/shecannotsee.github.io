#!/bin/bash

for file in ./notes/*.md; do
    # 获取文件名（不包括路径和扩展名）
    filename=$(basename "$file")
    # 提取更新日期部分
    modified_date=$(date -r "$file" "+%Y-%m-%d")
    new_name="./_posts/${modified_date}-${filename}"

    # 检查是否存在对应的文件
    if [[ -f "$new_name" ]]; then
        # 获取对应文件的更新日期部分
        existing_date=$(basename "$new_name" | cut -d "-" -f 1-3)
        if [[ "$existing_date" != "$modified_date" ]]; then
            read -p "文件 $new_name 已存在，是否更新为新的文件？[y/n] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "---" > "$new_name"
                echo "layout: post" >> "$new_name"
                echo "categories: blog" >> "$new_name"
                echo "---" >> "$new_name"
                cat "$file" >> "$new_name"
                echo "文件 $new_name 更新完成"
            fi
        fi
    fi
done

