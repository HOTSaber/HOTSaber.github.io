#!/bin/bash

# 定义要 push 的目录列表（Windows 路径需转换为 Git Bash 可识别的格式）
repos=(
    "/d/MyBlog"
    "/d/pyproject/AI_policy"
)

echo "开始执行 git push 操作..."
echo "提示：如不输入 commit 信息，将使用日期作为默认值"
echo

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
            # 检查是否有未提交的更改
            if [ -n "$(git status --porcelain)" ]; then
                echo "执行 git add..."
                git add .
                
                echo "执行 git commit..."
                git commit -m "$REPO_COMMIT_MSG"
                
                # 尝试执行 git push，支持失败后重试
                max_retries=3
                retry_count=0
                push_success=false
                
                while [ $retry_count -lt $max_retries ] && [ $push_success = false ]; do
                    echo "执行 git push... (尝试 $((retry_count + 1))/$max_retries)"
                    git push
                    
                    if [ $? -eq 0 ]; then
                        echo "成功: $repo 推送完成"
                        push_success=true
                    else
                        echo "错误: $repo 推送失败"
                        
                        # 不是最后一次尝试时，询问用户是否继续重试
                        if [ $retry_count -lt $((max_retries - 1)) ]; then
                            echo -n "是否要重新尝试推送？(y/n): "
                            read retry_choice
                            
                            # 如果用户输入不是 y 或 Y，停止重试
                            if [ "$retry_choice" != "y" ] && [ "$retry_choice" != "Y" ]; then
                                break
                            fi
                        else
                            echo "已达到最大重试次数 ($max_retries)，停止重试"
                        fi
                        
                        retry_count=$((retry_count + 1))
                    fi
                done
            else
                echo "无需操作: $repo 工作树干净，没有需要提交的更改"
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