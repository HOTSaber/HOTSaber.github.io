*****
[# 上网利器安装及使用 - [v2ray & warp]](https://blog.fh6766.com/2023/03/28/serving-with-warp/#2-3-%E9%87%8D%E5%90%AFv2ray)
[# 使用WARP代理模式，解锁Netflix和ChatGPT](https://blog.johnsmith.page/unblock-netflix-and-chatgpt-using-warp-proxy-mode/)
[# 奈飞解锁方式大全](https://bulianglin.com/archives/netflix-unlock.html)
[# VPS自建节点小白教程：购买、搭建和CF分流解锁Netflix等流媒体，15分钟讲清楚｜境外工具](https://www.youtube.com/watch?v=jea2l6iHcUM)
[]()
*****


# 安装x-ui脚本，安装x-ui,与warp go 或socks5-warp
使用[x-ui-yg脚本](https://github.com/yonggekkk/x-ui-yg)，用以下命令安装一键脚本：
```bash
bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/x-ui-yg/main/install.sh)
```
后续可使用`x-ui`重新进入脚本面板

需要进行步骤：
```
1. 安装x-ui
2. 管理acme申请域名证书
	需要有自己的域名，按提示进行即可
	最后要在x-ui网页的面板设置中填写两项：证书公钥文件路径【域名登录面板时，必须填写】
	之后可以使用域名+端口+/路径，进行访问
	完成此步骤，才可以使用tls功能
3. 使用【管理 Warp 查看本地Netflix、ChatGPT解锁情况】配置warp分流
      
```
## 只安装warp,不安装x-ui

使用[warp-yg脚本](https://github.com/yonggekkk/warp-yg)
```
bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/warp-yg/main/CFwarp.sh)
```
## 配置warp分流注意事项
1. 如出现：已安装Socks5-WARP客户端，但端口处于关闭状态
   使用`ss -tulpn | grep :40000`查看端口占用情况
   如返回
	```shell
	tcp   LISTEN 0      128                         127.0.0.1:40000      0.0.0.0:*    users:(("wireproxy",pid=895,fd=1)) 
   ```
   使用
   ```
   bash
	# 温和终止进程（推荐）
	sudo kill -15 895
   ```
   或使用systemctl来控制，如`ss -tulpn | grep :40000`返回：
```shell
tcp   LISTEN 0      128                         127.0.0.1:40000      0.0.0.0:*    users:(("warp-svc",pid=895,fd=1)) 
```
使用：
```
systemctl status warp-svc #查看warp-svc状态
systemctl stop warp-svc #停止warp-svc
systemctl start warp-svc #启动warp-svc
```
## 使用warp-plus-socks5功能
```bash
x-ui
12
2
#使用x-ui自动配置warp-plus-socks5本地或psiphon代理
#psiphon 是由赛风公司推出的网络规避工_具。通过VPN、SSH 和HTTP 代理技术，它可为用户提供最佳的内容访问通道。为了尽可能成功地突破审查
```
默认端口为40000则不用额外配置与`11`中的方案二wrap-socks代理效果是一样的，按后续配置xray或v2ray出站规则即可
# 修改xray或v2ray配置，实现分流
## v2ray配置分流规则
以配置文件路径`/etc/v2ray/config.json`为例.

- inbounds要启动sniffing
    
```json
"sniffing": {  
    "enabled": true,  
    "destOverride": ["http", "tls"]  
}
```
    
- 修改`outbounds` 和 `routing`，指定的路由域名将从`127.0.0.1:40000`出
- outbounds下添加
```json
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
  ```

- routing下添加
```json
{  
  "type": "field",  
  "domain": [  
    "geosite:google-scholar"  
  ],  
  "marktag": "warp diversion",  
  "outboundTag": "socks5-warp"  
},
```
[geosite、domain-list请参考](https://github.com/v2fly/domain-list-community/tree/master/data)、[geoip请参考](https://github.com/v2fly/geoip)

config.json修改示例
```json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "dns": {},
  "api": {
    "tag": "api",
    "services": [
      "HandlerService",
      "LoggerService",
      "StatsService"
    ]
  },
  "stats": {},
  "policy": {
    "levels": {
      "0": {
        "handshake": 3,
        "connIdle": 258,
        "uplinkOnly": 9,
        "downlinkOnly": 5,
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
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
        "protocol": [
          "bittorrent"
        ],
        "marktag": "ban_bt",
        "outboundTag": "block"
      },
      {
        "type": "field",
        "ip": [
          "geoip:cn"
        ],
        "marktag": "ban_geoip_cn",
        "outboundTag": "block"
      },
      {
        "type": "field",
        "domain": [
          "domain:openai.com"
        ],
        "marktag": "fix_openai",
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "domain": [
          "geosite:google-scholar",
          "geosite:google-play",
          "geosite:netflix",
          "geosite:youtube",
          "geosite:meta",
          "geosite:disney"
        ],
        "marktag": "warp diversion",
        "outboundTag": "socks5-warp"
      },
      {
        "type": "field",
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "block"
      }
    ]
  },
  "inbounds": [
    {
      "tag": "api",
      "port": 25821,
      "listen": "127.0.0.1",
      "protocol": "dokodemo-door",
      "sniffing": {
      "enabled": true,
      "destOverride": ["http", "tls"]
      },
      "settings": {
        "address": "127.0.0.1"
      }
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom"
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
      "tag": "block",
      "protocol": "blackhole"
    }
  ]
}

```

#### [](https://blog.fh6766.com/2023/03/28/serving-with-warp/#2-3-%E9%87%8D%E5%90%AFv2ray "2.3 重启v2ray")2.3 重启v2ray

```
systemctl restart v2ray
```

## Xray配置分流规则

由于是在Xray的服务端进行分流，因此本文指的是，修改Xray服务端配置。

```shell
sudo nano /usr/local/etc/xray/config.json
```

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


 