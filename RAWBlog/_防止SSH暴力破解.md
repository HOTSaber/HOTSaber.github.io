#### 1. 禁止密码登录，强制使用 SSH 密钥（最有效）

密码登录是暴力破解的主要目标，改用密钥登录可彻底杜绝此类风险：

```bash
# 1. 编辑 SSH 配置文件
sudo vim /etc/ssh/sshd_config

# 2. 修改以下配置（确保无 # 注释，值为 no）
PasswordAuthentication no  # 禁用密码登录
ChallengeResponseAuthentication no  # 禁用挑战式认证

# 3. 保存退出后，重启 SSH 服务使配置生效
sudo systemctl restart sshd
```

> 注意：操作前需确保已在本地生成 SSH 密钥并上传到服务器（如 `ssh-copy-id 用户名@服务器IP`），否则会导致自己无法登录！
#### 2. 限制 SSH 允许登录的用户

仅允许信任的用户登录 SSH，避免黑客尝试默认用户名（如 root、ubuntu）：

```bash
# 编辑 SSH 配置文件
sudo vim /etc/ssh/sshd_config

# 添加/修改配置（替换为你的实际用户名，多个用户用空格分隔）
AllowUsers your_username  # 仅允许 your_username 登录
# （可选）禁止 root 直接登录：PermitRootLogin no

# 重启服务生效
sudo systemctl restart sshd
```
#### 3. 屏蔽恶意 IP（临时应急）

对日志中出现的 4 个 IP，可通过 `iptables` 或 `ufw` 防火墙直接屏蔽，阻止其再次尝试：
```bash
# 以 ufw 防火墙为例（Ubuntu 默认预装）
sudo ufw deny from 193.46.255.33 to any port 22
sudo ufw deny from 193.46.255.103 to any port 22
sudo ufw deny from 80.94.93.119 to any port 22
sudo ufw deny from 91.224.92.28 to any port 22

# 启用 ufw 防火墙（若未启用）
sudo ufw enable
# 查看防火墙状态
sudo ufw status
```
#### 4. 安装 fail2ban（自动封禁暴力破解 IP）

`fail2ban` 是一款自动防护工具，可监控 SSH 日志，当检测到多次失败登录时，自动封禁该 IP 一段时间（如 10 分钟），无需手动操作：

```bash
# 安装 fail2ban
sudo apt update && sudo apt install -y fail2ban

# 启动并设置开机自启
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# 查看 fail2ban 状态（确认 sshd 规则已启用）
sudo fail2ban-client status sshd
```
### 四、后续验证：确认防护生效

配置完成后，可通过以下命令验证 SSH 服务和防护是否正常：
1. 检查 SSH 服务状态（确保重启后仍运行）：`sudo systemctl status sshd`
2. 查看 fail2ban 封禁记录（确认恶意 IP 被拦截）：`sudo fail2ban-client status sshd`
3. 本地测试登录（确保自己能通过密钥正常登录）：`ssh 用户名@服务器IP`
通过以上措施，可有效防范 SSH 暴力破解，保障服务器安全。若后续仍频繁出现陌生 IP 尝试，建议进一步检查是否有其他端口暴露在外，或考虑使用「端口转发」「VPN 访问」等更严格的访问控制方式。