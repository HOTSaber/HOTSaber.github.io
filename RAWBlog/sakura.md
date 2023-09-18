## 背景樱花飘落效果[](https://blog.17lai.site/posts/4d8a0b22/#%E8%83%8C%E6%99%AF%E6%A8%B1%E8%8A%B1%E9%A3%98%E8%90%BD%E6%95%88%E6%9E%9C)

在`themes/matery/source/js`目录下新建`sakura.js`文件，打开这个网址[传送门](https://cdn.jsdelivr.net/gh/Yafine/cdn@3.3.1/source/js/sakura.js)，将内容复制粘贴到`sakura.js`即可。

然后在`themes/matery/layout/layout.ejs`文件内添加下面的内容：

javascript

```javascript
<script type="text/javascript">
//只在桌面版网页启用特效
var windowWidth = $(window).width();
if (windowWidth > 768) {
    document.write('<script type="text/javascript" src="/js/sakura.js"><\/script>');
}
</script>
```

  
来源: 夜法之书  
文章作者: 夜法之书  
文章链接: [https://blog.17lai.site/posts/4d8a0b22/#%E8%83%8C%E6%99%AF%E6%A8%B1%E8%8A%B1%E9%A3%98%E8%90%BD%E6%95%88%E6%9E%9C](https://blog.17lai.site/posts/4d8a0b22/#%E8%83%8C%E6%99%AF%E6%A8%B1%E8%8A%B1%E9%A3%98%E8%90%BD%E6%95%88%E6%9E%9C)  
本文章著作权归作者所有，任何形式的转载都请注明出处。