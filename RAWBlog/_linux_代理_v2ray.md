以下是针对您提供的 Vmess 协议代理配置的 Ubuntu 系统设置方案：

---

### ​**一、客户端安装与配置**

#### ​**1. 安装 V2Ray 客户端**

bash

```bash
# 安装官方脚本
wget https://install.direct/go.sh
sudo bash go.sh
# 验证安装
systemctl status v2ray
```

#### ​**2. 创建配置文件**

在 `/usr/local/etc/v2ray/config.json` 中写入以下内容（根据您的参数调整）：

json

```json
{
  "inbounds": [{
    "port": 10808,  // 本地监听端口
    "protocol": "socks",
    "settings": {"auth": "noauth"}
  }],
  "outbounds": [{
    "protocol": "vmess",
    "settings": {
      "vnext": [{
        "address": "170.106.82.242",
        "port": 33027,
        "users": [{
          "id": "xxxxxx",
          "alterId": 0,
          "security": "auto"
        }]
      }]
    }
  }]
}
//或
{
    "inbounds": [
        {
            "port": 1080, // SOCKS 代理端口，在浏览器中需配置代理并指向这个端口
            "listen": "127.0.0.1",
            "protocol": "socks",
            "settings": {
                "udp": true
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "vmess",
            "settings": {
                "vnext": [
                    {
                        "address": "server", // 服务器地址，请修改为你自己的服务器 ip 或域名
                        "port": 10086, // 服务器端口
                        "users": [
                            {
                                "id": "b831381d-6324-4d53-ad4f-8cda48b30811"
                            }
                        ]
                    }
                ]
            }
        },
        {
            "protocol": "freedom",
            "tag": "direct"
        }
    ],
    "routing": {
        "domainStrategy": "IPOnDemand",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "direct"
            }
        ]
    }
}

```

---

### ​**二、代理服务管理**

#### ​**1. 启动服务**

bash

```bash
sudo systemctl restart v2ray
sudo systemctl enable v2ray
```

#### ​**2. 验证连接**

bash

```bash
curl --socks5 127.0.0.1:10808 https://www.google.com
# 若返回 HTML 内容则说明代理成功
```

### **五、进阶配置（可选）​**

#### ​**1. 流量分流规则**

在 V2Ray 配置文件中添加路由规则，实现国内外流量分流：

json

```json
"routing": {
  "domainStrategy": "IPOnDemand",
  "rules": [
    {"type": "field", "domain": ["geosite:cn"], "outboundTag": "direct"},
    {"type": "field", "ip": ["geoip:cn"], "outboundTag": "direct"}
  ]
}
```

#### ​**2. 开机自启优化**

bash

```bash
sudo nano /etc/systemd/system/v2ray.service.d/override.conf
# 添加以下内容
[Service]
Restart=always
RestartSec=5
```
### **六、安全注意事项**

1. ​**证书验证**：由于配置中 `"tls": false`，建议仅在可信网络使用
2. ​**端口限制**：通过 UFW 防火墙仅开放必要端口：
    
    bash
    
    ```bash
    sudo ufw allow 10808/tcp
    sudo ufw enable
    ```
    

---

通过以上步骤，您可以在 Ubuntu 系统中完整实现该 Vmess 代理配置。若需切换其他代理节点，只需修改 `config.json` 中的服务器参数并重启服务即可
# 4090server file样例

/usr/local/etc/v2ray/config.json文件

```json
{
  "log": {
    "access": "",
    "error": "",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "socks",
      "port": 10808,
      "listen": "0.0.0.0",
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ],
        "routeOnly": false
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    },
    {
      "tag": "http",
      "port": 10809,
      "listen": "0.0.0.0",
      "protocol": "http",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ],
        "routeOnly": false
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    }
  ],
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "trojan",
      "settings": {
        "servers": [
          {
            "address": "【yourdomain】",
            "method": "chacha20",
            "ota": false,
            "password": "【yourname】",
            "port": 443,
            "level": 1
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": false
        },
        "grpcSettings": {
          "serviceName": "【yourname】",
          "multiMode": false,
          "idle_timeout": 60,
          "health_check_timeout": 20,
          "permit_without_stream": false,
          "initial_windows_size": 0
        }
      },
      "mux": {
        "enabled": false,
        "concurrency": -1
      }
    },
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "block",
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      }
    }
  ],
  "dns": {
    "hosts": {
      "dns.google": "8.8.8.8",
      "proxy.example.com": "127.0.0.1"
    },
    "servers": [
      {
        "address": "223.5.5.5",
        "domains": [
          "geosite:cn",
          "geosite:geolocation-cn"
        ],
        "expectIPs": [
          "geoip:cn"
        ]
      },
      "1.1.1.1",
      "8.8.8.8",
      "https://dns.google/dns-query",
      {
        "address": "223.5.5.5",
        "domains": [
          "server.hotsaber.cn"
        ]
      }
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api"
      },
      {
        "type": "field",
        "outboundTag": "direct",
        "domain": [
          "domain:example-example.com",
          "domain:example-example2.com"
        ]
      },
      {
        "type": "field",
        "port": "443",
        "network": "udp",
        "outboundTag": "block"
      },
      {
        "type": "field",
        "outboundTag": "block",
        "domain": [
          "geosite:category-ads-all"
        ]
      },
      {
        "type": "field",
        "outboundTag": "direct",
        "domain": [
          "domain:dns.alidns.com",
          "domain:doh.pub",
          "domain:dot.pub",
          "domain:doh.360.cn",
          "domain:dot.360.cn",
          "geosite:cn",
          "geosite:geolocation-cn"
        ]
      },
      {
        "type": "field",
        "outboundTag": "direct",
        "ip": [
          "223.5.5.5/32",
          "223.6.6.6/32",
          "2400:3200::1/128",
          "2400:3200:baba::1/128",
          "119.29.29.29/32",
          "1.12.12.12/32",
          "120.53.53.53/32",
          "2402:4e00::/128",
          "2402:4e00:1::/128",
          "180.76.76.76/32",
          "2400:da00::6666/128",
          "114.114.114.114/32",
          "114.114.115.115/32",
          "180.184.1.1/32",
          "180.184.2.2/32",
          "101.226.4.6/32",
          "218.30.118.6/32",
          "123.125.81.6/32",
          "140.207.198.6/32",
          "geoip:private",
          "geoip:cn"
        ]
      },
      {
        "type": "field",
        "port": "0-65535",
        "outboundTag": "proxy"
      }
    ]
  }
}

```