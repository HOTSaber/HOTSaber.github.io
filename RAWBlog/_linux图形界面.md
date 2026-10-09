在 Ubuntu 系统中，你可以通过以下方法查看图形界面程序的运行状态：
### 1. 查看显示管理器状态
```bash
# 1. 查看所有 GPU 
lspci -nn | grep -i vga 
	# 2. 查看 NVIDIA 卡型号（如果有） 
nvidia-smi 
# 3. 查看 DRM 设备（显示子系统） 
ls /dev/dri/ 
# 4. 查看内核日志中的 GPU 初始化 
dmesg | grep -i "nvidia\|drm\|edid"
# 5. 并可通过以下命令确认显示器被识别：
1xrandr --query
# 6. 以用户 ps 的身份运行 xrandr，并指定 DISPLAY=:0 2sudo -u ps DISPLAY=:0 xrandr --query
# 查看xorg log 
cat /var/log/Xorg.0.log
```

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
# 6. **允许 NVIDIA 在无显示器时创建虚拟屏幕**

生成一个支持 **headless 模式** 的配置：

```bash
sudo nvidia-xconfig \
    --allow-empty-initial-configuration \
    --enable-all-gpus \
    --use-display-device=none \
    --virtual=1920x1080
```

这会生成 `/etc/X11/xorg.conf`

#### 再重启显示管理器

```bash
sudo systemctl restart gdm   # 或你使用的 display manager
```


通过以上步骤，基本可以判断图形界面程序的运行状态并定位问题。如果日志中出现明确的错误信息（如驱动加载失败、权限问题等），可以针对性地进行修复。

# EDID强制注入
## 确认内核内置 EDID 文件确实存在

```
ls /lib/firmware/edid/
```

必须能看到 `1920x1080.bin`。如果没有，说明内核 firmware 包不全，需要装一下：

```
sudo apt install linux-firmware
```

## 创建xorg配置文件
```
sudo nano /etc/X11/xorg.conf.d/20-nvidia.conf
```


```
Section "Device"
    Identifier     "GPU0"
    Driver         "nvidia"
    BusID          "PCI:8A:0:0"
    Option         "AllowEmptyInitialConfiguration" "true"
    Option         "PrimaryGPU" "yes"
EndSection

Section "Monitor"
    Identifier     "HDMI-Monitor"
    HorizSync      28 - 80
    VertRefresh    48 - 75
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "GPU0"
    Monitor        "HDMI-Monitor"
    Option         "MetaModes" "1920x1080@60"
EndSection

Section "ServerLayout"
    Identifier     "Layout0"
    Screen         0 "Screen0"
EndSection
```

### 说明

1. `PrimaryGPU "yes"`：把这块 GPU0 设为主 GPU，Xorg 优先使用它输出画面。
2. `BusID "PCI:8A:0:0"`：严格对应你 GPU0 的 PCI 地址，不要写错。
3. `MetaModes "1920x1080@60"` 和前面 GRUB 的 1080P EDID 匹配。
4. 这个配置**配合你之前的内核 EDID 参数一起使用**，内核负责让 GPU1 的 HDMI-A-2 上电、识别 EDID；Xorg 配置负责指定 Xorg 渲染画面输出到 GPU0。
## 查看显卡端口名称

```
ls /sys/class/drm
```
你会看到类似 `card0-DP-1` / `card0-HDMI-A-1`。
## 编辑 GRUB

```
nano /etc/default/grub
```

找到 `GRUB_CMDLINE_LINUX_DEFAULT`，替换为下面整行（**删除旧的 vt.handoff=7，保留 nvidia-drm.modeset=1**）
## 直接用通用标准 EDID（不用读取你显示器的 EDID，省事）

内核自带内置 EDID 固件，不需要抓你显示器的原始 EDID，直接拿来用。 内置支持：`1920x1080@60`、`2560x1440@60`、`3840x2160@60`。 修改 grub 参数示例（1080P）：

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia-drm.modeset=1 drm.edid_firmware=HDMI-A-2:edid/1920x1080.bin video=HDMI-A-2:1920x1080@60e"
```

- `drm.edid_firmware=HDMI-A-1:edid/1920x1080.bin`：给 `card1-HDMI-A-1` 加载内置 1080P EDID
- `video=HDMI-A-1:1920x1080@60e`：启用该 HDMI 端口，强制分辨率 1080p60

> 如果你想要 4K 版本，替换成：`edid/3840x2160.bin video=HDMI-A-1:3840x2160@60e`
## 更新 GRUB 与 initramfs（**必须执行**）

```
sudo update-grub
sudo update-initramfs -u
```
## 确认你是否已经改过 grub 并重启

```
cat /proc/cmdline
```

# card 编号和 GPU 的对应关系

dmesg 里明确写了：

```
0000:8a:00.0 on minor 1 → card1  (GPU0)
0000:c3:00.0 on minor 2 → card2  (GPU1)
```

- `card0` = 板载 AST 显卡
- `card1` = GPU0 (8a:00.0)
- `card2` = GPU1 (c3:00.0)

# 最省事的解决方案：用 nvidia-xconfig 自动生成

NVIDIA 官方工具会自动检测显卡，生成正确的完整配置文件：

```
# 先生成完整 xorg.conf，自动绑定所有 NVIDIA 显卡
sudo nvidia-xconfig -a --use-display-device=None --connected-monitor=None

# 然后指定用 GPU1 作为主输出
sudo nvidia-xconfig --query-gpu-info | grep PCI
```

生成完之后，编辑 `/etc/X11/xorg.conf`，确认 Screen 段绑定的是 GPU1（PCI:C3:0:0）。

## 更直接的方法：先删掉我们手写的配置，让 nvidia-xconfig 接管

```
# 备份我们之前写的配置
sudo mv /etc/X11/xorg.conf.d/20-nvidia.conf /root/20-nvidia.conf.bak

# 用 nvidia-xconfig 自动生成
sudo nvidia-xconfig --allow-empty-initial-configuration

# 重启 gdm
sudo systemctl restart gdm
```

nvidia-xconfig 会自动检测两块 4090，自动选一块有显示输出的（Disp.A=On 的 GPU1）作为主屏幕。
# 桌面卡顿问题
查看是否是硬件加速
```
sudo -u ps DISPLAY=:0 glxinfo | grep "OpenGL renderer"
```
OpenGL renderer string: `llvmpipe` (LLVM 15.0.7, 256 bits)就是软件渲染
## 确认nvidia与xorg驱动版本一致

重装完之后：

```
# 内核驱动版本
cat /proc/driver/nvidia/version

# Xorg 驱动版本（看 .so 文件信息）
strings /usr/lib/x86_64-linux-gnu/nvidia/xorg/nvidia_drv.so | grep "NVIDIA.*Driver"
```
## 修复步骤

### 1. 重装 xserver-xorg-video-nvidia-550

```
sudo apt install --reinstall xserver-xorg-video-nvidia-550
```

### 2. 确认文件版本更新了

```
strings /usr/lib/x86_64-linux-gnu/nvidia/xorg/nvidia_drv.so | grep "NVIDIA.*Driver"
```

应该输出 `550.163.01`，不再是 `550.54.15`。
### 3. 顺便删掉旧版本固件包

```
sudo apt remove nvidia-firmware-550-550.54.15
```
## 彻底删除自定义 xorg.conf

只要存在 `/etc/X11/xorg.conf`，Xorg 就会强制加载手写配置，极易导致 nvidia 驱动探测失败。我们直接删掉，让 Xorg 使用**自动 autoconfig 模式**：

```
sudo rm -f /etc/X11/xorg.conf
sudo systemctl restart gdm
```
### 4. 重启 gdm

```
sudo systemctl restart gdm
```

nvidia 550 系列 + `nvidia-drm.modeset=1`，**推荐不再手动写 xorg.conf**。现代 Xorg 搭配 nvidia 驱动依靠 OutputClass 自动配置显卡，静态 xorg.conf 反而容易冲突，尤其多 GPU 环境（你两块 4090）。