@echo off
echo %date% %time%: 脚本已启动 >> C:\Logs\bat_log.txt
chcp 65001
setlocal


set "GIT_BASH=D:\Program Files\Git\bin\bash.exe"

set "SCRIPT=/d/MyBlog/RAWBlog/scripts/pull_my_repos.sh"

echo 调用 Git Bash 执行脚本...
"%GIT_BASH%" -c "sh %SCRIPT%"

pause