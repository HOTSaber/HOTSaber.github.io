# x-ui设置
## 网址https证书设置
### x-ui脚本acme自动申请证书
进入脚本，按提示操作即可
```
#证书位置
/root/ygkkkca/cert.crt
/root/ygkkkca/private.key
```
### 使用caddy申请的证书

```
#证书位置
/root/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/server.hotsaber.cn/server.hotsaber.cn.crt
/root/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/server.hotsaber.cn/server.hotsaber.cn.key
```
## 新加节点配置
这里我们以trojan为例
![[_xray_x-ui使用-1.png]]
配置好以上参数，端口与密码会自动随机生成
**但推荐在Linux下使用以下命令生成：**
```bash
openssl rand -base64 32
```
xray配置位置:`/usr/local/x-ui/bin/config.json`
# 配置caddy反代
[caddy v1中文文档](https://dengxiaolong.com/caddy/zh/)
[caddy v2中文文档](https://caddy2.dengxiaolong.com/docs/)
**需要注意的是！**
**如果使用caddy，请直接使用caddy进行tls加密！**
**不要使用xray或v2ray进行双重加密，会使得代理链路不能**
## 总配置文件
在/etc/caddy/xray/下新加配置文件server.hostaber.cn_test.conf
**ps这里因为使用了v2ray脚本，所以在caddy下已有2233boy文件，已经默认加载，在其中加入也可**
**此时`xray`文件并未在总配置文件中加载！**
**所以要在总配置文件`/etc/caddy/Caddyfile`中添加`xray`文件夹的加载命令**
```caddyfile
import /etc/caddy/xray/*.conf
```
完成后重启caddy服务
### 【无tls加密】反代服务配置
编辑新建的反代配置文件`/etc/caddy/xray/server.hostaber.cn_test.conf`：
```caddyfile
server.hotsaber.cn:443 {
    reverse_proxy /【密码与路径】/* h2c://127.0.0.1:【端口号】
}
```
这里的【密码与路径】以及【端口号】是x-ui中节点配置中的密码与端口。
**h2c是明文未加密的http2**
**所有服务配置文件中一个域名如`server.hotsaber.cn:443`只能有一个服务配置文件！！！**
### ~~【有tls加密】反代服务配置~~
[caddyfile反代参数请参考](https://caddy2.dengxiaolong.com/docs/caddyfile/directives/reverse_proxy)
首先要明确上游xray配置的inbound参数:`streamSettings`下的`network`、`security`、`listen`、`port`，如果`security`配置为tls，则caddy也要通过 `transport` 配置适配 Xray 的传输协议和 TLS 层。

以下是 Xray 启用 TLS 后最常见的 3 种场景，对应 Caddy 的完整配置示例（假设你的域名是 `your-domain.com`）。

#### 场景 1：Xray 用 `TCP + TLS` 传输（最基础场景）

如果 Xray 的 `inbound` 配置中，`streamSettings` 如下（典型 Trojan/VLESS/VMess + TCP+TLS）：
```json
// Xray inbound 的 streamSettings 示例（TCP+TLS）
"streamSettings": {
  "network": "tcp",       // 传输协议为 TCP
  "security": "tls",      // 启用 TLS
  "tlsSettings": {
    "certificates": [{"certificateFile": "/path/to/xray.crt", "keyFile": "/path/to/xray.key"}],
    "serverName": "your-domain.com"  // 可选，SNI 匹配
  }
}
```
**对应的 Caddyfile 配置**：
[caddyfile反代参数请参考](https://caddy2.dengxiaolong.com/docs/caddyfile/directives/reverse_proxy)
```caddyfile
# 你的域名（Caddy 可自动申请 Let's Encrypt 证书，也可手动指定）
your-domain.com {
  # 反向代理到 Xray 的监听地址（127.0.0.1:端口）
  reverse_proxy 127.0.0.1:40708 {
    # 关键：适配 Xray 的 TCP+TLS 传输，禁用 Caddy 对上游的 TLS 验证（因 Xray 已处理 TLS）
    # 若 Xray 用的是可信证书（非自签），可删除 tls_insecure_skip_verify
    transport tcp {
      tls
      tls_insecure_skip_verify  # 仅当 Xray 用自签证书时添加（跳过证书验证）
    }
  }

  # 可选：启用 Caddy 的 TLS（推荐，让客户端到 Caddy 也走 TLS，双重加密）
  # Caddy 会自动申请证书，无需手动配置
  tls your-email@example.com  # 用于申请 Let's Encrypt 证书的邮箱
}
```
#### 场景 2：Xray 用 `gRPC + TLS` 传输（高效场景）
[caddyfile反代参数请参考](https://caddy2.dengxiaolong.com/docs/caddyfile/directives/reverse_proxy)
##### 场景 1：Xray 仅启用「单向 TLS」（最常见）
如果你的 Xray 配置中，`streamSettings.security: "tls"` 下 **没有启用 `tlsSettings.clientAuth`**（即不要求客户端提供证书），示例 Xray 配置如下：
```json
// Xray 单向 TLS 配置（仅服务器端验证）
"streamSettings": {
  "network": "tcp", // 或 grpc、h2 等
  "security": "tls",
  "tlsSettings": {
    "certificates": [
      {
        "certificateFile": "/path/to/xray-server.crt", // Xray 服务器证书
        "keyFile": "/path/to/xray-server.key"         // Xray 服务器私钥
      }
    ]
    // 没有 "clientAuth" 字段，或 clientAuth.mode: "none"
  }
}
```
此时 Caddy 仅需与 Xray 建立普通 TLS 连接，**不需要提供 `cert.crt` 和 `private.key`**，`transport http` 配置如下（核心是 `tls` 开启，无需 `tls_client_auth`）：
```caddyfile
# Caddyfile 配置（单向 TLS 场景）
your-domain.com { # 你的前端域名（如需要 Caddy 处理前端 TLS，可在此配置）
  reverse_proxy 127.0.0.1:40708 { # 指向你的 Xray 监听地址（如 127.0.0.1:40708）
    transport http {
      tls # 开启 Caddy 与 Xray 的 TLS 通信（必须）
      # 可选：若 Xray 用自签证书，Caddy 默认不信任，需加 tls_insecure_skip_verify（仅测试环境用）
      # tls_insecure_skip_verify # 生产环境不推荐，建议用可信证书（如 Let's Encrypt）
      
      # 其他可选优化（按需求添加，非必需）
      keepalive 30s # 保持连接复用，提升性能
      versions h2 tls1.3 # 限制 HTTP 版本（h2 即 HTTP/2，适配 Xray 常见配置）
      dial_timeout 10s # 连接超时时间
    }
  }
}
```
##### 场景 2：Xray 启用「双向 TLS（mTLS）」（需客户端证书验证）

如果你的 Xray 配置中，`tlsSettings.clientAuth.mode` 设为 `require` 或 `verify_require`（即要求客户端必须提供合法证书才能连接），示例 Xray 配置如下：
```json
// Xray 双向 TLS 配置（要求客户端提供证书）
"streamSettings": {
  "network": "tcp",
  "security": "tls",
  "tlsSettings": {
    "certificates": [
      {
        "certificateFile": "/path/to/xray-server.crt",
        "keyFile": "/path/to/xray-server.key"
      }
    ],
    "clientAuth": {
      "mode": "require", // 要求客户端提供证书
      "ca": ["/path/to/ca.crt"] // 用于验证客户端证书的 CA 根证书
    }
  }
}
```
此时 Caddy 作为客户端，必须向 Xray 提供 **由 Xray 信任的 CA 签名的客户端证书**，才会被允许建立连接。此时需要通过 `tls_client_auth` 配置 `cert.crt`（客户端证书）和 `private.key`（客户端私钥），Caddyfile 如下：
```caddyfile
# Caddyfile 配置（双向 TLS 场景）
your-domain.com {
  reverse_proxy 127.0.0.1:40708 {
    transport http {
      tls # 开启 TLS 通信
      # 配置 Caddy 向 Xray 提供的客户端证书和私钥（路径需正确）
      tls_client_auth /path/to/cert.crt /path/to/private.key
      
      # 可选：若 Xray 服务器证书由自签 CA 签发，需指定信任该 CA（否则 Caddy 会拒绝连接）
      tls_trusted_ca_certs /path/to/xray-ca.crt
      
      # 其他可选优化
      keepalive 30s
      versions h2 tls1.3
    }
  }
}
```
#### 场景 3：Xray 用 `HTTP/2 (h2) + TLS` 传输（兼容场景）
[caddyfile反代参数请参考](https://caddy2.dengxiaolong.com/docs/caddyfile/directives/reverse_proxy)
若 Xray 的传输协议是 `http`（实际为 HTTP/2 over TLS，即 `h2`），`streamSettings` 如下：
```json
// Xray inbound 的 streamSettings 示例（h2+TLS）
"streamSettings": {
  "network": "http",      // 传输协议为 HTTP/2
  "security": "tls",      // 启用 TLS
  "tlsSettings": {
    "certificates": [{"certificateFile": "/path/to/xray.crt", "keyFile": "/path/to/xray.key"}]
  },
  "httpSettings": {
    "host": ["your-domain.com"],  # 可选，HTTP Host 匹配
    "path": "/your-path/"         # 可选，HTTP 路径匹配
  }
}
```
**对应的 Caddyfile 配置**：
```caddyfile
your-domain.com {
  # 若 Xray 配置了 path（如 /your-path/），需先匹配路径再转发
  @xray path /your-path/*
  reverse_proxy @xray 127.0.0.1:40708 {
    # 适配 HTTP/2 (h2) 协议，因 Xray 启用 TLS，用 h2 而非 h2c
    transport http {
      versions h2
      tls
      tls_insecure_skip_verify  # 自签证书时添加
    }
    # 若 Xray 需特定 Host，添加 header 透传
    header_up Host {http.request.host}  # 透传客户端的 Host 到 Xray
  }

  # Caddy 自身启用 TLS
  tls your-email@example.com
}
```
**所有服务配置文件中一个域名如`server.hotsaber.cn:443`只能有一个服务配置文件！！！**
# 配置xray出站规则
xray配置文件位置:`/`
- Xray的Inbound入站，添加sniffing，因为需要根据sni探测域名。

```json
"inbounds": [
  {
    "port": 443,
    "protocol": "vless",
    "settings": { 
      …… //根据自己的实际情况填写
    },
    "streamSettings": {
      …… //根据自己的实际情况填写
    }
    "sniffing": {
      "enabled": true,
      "destOverride": [
        "http",
        "tls",
        "quic"
      ]
    }
  }
]
```

- Xray的Routing路由规则中，设置域名过滤（分流Netflix和ChatGPT）。

```json
"routing": {
  "domainStrategy": "AsIs",
  "rules": [
    {
      "type": "field",
      "domain": [
         "geosite:netflix",
         "geosite:openai"
       ],
       "outboundTag": "warp"
    }
  ]
}
```

- Xray的Outbound出站，使用socks协议，将数据转发至本机40000端口。

```json
"outbounds": [
  {
    "tag": "direct",
    "protocol": "freedom"
  },
  {
    "tag": "warp",
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 40000
        }
      ]
    }
  }
]
```

- 重启Xray服务

```shell
sudo systemctl restart xray
或
sudo service xray restart
```

- 查看Xray运行状态

```shell
sudo systemctl status xray
或
sudo service xray status
```
### 1. `"domainStrategy": "IPIfNonMatch"`（默认值）

- **行为逻辑**：  
    优先使用**域名本身**进行路由规则匹配。如果没有找到匹配的域名规则，会自动将该域名解析为 IP 地址，再尝试用 IP 去匹配路由规则中的 IP 相关条件（如 `ip` 字段、`cidr` 网段等）。  
    简单说：**先试域名匹配，不匹配就解析成 IP 再试 IP 匹配**。
    
- **适用场景**：  
    适合大多数常规使用，兼顾域名匹配的灵活性和 IP 匹配的兼容性。例如：
    
    - 当你配置了针对 `google.com` 的域名规则时，会直接匹配并生效；
    - 若没有配置 `google.com` 的规则，但配置了 `8.8.8.8/32`（Google DNS 的 IP）的规则，`google.com` 解析后会匹配该 IP 规则。

### 2. `"domainStrategy": "AsIs"`

- **行为逻辑**：  
    仅使用**域名本身**进行路由规则匹配，**不会将域名解析为 IP**。即使没有找到匹配的域名规则，也不会尝试用 IP 匹配，而是直接走默认出站（`outbounds[0]`）。  
    简单说：**只认域名，不解析 IP，不匹配就走默认**。
    
- **适用场景**：  
    适合需要严格按域名匹配，或不希望因 IP 解析导致规则混乱的场景。例如：
    
    - 某些网站使用 CDN 分发，同一域名可能解析到多个 IP（跨地区、跨运营商），若用 `IPIfNonMatch` 可能匹配到不相关的 IP 规则；
    - 希望明确控制 “只有匹配域名规则的流量才特殊处理，其他全部走默认”。

xray出站配置参考:
在inbound中添加了sniffing，在route中倒数第二项添加了出站规则，在outbound中添加了socks5-warp
```json
{
"api": {
    "services": [
      "HandlerService",
      "LoggerService",
      "StatsService"
    ],
    "tag": "api"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 62789,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "sniffing": {
	      "enabled": true,
	      "destOverride": [
	        "http",
	        "tls",
	        "quic"
		      ]
		},
      "tag": "api"
    }
  ],  
 "policy": {
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    },
     "levels": {
      "0": {
        "handshake": 10,
        "connIdle": 100,
        "uplinkOnly": 2,
        "downlinkOnly": 3,
        "bufferSize": 10240  
      }
    }
  },
"outbounds": [
{
"protocol": "blackhole",
"tag": "blocked"
},
{
"tag": "direct",
"protocol": "freedom",
"settings": {
"domainStrategy":"UseIP"
}
},
{
"tag": "vps-outbound-v4", 
"protocol": "freedom",
"settings": {
"domainStrategy":"UseIPv4v6"
}
},
{
"tag": "vps-outbound-v6",
"protocol": "freedom",
"settings": {
"domainStrategy":"UseIPv6v4"
}
},
{
"tag": "socks5-warp",
"protocol": "socks",
"settings": {
"servers": [
{
"address": "127.0.0.1",
"port": 40000 
}
]
}      
},
{
"tag":"socks5-warp-v4",
"protocol":"freedom",
"settings":{
"domainStrategy":"UseIPv4v6"
},
"proxySettings":{
"tag":"socks5-warp"
}
},
{
"tag":"socks5-warp-v6",
"protocol":"freedom",
"settings":{
"domainStrategy":"UseIPv6v4"
},
"proxySettings":{
"tag":"socks5-warp"
}
},
{
"tag":"xray-wg-warp",
"protocol":"wireguard",
"settings":{
"secretKey":"4GRI+uhXHop6U9H5Gi4YbD+5IoBvZ/kLdTdyal/y9EE=",
"address":[
"172.16.0.2/32",
"2606:4700:110:845b:dd5b:5b91:8e5a:60b9/128"
],
"peers":[
{
"publicKey":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
"allowedIPs": [
"0.0.0.0/0",
"::/0"
],
"endpoint":"162.159.192.1:2408"
}
],
"reserved":[197,230,30]
}
},
{
"tag":"xray-wg-warp-v4",
"protocol":"freedom",
"settings":{
"domainStrategy":"UseIPv4v6"
},
"proxySettings":{
"tag":"xray-wg-warp"
}
},
{
"tag":"xray-wg-warp-v6",
"protocol":"freedom",
"settings":{
"domainStrategy":"UseIPv6v4"
},
"proxySettings":{
"tag":"xray-wg-warp"
}
}
],
"routing": {
"domainStrategy": "AsIs",
"rules": [
{
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
    {
          "type": "field",
          "port": "443",
          "network": "udp",
          "outboundTag": "blocked"
            },
       {
        "type": "field",
        "domain": [
          "www.gstatic.com"
        ],
        "outboundTag": "direct"
      },
      {
        "ip": [
          "geoip:cn"
        ],
        "outboundTag": "blocked",
        "type": "field"
      },
      {
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ],
        "type": "field"
      },
{
"type":"field",
"outboundTag":"xray-wg-warp-v4",
"domain":[
"ifconfig.co","yg_kkk"
]
},
{
"type":"field",
"outboundTag":"xray-wg-warp-v6",
"domain":[
"ipget.net","yg_kkk"
]
},
{
"type":"field",
"outboundTag":"socks5-warp-v4",
"domain":[
"db-ip.com","yg_kkk"
]
},
{
"type":"field",
"outboundTag":"socks5-warp-v6",
"domain":[
"ip.me","yg_kkk"
]
},
{
"type": "field",
"outboundTag":"vps-outbound-v4",
"domain": [
"api.myip.com","yg_kkk"
]
},
{
"type": "field",
"outboundTag":"vps-outbound-v6",
"domain": [
"api64.ipify.org","yg_kkk"
]
},
{
"type": "field",
"domain": [
  "geosite:google-scholar",
  "geosite:google-play",
  "geosite:netflix",
  "geosite:meta",
  "geosite:disney"
],
"marktag": "warp diversion",
"outboundTag": "socks5-warp"
},
{
"type": "field",
"outboundTag": "direct",
"network": "udp,tcp"
}
]
},
"stats": {}
}

```