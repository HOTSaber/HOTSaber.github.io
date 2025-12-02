****
自动拉取与更新脚本使用说明
****
当前surface相关路径为:
```
D:\Program Files\Git\cmd\git-bash.exe
D:\MyBlog\RAWBlog
D:\pyproject\AI_policy
D:\MyBlog\RAWBlog\scripts
```

```
/d/Program Files/Git/cmd/git-bash.exe
/d/MyBlog/RAWBlog
/d/pyproject/AI_policy
/d/MyBlog/RAWBlog/scripts
```
当前5060相关路径为:
```
D:\Program Files\Git\cmd\git-bash.exe
D:\MyBlog\RAWBlog
D:\pyproject\AI_policy
D:\MyBlog\RAWBlog\scripts
```

```
/d/Program Files/Git/cmd/git-bash.exe
/d/MyBlog/RAWBlog
/d/pyproject/AI_policy
/d/MyBlog/RAWBlog/scripts
```
# sh文件
需要在`git bash`中运行
```
cd /d/scripts chmod +x pull_my_repos.sh # （可选）赋予执行权限 ./pull_my_repos.sh
```
**注意：在 Git Bash 中，Windows 的 `D:\` 对应的是 `/d/`，所以路径要写成 `/d/MyBlog/RAWBlog`。**
# bat文件
在`window`下可以双击运行的批处理文件
- 自动调用 **Git Bash**
- 在 Git Bash 中运行你刚才的 `git pull` 脚本（或直接执行命令）
- 无需手动打开终端
## pull_my_repos.bat
直接执行git命令，无需sh脚本
# pull_my_repos_usesh.bat
执行sh脚本，需要配置好sh脚本内容与位置

# 开机自启动
打开 `C:\Users\username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\`，将`bat`文件或其快捷⽅式粘贴进去
# 固定在开始菜单
打开 `C:\Users\aucnm\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\`，将`bat`文件的`快捷⽅式`粘贴进去

# push功能同理

# 脚本确定后忽略脚本变动
需要修改 .gitignore 文件，添加忽略 scripts 目录下的 bat 和 sh 文件的规则。
```
RAWBlog/scripts/*.bat
RAWBlog/scripts/*.sh
```
