```bash
uv run langflow run --host 0.0.0.0 --port 8052
```

```bash
python -m langflow run --host 0.0.0.0 --port 8052
```

要修改 Langflow 的默认端口号（从 `7860` 更改为其他端口），可通过以下两种方式实现：

---

### 方法一：通过命令行参数直接指定端口
在运行 `langflow run` 命令时，添加 `--port` 参数并指定新端口号。例如，若想将端口改为 `8080`，可执行：
```bash
python -m langflow run --port 8080
```
此时 Langflow 将运行在 `http://127.0.0.1:8080`。

---

### 方法二：通过环境变量配置端口
若需长期固定使用某个端口，可通过设置环境变量 `LANGFLOW_PORT`。操作步骤如下：
1. **Linux/macOS**：
   ```bash
   export LANGFLOW_PORT=8080  # 临时生效
   python -m langflow run
   ```
   或永久生效（将变量写入 `~/.bashrc` 或 `~/.zshrc`）：
   ```bash
   echo "export LANGFLOW_PORT=8080" >> ~/.bashrc
   source ~/.bashrc
   python -m langflow run
   ```

2. **Windows**（PowerShell）：
   ```powershell
   $env:LANGFLOW_PORT=8080
   python -m langflow run
   ```

---

### 补充说明
1. **绑定地址的修改**：若需允许外部访问（如从局域网访问），可同时修改 `host` 参数：
   ```bash
   python -m langflow run --host 0.0.0.0 --port 8080
   ```
   此时服务将运行在 `http://<服务器IP>:8080`，需确保防火墙已开放对应端口。

2. **验证端口是否生效**：运行后查看启动日志，确认输出中包含类似 `Running on http://0.0.0.0:8080` 的提示。

---

### 常见问题排查
• **端口冲突**：若新端口被占用，会提示 `OSError: [Errno 98] Address already in use`，需更换其他端口。
• **权限问题**：Linux 系统下低于 `1024` 的端口需 `sudo` 权限（如 `80` 端口）。

---

通过以上方法，可灵活调整 Langflow 的监听端口，满足不同场景需求。具体参数细节可参考官方 CLI 文档。