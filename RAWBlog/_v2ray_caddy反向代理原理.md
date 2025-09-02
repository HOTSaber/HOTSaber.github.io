
caddy配置文件位置：
```path
/etc/caddy/
```
v2ray脚本配置文件位置：
```
/etc/v2ray/conf/
```
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
形成如下的代理流程：

![[_v2ray_caddy反向代理原理-1.png]]