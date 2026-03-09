#!/bin/bash

# 定义要 pull 的目录列表（Windows 路径需转换为 Git Bash 可识别的格式）
repos=(
    "/d/MyBlog"
    "/d/pyproject/AI_policy"
    "/d/pyproject/AI_policy/novel"
)

# 定义对应的 GitHub 仓库 URL（与本地路径一一对应）
repos_url=(
    "https://github.com/HOTSaber/HOTSaber.github.io.git"
    "https://github.com/HOTSaber/AI_policy.git"
    "https://github.com/HOTSaber/novel.git"
)

echo "开始执行 git pull 操作..."

for i in "${!repos[@]}"; do
    repo="${repos[$i]}"
    repo_url="${repos_url[$i]}"
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
        echo "尝试从 GitHub 克隆仓库到 $repo..."
        
        # 创建父目录
        parent_dir="$(dirname "$repo")"
        if [ ! -d "$parent_dir" ]; then
            echo "创建父目录: $parent_dir"
            mkdir -p "$parent_dir"
        fi
        
        # 克隆仓库
        git clone "$repo_url" "$repo"
        
        if [ $? -eq 0 ]; then
            echo "成功: 从 $repo_url 克隆到 $repo"
            cd "$repo" || { echo "无法进入目录 $repo"; continue; }
            echo "无需操作: 新克隆的仓库，工作树干净"
        else
            echo "错误: 克隆仓库失败，请检查网络连接或仓库 URL 是否正确"
        fi
    fi
done

echo "所有操作已完成！"