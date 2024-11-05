
在Ubuntu 22.04 LTS上部署WebDAV可以通过Apache或Nginx等Web服务器实现。以下是使用Apache部署WebDAV的步骤：

### 步骤 1：安装Apache

首先，确保你的服务器上安装了Apache。如果还没有安装，可以使用以下命令：

```bash
sudo apt update
sudo apt install apache2
```

### 步骤 2：启用WebDAV模块

接下来，启用Apache的WebDAV模块，与身份验证模块：

```bash
sudo a2enmod dav
sudo a2enmod dav_fs
sudo a2enmod auth_basic 
sudo a2enmod authn_file
```

### 步骤 3：创建WebDAV目录

选择一个目录作为WebDAV的存储位置。例如，我们可以创建一个名为`/var/www/webdav`的目录：

```bash
sudo mkdir /var/www/webdav
```

设置适当的权限：

```bash
sudo mkdir -p /var/www/webdav
sudo chown -R www-data:www-data /var/www/webdav
sudo chmod -R 775 /var/www/webdav
```

### 步骤 4：配置WebDAV

创建一个新的Apache配置文件，或修改现有的配置文件。我们可以创建一个新的配置文件：

```bash
sudo nano /etc/apache2/sites-available/webdav.conf
```

在文件中添加以下内容：

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/webdav

    Alias /webdav /var/www/webdav

    <Directory /var/www/webdav>
        Options Indexes MultiViews
        AllowOverride None
        Require all granted
    </Directory>

    <Location />
        Dav On
        AuthType Basic
        AuthName "Austin"
        AuthUserFile /etc/apache2/webdav.htpasswd
        Require valid-user
    </Location>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
编辑结束后使用`ctrl+o`保存，`enter`确认保存目录，`ctrl+x`退出编辑
如果有`000-default.conf`文件存在则：
#### 确保 `webdav.conf` 的优先级

如果您希望保持 `webdav.conf` 单独配置，确保它被启用并且在 `sites-enabled` 目录中优先于 `000-default.conf`。您可以通过调整文件名来实现，例如将 `webdav.conf` 重命名为 `001-webdav.conf`，以确保它在 `000-default.conf` 之前加载。

或者：
#### 修改 `000-default.conf`

如果您希望将 WebDAV 与默认虚拟主机结合，可以在 `000-default.conf` 中添加 WebDAV 配置：

```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/webdav

    Alias /webdav /var/www/webdav

    <Directory /var/www/webdav>
        Options Indexes MultiViews
        AllowOverride None
        Require all granted
    </Directory>

    <Location />
        Dav On
        AuthType Basic
        AuthName "Austin"
        AuthUserFile /etc/apache2/webdav.htpasswd
        Require valid-user
    </Location>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
### 步骤 5：创建用户和密码

使用`htpasswd`命令创建一个用户，以便进行身份验证：

```bash
sudo apt install apache2-utils
sudo htpasswd -c /etc/apache2/webdav.htpasswd Austin
```

系统会提示你输入和确认密码。CHQS407to512

### 步骤 6：启用网站配置

启用刚刚创建的WebDAV配置，并重新加载Apache：

```bash
sudo a2ensite webdav.conf
sudo systemctl reload apache2
```

### 步骤 7：防火墙设置

如果你启用了UFW防火墙，确保允许HTTP流量：

```bash
sudo ufw allow 'Apache'
```

### 步骤 8：测试WebDAV

现在，你可以通过浏览器或WebDAV客户端访问WebDAV服务。访问`http://your_server_ip/webdav`，输入你创建的用户名和密码。

### 其他注意事项

- **HTTPS**：建议在生产环境中使用HTTPS来保护数据传输。可以使用Let’s Encrypt等工具为你的Apache服务器配置SSL证书。
- **权限和安全**：根据需要调整文件和目录的权限，确保安全性。

通过上述步骤，你应该能够在Ubuntu 22.04 LTS上成功部署WebDAV服务。如果遇到问题，可以查看Apache的错误日志以获取更多信息：

```bash
sudo tail -f /var/log/apache2/error.log
```

# 步骤9: 在windows上配置webdav为共享磁盘
****
参考[Windows下WebDAV映射网络驱动器若干问题](https://www.cnblogs.com/qianjiashi/p/15704595.html "发布于 2021-12-18 11:04")与[在 Windows 上使用 WebDAV 装载共享文件夹](https://docs.qnap.com/operating-system/qts/4.5.x/zh-cn/GUID-31D5B05F-F29E-4D61-9758-C8CF839C14FD.html)
****
## 前言

发现 `Windows` 默认只支持 `HTTPS` 方式的 `WebDAV` 映射，默认不支持 `HTTP` 方式的 `WebDAV` 映射，有没有办法在不安装第三方客户端的情况下，让 `Windows` 支持 `HTTP` 方式的 `WebDAV` 映射呢？上网一查是有的，只不过要改注册表

## 具体操作

1. 改注册表

`计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters` 下，把 `BasicAuthLevel` 的值改为 `2` ( ‘1’ 默认只支持 HTTPS，’2’ 支持 HTTP 和 HTTPS)

2. 重启服务

`以管理员身份运行CMD`

```dos
net stop webclient 
net start webclient
```

或者
进入`控制面板 -> 系统和安全(或系统和维护) -> 管理工具 -> 服务`，打开的弹窗中，找到 `WebClient`，启动之(如果已停止的话)，并且最好设置`启动类型`为`自动`。

3. 映射网络驱动器

计算机 –> 右键 –> 映射网络驱动器 –> 填写相应的信息 –> 完成
注意启用`登录时重新连接`以及`使用其他凭据连接`。

第二个问题：

转载自：https://blog.52nyg.com/2021/06/691

WebDav连接上后，结果提示：

在webdav中复制文件出来会提示此错误:"文件大小超出允许的限制，无法保存"

这是因为Windows默认限制为50MB文件大小 超出不允许复制

解决方法：  
1. 按 Win + R 键  
2. 在运行窗口输入regedit,按回车  
3. 在打开的注册表编辑器中进入这个地址：HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters  
4. 找到FileSizeLimitInBytes，双击打开  
5. 在打开的设置窗口，选择decimal（十进制）  
6. 修改限制的大小，比如加个0（默认是50M,即50000000）其实有最大值限制，4294967295~4,095.9MB=4GB，也就是32位系统能提供的最大值了
7. 修改好后，再选择hexadecimal（十六进制）  
8. 保存，然后重启电脑