# kex_exchange_identification
1. **创建或编辑 SSH 配置文件**‌  
    在您的用户目录下的 `.ssh` 文件夹中，找到或创建一个名为 `config` 的文件（无扩展名）。
    
2. ‌**配置 GitHub 使用 443 端口**‌  
    在 `config` 文件中添加以下内容：
    
```
Host github.com
	Hostname ssh.github.com
	Port 443
	User git
```
    
    这段配置指示 SSH 客户端通过 `ssh.github.com` 的主机名和 443 端口来连接 GitHub