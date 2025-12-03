#!/bin/bash

# 定义要 pull 的目录列表（Windows 路径需转换为 Git Bash 可识别的格式）
repos=(
    "/d/MyBlog"
    "/d/pyproject/AI_policy"
)

echo "开始执行 git pull 操作..."

for repo in "${repos[@]}"; do
    echo "----------------------------------------"
    echo "正在处理目录: $repo"
    
    if [ -d "$repo" ]; then
        cd "$repo" || { echo "无法进入目录 $repo"; continue; }
        
        if [ -d ".git" ]; then
            echo "执行 git pull..."
            git pull
        else
            echo "警告: $repo 不是一个 Git 仓库（缺少 .git 目录）"
        fi
    else
        echo "错误: 目录 $repo 不存在"
    fi
done

echo "所有操作已完成！"