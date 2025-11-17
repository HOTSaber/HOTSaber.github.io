# 确保安装python（同vscode）
![[_Trae虚拟环境配置-1.png]]
# 配置虚拟环境
可以参考[# TRAE如何使用conda的虚拟环境（Python）](https://zhuanlan.zhihu.com/p/1961377373598512664)
文件->首选项->设置->Editor设置->搜索框中输入
添加envs与[conda](https://zhida.zhihu.com/search?content_id=264177469&content_type=Article&match_order=1&q=conda&zhida_source=entity)的路径

后面遇到的问题是conda env list成功，conda activate myenv不成功

- 这种情况大多是因为只用的powershell作为terminal（终端）,在trae的powershell终端输入以下命令激活powershell下的conda:
```shell
conda init
```
- 或者更换terminal，为CMD
	- 选择默认配置文件-->选择Command Prompt
![[_Trae虚拟环境配置-2.png]]
![[_Trae虚拟环境配置-3.png]]
# 选择对应的虚拟环境
另外，ctrl+shift+p,输入 python select，选择自己[虚拟环境](https://zhida.zhihu.com/search?content_id=264177469&content_type=Article&match_order=1&q=%E8%99%9A%E6%8B%9F%E7%8E%AF%E5%A2%83&zhida_source=entity)的解释器