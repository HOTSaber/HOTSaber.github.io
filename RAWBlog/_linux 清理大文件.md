# 1

1. 删除指定目录下的所有空白文件（包括隐藏文件）：
    

```shell
find /path/to/directory -type f -empty -delete
```

其中`/path/to/directory`为要清理的目录路径。

2. 查找并显示指定目录及子目录下超过设定大小限制的文件：
    

```shell
du -h --max-depth=1 /path/to/directory | grep '[0-9.]\+G\|M'
```

这将列出指定目录下超过1GB或者1MB的文件。

3. 根据文件大小进行排序，然后选取前N个最大的文件进行处理：
    

```shell
ls -lSr /path/to/directory | head -n N
```

其中`/path/to/directory`为要清理的目录路径，`N`表示需要保留的文件数量。

4. 通过修改文件系统属性来标记不再需要的文件，但不会立即删除：
    

```shell
chattr +a /path/to/file
```

该操作只能应用于支持ext2、ext3、ext4等文件系统格式的文件。

5. 如果想要永久删除被标记为"append only"的文件，则需要先移除该属性：
    

```shell
chattr -a /path/to/filerm /path/to/file
```
# 2
1.查看磁盘使用情况

```bash
df -h
```

此命令将显示所有已安装文件系统的磁盘使用情况。您可以根据需要确定哪些文件系统占用了最多的磁盘空间。

2.查找大文件和目录

```cobol
du -sh /*
```

此命令将列出根目录下的所有文件和目录的大小，并以易于阅读的格式显示它们所占用的磁盘空间。您可以进一步缩小搜索范围，例如，在/home目录中执行此命令，以查找该目录中的大文件和目录。

3.使用du命令检查文件夹大小

使用du命令可以检查每个文件夹的大小，找出占用磁盘空间较大的文件夹。例如，使用以下命令将/var目录下所有文件夹按大小排序：

```bash
du -h /var | sort -rh | head -n 10
```
 **`du -h`**:
    
    - `du`: 这个命令用于估算文件和目录的磁盘使用情况。
    - `-h`: 这个参数是“human-readable”的缩写，意味着输出的结果将以人类可读的格式（如K、M、G）显示，而不是以字节为单位。
 **`|`**:
    
    - 这是一个管道符号，用于将一个命令的输出作为另一个命令的输入。
 **`sort -rh`**:
    
    - `sort`: 这个命令用于对文本行进行排序。
    - `-r`: 这个参数表示“reverse”，意味着排序结果将是降序的。
    - `-h`: 这个参数告诉`sort`命令以人类可读的数字大小进行排序。这对于处理像`du -h`这样的输出特别有用，因为它可以正确地对K、M、G等单位进行排序。
 **`|`**:
    
    - 再次使用管道符号，将`sort`命令的输出传递给`head`命令。
 **`head -n 10`**:
    
    - `head`: 这个命令用于输出文件的前几行。
    - `-n 10`: 这个参数指定`head`命令只输出前10行
该命令将显示/var目录下最大的前10个文件夹。

4.检查日志文件大小

在Linux系统中，日志文件可能会非常大，占用大量磁盘空间。您可以使用[ls命令](https://so.csdn.net/so/search?q=ls%E5%91%BD%E4%BB%A4&spm=1001.2101.3001.7020)和grep命令来查看日志文件的大小并找出最大的几个文件。例如，使用以下命令列出/var/log目录下最大的10个文件：

```bash
ls -lSr /var/log | grep ^- | tail | awk '{print $5, $9}'
```

该命令将显示/var/log目录下最大的前10个文件名和大小。

5.删除临时文件和目录

```bash
rm -rf /tmp/*          rm -rf /var/tmp/*
```

这将删除/tmp和/var/tmp目录中的所有文件。请注意，在删除文件之前，请确保您不需要这些文件中包含的数据，例如应用程序或系统进程正在使用的临时文件。

6.清空系统日志

```bash
journalctl --rotate          journalctl --vacuum-time=1s
```

第一个命令将旧的系统日志归档并开始记录新的日志。第二个命令将清除早于1秒钟的日志条目。您可以根据需要更改--vacuum-time选项的值来调整要保留的日志时间。

7.手动清理日志文件

如果您需要手动清理日志文件，请使用以下命令删除/var/log目录下的所有日志文件：

```bash
find /var/log/ -type f -name "*.log" -delete          find /var/lib/docker/containers/ -type f -name "*.log" -delete
```

在删除日志文件之前，请确保您不需要这些文件中包含的数据，例如调试信息或错误消息。

8.清空已打开的日志文件

在某些情况下，已打开并写入的日志文件可能无法直接删除。在这种情况下，您可以使用以下命令将文件截断为零大小，并释放由该文件占用的磁盘空间：

```csharp
sh -c 'truncate -s 0 /var/log/'
```

其中，是要截断的日志文件名。例如，清空syslog文件的命令如下：

```csharp
sh -c 'truncate -s 0 /var/log/syslog'
```

9.清理缓存

```cobol
sync && sysctl -w vm.drop_caches=3
```

该命令将使Linux内核释放所有未使用的缓存页，并回收未使用的内存。请注意，这会导致系统性能下降，因为它会强制Linux重新加载从磁盘读取的文件。

10.删除不使用的软件包

```bash
sudo yum autoremove          apt-get autoremove
```

这将删除您已卸载但未自动删除的软件包。

11.删除无用的内核

```lua
package-cleanup --oldkernels
```

12.删除未使用的依赖项

```lua
package-cleanup --leaves
```

13.清理错误的yum缓存

```less
yum clean all
```

14.清除APT缓存

```bash
apt-get clean          apt-get autoclean
```

15.删除旧的备份文件

```cobol
find /path/to/backup/folder -type f -mtime +30 -delete
```

该命令将删除早于30天的所有备份文件。您可以根据需要更改-mtime选项的值来调整备份保留时间。

总之，在清理垃圾时，请小心谨慎，并确保您不会删除重要的数据。另外，建议在执行任何操作之前备份数据以防不测。

16.docker清理

删除未使用的镜像

```undefined
docker image prune
```

这个命令将删除未被任何容器使用的所有镜像。如果您想删除特定的镜像，请使用 docker rmi 命令。

删除未运行的容器

```undefined
docker container prune
```

这个命令将删除未在运行中的所有容器。如果您想删除特定的容器，请使用 docker rm 命令。

删除未使用的卷

```undefined
docker volume prune
```

这个命令将删除未被任何容器使用的所有卷。如果您想删除特定的卷，请使用 docker volume rm 命令。

删除未使用的网络

```undefined
docker network prune
```

这个命令将删除未被任何容器使用的所有网络。如果您想删除特定的网络，请使用 docker network rm 命令。

停止运行中的容器：

```cobol
docker stop <container_id_or_name>
```

这个命令将停止正在运行的 Docker 容器。如果您不确定容器是否在运行，请先使用 docker ps 命令确认容器状态。

卸载容器：

```cobol
docker rm <container_id_or_name>
```

这个命令将删除指定的 Docker 容器。请注意，这将永久删除容器及其关联数据。

如果您需要卸载多个容器，则可以使用以下命令：

```bash
docker stop $(docker ps -a -q)docker rm $(docker ps -a -q)
```

这将分别停止和删除所有 Docker 容器。

批量清理 Docker，可以使用以下命令：

```sql
docker system prune -a --volumes
```

这个命令将删除所有未被任何容器使用的、已经停止的容器和未被使用的镜像、网络和卷。添加 -a 标志将从系统中删除所有镜像（包括被使用的），而 --volumes 标志将删除未使用的卷。

17.查看Docker容器内存储的使用情

进入容器

```bash
docker exec -it/bin/bash
```

其中，是要进入的容器ID。该命令将打开一个终端会话，并在容器内启动Bash shell。

查看磁盘使用情况

```bash
df -h
```

此命令将显示容器中所有已安装文件系统的磁盘使用情况。您可以根据需要确定哪些文件系统占用了最多的磁盘空间。

查找大文件和目录

```cobol
sudo du -sh /*
```

此命令将列出根目录下的所有文件和目录的大小，并以易于阅读的格式显示它们所占用的磁盘空间。您可以进一步缩小搜索范围，例如，在/home目录中执行此命令，以查找该目录中的大文件和目录。

退出容器

```php
exit
```

该命令将关闭容器终端会话并返回主机终端。