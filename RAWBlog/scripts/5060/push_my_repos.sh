#!/bin/bash

# 定义要 push 的目录列表（Windows 路径需转换为 Git Bash 可识别的格式）
repos=(
    "/d/MyBlog/HOTSaber.github.io"
    "/d/pycharmproject/AI_policy"
)

# 遍历所有要 push 的目录
for repo in "${repos[@]}"; do
    echo "----------------------------------------"
    echo "正在处理目录: $repo"
    
    # 获取当前日期作为默认 commit 信息
    DEFAULT_COMMIT_MSG="更新 $(date +"%Y-%m-%d %H:%M:%S")"
    
    echo -n "请输入 $repo 的 commit 信息: "
    read REPO_COMMIT_MSG
    
    # 如果用户未输入 commit 信息，使用默认值
    if [ -z "$REPO_COMMIT_MSG" ]; then
        REPO_COMMIT_MSG="$DEFAULT_COMMIT_MSG"
    fi
    
    echo "$repo 使用的 commit 信息: $REPO_COMMIT_MSG"
    
    if [ -d "$repo" ]; then
        cd "$repo" || { echo "无法进入目录 $repo"; continue; }
        
        if [ -d ".git" ]; then
            echo "执行 git add..."
            git add .
            
            echo "执行 git commit..."
            git commit -m "$REPO_COMMIT_MSG"
            
            echo "执行 git push..."
            git push
            
            if [ $? -eq 0 ]; then
                echo "成功: $repo 推送完成"
            else
                echo "错误: $repo 推送失败"
            fi
        else
            echo "警告: $repo 不是一个 Git 仓库（缺少 .git 目录）"
        fi
    else
        echo "错误: 目录 $repo 不存在"
    fi
done

echo "----------------------------------------"
echo "所有操作已完成！"