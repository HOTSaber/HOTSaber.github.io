当您需要从一个不同于当前脚本的路径中导入（import）封装的代码时，Python 提供了几种方法来处理路径和模块导入的问题。以下是一些常用的方法来导入位于不同路径的模块：

### 1. 修改系统路径（`sys.path`）
Python 的导入系统依赖于 `sys.path`，这是一个包含所有可搜索路径的列表。添加您的模块所在路径到这个列表，可以让 Python 知道在哪里查找您的模块。

```python
import sys
sys.path.append('/path/to/your/module')

import your_module
```

这种方法简单直接，但需要注意，添加的路径会在脚本运行期间一直存在于 `sys.path` 中，可能会影响到后续的模块导入。

### 2. 使用环境变量
您可以通过设置 `PYTHONPATH` 环境变量来告诉 Python 解释器在哪里查找模块。这可以在您的操作系统中配置，或者通过脚本动态设置。

在 Unix/Linux 系统中，您可以在 shell 中设置 `PYTHONPATH`：
```bash
export PYTHONPATH="/path/to/your/module:$PYTHONPATH"
python your_script.py
```

在 Windows 系统中，可以在命令行中设置：
```cmd
set PYTHONPATH=C:\path\to\your\module;%PYTHONPATH%
python your_script.py
```

### 3. 使用相对导入
如果您的代码组织在一个包内（即包含 `__init__.py` 的目录），您可以使用相对导入来引入同一包内的其他模块或包。

假设文件结构如下：
```
package/
│
├── module1.py
└── subdir/
    └── module2.py
```

在 `module2.py` 中，您可以这样导入 `module1`：
```python
from .. import module1
```

### 4. 使用 `importlib`
`importlib` 是一个强大的库，提供了程序性地导入模块的方法。这对于动态导入模块特别有用。

```python
import importlib.util
import sys

def module_from_path(path):
    spec = importlib.util.spec_from_file_location("module_name", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

your_module = module_from_path('/path/to/your/module.py')
```

这种方法允许您指定模块文件的完整路径进行导入，非常灵活。

### 选择适合的方法
选择哪种方法取决于您的具体需求：
- 如果是临时导入，修改 `sys.path` 可能是最快的方法。
- 如果您经常需要从同一路径导入，考虑设置 `PYTHONPATH` 环境变量。
- 如果是包内模块的组织，使用相对导入。
- 对于复杂或动态的导入需求，考虑使用 `importlib`。

每种方法都有其适用场景，理解这些场景有助于您更高效地管理 Python 项目中的模块导入问题。