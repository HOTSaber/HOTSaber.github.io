****
Failed to initialize NVML
参考[# Nvidia显卡Failed to initialize NVML Driver/library version mismatch错误解决方案](https://blog.csdn.net/weixin_54104864/article/details/134272887)与[# 解决nvidia-smi “Failed to initialize NVML: Driver/library version mismatch”](https://blog.csdn.net/jingjm00/article/details/135865160)
****
# 更新驱动
使用以下命令，查看系统推荐驱动版本：
```
ubuntu-drivers devices
```
根据ubuntu-drivers devices的输出，如`nvidia-driver-550 - third-party non-free recommended`是为你的设备推荐的驱动程序。除非有特别需求，通常建议安装推荐的驱动版本。

使用以下命令安装推荐的驱动程序：
```
sudo apt-get update
sudo apt-get install nvidia-driver-550
```

如果你已经安装了其他版本的驱动程序，可能需要先卸载它们：
```
sudo apt-get remove --purge '^nvidia-.*'
```
然后，安装新的驱动程序。
重启计算机
安装新驱动程序后，重启计算机以确保新驱动程序正确加载：
```
sudo reboot
```
验证安装
重新启动后，运行nvidia-smi来检查新驱动是否已正确安装并且正在运行：
```
nvidia-smi
```
# 取消自动更新设置
1. 然后，安装新的驱动程序。
重启计算机
安装新驱动程序后，重启计算机以确保新驱动程序正确加载：
```
sudo reboot
```
验证安装
重新启动后，运行nvidia-smi来检查新驱动是否已正确安装并且正在运行：
```
nvidia-smi
```
2. 禁止自动升级

修改配置文件/etc/apt/apt.conf.d/10periodic
```
#０是关闭，1是开启，将所有值改为0
vi etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists “0”;
APT::Periodic::Download-Upgradeable-Packages “0”;
APT::Periodic::AutocleanInterval “0”;
```
执行命令：
```
sudo apt-mark hold linux-image-generic linux-headers-generic
```
使用 apt-mark hold

apt-mark hold 命令可以帮助我们锁定某个软件包的版本，这样就可以防止 Ubuntu 自动更新该软件包。在这种情况下，我们可以使用 `apt-mark hold` 命令来锁定显卡驱动软件包的版本，从而防止 Ubuntu 自动更新显卡驱动。具体操作步骤如下：

打开终端，使用以下命令来查看当前安装的显卡驱动软件包：
```
dpkg -l | grep -i nvidia
```
执行以下命令将该软件包的版本锁定：
```
sudo apt-mark hold
```
其中， 表示需要锁定的显卡驱动软件包的名称，例如：nvidia-driver-450。

如果需要解除锁定，我们可以使用以下命令：
```
sudo apt-mark unhold
```
需要注意的是，该方法只会禁止 Ubuntu 自动更新显卡驱动，如果我们需要安装更新版本的显卡驱动，则需要手动执行`apt-get update` 和 `apt-get upgrade` 命令

****
在 Ubuntu 中禁用 NVIDIA 驱动的自动更新，可以通过以下方法实现。具体步骤取决于你的驱动安装方式（如通过官方仓库、PPA 或手动安装的 `.run` 文件）。

---

### ​**方法一：通过 `apt-mark` 锁定驱动版本（推荐）​**

如果通过 ​**Ubuntu 仓库** 或 ​**PPA** 安装 NVIDIA 驱动，使用 `apt-mark` 工具阻止自动更新：

#### ​**1. 查看当前安装的 NVIDIA 驱动包**

bash

```bash
dpkg -l | grep -E "nvidia-(driver|utils|dkms|kernel)"
```

输出示例：

```
ii  nvidia-driver-535               535.171.04-0ubuntu0.22.04.1    amd64        NVIDIA driver metapackage
ii  nvidia-utils-535                535.171.04-0ubuntu0.22.04.1    amd64        NVIDIA utilities
```

#### ​**2. 锁定驱动包版本**

bash

```bash
sudo apt-mark hold nvidia-driver-535 nvidia-utils-535 nvidia-dkms-535
```

- ​**说明**：将 `nvidia-driver-535` 替换为你的实际驱动包名。

#### ​**3. 验证锁定状态**

bash

```bash
apt-mark showhold
```

输出应显示已锁定的包名。

---

### ​**方法二：禁用 `unattended-upgrades` 更新 NVIDIA 驱动**

如果使用 ​**自动安全更新**​（`unattended-upgrades`），需配置其忽略 NVIDIA 包：

#### ​**1. 编辑配置文件**

bash

```bash
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

#### ​**2. 修改 `Unattended-Upgrade` 部分**

找到 `Unattended-Upgrade::Package-Blacklist` 并添加正则表达式：

conf

```conf
Unattended-Upgrade::Package-Blacklist {
    "nvidia-driver-.*";
    "nvidia-utils-.*";
    "nvidia-dkms-.*";
};
```

#### ​**3. 重启自动更新服务**

bash

```bash
sudo systemctl restart unattended-upgrades
```

---

### ​**方法三：手动安装驱动时禁用更新**

如果通过 ​**NVIDIA 官方 `.run` 文件手动安装**，系统不会通过 `apt` 自动更新驱动，但需确保：

#### ​**1. 移除 NVIDIA 相关软件源**

检查是否添加了第三方仓库（如 `graphics-drivers/ppa`）：

bash

```bash
ls /etc/apt/sources.list.d/
```

若有相关文件（如 `graphics-drivers-ubuntu-ppa-*.list`），​**删除或注释**其内容：

bash

```bash
sudo nano /etc/apt/sources.list.d/graphics-drivers-ubuntu-ppa-jammy.list
```

在每行前添加 `#` 注释符号：

conf

```conf
# deb https://ppa.launchpadcontent.net/graphics-drivers/ppa/ubuntu/ jammy main
```

#### ​**2. 更新软件列表**

bash

```bash
sudo apt update
```

---

### ​**方法四：完全禁用自动更新（不推荐）​**

**仅限临时使用**，长期禁用可能导致系统安全隐患：

bash

```bash
sudo systemctl stop unattended-upgrades
sudo systemctl disable unattended-upgrades
```

---

### ​**恢复自动更新**

若需重新启用 NVIDIA 驱动的自动更新：

bash

```bash
# 解除包版本锁定
sudo apt-mark unhold nvidia-driver-535 nvidia-utils-535

# 恢复软件源（如果之前注释了）
sudo nano /etc/apt/sources.list.d/graphics-drivers-ubuntu-ppa-jammy.list
# 删除行首的 `#` 符号

# 更新软件列表
sudo apt update
```

---

### ​**总结**

- ​**推荐方案**：通过 `apt-mark hold` 锁定驱动版本（方法一）并配置 `unattended-upgrades` 黑名单（方法二）。
- ​**手动安装驱动**：确保移除第三方软件源（方法三）。
- 定期手动检查驱动更新，尤其是在升级内核或 CUDA 工具包时。