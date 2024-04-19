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
从您的输出中可以看到，有多个NVIDIA驱动程序可用，适用于您的NVIDIA设备。这些驱动程序中，一些是由发行版提供的开源版本（标记为open和free），另一些则是NVIDIA提供的专有版本（标记为non-free）。recommended标签表示建议使用的驱动版本。
为了解决之前提到的Failed to initialize NVML: Driver/library version mismatch错误，你应该确保安装的驱动程序版本与你的CUDA版本相兼容。这里是如何选择和安装最合适的驱动程序的步骤：
选择正确的驱动程序
检查CUDA兼容性: 首先，确定你将使用哪个版本的CUDA，并查看NVIDIA官方文档，了解哪个版本的驱动程序与之兼容。
选择推荐的驱动: 根据ubuntu-drivers devices的输出，nvidia-driver-550 - third-party non-free recommended是为你的设备推荐的驱动程序。除非有特别需求，通常建议安装推荐的驱动版本。
安装驱动程序
使用以下命令安装推荐的驱动程序：
bashCopy code
sudo apt-get update
sudo apt-get install nvidia-driver-550
卸载旧驱动
如果你已经安装了其他版本的驱动程序，可能需要先卸载它们：
bashCopy code
sudo apt-get remove --purge '^nvidia-.*'
然后，安装新的驱动程序。
重启计算机
安装新驱动程序后，重启计算机以确保新驱动程序正确加载：
bashCopy code
sudo reboot
验证安装
重新启动后，运行nvidia-smi来检查新驱动是否已正确安装并且正在运行：
bashCopy code
nvidia-smi