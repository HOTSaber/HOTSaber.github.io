****
**需要注意的是！**
**如果使用caddy，请直接使用caddy进行tls加密！**
**不要使用xray或v2ray进行双重加密，会使得代理链路不能**
****
# caddy配置文件设置
- Caddy 的核心是 **配置文件**（默认 `Caddyfile`），通过配置定义服务规则。
caddy配置文件位置：
```path
/etc/caddy/
```
v2ray脚本配置文件位置：
```
/etc/v2ray/conf/
```
默认情况下，Caddy 系统服务会加载 `/etc/caddy/Caddyfile` 主配置。若要加载自定义配置文件（如 `/etc/caddy/myfirstsite.conf`），需修改主配置：
### 通过系统服务自动加载配置文件
1. 编辑主配置：
```bash
sudo nano /etc/caddy/Caddyfile
```
2. 添加导入语句（加载指定目录下的所有 `.conf` 文件）：
```caddyfile
# 主配置文件中只需添加这一行，自动加载所有子配置
import /etc/caddy/*.conf
```
3. 重启 Caddy 服务使配置生效：
```bash
sudo systemctl restart caddy
# 检查状态，确保无错误
sudo systemctl status caddy
```
### 手动加载配置文件
在终端直接指定配置文件启动（会话关闭后服务停止）：
```bash
# 在配置文件所在目录执行
sudo caddy run --config myfirstsite.conf
```
#### **3. 验证服务**

- 访问你的域名（如 `https://example.com`），若看到 `Hello Caddy!` 则配置生效。
- Caddy 已自动申请 SSL 证书，浏览器地址栏会显示小锁图标（HTTPS 生效）。
# 例子
### 假设现有v2ray配置文件如下：
```
{
  "inbounds": [
    {
      "tag": "Trojan-gRPC-TLS-server.hotsaber.cn.json",
      "port": 【端口号1】,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "【密码与服务路径名1】"
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "grpc_host": "server.hotsaber.cn",
        "security": "none",
        "grpcSettings": {
          "serviceName": "【密码与服务路径名1】"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
```
**注意这里`security`设置为none，是未未加密状态**
**所以可以使用`h2c`明文协议**
如果`security`设置为`tls`，则需要caddy也打开`tls`会导致代理链路不通，代理失效！
### 现在希望实现不直接通过【端口1】实现代理，而是通过443端口实现代理
需要使用caddy实现内部反向代理，配置如下:
```caddyfile
server.hotsaber.cn:443 {
    reverse_proxy /【密码与服务路径名1】/* h2c://127.0.0.1:【端口号1】
    import /etc/caddy/233boy/server.hotsaber.cn.conf.add
}
```
配置解释如下：
```caddyfile
# 监听域名和端口：对访问 server.hotsaber.cn:443 的请求进行处理
# 443 是 HTTPS 默认端口，Caddy 会自动申请和配置 SSL 证书（Let's Encrypt），实现 HTTPS 访问
server.hotsaber.cn:443 {
    # 反向代理规则：
    # 当请求路径以 /【密码与服务路径名1】/ 开头时
    # 将请求转发到本地的 h2c://127.0.0.1:【端口号1】 服务
    reverse_proxy /【密码与服务路径名1】/* h2c://127.0.0.1:【端口号1】

    # 导入外部配置文件：将 /etc/caddy/233boy/server.hotsaber.cn.conf.add 中的内容合并到当前配置
    # 通常用于拆分复杂配置，或添加额外规则（如缓存、跨域、日志等）
    import /etc/caddy/233boy/server.hotsaber.cn.conf.add
}
```
**要确保`/etc/caddy/233boy/*.conf`已经在配置总文件中正确加载**
最终形成如下的代理流程：

![[_v2ray_caddy反向代理原理-1.png]]
### **三、常用配置场景**

#### **1. 反向代理（将请求转发到后端服务）**

例如将 `api.example.com` 的请求转发到本地 3000 端口的 Node.js 服务：
```caddyfile
api.example.com {
    # 转发所有请求到 http://127.0.0.1:3000
    reverse_proxy 127.0.0.1:3000

    # 可选：添加超时设置
    reverse_proxy {
        to 127.0.0.1:3000
        timeout 30s  # 超时时间
    }
}
```
#### **2. 多路径分流**

同一域名下，不同路径转发到不同服务（如静态文件 + API 代理）：
```caddyfile
example.com {
    # 静态文件服务（默认路径）
    root * /var/www/example.com
    file_server

    # API 路径转发到后端
    reverse_proxy /api/* 127.0.0.1:5000

    # 特定路径转发到另一个服务
    reverse_proxy /admin/* 127.0.0.1:8080
}
```
#### **3. 重定向与缓存**
```caddyfile
example.com {
    # HTTP 重定向到 HTTPS（Caddy 默认已开启，可省略）
    redir http://{host}{uri} https://{host}{uri} permanent

    # 缓存静态资源（JS/CSS/图片等）
    @static {
        file
        path *.js *.css *.png *.jpg *.jpeg *.gif *.ico
    }
    header @static Cache-Control "public, max-age=31536000"

    # 静态文件服务
    root * /var/www/example.com
    file_server
}
```
### **四、关键操作命令**

|命令|作用|
|---|---|
|`sudo systemctl start caddy`|启动 Caddy 服务|
|`sudo systemctl stop caddy`|停止服务|
|`sudo systemctl restart caddy`|重启服务（配置修改后生效）|
|`sudo systemctl reload caddy`|重载配置（不中断服务，推荐）|
|`sudo systemctl status caddy`|查看服务状态（含错误日志）|
|`caddy validate --config /etc/caddy/Caddyfile`|验证配置文件语法是否正确|
### **五、日志与调试**

- **访问日志**：默认路径 `/var/log/caddy/access.log`（记录所有请求）。
- **错误日志**：默认路径 `/var/log/caddy/error.log`（排查配置或运行错误）。
- 调试模式：启动时添加 `--debug` 查看详细日志：

```bash
sudo caddy run --config /etc/caddy/Caddyfile --debug
```

通过以上步骤，你可以快速搭建静态网站、反向代理后端服务等常见场景。Caddy 的配置语法简洁，且自动处理 HTTPS 证书，非常适合新手和生产环境使用。更多高级功能（如负载均衡、WebSocket 代理）可参考 [官方文档](https://caddyserver.com/docs/)。