在Ubuntu上安装NVIDIA驱动程序通常可以通过以下步骤进行：

1. 打开终端。
    
2. 确保系统是最新的：
    
    ```
    sudo apt updatesudo apt upgrade
    ```
    
3. 添加NVIDIA PPA（可选，推荐）：
    
    ```
    sudo add-apt-repository ppa:graphics-drivers/ppasudo apt update
    ```
    
4. 安装NVIDIA驱动程序：
    
    ```
    sudo ubuntu-drivers autoinstall
    ```
    
    或者，使用`apt`搜索可用驱动程序并选择安装：
    
    ```
    ubuntu-drivers devicessudo apt install nvidia-driver-XXX
    ```
    
    其中`xxx`是你想要安装的驱动程序版本，这里用335版本。
    
5. 重启计算机：
    
    ```
    sudo reboot
    ```
    

安装完成后，你可以通过运行以下命令来验证驱动程序是否成功安装：

```
nvidia-smi
```

这将显示已安装的NVIDIA驱动程序的信息。