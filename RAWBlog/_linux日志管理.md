# Ubuntu NetworkManager 记录

NetworkManager 是 Ubuntu 系统中的网络管理工具。它可以自动配置、连接和断开网络设备，并提供了图形化界面来管理网络连接。

要查看 NetworkManager 的日志文件，可以使用以下命令：

```shell
journalctl -u NetworkManager.service
```

这将显示 NetworkManager 服务的最新日志信息。如果需要更详细的日志内容，可以添加 `-f` 参数进行实时输出。

此外，还有其他与 NetworkManager 相关的日志文件位于 `/var/log/` 目录下，比如 `syslog`、`messages` 等。可以通过阅读这些日志文件来获取更多关于 NetworkManager 运行状态和错误信息的记录。
# 导出日志/记录
以下是将`ssh.service`的日志保存为txt格式文件的步骤：

1. 打开终端。
    
2. 使用`journalctl`命令并指定要保存的服务（在这里是`ssh.service`），然后使用重定向操作符`>`将输出保存到文件中。例如，要将日志保存到名为`ssh_logs.txt`的文件中，可以运行以下命令：
    
    ```sh
    sudo journalctl -u ssh.service > ssh_logs.txt
    ```
    
    这会将`ssh.service`的日志内容写入到当前目录下的`ssh_logs.txt`文件中。如果文件已经存在，该命令会覆盖文件内容；如果文件不存在，它会创建该文件。
    
3. 如果你想追加日志到现有的txt文件中，而不是覆盖它，可以使用`>>`操作符：
    
    ```sh
    sudo journalctl -u ssh.service >> ssh_logs.txt
    ```
    
    这会将日志追加到`ssh_logs.txt`文件的末尾，而不会覆盖文件中的现有内容。
    
4. 保存的文件`ssh_logs.txt`现在可以使用任何文本编辑器打开查看。
    

请注意，`journalctl`的输出是文本格式的，因此你不需要担心二进制格式的问题。此外，你可以使用`journalctl`的其他选项来过滤、排序或格式化输出，以满足你的具体需求。例如，使用`-o`选项可以以不同的输出格式（如`export`、`short`、`short-precise`、`short-iso`、`short-monotonic`、`verbose`）查看日志。