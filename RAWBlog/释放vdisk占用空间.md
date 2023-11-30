详见[清理WSL2的磁盘占用](https://blog.csdn.net/zw_lucky/article/details/130097668?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-2-130097668-blog-132858503.235%5Ev38%5Epc_relevant_sort_base1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-2-130097668-blog-132858503.235%5Ev38%5Epc_relevant_sort_base1&utm_relevant_index=5)

[WSL2](https://so.csdn.net/so/search?q=WSL2&spm=1001.2101.3001.7020)本质上是虚拟机，，`Windows`会自动创建`vhdx`后缀的虚拟磁盘文件作为存储。这个`vhdx` 后缀的虚拟磁盘文件特点是可以自动扩容，但是一般不会自动缩容。一旦有很多文件把它“撑大”，即使把这些文件删除它也不会自动“缩小”。意味着它可能只有 15GB 的数据，但是虚拟磁盘占用了 100GB 的空间。所以删除文件后还需要我们手动进行压缩才能释放磁盘空间。

我找了一些方法来去压缩 WSL2 的虚拟磁盘，发现了一个对我有效的方法，希望它对你来说也同样适用。
在压缩虚拟磁盘前，需要将 WSL2 先关闭。

可以先使用命令行来检查它的状态：

```shell
wsl.exe --list --verbose
```

如果没有关闭（状态是 `Running` ），再用命令行去关闭它：

```shell
wsl.exe --terminate 
```

我发现可以使用 `diskpart` 工具来压缩WSL2的虚拟磁盘，它会根据WSL2中数据的大小来重新申请磁盘空间。

在命令行启动 `diskpart` 工具：

```shell
diskpart
```
接下来需要确定虚拟磁盘文件的位置。

WSL2的虚拟磁盘文件在`C:\Users\{user}\AppData\Local\Packages\`下面，不同的WSL2发行版对应的名称不同，例如 **Pengwin** 是 `WhitewaterFoundryLtd.Co`，**Ubuntu** 是 `CanonicalGroupLimited`，**Debian** 是  
`TheDebianProject` 。找到了你的 WSL2 的文件夹，就能在它下面找到 `LocalState\ext4.vhdx` 这个磁盘文件。

例如，我的磁盘文件是 `C:\Users\ontheroad\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\ext4.vhdx`。

用 `diskpart` 选择这个文件：

```vhdl
select vdisk file="{vhdx文件名}"
```

再执行压缩命令：

```shell
compact vdisk
```

压缩过程需要几分钟。

压缩完成后可以关掉 `diskpart` 窗口，整个过程也完成了。可以再看看文件管理器中的磁盘使用，应该减少了很多。

```text
# 压缩完毕后卸载磁盘
detach vdisk
```

上述操作执行完毕，`WSL2` 删除文件后空出来的磁盘空间就被释放了。