## 一、准备文件

### [](https://www.seayj.cn/articles/11491/index.html#1-1-%E4%B8%8B%E8%BD%BD "1.1 下载")1.1 下载

[点击下载](https://www.seayj.cn/articles/11491/prism.css) `prism.css`  
[点击下载](https://www.seayj.cn/articles/11491/prism.js) `prism.js`

然后将这两份文件复制到 `博客根目录/themes/{主题文件夹}/source/libs/prism/` 目录下！

### [](https://www.seayj.cn/articles/11491/index.html#1-2-%E8%AF%B4%E6%98%8E "1.2 说明")1.2 说明

您可能会发现在该目录下会已经存在一个 `prism.css` 文件，那是主题自带的，也可以使用，您可以按照需自己的需求来！但是**如果使用默认的** `prism.css` **一定使用配套的** `prism.js` ！否则会出现问题！如果想使用自定义的 `prismJS` 高亮规则，可以去官网配置并下载：[自定义 prismJS 规则](https://www.seayj.cn/articles/11491/index.html)！

**补充：**  
我不知道为什么，我的 `博客根目录/themes/{主题文件夹}/source/libs/prism/` 目录下只有一个 `prism.css` ，这使得我的博客代码高亮出了很大问题！后来我自己配置一套 `prismJS` 文件后才解决的问题！

同时，您需要知道的是：PrismJS 官网下载的 prism 文件在 `hexo-theme-matery` 主题下显示有些冲突，需要您去修改对应的 CSS 文件。这里我已经修改好了，所以 `hexo-theme-matery` 主题的朋友，您可以直接使用我提供的下载，它支持几乎所有语言得代码高亮！（其他主题我未做探索）

## [](https://www.seayj.cn/articles/11491/index.html#%E4%BA%8C%E3%80%81%E9%85%8D%E7%BD%AE-prismJS "二、配置 | prismJS")二、配置 | prismJS

这里我只讲解 `prismJS` 的配置方法，因为它不会像 `Highlight` 在 `hexo-theme-matery` 主题中出现显示问题（个人感觉 Matery 主题更适合使用 `prismJS` 进行代码高亮）

### [](https://www.seayj.cn/articles/11491/index.html#2-1-%E4%BF%AE%E6%94%B9-config-yml-%E6%A0%B9%E7%9B%AE%E5%BD%95 "2.1 修改 _config.yml(根目录)")2.1 修改 _config.yml(根目录)

在根目录下的 `_config.yml` 文件中找到对应代码位置并修改成如下内容：

yaml

_config.yml(根目录)
```
highlight:  
enable: false # 关闭 highlight  
prismjs:  
enable: true # 启用 prismjs  
preprocess: true # Hexo 内建的 PrismJS 支持浏览器端高亮（preprocess 设置为 false）和服务器端高亮（preprocess 设置为 true）两种方式  
line_number: true # 是否显示行号  
line_threshold: 0 # 接受一个可选的阈值，只要代码块的行数超过这个阈值，就只显示行号。 默认值为 0。  
tab_replace: '' # 用代码内的 tab (\t) 替换为给定值，默认值是两个空格。
```
### [](https://www.seayj.cn/articles/11491/index.html#2-2-%E4%BF%AE%E6%94%B9-config-yml-%E4%B8%BB%E9%A2%98%E7%9B%AE%E5%BD%95 "2.2 修改 _config.yml(主题目录)")2.2 修改 _config.yml(主题目录)

在根目录下的 `_config.yml` 文件中找到对应代码位置并确保 `libs.css.prism` 和 `libs.js.prism` 中的路径如下（如果没有就手动添上）：

yaml

_config.yml(主题目录)
```
libs:  
css:  
prism: /libs/prism/prism.css # 标注 prism.css 文件位置  
  
js:  
prism: /libs/prism/prism.js # 标注 prism.js 文件位置
```

### 2.3 修改 post-detail.ejs

最后打开 `博客根目录/themes/{主题文件夹}/layout/_partial/post-detail.ejs` 文件，确保（大概在 74 行）有如下代码（如果缺少就补上）：

```
<% if (config.prismjs && config.prismjs.enable) { %>  
<!-- 是否加载使用自带的 prismjs. -->  
<link rel="stylesheet" href="<%- theme.jsDelivr.url %><%- url_for(theme.libs.css.prism) %>">  
<script src="<%- theme.jsDelivr.url %><%- url_for(theme.libs.js.prism) %>"></script>  
<% } %>
```

`post.ejs` 文件末尾加入：

```markup
<script src="<%- theme.libs.js.prism %>" defer></script>
<script src="https://cdn.bootcdn.net/ajax/libs/prism/1.9.0/plugins/line-numbers/prism-line-numbers.js" defer></script>
```


`head.ejs` 文件中加入 `css` ：

```markup
<link rel="stylesheet" type="text/css" href="<%- theme.libs.css.prism %>">
<link rel="stylesheet" type="text/css" href="https://cdn.bootcdn.net/ajax/libs/prism/1.9.0/plugins/line-numbers/prism-line-numbers.css">
```
