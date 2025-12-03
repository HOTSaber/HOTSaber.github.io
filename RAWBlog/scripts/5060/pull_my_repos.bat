@echo off
setlocal

echo 开始执行 git pull 操作...

:: 定义 Git 的路径
set "GIT_PATH=D:\Program Files\Git\bin\bash.exe"

:: 定义仓库路径
set "REPO1_PATH=D:\MyBlog\HOTSaber.github.io"
set "REPO2_PATH=D:\pycharmproject\AI_policy"

:: 检查 git 是否存在
if not exist "%GIT_PATH%" (
    echo 错误：未找到 Git。请检查安装路径是否正确。
    pause
    exit /b 1
)

:: 执行第一个仓库的 pull
echo.
echo [1/2] 正在拉取 %REPO1_PATH% ...
cd /d "%REPO1_PATH%"
if exist ".git" (
    "%GIT_PATH%" pull
    if errorlevel 1 (
        echo 警告：拉取 %REPO1_PATH% 时出现错误！
        set "ERROR_OCCURRED=true"
    )
) else (
    echo 警告：%REPO1_PATH% 不是一个有效的 Git 仓库！
    set "ERROR_OCCURRED=true"
)

:: 执行第二个仓库的 pull
echo.
echo [2/2] 正在拉取 %REPO2_PATH% ...
cd /d "%REPO2_PATH%"
if exist ".git" (
    "%GIT_PATH%" pull
    if errorlevel 1 (
        echo 警告：拉取 %REPO2_PATH% 时出现错误！
        set "ERROR_OCCURRED=true"
    )
) else (
    echo 警告：%REPO2_PATH% 不是一个有效的 Git 仓库！
    set "ERROR_OCCURRED=true"
)

echo.
if defined ERROR_OCCURRED (
    echo 注意：部分仓库更新失败，请检查错误信息！
) else (
    echo 所有仓库已成功更新完成！
)
pause