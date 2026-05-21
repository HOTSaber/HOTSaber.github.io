在 Ubuntu（systemd）下，查看所有名称包含 `frp` 的服务，用 `systemctl` 配合 `grep` 即可。

### 1) 查看所有已加载且包含 frp 的服务（含运行 / 停止）


```
systemctl list-units --type=service --all | grep frp
```

### 2) 查看系统中所有安装过的 frp 服务文件（更全）


```
systemctl list-unit-files --type=service | grep frp
```

### 3) 只看正在运行的 frp 服务


```
systemctl list-units --type=service --state=running | grep frp
```

### 4) 查看详细状态（查到服务名后）

```
systemctl status 服务名
```