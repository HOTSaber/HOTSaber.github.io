要将本地文件夹使用Git推送到GitHub仓库，并以当前文件夹名新建一个私人仓库，你可以按照以下步骤操作：

### 第一步：在GitHub上创建新的私人仓库

1. 登录到你的GitHub账户。
2. 点击页面右上角的`+`图标，选择“New repository”（新建仓库）。
3. 在“Repository name”中输入你的本地文件夹名。
4. 确保将仓库设置为“Private”（私人）。
5. 你可以选择初始化仓库时添加`.gitignore`文件和`README.md`文件，也可以稍后添加。
6. 点击“Create repository”按钮创建仓库。

### 第二步：在本地设置Git仓库

1. 打开命令行工具（如终端或命令提示符），并导航到你的本地文件夹。
2. 初始化Git仓库：
    
    ```bash
    git init
    ```
    
3. 将所有文件添加到Git仓库：
    
    ```bash
    git add .
    ```
    
4. 提交更改：
    
    ```bash
    git commit -m "Initial commit"
    ```
    

### 第三步：将本地仓库与GitHub仓库关联

1. 在GitHub上，复制你新建仓库的远程仓库URL。这通常在仓库页面的右侧，标有“HTTPS”或“SSH”的部分。
2. 在本地命令行中，使用`git remote add`命令将本地仓库与远程仓库关联：
    
    ```bash
    git remote add origin <your-remote-repository-url>
    ```
    
    将`<your-remote-repository-url>`替换为你在GitHub上复制的URL。

### 第四步：推送本地仓库到GitHub

1. 使用`git push`命令将本地仓库推送到GitHub：
    
    ```bash
    git push -u origin master
    ```
    
    注意：如果你使用的是较新版本的Git和GitHub，可能会使用`main`分支代替`master`分支。如果是这样，请相应地更改命令。

完成上述步骤后，你的本地文件夹应该已经被推送到GitHub上的新私人仓库中了。你可以在GitHub上查看仓库内容，并进行后续的版本控制操作。