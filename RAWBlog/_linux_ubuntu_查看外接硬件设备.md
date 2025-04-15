### **使用硬件信息工具 `hwinfo`**

bash

```bash
# 安装工具
sudo apt install hwinfo

# 查看显示器信息
sudo hwinfo --monitor | grep -E "Model:|Vendor:"
```

- ​**输出示例**：
    
    bash
    
    ```bash
    Model: "Dell U2415"
    Vendor: "Dell Inc."
    ```
    

---

### ​**4. 通过 `lshw` 获取显示适配器信息**

bash

```bash
sudo lshw -C display | grep -A 5 "display"
```

- ​**输出关键信息**：`product`（显卡型号）、`configuration`（驱动和分辨率）
    
    1
    
    3
    
    。

---

### ​**5. 检查内核日志中的显示器事件**

bash

```bash
dmesg | grep -i "drm\|hdmi"
```

- ​**输出关键信息**：`[drm]` 相关日志会记录显示器连接/断开事件及接口状态
    
    1
    
    。