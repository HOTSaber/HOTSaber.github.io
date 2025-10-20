****
想要实现访问`chqsteam.com`自动转向`hotsaber.cn`
****
使用cloudflare中的`页面规则`（page rules）进行域名重定向设置
- 注意URL中要以`/*`结尾
- 目标URL中要以`http`或'https'开头，是完整的URL
- free版cloudflare支持3个域名重定向规则
![[_cloudflare_域名重定向-1.png]]