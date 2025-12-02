@echo off

chcp 65001

setlocal


set "GIT_BASH=D:\Program Files\Git\bin\bash.exe"

set "SCRIPT=/d/MyBlog/HOTSaber.github.io/RAWBlog/scripts/pull_my_repos.sh"

echo 调用 Git Bash 执行脚本...
"%GIT_BASH%" -c "sh %SCRIPT%"

pause