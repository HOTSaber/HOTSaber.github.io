---
title: 博客主题设置
date: 2023-05-19 19:03:07
categories: 
	- 博客搭建记录
tags: 
	- 主题
	- 本地
	- 搜索
---
# 安装主题

- 在根目录[^01]用gitbash窗口运行以下命令，安装butterfly
```
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/butterfly
```
- 安装成功验证：此时`根目录/theme`文件夹下应当有`butterfly`文件夹
# 选用主题
- 修改根目录下的`config.yml`，把主题改为butterfly,如下所示
```
# Extensions  
## Plugins: https://hexo.io/plugins/  
## Themes: https://hexo.io/themes/  
theme: butterfly
```
# 安装插件
- 安装pug以及stylus的渲染器
```
npm install hexo-renderer-pug hexo-renderer-stylus --save
```
- 为了减少升级主题后带来的不便，请使用以下方法（建议，可以不做）。

	- 在hexo的根目录创建一个文件`_config.butterfly.yml`，并把主题目录的`_config.yml`内容复制到`_config.butterfly.yml`去。(注意:复制的是主题的`_config.yml`，而不是hexo的`_config.yml`)
	
	- 注意：不要把主题目录的`_config.yml`删掉
	
	- 注意：以后只需要在`_config.butterfly.yml`进行配置就行。
	- 如果使用了`_config.butterfly.yml`，配置主题的`_config.yml`将不会有效果。
	
	- Hexo会自动合并主题中的`_config.yml`和`_config.butterfly.yml`里的配置，如果存在同名配置，会使用`_config.butterfly.yml`的配置，其优先度较高。
# 部署本地搜索功能
- 使用以下指令，安装`hexo-generator-search`[^02]搜索插件
```
npm install hexo-generator-search --save
```
- 修改主题配置文件 `_config.butterfly.yml`（按GitHub中的说明进行配置即可）
```
local_search:  
  enable: true  
  path: search.xml  
  field: post  
  content: true  
  template: ./search.xml
```



---
[^01]:在my firs blog中创建的文件夹，即MyBlog文件夹
[^02]:https://github.com/wzpan/hexo-generator-search
参考网址：
[https://butterfly.js.org/posts/21cfbf15/](https://butterfly.js.org/posts/21cfbf15/)
[https://blog.csdn.net/mjh1667002013/article/details/129290903?spm=1001.2014.3001.5506](https://blog.csdn.net/mjh1667002013/article/details/129290903?spm=1001.2014.3001.5506)
