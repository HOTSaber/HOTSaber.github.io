设置 `.gitignore` 文件可以帮助你指定 Git 忽略跟踪某些文件或文件夹。以下是如何设置 `.gitignore` 文件的步骤：


要永久让 Git 忽略 `source/_posts/.obsidian/workspace.json` 文件，需通过 ​**`.gitignore` 文件配置规则**并结合 ​**Git 缓存清理操作**。以下是具体步骤：

---

### 一、配置 `.gitignore` 文件

1. ​**创建或编辑 `.gitignore` 文件**  
    在项目根目录下创建 `.gitignore` 文件（若不存在），使用文本编辑器打开。
    
2. ​**添加忽略规则**  
    在文件中添加以下规则之一（根据需求选择）：
    
    gitignore
    
    复制
    
    ```gitignore
    # 精确匹配路径（推荐）
    source/_posts/.obsidian/workspace.json
    
    # 或忽略整个 .obsidian 目录下的 workspace.json
    .obsidian/workspace.json
    
    # 或忽略所有 .obsidian 目录中的内容（若需完全忽略该插件配置）
    .obsidian/
    ```
    
    - 使用 `/` 表示目录层级，`*` 可匹配通配符。
    - 注释以 `#` 开头，用于说明规则。

---

### 二、处理已跟踪的文件（若文件已被提交过）

如果该文件 ​**已被 Git 跟踪**​（即曾提交到仓库中），仅修改 `.gitignore` 无效，需执行以下操作：

bash

复制

```bash
# 从 Git 缓存中移除文件（保留本地文件）
git rm --cached source/_posts/.obsidian/workspace.json

# 提交删除操作到仓库
git commit -m "停止跟踪 workspace.json 文件"
```

---

### 三、提交并生效规则

1. ​**提交 `.gitignore` 文件**  
    将更新后的 `.gitignore` 提交到仓库，确保规则对所有协作者生效：
    
    bash
    
    复制
    
    ```bash
    git add .gitignore
    git commit -m "添加忽略 workspace.json 的规则"
    ```
    
2. ​**验证忽略效果**  
    执行 `git status`，确认该文件不再出现在未跟踪文件列表中。
    

---

### 四、注意事项

1. ​**路径匹配规则**
    
    - 规则中的路径需相对于 `.gitignore` 所在目录。
    - 若文件位于子目录中，需使用完整路径（如 `source/_posts/.obsidian/workspace.json`）。
2. ​**全局忽略配置（可选）​**  
    若需在所有项目中忽略此类文件，可配置全局忽略规则：
    
    bash
    
    复制
    
    ```bash
    git config --global core.excludesfile ~/.gitignore_global
    ```
    
    在 `~/.gitignore_global` 中添加相同规则。
    

---

### 五、常见问题

- ​**忽略规则不生效**：检查文件是否已被 Git 跟踪，若已跟踪需先执行 `git rm --cached`。
- ​**IDE 自动生成文件**：`.obsidian` 目录通常由笔记工具生成，建议直接忽略整个目录。

---

通过上述步骤，Git 将永久忽略该文件，避免后续提交冲突。若需恢复跟踪，只需从 `.gitignore` 中移除规则并重新添加文件。



1. **创建 `.gitignore` 文件**：  
    在项目根目录下创建一个名为 `.gitignore` 的文件。你可以使用文本编辑器（如 Notepad++、VSCode 等）来创建并编辑这个文件。
    
2. **添加忽略规则**：  
    在 `.gitignore` 文件中，你可以添加要忽略的文件或文件夹的规则。每个规则占一行。规则由通配符和模式匹配组成，用于匹配文件或文件夹名称以及定义要忽略的文件类型或特定内容。
    
    例如：
    
    - 忽略所有 `.txt` 文件：`*.txt`
    - 忽略名为 `temp` 的文件夹及其所有内容：`temp/`
    - 忽略所有 `.log` 文件和 `data` 文件夹：`*.log` 和 `data/`
    
    注意，规则前加上 `/` 表示目录，不加则表示文件或目录中的文件。
    
3. **保存并关闭文件**：  
    完成编辑后，保存 `.gitignore` 文件并关闭文本编辑器。
    
4. **测试规则**：  
    在 Git 仓库中尝试添加或修改被 `.gitignore` 忽略的文件或文件夹，然后使用 `git status` 命令查看 Git 是否跟踪了这些更改。如果被忽略的文件或文件夹没有出现在 `git status` 的输出中，那么说明 `.gitignore` 文件的设置是成功的。
    
5. **注意事项**：
    
    - 如果在设置 `.gitignore` 文件之前已经将某些文件或文件夹添加到了 Git 仓库并提交了更改，那么这些文件或文件夹仍会被 Git 跟踪。在这种情况下，你需要先使用 `git rm --cached <filename>` 命令将这些文件从 Git 的跟踪中移除。
    - 如果在添加 `.gitignore` 文件之后仍然看到被忽略的文件出现在 `git status` 的输出中，可能是因为 Git 的缓存还没有清除。你可以使用 `git rm --cached <filename>` 命令清除缓存，或者简单地使用 `git add .` 和 `git commit` 提交 `.gitignore` 文件的更改，然后再次检查。

通过以上步骤，你就可以成功设置 `.gitignore` 文件来忽略跟踪特定的文件或文件夹了。

## 语法
```
* 空格不匹配任意文件，可作为分隔符，可用反斜杠转义
* 开头的文件标识注释，可以使用反斜杠进行转义
* ! 开头的模式标识否定，该文件将会再次被包含，如果排除了该文件的父级目录，则使用 ! 也不会再次被包含。可以使用反斜杠进行转义
* / 结束的模式只匹配文件夹以及在该文件夹路径下的内容，但是不匹配该文件
* / 开始的模式匹配项目跟目录
* 如果一个模式不包含斜杠，则它匹配相对于当前 .gitignore 文件路径的内容，如果该模式不在 .gitignore 文件中，则相对于项目根目录
* ** 匹配多级目录，可在开始，中间，结束
* ? 通用匹配单个字符
* * 通用匹配零个或多个字符
* [] 通用匹配单个字符列表
```
## 示例
```
bin/: 忽略当前路径下的bin文件夹，该文件夹下的所有内容都会被忽略，不忽略 bin 文件
/bin: 忽略根目录下的bin文件
/*.c: 忽略 cat.c，不忽略 build/cat.c
debug/*.obj: 忽略 debug/io.obj，不忽略 debug/common/io.obj 和 tools/debug/io.obj
**/foo: 忽略/foo, a/foo, a/b/foo等
a/**/b: 忽略a/b, a/x/b, a/x/y/b等
!/bin/run.sh: 不忽略 bin 目录下的 run.sh 文件
*.log: 忽略所有 .log 文件
config.php: 忽略当前路径的 config.php 文件
```
### .gitignore规则不生效

.gitignore只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。

解决方法就是先把本地缓存删除（改变成未track状态），然后再提交:

```git
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```

**你想添加一个文件到Git，但发现添加不了，原因是这个文件被.gitignore忽略了：**

```git
$ git add App.class
The following paths are ignored by one of your .gitignore files:
App.class
Use -f if you really want to add them.
```

如果你确实想添加该文件，可以用-f强制添加到Git：

```git
$ git add -f App.class
```

或者你发现，可能是.gitignore写得有问题，需要找出来到底哪个规则写错了，可以用git check-ignore命令检查：

```git
$ git check-ignore -v App.class
.gitignore:3:*.class    App.class
```

Git会告诉我们，.gitignore的第3行规则忽略了该文件，于是我们就可以知道应该修订哪个规则。

### Java项目中常用的.gitignore文件

```git
# Compiled class file
*.class

# Eclipse
.project
.classpath
.settings/

# Intellij
*.ipr
*.iml
*.iws
.idea/

# Maven
target/

# Gradle
build
.gradle

# Log file
*.log
log/

# out
**/out/

# Mac
.DS_Store

# others
*.jar
*.war
*.zip
*.tar
*.tar.gz
*.pid
*.orig
temp/
```

### c++项目中常用的.gitignore

```git
# Prerequisites
*.d

# Compiled Object files
*.slo
*.lo
*.o
*.obj

# Precompiled Headers
*.gch
*.pch

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Fortran module files
*.mod
*.smod

# Compiled Static libraries
*.lai
*.la
*.a
*.lib

# Executables
*.exe
*.out
*.app

build/
.vscode/
```