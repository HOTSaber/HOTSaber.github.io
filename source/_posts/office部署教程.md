---
title: office 365 部署教程
date: 2023-07-06 09:06:07
categories:
	- 文档编辑与管理
tags: 
	- office
	- office 365
	- office tool
---
---------
1. 为什么使用`office 365`或高版本`office`? 详见[office共享与在线协作](https://hotsaber.github.io/2023/09/18/office共享与在线协作/)
2. 官方详细教程可访问[网址](https://www.coolhub.top/archives/42)
3. **部署前需要卸载老版本，并清除注册信息与重置office设置**
4. **如卸载失败，可以使用`工具箱`中的`移除office`功能强制移除**
**********
# Office tool plus 部署工具
## 下载地址
- [百度网盘](https://pan.baidu.com/s/17S1IMN5U4X-5kvri-iL2LA)
- [官网下载](https://otp.landian.vip/zh-cn/download.html)（下载包含框架版本）
# 清除旧版本Office
1. 卸载WPS Office，两者共存容易出问题
2. 卸载旧版本 Office，按照标准流程操作，请勿直接强制移除。
3. 清除旧版本激活信息，看下面的截图来学习。
4. 清除 Office 设置，在\[工具箱] -> \[重置 Office 为默认设置]。
5. **如卸载失败，可以使用`工具箱`中的`移除office`功能强制移除**
- 清除激活信息
![](https://www.coolhub.top/wp-content/uploads/2023/01/clear-activation-v10.png)
![](https://www.coolhub.top/wp-content/uploads/2022/06/clear-activation.png)
- 重置Office设置
![](https://www.coolhub.top/wp-content/uploads/2023/01/reset-office-settings-v10.png)
![](https://www.coolhub.top/wp-content/uploads/2020/04/reset-Office-settings.png)
# Office安装（部署）
## 指令安装
- 按下 Ctrl + Shift + P 打开命令框,输入以下命令，部署off365企业应用版，与visio2019
```
deploy /addProduct O365ProPlusRetail_zh-cn_Access,Bing,Groove,Lync,OneDrive,OneNote,Outlook,Publisher,Teams /addProduct VisioStd2019Volume_zh-cn_Groove,OneDrive /channel Current /downloadFirst
```
- **手动部署请参考[网址](https://www.coolhub.top/archives/11)**
部分设置可参考下图
![](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/office%20%E9%83%A8%E7%BD%B2%E6%95%99%E7%A8%8B.png)
# 激活Office
## 指令激活
```
ospp /insLicID MondoVolume /sethst:kms.loli.best /setprt:1688 /act
```
**上述代码可一次性激活 Office, Visio, Project，同时适用 Win 7/8，能使用 Office 的所有功能。**
## 手动激活
1. **安装 Office 批量许可证 (Volume)**，无论如何，这里你都要选批量许可证。
2. 设置一个 KMS 主机地址（可以设置端口为 1688）并保存设置。
3. 点击激活按钮，等待激活完成。
**office 365企业版需要选择Office Mondo 2016 批量许可证**
![](https://www.coolhub.top/wp-content/uploads/2022/06/clear-activation.png)
*****
**如有更多问题可以访问[官网教程]()**
或通过软件中的帮助链接访问管网教程
![](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/office%20%E9%83%A8%E7%BD%B2%E6%95%99%E7%A8%8B-1.png)
