# 新加节点配置
这里我们以trojan为例
![[_xray_x-ui使用-1.png]]
配置好以上参数，端口与密码会自动随机生成
# 配置caddy反代
在/etc/caddy/2233boy/下新加配置文件server.hostaber.cn_test.conf
**ps这里因为使用了v2ray脚本，所以有此路径文件**
```

```
# 配置xray出站规则
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