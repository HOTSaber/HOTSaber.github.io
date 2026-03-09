#!/bin/bash

# 定义要 pull 的目录列表（Windows 路径需转换为 Git Bash 可识别的格式）
repos=(
    "/d/MyBlog/HOTSaber.github.io"
    "/d/pycharmproject/AI_policy"
    "/d/pycharmproject/AI_policy/novel"
)

echo "开始执行 git pull 操作..."

for repo in "${repos[@]}"; do
    echo "----------------------------------------"
    echo "正在处理目录: $repo"
    
    if [ -d "$repo" ]; then
        cd "$repo" || { echo "无法进入目录 $repo"; continue; }
        
        if [ -d ".git" ]; then
            max_retries=3
            retry_count=0
            pull_success=false
            
            while [ $retry_count -lt $max_retries ] && [ $pull_success = false ]; do
                echo "执行 git pull... (尝试 $((retry_count + 1))/$max_retries)"
                git pull
                
                if [ $? -eq 0 ]; then
                    echo "git pull 成功！"
                    pull_success=true
                else
                    retry_count=$((retry_count + 1))
                    
                    if [ $retry_count -lt $max_retries ]; then
                        read -p "git pull 失败，是否重试？(y/N): " retry_answer
                        if [[ ! "$retry_answer" =~ ^[Yy]$ ]]; then
                            echo "用户取消重试，跳过该仓库"
                            break
                        fi
                    else
                        echo "已达到最大重试次数 ($max_retries)，跳过该仓库"
                    fi
                fi
            done
        else
            echo "警告: $repo 不是一个 Git 仓库（缺少 .git 目录）"
        fi
    else
        echo "错误: 目录 $repo 不存在"
    fi
done

echo "所有操作已完成！"