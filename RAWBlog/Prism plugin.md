## 问题描述

在[hexo](https://hexo.io/zh-cn/)框架中使用[3-hexo](https://github.com/yelog/hexo-theme-3-hexo)主题时，会遇到这样一个问题：在markdown中嵌入html代码，这些嵌入的html代码无法正常显示。

## 原因分析

在使用3-hexo主题时，默认使用主题自带的渲染插件（会禁用`highlight`和`prismjs`），该插件会把这些嵌入的html代码进行渲染，所以无法正常显示html代码本身。

## 解决办法

使用hexo框架默认自带的[prismjs](https://prismjs.com/download.html#themes=prism-solarizedlight&languages=markup+css+clike+javascript)插件进行渲染，具体实现：编辑项目根目录下的`_config.yml`文件，启用prismjs插件。

```
prismjs: 
	enable: true
```
只要启用hexo框架默认自带的prismjs高亮插件即可实现对嵌入html代码的正常显示。

但是默认情况下，渲染的html代码样式可能不满足需求，此时可以对prismjs插件进行定制。

**首先，** 重新[下载prismjs插件](https://prismjs.com/download.html#themes=prism-solarizedlight&languages=markup+css+clike+javascript)对应的css文件和js文件，重命名为：`prism.css`和`prism.js`。并分别放置到3-hexo主题目录路径下，即：`themes/3-hexo/source/css/prism.css`和`themes/3-hexo/source/js/prism.js`。

**其次，** 在3-hexo主题文件中分别引入prism插件css文件和js文件，具体来说：

在`themes/3-hexo/layout/_partial/header.ejs`文件中引入`prism.css`：
```
<link rel="stylesheet" href="/css/prism.css">
```
在`themes/3-hexo/layout/_partial/footer.ejs`中引入`prism.js`：
```
<script src="/js/prism.js" async></script>
```
最后，根据具体需要再次细调相应文件中的css样式即可。


