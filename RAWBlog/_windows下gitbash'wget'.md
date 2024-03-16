*****
在 Git Bash 中运行命令时，如果遇到了 `wget: command not found` 的错误，这通常意味着 `wget` 并没有在 Git Bash 中安装。Git Bash 是 Windows 系统上模拟 Bash shell 环境的工具，它并不包含所有 Linux 系统中的命令，包括 `wget`。
*****
# windows下安装wget
## 安装chocolatey
****
Chocolatey是Windows的包管理器，类似于Linux中的apt或yum。它允许你从命令行安装应用程序、工具和实用程序，并自动处理依赖关系。虽然Chocolatey本身不直接提供MinGW或Cygwin，但你可以使用它来安装这些工具。
****
**安装**：

1. 打开Windows PowerShell（以管理员身份运行）。
2. 运行以下命令来安装Chocolatey：
    
    ```powershell
    powershell复制代码Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ```
    
3. 安装完成后，你可以使用`choco install`命令来安装各种软件包，比如`choco install mingw`或`choco install cygwin`（如果可用的话）。
## 在git bash中安装wget
1. 使用管理员打开powershell
2. 使用以下命令安装wget
```
choco install wget
```