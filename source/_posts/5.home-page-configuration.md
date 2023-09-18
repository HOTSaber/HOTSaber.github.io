---
title: 页面设置
date: 2023-05-19 19:28:37
categories: 
	- 博客搭建记录
tags: 
	- 导航栏
	- 参数
	- 解释
	- 菜单
	- 页面
	- hexo
---
# 导航栏设置
- 修改主配置文件中的`_config.butterfly.yml_`如下所示
```
nav:  
  logo: # image  
  display_title: true  
  fixed: false # fixed navigation bar
```
| 参数 |解释 |
| :----: | :---- |
| logo | 网站的logo，支持图片，直接填入图片链接 |
| display_title | 是否显示网站标题， true or false |
| fixed | 是否固定状态栏， true or false |
# 菜单/目录
- 修改主配置文件中的`_config.butterfly.yml_`如下所示
```
  主页: / || fas fa-home  
  博文 || fa fa-graduation-cap:  
    分类: /categories/ || fa fa-archive  
    标签: /tags/ || fa fa-tags  
    归档: /archives/ || fa fa-folder-open  
#  生活 || fas fa-list:#    分享: /shuoshuo/ || fa fa-comments-o  
#    相册: /photos/ || fa fa-camera-retro  
#    音乐: /music/ || fa fa-music  
#    影视: /movies/ || fas fa-video  
  友链: /links/ || fa fa-link  
#  留言板: /comment/ || fa fa-paper-plane  
#  留言板: /messageboard/ || fa fa-paper-plane  
  关于笔者: /about/ || fas fa-heart
```
- 以上所有的导航栏中的栏目一定都要使用`hexo new page 项目名`在根目录新建文件夹
# 标签页
- 前往根目录，使用gitbash，输入以下命令
```
hexo new page tags
```
	- 找到`source/tags/index.md`这个文件，并修改这个文件，添加`type: "tags"`：
```
--- 
title: 标签  
date: 2023-05-19 19:35:40  
type: tags  
orderby: random   
order: 1
---
```
| 参数 |解释 |
| :----: | :---- |
| type | 【必须】页面类型，必须为tag |
| orderby | 【可选】排序方式：random/name/length |
| order | 【可选】排序次序： 1, asc for ascending; -1, desc for descending |
- 使用以下命令依次按需求添加自己所需页面，应与`菜单\目录`中内容相对应，使用命令会自动生成`index`文件，可以批量新建page后再逐一修改`index`文件
```
hexo new page categories
hexo new page link
```
- 在根目录`source`中创建`_data`文件夹，在其中创建一个`link.yml`文件，写入以下内容，其中`class_name` 和 `class_desc` 支持 html 格式书写，如不需要，也可以留空。
```
- class_name: 链接
  class_desc: 那些人，那些事
  link_list:
    - name: GitHub
      link: https://github.com/
      avatar: https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/20230520173243.png
      descr: 开源代码托管平台
    - name: Hexo
      link: https://hexo.io/zh-tw/
      avatar: https://d33wubrfki0l68.cloudfront.net/6657ba50e702d84afb32fe846bed54fba1a77add/827ae/logo.svg
      descr: 快速、简单且強大的博客框架

- class_name: 网站
  class_desc: 值得推荐的网站
  link_list:
    - name: BiliBili
      link: www.bilibili.com
      avatar: https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/20230520173745.png
      descr: 中国最大学习网站
    - name: Youtube
      link: https://www.youtube.com/
      avatar: https://i.loli.net/2020/05/14/9ZkGg8v3azHJfM1.png
      descr: 视频网站
    - name: Weibo
      link: https://www.weibo.com/
      avatar: https://i.loli.net/2020/05/14/TLJBum386vcnI1P.png
      descr: 中国最大社交分享平台
    - name: Twitter
      link: https://twitter.com/
      avatar: https://i.loli.net/2020/05/14/5VyHPQqR6LWF39a.png
      descr: 社交分享平台
```














