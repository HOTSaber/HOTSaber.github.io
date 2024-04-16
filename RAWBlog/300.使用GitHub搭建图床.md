---
title: 使用GitHub搭建图床
date: 2024-04-16  00:37:36
categories:
  - GitHub
tags:
  - 图床
  - GitHub
  - Git
  - PicGo
  - Obsidian
---
****
腾讯云图床请参考[搭建图床](https://hotsaber.github.io/2023/05/20/4.%E6%90%AD%E5%BB%BA%E5%9B%BE%E5%BA%8A/)
****
#  在GitHub创建一个新仓库，用于存放图片
- 填写仓库名称和描述，且仓库必须是public的，否则存储的图片不能正常访问。
# 生成一个token，用于picGo访问github
1. 在**GitHub个人账户**中进入`settings`-->`Developer settings`-->`Personal access tokens`-->`token(classic)`选择`Generate new token`
   ps:**不是仓库的settings**，只有token(classic)才有无限期token
2. 填写`Note`，选择`No expiration`,勾选`repo`，点击`Generate token`
   **ps:生成的token只会在这里显示一次，后续无法查看，记得提前复制**
# picgo设置
## 下载picgo
访问 PicGo 的 Github 项目地址并安装PicGo客户端：[Releases · Molunerfinn/PicGo (github.com)](https://eryinote.com/go?_=31614169aaaHR0cHM6Ly9naXRodWIuY29tL01vbHVuZXJmaW5uL1BpY0dvL3JlbGVhc2Vz)
# picgo设置
![[300.使用GitHub搭建图床-1.png]]
1. 进入`图床设置`-->`GitHub`
2. 设定`仓库名`、`分支名`
   - 仓库名为：github用户名/第一步新建的仓库名称
   - 分支名：main【默认为main】
3. 填写`token`
4. 如果图片是存放在仓库的子文件中的，可以设置`存储路径`，如`image/`
5. 设置`自定义域名`
	   这里我们通过jsDelivr实现Github的图床CDN加速
	   可以访问[jsDelivr官网](https://www.jsdelivr.com/?docs=gh)查看教程，自定义域名如下：
	    `https://<jsDelivr加速域名>/gh/<用户>/<项目>@<版本>
	    原本github的自定义域名应该是：
	    `https://raw.githubusercontent.com/[username]/[仓库名]]`
# obsidian一键上传
请参考[obsidian入门教程--图片上传进阶内容](https://hotsaber.github.io/2023/07/09/8.obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B/#%E5%9B%BE%E7%89%87%E4%B8%8A%E4%BC%A0%EF%BC%88%E8%BF%9B%E9%98%B6%E5%86%85%E5%AE%B9%EF%BC%89)

# GitHub与腾讯云链接互换
以[obsidian 入门教程](https://hotsaber.github.io/2023/07/09/8.obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B/)的图`obsidian 入门教程-1`为例
其jsdelivr链接为：
```
https://cdn.jsdelivr.net/gh/HOTSaber/Imagehosting@main/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-1.png
```
其腾讯云链接为：
```
https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-1.png
```
可以看到在`/blogpic/.....`后的内容是完全一样的，只是`/blogpic/...`前的内容不一样，所以只要图片名保持一置，通过修改图片名前的web地址，我们可以实现在不同的图床间进行切换。
**前提是两个图床中都有此文件**
这里我们将[obsidian 入门教程](https://hotsaber.github.io/2023/07/09/8.obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B/)中图片编号奇数的设为jsdelivr链接，偶数的设为腾讯云链接，以供参考。
****
[jsdelivr](https://www.jsdelivr.com/?docs=gh)是一个免费的公共CDN（内容分发网络）服务，它允许网站开发者将他们的代码库、JavaScript库、字体和其他资源托管在jsdelivr上，并通过jsdelivr的CDN网络进行快速分发。使用jsdelivr可以有效地减少用户下载资源的时间，提高网页加载速度，同时减轻原始服务器的负载。  
jsdelivr支持多种类型的文件托管，包括JavaScript、CSS、字体、图片等。开发者可以将自己的文件上传到jsdelivr，并获取一个指向这些文件的URL。然后，他们可以在自己的网站中引用这些URL，jsdelivr会自动处理文件的缓存、分发和版本控制。
****
