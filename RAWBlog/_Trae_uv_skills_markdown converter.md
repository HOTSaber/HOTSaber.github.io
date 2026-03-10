# 在Trae`设置`中的`规则与技能`中拖入`skills压缩包`以为Trae添加skills
# skills来源
## github
如：
[openclaw的skills项目](https://github.com/openclaw/skills)
[anthropics的skills项目](https://github.com/anthropics/skills)
 [claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills)
## skills社区
[clawhub](https://clawhub.ai/)
[skillsmp](https://skillsmp.com/)
# skills中的依赖问题
**以[markdown converter](https://clawhub.ai/steipete/markdown-converter)为例**

我们可以在skills.md文件中看到skill的内在运行逻辑

```bash
# Convert to stdout
uvx markitdown input.pdf

# Save to file
uvx markitdown input.pdf -o output.md
uvx markitdown input.docx > output.md

# From stdin
cat input.pdf | uvx markitdown
```

但在运行`uvx markitdown`时会失败，首先要**安装uv**与**uvx虚拟环境**下的markitdown饴
```bash
#安装uv
pip install uv
```
- uvx markitdown 失败原因 ：uvx 是一个临时环境工具，它会创建一个独立的虚拟环境来运行命令，这个环境中没有安装 docx 相关的依赖包。
- python -m markitdown 成功原因 ：直接使用 Python 模块方式运行时，它使用的是当前 Conda 环境，而你已经在这个环境中安装了 markitdown[docx] 依赖。
如果你需要经常进行文档转换，可以将 python -m markitdown 命令保存为一个批处理文件，方便快速使用。或者，如果你仍然希望使用 uvx，可以在命令中指定安装依赖，例如：
```bash
#为uvx临时环境工具安装依赖
#只安装docx支持
uv tool run pip install markitdown[docx] 
#安装所有支持
uv tool run pip install markitdown[all] 

```