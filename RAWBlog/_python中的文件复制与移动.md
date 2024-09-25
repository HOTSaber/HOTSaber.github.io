在 Python 中，你可以使用 `shutil` 模块来实现文件的复制与移动操作。`shutil` 提供了高效的文件和目录操作功能。

### 文件复制
使用 `shutil.copy()` 或 `shutil.copy2()` 函数来复制文件。

- **`shutil.copy(src, dst)`**: 复制文件内容和权限，但不复制元数据（如创建时间和修改时间）。
- **`shutil.copy2(src, dst)`**: 复制文件内容、权限以及元数据（类似 `cp -p` 的行为）。

### 文件移动
使用 **`shutil.move()`** 来移动文件或目录。这个函数可以移动文件，也可以重命名文件。如果目标路径已经存在，则文件将被覆盖。

### 示例代码

#### 1. 文件复制

```python
import shutil

# 源文件路径
src_file = 'path/to/source_file.txt'

# 目标文件路径
dst_file = 'path/to/destination_file.txt'

# 使用 shutil.copy 复制文件（不保留元数据）
shutil.copy(src_file, dst_file)

# 使用 shutil.copy2 复制文件（保留元数据，如创建时间和修改时间）
shutil.copy2(src_file, dst_file)
```

#### 2. 文件移动

```python
import shutil

# 源文件路径
src_file = 'path/to/source_file.txt'

# 目标文件路径
dst_file = 'path/to/destination_file.txt'

# 使用 shutil.move 移动文件
shutil.move(src_file, dst_file)
```

### 3. 目录复制与移动

- 复制整个目录使用 **`shutil.copytree()`**：
  ```python
  src_dir = 'path/to/source_directory'
  dst_dir = 'path/to/destination_directory'

  # 递归复制整个目录
  shutil.copytree(src_dir, dst_dir)
  ```

- 移动整个目录使用 **`shutil.move()`**：
  ```python
  src_dir = 'path/to/source_directory'
  dst_dir = 'path/to/destination_directory'

  # 移动整个目录
  shutil.move(src_dir, dst_dir)
  ```

### 注意事项
- `shutil.move()` 函数在目标目录已经存在时，会覆盖目标文件或文件夹。
- `shutil.copytree()` 复制目录时，目标目录不能已经存在，否则会抛出异常。

这两种方式都可以有效地实现文件和目录的复制与移动操作，`shutil` 是处理文件和目录操作的常用模块。