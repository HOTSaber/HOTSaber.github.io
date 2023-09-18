---
title: obsidian 入门教程
date: 2023-07-09 09:06:07
categories:
	- 文档编辑与管理
tags: 
	- obsidian
	- 截图快捷键
	- 相对路径
	- 转义
---

****

**本教程主要用于组会记录员使用，记录员需熟练使用md格式文档，后续会议记录我们会将md文档共享在小组博客，以供大家学习使用**

****

# 部署

从[官网](https://obsidian.md/)下载安装程序

# 使用前设置

## 新建一个仓库
- 选定位置新建一个仓库
**此后md文档与相应附件都尽量保存在仓库目录下**
![obsidian 入门教程-1](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-1.png)
## 配制附件文件夹
- 进入设置-->文件与链接-->附件默认存放路径，选择`指定的附件文件夹`-->设置附件文件路径为`blogpic`
![obsidian 入门教程-4](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-4.png)
**为方便管理员更新博客，请都采用md格式，采用*****相同的附件文件名***
## 安装必备第三方插件
1. 进入设置-->第三方插件-->社区插件市场
**插件市场可能需要挂VPN访问**
![obsidian 入门教程-3](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-3.png)
2. 搜索`paste image rename` 进行安装，并进行相应设置
![obsidian 入门教程-5](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-5.png)
**此时向文档中黏贴截图文件时就不会有文件名乱码的情况**
**windows系统下，截图快捷键为`ctrl+shift+s`**
3. **在打包发送文档时，要将文件与md文件共同打包成一个压缩包发送**
![obsidian 入门教程-6](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-6.png)
**最后将压缩包发给博客管理员**

# md语法格式

- 详细内容请见[markdown格式语法](https://hotsaber.github.io/2023/07/06/md%E8%AF%AD%E6%B3%95/)
----
# 相对路径与绝对路径的理解

- 现有文件结构如下
![obsidian 入门教程-8](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-8.png)
在`test.py`中想调用`excelexp.xlsx`有两种`文件路径`表达方式：
1. 使用绝对路径
```
df = pd.read_excel(r"D:\pyproject\Learn\excelexp.xlsx")
```
2. 使用相对路径
```
df = pd.read_excel(r".\excelexp.xlsx")
```
最终实现的结果都是一样的，但绝对路径的使用有一个问题，如果将代码分享给他人后，文件位置不在D盘了，或者上级文件有名称不对应，则会因为路径错误而无法找到文件。
- 其中`D:\pyproject\Learn\excelexp.xlsx`路径的文件寻址顺序为
![obsidian 入门教程-8](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-8.jpg)
- 其中`D:\pyproject\Learn\excelexp.xlsx`路径的文件寻址顺序为
![obsidian 入门教程-9](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/obsidian%20%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B-9.jpg)
所有标红的文件或文件夹都不能有所变动，一但变动，程序就无法按照寻址顺序找到相应文件
**可以看出，在程序寻址时，相对路径的表达方式所设计到的文件最少**
**只要标红的文件不改变，程序就可以完成寻址**
**所以采用相对路径时，只要把`Learn`文件打包发给别人，就可以在别人的计算机上运行相应程序了**
********
**`r“D:\XXXXX”`中`r`表示的是原始字符串，因为`\`在python中有转义作用，如`\n`等，所以用`r`表示后续内容非转义，使用`/`则不用考虑此问题**
****
# 图片上传（进阶内容）

- 使用图片上传功能需要使用`image auto upload Plugin`插件，实现一键上传
- 需要`picgo`转件，与自建图床，详细教程请访问博客[搭建图床](https://hotsaber.github.io/2023/05/20/%E6%90%AD%E5%BB%BA%E5%9B%BE%E5%BA%8A/)