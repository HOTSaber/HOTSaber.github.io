# **检查U盘**

在终端中，输入以下命令来列出所有可用的磁盘和分区：


```bash
fdisk -l
```

找到U盘对应的设备名称，通常是类似于 `/dev/sdb1` 的形式。
# 检查是否已经挂载

U盘有可能已经自动挂载了，检查分区是否已经挂载了：

```bash
df -h
```
如返回以下：
```bash
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           3.1G  2.8M  3.1G   1% /run
/dev/nvme0n1p2  938G  367G  524G  42% /
tmpfs            16G     0   16G   0% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
efivarfs        512K   65K  443K  13% /sys/firmware/efi/efivars
/dev/nvme0n1p1  511M  6.1M  505M   2% /boot/efi
tmpfs           3.1G  112K  3.1G   1% /run/user/1000
tmpfs           3.1G   60K  3.1G   1% /run/user/0
/dev/sda3       238G  203G   35G  86% /media/ps/Local Disk
```
可以看到U盘`/dev/sda3`已经挂载到了`/media/ps/Local Disk`目录下了，此时打开`/media/ps/Local\ Disk`目录就可以访问U盘当中的内容了
# 转义问题
在Linux和Unix系统中，命令行中的空格用来分隔不同的命令和参数。如果文件名或目录名中包含空格，你需要使用引号将整个路径包围起来，或者使用反斜杠（`\`）来转义空格。所以命令行中的`Local Disk`应当输入为`Local\ Disk`
# 挂载与卸载
1. **创建挂载点**：选择或创建一个文件夹作为U盘的挂载点。例如，如果你想要将U盘挂载到 `/media/usb`，但这个文件夹不存在，你需要首先创建它：
    ```
    sudo mkdir -p /media/usb
	```
2. **挂载U盘**：使用以下命令将U盘挂载到你刚刚创建的挂载点：  
	```
	sudo mount /dev/sdb1 /media/usb
	```    
    注意替换 `/dev/sdb1` 为你在步骤3中找到的设备名称，以及 `/media/usb` 为你选择的挂载点。
    
3. **访问U盘**：现在你可以通过文件管理器访问 `/media/usb` 来查看U盘的内容，或者在终端中使用命令如 `cd /media/usb`。
    
4. **完成使用后卸载U盘**：在移除U盘之前，最好先卸载它，以确保所有数据都已正确写入并避免数据损失。在终端中，使用以下命令：\
```
sudo umount /media/usb
```
确保替换 `/media/usb` 为你的挂载点路径。之后，你可以安全地移除U盘。
    

请注意，如果你在使用图形用户界面，通常情况下Ubuntu会自动识别并提示你打开U盘，无需手动挂载。如果自动挂载失败，那么以上步骤可以帮助你手动进行。