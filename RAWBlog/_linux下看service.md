1. **使用`systemctl`命令**:

`systemctl`是systemd的主要命令行工具，你可以使用它来查看当前运行的服务。

```bash
sudo systemctl list-units --type=service
```

这将列出所有正在运行的服务。如果你想查看所有服务（不仅仅是正在运行的），可以使用：

```bash
sudo systemctl list-units --type=service --all
```

2. **使用`service`命令**:

尽管`service`命令在现代的Ubuntu版本中已经被`systemctl`替代，但它仍然可以在许多系统上使用。

```bash
sudo service --status-all
```

这将列出所有服务以及它们的状态。  
3. **使用`ps`命令结合`grep`命令**:

如果你想查找特定的服务，你可以使用`ps`命令结合`grep`命令来查找与该服务相关的进程。

```bash
ps -ef | grep [s]ervice_name
```

将`service_name`替换为你想查找的实际服务名。  
4. **使用`netstat`命令结合`grep`命令**:

如果你想查找正在监听端口的服务，可以使用`netstat`命令结合`grep`命令。

```bash
sudo netstat -tulpn | grep LISTEN
```

这将列出所有正在监听端口的服务。

记住，有些服务可能以不同的方式启动或管理，所以并非所有服务都会出现在上述命令的列表中。但是，上述方法应该能帮助你查看大多数常见的系统服务。