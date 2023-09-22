---
title: deploy new blog
date: 2023-05-19 19:01:22
categories: [博客搭建记录]
tags: [deploy, markdown, hexo]
---
# 上传内容
1. 安装扩展
	- `npm i hexo-deployer-git`
2. 输入`hexo new post "我的第一篇博客"`创建一篇文章
3. 然后打开`D:\Hexo\source\_posts`的目录，可以发现下面多了一个文件夹和一个`.md`文件，一个用来存放你的图片等数据，另一个就是你的文章文件
4. 编写完markdown文件后，根目录下输入`hexo g`生成静态网页，然后输入`hexo s`可以本地预览效果，最后输入`hexo d`上传到`github`上。这时打开你的`github.io`主页就能看到发布的文章啦。
