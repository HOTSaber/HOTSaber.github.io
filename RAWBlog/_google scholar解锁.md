****
[参考文章](https://yaoxi-std.net/zh/posts/services/google-scholar-unban-ipv6/)
scholar 一般只封锁 IPv4。所以先尝试根据资料修改代理节点上的 hosts 文件。
****

在VPS文件 `/etc/hosts`中，添加
```hosts
2404:6800:4008:c06::be scholar.google.com
2404:6800:4008:c06::be scholar.google.com.hk
2404:6800:4008:c06::be scholar.google.com.tw
2404:6800:4005:805::200e scholar.google.cn
```

,"geosite:google-scholar"
,"geosite:google-gemini"