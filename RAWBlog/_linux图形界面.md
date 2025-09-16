在 Ubuntu 系统中，你可以通过以下方法查看图形界面程序的运行状态：
### 1. 查看显示管理器状态

Ubuntu 的图形界面依赖于显示管理器（如 GDM、LightDM 等），可以通过 `systemctl` 命令检查其运行状态：
```bash
# 查看当前使用的显示管理器（通常是 gdm3 或 lightdm）
cat /etc/X11/default-display-manager

# 检查显示管理器状态
sudo systemctl status gdm3  # 若使用 gdm3
# 或
sudo systemctl status lightdm  # 若使用 lightdm
```
- 如果状态显示 `active (running)`，说明显示管理器正常运行
- 如果显示 `inactive (dead)` 或有错误，可尝试重启：
```bash
sudo systemctl restart gdm3  # 或 lightdm
```
### 2. 检查 X Server 运行状态

图形界面的核心是 X Server（Xorg），可以通过以下命令查看：
```bash
# 查看 Xorg 进程是否运行
ps -ef | grep Xorg

# 查看 X Server 日志（包含错误信息）
cat /var/log/Xorg.0.log | grep -i "error\|fail"
```

正常情况下会显示类似 `/usr/lib/xorg/Xorg` 的进程，日志中不应有严重错误（如 `Fatal server error`）。
### 3. 查看图形桌面环境进程

Ubuntu 常用的桌面环境是 GNOME 或 Unity，可检查其核心进程：
```bash
# 查看 GNOME 桌面进程
ps -ef | grep gnome-shell

# 查看桌面会话状态
logname  # 查看当前登录用户
w        # 查看所有登录会话（包括图形界面）
```

如果 `gnome-shell` 进程存在且正常运行，说明 GNOME 桌面环境基本正常。
### 4. 检查图形驱动状态

图形驱动异常也会导致界面无法显示，可通过以下命令检查：
```bash
# 对于 NVIDIA 显卡
nvidia-smi  # 查看驱动状态

# 对于 AMD/Intel 显卡
lspci | grep -i vga  # 查看显卡型号
glxinfo | grep "OpenGL vendor"  # 查看 OpenGL 驱动信息（需安装 mesa-utils）
```

如果命令无法执行或显示异常，可能是驱动未正确安装或加载。

### 5. 尝试重新初始化图形界面

如果发现服务异常，可尝试重新启动图形服务：
```bash
# 重启显示管理器（会强制注销当前图形会话）
sudo systemctl restart gdm3

# 若上述命令无效，可尝试 kill 所有 X 进程（谨慎使用）
sudo pkill Xorg
```

执行后显示器通常会短暂黑屏，然后重新初始化图形界面。

通过以上步骤，基本可以判断图形界面程序的运行状态并定位问题。如果日志中出现明确的错误信息（如驱动加载失败、权限问题等），可以针对性地进行修复。