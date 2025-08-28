# 安装X-ui
```bash
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
```
x-ui 管理脚本使用方法:
```bash
 ----------------------------------------------
x-ui              - 显示管理菜单 (功能更多)
x-ui start        - 启动 x-ui 面板
x-ui stop         - 停止 x-ui 面板
x-ui restart      - 重启 x-ui 面板
x-ui status       - 查看 x-ui 状态
x-ui enable       - 设置 x-ui 开机自启
x-ui disable      - 取消 x-ui 开机自启
x-ui log          - 查看 x-ui 日志
x-ui v2-ui        - 迁移本机器的 v2-ui 账号数据至 x-ui
x-ui update       - 更新 x-ui 面板
x-ui install      - 安装 x-ui 面板
x-ui uninstall    - 卸载 x-ui 面板
----------------------------------------------

```
# 使用一键脚本

[项目网址](https://gitlab.com/rwkgyg/CFwarp)

```bash

wget -N https://gitlab.com/rwkgyg/CFwarp/raw/main/CFwarp.sh && bash CFwarp.sh

```
## 启动脚本并安装


```bash
# 步骤1, 启动脚本
./CFwarp.sh

# 步骤2，选择3【warp-go 非全局代理模式】

# 步骤3，选择1【方案一：安装/切换WARP-GO】

# 结果：
 #方案一：当前 IPV4 接管VPS出站情况如下（WARP监测已开启）
 #WARP状态：运行中，WARP普通账户(无限WARP流量)
 #服务商 Cloudflare 获取IPV4地址：104.28.201.73  美国
 #奈飞NF解锁情况：恭喜，当前IP完整解锁Netflix非自制剧
 #ChatGPT解锁情况：恭喜，当前IP完整解锁ChatGPT (网页+客户端)

```

配置文件目录:`/usr/local/bin/warp.conf`

```
**-----------------------------------------------------------------------------------------**

**相关快捷方式：**

**一、warp-go-warp**

**启动systemctl enable warp-go**

**开始systemctl start warp-go**

**状态systemctl status warp-go**

**重启systemctl restart warp-go**

**停止systemctl stop warp-go**

`**强制停止kill -15 $(pgrep warp-go)**`

**关闭systemctl disable warp-go**

**二、wgcf-warp**

**查看WARP当前统计状态：wg**

**手动临时关闭WARP网络接口wg-quick down wgcf**

**手动开启WARP网络接口wg-quick up wgcf**

**启动systemctl enable wg-quick@wgcf**

**开始systemctl start wg-quick@wgcf**

**状态systemctl status wg-quick@wgcf**

**重启systemctl restart wg-quick@wgcf**

**停止systemctl stop wg-quick@wgcf**

**关闭systemctl disable wg-quick@wgcf**

**三、socks5-warp**

**systemctl is-active warp-svc**

**systemctl is-enabled warp-svc**

**warp-cli --accept-tos status**

**warp-cli --accept-tos account**

**warp-cli --accept-tos settings**

**状态systemctl status** **warp-svc**

**重启systemctl restart** **warp-svc**

**停止systemctl stop** **warp-svc**

**关闭systemctl disable** **warp-svc**
```

## 刷新/更换 CloudFlare Warp IP

```bash
# 使用这个命令,每次重启都会刷新IP
systemctl restart wg-quick@wgcf
```

## 配置v2ray

`v2ray` 的配置文件一般位于 `/etc/v2ray/config`，这里我们修改 `outbounds` 和 `routing` 配置

```json
# outbounds 增加一栏
#  {
#   "tag": "IP6_out",
#   "protocol": "freedom",
#   "settings": {
#     "domainStrategy": "UseIPv6"
#   }

# routing 给每个rules 增加 type, domain 和 outboundTag
# "type": "field",
# "domain": [ "openai.com" ],
# "outboundTag": "IP6_out"
```


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
      "port": xxxx,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "IP6_out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      }
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "policy": {
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "routing": {
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "type": "field",
        "domain": [
          "openai.com"
        ],
        "outboundTag": "IP6_out"
      },
      {
        "ip": [
          "geoip:private"
        ],
        "type": "field",
        "domain": [
          "openai.com"
        ],
        "outboundTag": "IP6_out"
      },
      {
        "protocol": [
          "bittorrent"
        ],
        "type": "field",
        "domain": [
          "openai.com"
        ],
        "outboundTag": "IP6_out"
      }
    ]
  },
  "stats": {}
}
```

:::

由于笔者安装了 `xui`, 所以配置文件直接在网页上修改，然后重启面板生效

```
#官方教程：https://pkg.cloudflareclient.com/install

#安装WARP仓库GPG 密钥：
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

#添加WARP源：
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

#更新APT缓存：
apt update

#安装WARP：
apt install cloudflare-warp

#注册WARP：
warp-cli registration new

#设置为代理模式（一定要先设置）：
warp-cli set-mode proxy

#连接WARP：
warp-cli connect

#查询代理后的IP地址：
curl ifconfig.me --proxy socks5://127.0.0.1:40000

```

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
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "netflix_proxy",
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
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "policy": {
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "netflix_proxy",
        "domain": [
          "geosite:netflix",
          "geosite:disney"
        ]
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "ip": [
          "geoip:private"
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
      }
    ]
  },
  "stats": {}
}
```

```json
1. {  
    
2.   "protocol": "wireguard",  
    
3.   "tag": "wireguard-1",  
    
4.   "settings": {  
    
5.     "secretKey": "123N7VAfvuL3ReOM4ZZOduq1jEdmpg0J0ao3YYGnQwEmQ=",  
    
6.     "Address": ["172.16.0.2/32","2606:4700:110:8f5e:bbb5:49af:4b2f:68d6/128"],  
    
7.     "dns": "1.1.1.1",  
    
8.     "mtu": 1280,  
    
9.     "peers": [  
    
10.       {  
    
11.         "publicKey": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",  
    
12.         "AllowedIPs": ["0.0.0.0/0","::/0"],  
    
13.         "endpoint": "engage.cloudflareclient.com:2408"  
    
14.       }  
    
15.     ]  
    
16.   }  
    
17. },

```

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
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "policy": {
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "routing": {
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "ip": [
          "geoip:private"
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
      }
    ]
  },
  "stats": {}
}
```