[视频演示](https://drive.google.com/file/d/1cXcIHCNbZuXpL9UrR_h6PrTzOiGXr4_L/view)

就在不解锁的机器上套warp，不需要额外搞台机器的。你可以了解一下这个项目：[fscarmen/warp](https://gitlab.com/fscarmen/warp)。

如果你用的是xui面板。可以先用warp脚本在服务器上创建一个socks5代理，接着修改xui面板的xray配置将openai的请求全部交给warp出站，这样原本不解锁GPT移动端的代理节点就能解锁了。[指定网站分流到 socks5 的 xray 配置模板 (适用于 WARP Client Proxy 和 WireProxy)](https://gitlab.com/fscarmen/warp#%E6%8C%87%E5%AE%9A%E7%BD%91%E7%AB%99%E5%88%86%E6%B5%81%E5%88%B0-socks5-%E7%9A%84-xray-%E9%85%8D%E7%BD%AE%E6%A8%A1%E6%9D%BF-%E9%80%82%E7%94%A8%E4%BA%8E-warp-client-proxy-%E5%92%8C-wireproxy)。

当然这个的前提是你的vps处在openai支持的国家和地区。如果机器不在openai支持的国家和地区，那么需要通过链式代理的方式解决，不在openai支持的国家和地区仅仅套warp，得到的warp ip还是不在openai支持的国家和地区的。你开的aws ec2应该身处openai支持的国家和地区吧。

操作步骤：

```shell
# 下载并执行warp脚本。
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh

输入2，选择简体中文

输入13，安装 wireproxy，让 WARP 在本地创建一个 socks5 代理 (bash menu.sh w) 

直接回车，自定义client端口号为40000。【第一次接触warp可以直接回车，安装完warp socks代理。以后慢慢熟悉了，可以将免费版本的warp可以升级为warp+或者team。】

接着就是修改xui面板的xray配置。将下面代码替换掉默认的xray配置，比默认的xray配置多了一个socks出站和一个路由规则，凡是openai的请求全部交给warp的socks端口处理。

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
    ],
    "policy": {
        "levels": {
            "0": {
                "handshake": 10,
                "connIdle": 100,
                "uplinkOnly": 2,
                "downlinkOnly": 3,
                "statsUserUplink": true,
                "statsUserDownlink": true,
                "bufferSize": 10240
            }
        },
        "system": {
            "statsInboundDownlink": true,
            "statsInboundUplink": true
        }
    },
    "routing": {
        "rules": [
            {
                "type":"field",
                "domain":[
                    "geosite:openai"
                ],
                "outboundTag":"warp"
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

保存配置，重启xui面板，原本不解锁GPT APP的节点就解锁了。
```