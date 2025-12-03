@echo off

chcp 65001

setlocal

:: 使用正确的Git Bash解释器路径
set "GIT_BASH=D:\Program Files\Git\bin\bash.exe"
:: 使用Git Bash可识别的Unix风格路径
set "SCRIPT=/d/MyBlog/RAWBlog/scripts/push_my_repos.sh"

echo 调用 Git Bash 执行脚本...
"%GIT_BASH%" -c "sh %SCRIPT%"

pause