# 在Ubuntu服务器上部署实体关系管理工具

我将指导你如何将这个网页应用部署到Ubuntu服务器，并确保可以通过IP地址和端口访问。下面是完整的解决方案：

## 部署步骤

### 1. 创建项目目录结构

在你的服务器上创建项目目录：



```bash
mkdir -p ~/entity_editor/{templates,static}
```
/entity_editor/app.py
/entity_editor/templates/index.html
/entity_editor/static/style.css
### 2. 将网页文件保存为HTML

创建HTML文件：



```bash
nano ~/entity_editor/templates/index.html
```

将上面提供的HTML代码复制粘贴到这个文件中，然后保存退出（Ctrl+X，按Y，然后Enter）。

```html
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <title><!DOCTYPE html>  
<html lang="zh-CN">  
<head>  
    <meta charset="UTF-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  
    <title>三栏联动实体管理工具</title>  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">  
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">  
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">  
</head>  
<body>  
    <header class="app-header">  
        <div class="header-content">  
            <div>                <h1 class="header-title">三栏联动实体管理工具</h1>  
                <div class="directory-info">  
                    <span>EA实体属性: {{ EA_DIR }}</span>  
                    <span class="directory-tag">分类实体: {{ RESULTS_DIR }}</span>  
                    <span class="directory-tag">关系五元组: {{ PROVINCE_DIR }}</span>  
                </div>            </div>            <div>                <button id="btn-delete-selected" class="btn btn-danger">  
                    <i class="fas fa-trash-alt"></i> 删除所有选中项  
                </button>  
            </div>        </div>    </header>  
    <div class="selection-info">  
        <span id="selection-status">未选中任何实体</span>  
    </div>  
    <div class="container-fluid">  
        <div class="panel-container">  
            <!-- EA实体属性面板 -->  
            <div class="panel">  
                <div class="panel-header">  
                    <span><i class="fas fa-tags"></i> EA实体属性</span>  
                    <span id="ea-stats" class="badge bg-light text-dark">0个文件</span>  
                </div>  
                <div class="panel-action-bar">  
                    <div class="d-flex" style="gap: 8px">  
                        <button class="btn btn-light btn-action" id="btn-add-ea">  
                            <i class="fas fa-plus"></i> 添加  
                        </button>  
                        <select id="ea-files" class="form-select form-select-sm">  
                            <option value="" selected>选择实体文件...</option>  
                        </select>                        <button id="ea-load" class="btn btn-primary btn-sm">加载</button>  
                    </div>                    <div class="input-group" style="max-width: 300px">  
                        <input id="ea-search" type="text" class="form-control form-control-sm" placeholder="搜索实体...">  
                        <button id="ea-search-btn" class="btn btn-primary btn-sm">搜索</button>  
                    </div>                </div>  
                <div class="panel-content-container">  
                    <table class="panel-table">  
                        <thead>                            <tr>                                <th width="35%">实体</th>  
                                <th>属性</th>  
                                <th width="15%">行号</th>  
                            </tr>                        </thead>                        <tbody id="ea-content">  
                            <tr>                                <td colspan="3" class="empty-state">  
                                    <i class="fas fa-file-alt"></i>  
                                    <p>请选择文件并加载数据</p>  
                                </td>                            </tr>                        </tbody>                    </table>                </div>  
                <div id="ea-status" class="stats-bar">  
                    等待文件加载...  
                </div>  
            </div>  
            <!-- 分类实体面板 -->  
            <div class="panel">  
                <div class="panel-header">  
                    <span><i class="fas fa-list"></i> 分类实体 (全目录)</span>  
                    <span id="results-stats" class="badge bg-light text-dark">0个实体</span>  
                </div>  
                <div class="panel-action-bar">  
                    <div class="d-flex" style="gap: 8px">  
                        <button class="btn btn-light btn-action" id="btn-add-results">  
                            <i class="fas fa-plus"></i> 添加  
                        </button>  
                        <button id="results-refresh" class="btn btn-primary btn-action">  
                            <i class="fas fa-sync-alt"></i> 刷新  
                        </button>  
                    </div>                    <div class="input-group" style="max-width: 300px">  
                        <input id="results-search" type="text" class="form-control form-control-sm" placeholder="搜索实体...">  
                        <button id="results-search-btn" class="btn btn-primary btn-sm">搜索</button>  
                    </div>                </div>  
                <div class="panel-content-container">  
                    <table class="panel-table">  
                        <thead>                            <tr>                                <th width="25%">文件</th>  
                                <th>实体</th>  
                                <th width="15%">行号</th>  
                            </tr>                        </thead>                        <tbody id="results-content">  
                            <tr>                                <td colspan="3" class="empty-state">  
                                    <i class="fas fa-spinner fa-spin"></i>  
                                    <p>加载分类实体数据...</p>  
                                </td>                            </tr>                        </tbody>                    </table>                </div>  
                <div id="results-status" class="stats-bar">  
                    正在加载全目录数据...  
                </div>  
            </div>  
            <!-- 关系五元组面板 -->  
            <div class="panel">  
                <div class="panel-header warning">  
                    <span><i class="fas fa-project-diagram"></i> 关系五元组 (全目录)</span>  
                    <span id="province-stats" class="badge bg-light text-dark">0个关系</span>  
                </div>  
                <div class="panel-action-bar">  
                    <div class="d-flex" style="gap: 8px">  
                        <button class="btn btn-light btn-action" id="btn-add-province">  
                            <i class="fas fa-plus"></i> 添加  
                        </button>  
                        <button id="province-refresh" class="btn btn-primary btn-action">  
                            <i class="fas fa-sync-alt"></i> 刷新  
                        </button>  
                    </div>                    <div class="input-group" style="max-width: 300px">  
                        <input id="relation-search" type="text" class="form-control form-control-sm" placeholder="搜索关系...">  
                        <button id="relation-search-btn" class="btn btn-primary btn-sm">搜索</button>  
                    </div>                </div>  
                <div class="panel-content-container">  
                    <table class="panel-table">  
                        <thead>                            <tr>                                <th width="20%">文件</th>  
                                <th width="20%">实体1</th>  
                                <th width="10%">类型</th>  
                                <th width="10%">关系</th>  
                                <th width="20%">实体2</th>  
                                <th width="10%">类型</th>  
                                <th width="10%">行号</th>  
                            </tr>                        </thead>                        <tbody id="province-content">  
                            <tr>                                <td colspan="7" class="empty-state">  
                                    <i class="fas fa-spinner fa-spin"></i>  
                                    <p>加载关系数据...</p>  
                                </td>                            </tr>                        </tbody>                    </table>                </div>  
                <div id="province-status" class="stats-bar">  
                    正在加载全目录数据...  
                </div>  
            </div>        </div>  
        <!-- 选中的实体信息面板 -->  
        <div class="panel mt-3">  
            <div class="panel-header">  
                <span><i class="fas fa-check-circle"></i> 选中实体详细信息</span>  
                <span id="selected-count" class="badge bg-danger">0</span>  
            </div>  
            <div class="panel-content-container" style="max-height: 200px; overflow: auto;">  
                <div class="p-3">  
                    <div class="d-flex flex-wrap" id="selected-entities-container" style="gap: 10px;">  
                        <!-- 选中的实体卡片将通过JavaScript添加 -->  
                    </div>  
                </div>            </div>        </div>    </div>  
    <!-- 删除确认模态框 -->  
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">  
        <div class="modal-dialog modal-lg">  
            <div class="modal-content">  
                <div class="modal-header bg-danger text-white">  
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle"></i> 确认删除</h5>  
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>  
                </div>                <div class="modal-body">  
                    <div class="alert alert-danger">  
                        <h5>您将要删除 <span id="delete-count" class="badge bg-danger">0</span> 个实体及其所有关系！</h5>  
                        <p class="mb-0">此操作将从所有文件中删除选定实体及其相关数据，且无法恢复。</p>  
                    </div>  
                    <h6 class="mt-3">将被删除的实体列表：</h6>  
                    <ul id="delete-list">  
                        <!-- 删除列表将通过JavaScript填充 -->  
                    </ul>  
  
                    <div class="alert alert-warning mt-2">  
                        <i class="fas fa-exclamation-circle me-2"></i>  
                        <span id="affected-files">删除这些实体将影响多个文件中的相关数据。</span>  
                    </div>                </div>                <div class="modal-footer">  
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>  
                    <button type="button" id="confirm-delete" class="btn btn-danger">确认删除</button>  
                </div>            </div>        </div>    </div>  
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>  
    <script>        // 在JavaScript中，使用绝对路径比较  
        function isSamePath(path1, path2) {  
            return path1.replace(/\\/g, '/') === path2.replace(/\\/g, '/');  
        }  
  
        // 在加载目录数据时，使用绝对路径比较  
        function loadResultsDirectory() {  
            elements.results.status.textContent = "加载分类实体数据...";  
  
            // 使用绝对路径比较  
            const absResultsDir = "{{ RESULTS_DIR }}".replace(/\\/g, '/');  
  
            fetch(`/api/read-directory?path=${encodeURIComponent(absResultsDir)}`)  
                .then(response => response.json())  
                .then(data => {  
                    if (data.error) throw new Error(data.error);  
  
                    state.resultsData = data.content;  
                    renderResultsContent(data.content);  
  
                    elements.results.status.textContent = `已加载全部实体 | ${data.count}个实体`;  
                    elements.results.stats.textContent = `${data.count}个实体`;  
                })  
                .catch(error => {  
                    console.error('加载分类实体错误:', error);  
                    elements.results.content.innerHTML = `<tr><td colspan="3" class="text-center py-5 text-danger">错误: ${error.message}</td></tr>`;  
                    elements.results.status.textContent = "数据加载失败";  
                });  
        }  
  
        function loadProvinceDirectory() {  
            elements.province.status.textContent = "加载关系数据...";  
  
            // 使用绝对路径比较  
            const absProvinceDir = "{{ PROVINCE_DIR }}".replace(/\\/g, '/');  
  
            fetch(`/api/read-directory?path=${encodeURIComponent(absProvinceDir)}`)  
                .then(response => response.json())  
                .then(data => {  
                    if (data.error) throw new Error(data.error);  
  
                    state.provinceData = data.content;  
                    renderProvinceContent(data.content);  
  
                    elements.province.status.textContent = `已加载全部关系 | ${data.count}个关系`;  
                    elements.province.stats.textContent = `${data.count}个关系`;  
                })  
                .catch(error => {  
                    console.error('加载关系五元组错误:', error);  
                    elements.province.content.innerHTML = `<tr><td colspan="7" class="text-center py-5 text-danger">错误: ${error.message}</td></tr>`;  
                    elements.province.status.textContent = "数据加载失败";  
                });  
        }  
  
        // 全局状态对象  
        const state = {  
            // 选中的实体  
            selectedEntities: new Map(),  
  
            // 选中的行  
            selectedRows: new Set(),  
  
            // 当前选中的实体  
            currentEntity: null,  
  
            // 面板数据  
            eaData: [],  
            resultsData: [],  
            provinceData: [],  
  
            // 当前置顶的行  
            promotedRows: {  
                ea: [],  
                results: [],  
                province: []  
            },  
  
            // 目录路径  
            EA_DIR: "{{ EA_DIR }}",  
            RESULTS_DIR: "{{ RESULTS_DIR }}",  
            PROVINCE_DIR: "{{ PROVINCE_DIR }}"  
        };  
  
        // DOM元素  
        const elements = {  
            ea: {  
                fileSelect: document.getElementById('ea-files'),  
                loadBtn: document.getElementById('ea-load'),  
                content: document.getElementById('ea-content'),  
                status: document.getElementById('ea-status'),  
                stats: document.getElementById('ea-stats'),  
                searchInput: document.getElementById('ea-search'),  
                searchBtn: document.getElementById('ea-search-btn')  
            },  
            results: {  
                content: document.getElementById('results-content'),  
                status: document.getElementById('results-status'),  
                stats: document.getElementById('results-stats'),  
                searchInput: document.getElementById('results-search'),  
                searchBtn: document.getElementById('results-search-btn'),  
                refreshBtn: document.getElementById('results-refresh')  
            },  
            province: {  
                content: document.getElementById('province-content'),  
                status: document.getElementById('province-status'),  
                stats: document.getElementById('province-stats'),  
                searchInput: document.getElementById('relation-search'),  
                searchBtn: document.getElementById('relation-search-btn'),  
                refreshBtn: document.getElementById('province-refresh')  
            },  
            deleteBtn: document.getElementById('btn-delete-selected'),  
            selectionStatus: document.getElementById('selection-status'),  
            selectedCount: document.getElementById('selected-count'),  
            selectedContainer: document.getElementById('selected-entities-container'),  
            deleteModal: {  
                count: document.getElementById('delete-count'),  
                list: document.getElementById('delete-list'),  
                affectedFiles: document.getElementById('affected-files'),  
                confirmBtn: document.getElementById('confirm-delete')  
            }  
        };  
  
        // 恢复面板的原始顺序  
        function restorePanelOrder(panelId) {  
            const tbody = document.getElementById(`${panelId}-content`);  
            const rows = Array.from(tbody.querySelectorAll('tr'));  
  
            // 移除所有行  
            while (tbody.firstChild) {  
                tbody.removeChild(tbody.firstChild);  
            }  
  
            // 按原始顺序重新添加行  
            state.originalRows[panelId].forEach(row => {  
                tbody.appendChild(row);  
            });  
        }  
  
        // 将匹配的行置顶  
        function promoteMatchingRows(panelId, entity) {  
            const tbody = document.getElementById(`${panelId}-content`);  
            const rows = Array.from(tbody.querySelectorAll('tr'));  
            const matchingRows = [];  
            const nonMatchingRows = [];  
  
            // 分离匹配和不匹配的行  
            rows.forEach(row => {  
                let match = false;  
  
                switch(panelId) {  
                    case 'ea':  
                        const eaEntity = row.querySelector('.entity-name');  
                        if (eaEntity && eaEntity.textContent === entity) {  
                            match = true;  
                        }  
                        break;  
  
                    case 'results':  
                        const resultsEntity = row.querySelector('.entity-name');  
                        if (resultsEntity && resultsEntity.textContent === entity) {  
                            match = true;  
                        }  
                        break;  
  
                    case 'province':  
                        const entity1 = row.querySelector('.entity1');  
                        const entity2 = row.querySelector('.entity2');  
                        if ((entity1 && entity1.textContent === entity) ||  
                            (entity2 && entity2.textContent === entity)) {  
                            match = true;  
                        }  
                        break;  
                }  
  
                if (match) {  
                    matchingRows.push(row);  
                } else {  
                    nonMatchingRows.push(row);  
                }  
            });  
  
            // 清空表格  
            while (tbody.firstChild) {  
                tbody.removeChild(tbody.firstChild);  
            }  
  
            // 先添加匹配的行（置顶）  
            matchingRows.forEach(row => {  
                tbody.appendChild(row);  
            });  
  
            // 再添加不匹配的行  
            nonMatchingRows.forEach(row => {  
                tbody.appendChild(row);  
            });  
  
            // 保存当前置顶的行  
            state.promotedRows[panelId] = matchingRows;  
        }  
  
        // 初始化三栏联动选择功能  
        function initMultiSelect() {  
            // 为所有表格行添加点击事件监听器  
            document.addEventListener('click', function(e) {  
                const row = e.target.closest('tr');  
                if (!row || row.closest('thead')) return;  
  
                const tbody = row.closest('tbody');  
                if (!tbody) return;  
  
                const panel = tbody.id.replace('-content', '');  
                if (!['ea', 'results', 'province'].includes(panel)) return;  
  
                // 阻止事件冒泡到文档级别  
                e.stopPropagation();  
                e.stopImmediatePropagation();  
  
                console.log("点击的行:", row.outerHTML);  
  
                // 获取当前点击行的实体信息  
                const entities = extractEntitiesFromRow(panel, row);  
  
                // 如果没有选中新实体，则清除选择  
                if (entities.length === 0) {  
                    clearAllSelections();  
                    updateSelectionStatus();  
                    return;  
                }  
  
                // 设置当前实体  
                state.currentEntity = entities[0];  
  
                // 清除之前的选择  
                clearAllSelections();  
  
                // 恢复所有面板的原始顺序  
                ['ea', 'results', 'province'].forEach(panelId => {  
                    restorePanelOrder(panelId);  
                });  
  
                // 高亮当前行  
                row.classList.add('selected');  
                state.selectedRows.add(row);  
                console.log("添加行到 selectedRows:", row);  
  
                // 在所有面板中搜索并高亮相关实体  
                entities.forEach(entity => {  
                    highlightRelatedRows(entity, panel);  
  
                    // 将匹配的行置顶（除了当前面板）  
                    if (panel !== 'ea') promoteMatchingRows('ea', entity);  
                    if (panel !== 'results') promoteMatchingRows('results', entity);  
                    if (panel !== 'province') promoteMatchingRows('province', entity);  
                });  
  
                // 更新状态显示  
                updateSelectionStatus();  
            });  
  
            // 修改文档点击事件处理函数  
            document.addEventListener('click', function(e) {  
                // 检查点击的是否是面板表格、选中实体卡片或删除按钮  
                const isTableClick = e.target.closest('.panel-table');  
                const isCardClick = e.target.closest('.selected-entity-card');  
                const isDeleteBtn = e.target.closest('#btn-delete-selected');  
  
                // 如果点击的是表格、卡片或删除按钮，不执行清除  
                if (isTableClick || isCardClick || isDeleteBtn) return;  
  
                clearAllSelections();  
                updateSelectionStatus();  
  
                // 恢复所有面板的原始顺序  
                ['ea', 'results', 'province'].forEach(panelId => {  
                    restorePanelOrder(panelId);  
                });  
            });  
  
            // 删除按钮事件  
            elements.deleteBtn.addEventListener('click', function() {  
                if (state.selectedEntities.size === 0) {  
                    alert("请先选择要删除的实体");  
                    return;  
                }  
  
                prepareDeleteModal();  
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));  
                deleteModal.show();  
            });  
  
            // 确认删除按钮  
            elements.deleteModal.confirmBtn.addEventListener('click', function() {  
                deleteSelectedEntities();  
                bootstrap.Modal.getInstance(document.getElementById('deleteModal')).hide();  
            });  
        }  
  
        // 提取行中的实体信息  
        function extractEntitiesFromRow(panel, row) {  
            const entities = [];  
  
            switch(panel) {  
                case 'ea':  
                    // EA面板：实体是第一列的内容  
                    const entityCell = row.querySelector('.entity-name');  
                    if (entityCell) {  
                        entities.push(entityCell.textContent);  
                    }  
                    break;  
  
                case 'results':  
                    // 分类实体面板：实体是第二列的内容  
                    const entityResults = row.querySelector('.entity-name');  
                    if (entityResults) {  
                        entities.push(entityResults.textContent);  
                    }  
                    break;  
  
                case 'province':  
                    // 关系五元组：实体1和实体2  
                    const entity1 = row.querySelector('.entity1');  
                    const entity2 = row.querySelector('.entity2');  
                    if (entity1) entities.push(entity1.textContent);  
                    if (entity2) entities.push(entity2.textContent);  
                    break;  
            }  
  
            return entities;  
        }  
  
        // 在所有面板中高亮相关实体行  
        function highlightRelatedRows(entity, sourcePanel) {  
            console.log(`高亮相关行 - 实体: ${entity}, 来源面板: ${sourcePanel}`);  
  
            const panels = ['ea', 'results', 'province'];  
            panels.forEach(panel => {  
                const rows = document.querySelectorAll(`#${panel}-content tr`);  
                console.log(`在面板 ${panel} 中找到 ${rows.length} 行`);  
  
                rows.forEach(row => {  
                    let match = false;  
  
                    // 检查该行是否包含目标实体  
                    switch(panel) {  
                        case 'ea':  
                            const eaEntity = row.querySelector('.entity-name');  
                            if (eaEntity) {  
                                match = eaEntity.textContent === entity;  
                            }  
                            break;  
  
                        case 'results':  
                            const resultsEntity = row.querySelector('.entity-name');  
                            if (resultsEntity) {  
                                match = resultsEntity.textContent === entity;  
                            }  
                            break;  
  
                        case 'province':  
                            const provinceEntity1 = row.querySelector('.entity1');  
                            const provinceEntity2 = row.querySelector('.entity2');  
                            match = (provinceEntity1 && provinceEntity1.textContent === entity) ||  
                                    (provinceEntity2 && provinceEntity2.textContent === entity);  
                            break;  
                    }  
  
                    // 如果匹配则高亮  
                    if (match) {  
                        console.log("找到匹配行:", row);  
                        row.classList.add('selected');  
                        state.selectedRows.add(row);  
                        console.log(`添加行到 selectedRows，当前大小: ${state.selectedRows.size}`);  
  
                        // 添加到选中实体集合  
                        if (!state.selectedEntities.has(entity)) {  
                            state.selectedEntities.set(entity, {  
                                name: entity,  
                                type: getEntityType(entity, panel),  
                                rows: new Set()  
                            });  
                        }  
                        state.selectedEntities.get(entity).rows.add(row);  
                    }  
                });  
            });  
        }  
  
        // 获取实体类型  
        function getEntityType(entity, sourcePanel) {  
            switch(sourcePanel) {  
                case 'ea': return "EA实体属性";  
                case 'results': return "分类实体";  
                case 'province': return "关系五元组";  
                default: return "未知类型";  
            }  
        }  
  
        // 清除所有选择  
        function clearAllSelections() {  
            console.log("清除所有选择 - 开始");  
            // 清除所有选中的行  
            console.log(`当前选中的行数: ${state.selectedRows.size}`);  
            state.selectedRows.forEach(row => {  
                row.classList.remove('selected');  
            });  
  
            // 清除状态  
            state.selectedRows.clear();  
            state.selectedEntities.clear();  
            state.currentEntity = null;  
            console.log("清除所有选择 - 完成");  
        }  
  
        // 更新选中状态显示  
        function updateSelectionStatus() {  
            const count = state.selectedEntities.size;  
            elements.selectionStatus.innerHTML = count === 0 ?  
                "未选中任何实体" :  
                `已选中 <strong>${count}</strong> 个实体`;  
  
            elements.selectionStatus.parentElement.style.display = count === 0 ? 'none' : 'block';  
            elements.selectedCount.textContent = count;  
  
            // 更新面板状态  
            if (count > 0) {  
                elements.ea.status.innerHTML =  
                    `当前文件: <strong>${state.eaCurrentFile || '未选择'}</strong> | 已加载${state.eaData.length}个实体 | 选中${countSelectedInPanel('ea')}个`;  
  
                elements.results.status.textContent =  
                    `已加载全部实体 | 选中${countSelectedInPanel('results')}个实体`;  
                elements.province.status.textContent =  
                    `已加载全部关系 | 选中${countSelectedInPanel('province')}个关系`;  
  
                // 更新选中的实体卡片  
                updateSelectedEntitiesCards();  
            }  
        }  
  
        // 计算面板中选中的数量  
        function countSelectedInPanel(panel) {  
            return Array.from(state.selectedRows).filter(row =>  
                row.closest('tbody').id === `${panel}-content`  
            ).length;  
        }  
  
        // 更新选中的实体卡片  
        function updateSelectedEntitiesCards() {  
            elements.selectedContainer.innerHTML = '';  
  
            state.selectedEntities.forEach((entityInfo, entityName) => {  
                const card = document.createElement('div');  
                card.className = 'selected-entity-card';  
                card.innerHTML = `  
                    <div class="entity-name">${entityName}</div>  
                    <div class="entity-type">${entityInfo.type}</div>  
                `;  
                elements.selectedContainer.appendChild(card);  
            });  
        }  
  
        // 准备删除模态框  
        function prepareDeleteModal() {  
            elements.deleteModal.count.textContent = state.selectedEntities.size;  
            elements.deleteModal.list.innerHTML = '';  
  
            // 计算受影响的文件  
            const files = new Set();  
  
            state.selectedEntities.forEach((entityInfo, entityName) => {  
                const li = document.createElement('li');  
                li.innerHTML = `<strong>${entityName}</strong> (${entityInfo.type})`;  
                elements.deleteModal.list.appendChild(li);  
  
                // 收集受影响的文件  
                entityInfo.rows.forEach(row => {  
                    const fileCell = row.querySelector('.file-badge');  
                    if (fileCell) {  
                        files.add(fileCell.textContent);  
                    }  
                });  
            });  
  
            elements.deleteModal.affectedFiles.textContent =  
                `删除这些实体将影响 ${files.size} 个文件中的相关数据。`;  
        }  
  
        // 删除选中的实体  
        function deleteSelectedEntities() {  
            // 收集删除操作  
            const deletions = [];  
  
            // 创建一个集合，用于记录已处理的行（避免重复）  
            const processedRows = new Set();  
  
            console.log("开始收集删除数据，选中的行数：", state.selectedRows.size);  
  
            // 遍历所有选中的行  
            state.selectedRows.forEach(row => {  
                // 确保每行只处理一次  
                if (processedRows.has(row)) return;  
                processedRows.add(row);  
  
                const tbody = row.closest('tbody');  
                if (!tbody) {  
                    console.warn("无法找到tbody元素", row);  
                    return;  
                }  
  
                const panel = tbody.id.replace('-content', '');  
                let filePath = '';  
                let lineContent = '';  
                let fileName = '';  
  
                console.log(`处理行，面板类型: ${panel}`, row);  
  
                // 根据不同面板类型获取文件路径和行内容  
                switch(panel) {  
                    case 'ea':  
                        // EA面板：使用当前加载的文件  
                        filePath = state.eaCurrentFile;  
                        console.log("EA面板，当前文件路径:", filePath);  
  
                        // 从行获取实体名和属性  
                        const entityCell = row.querySelector('.entity-name');  
                        const attributes = Array.from(row.querySelectorAll('.badge'))  
                            .map(badge => badge.textContent.trim());  
  
                        if (entityCell) {  
                            // 构造行内容：实体,属性1,属性2...  
                            lineContent = [entityCell.textContent.trim(), ...attributes].join(',');  
                            console.log("EA面板行内容:", lineContent);  
                        }  
                        break;  
  
                    case 'results':  
                        // 分类实体面板：从文件名cell获取文件名  
                        const fileBadge = row.querySelector('.file-badge');  
                        if (fileBadge) {  
                            fileName = fileBadge.textContent.trim();  
                            // 确保文件路径正确构造  
                            filePath = `${state.RESULTS_DIR}/${fileName}`;  
                            console.log("分类实体面板，文件名:", fileName);  
                        }  
  
                        // 获取实体名称作为行内容  
                        const resultEntity = row.querySelector('.entity-name');  
                        if (resultEntity) {  
                            lineContent = resultEntity.textContent.trim();  
                            console.log("分类实体面板行内容:", lineContent);  
                        }  
                        break;  
  
                    case 'province':  
                        // 关系五元组面板：从文件名cell获取文件名  
                        const provinceFileBadge = row.querySelector('.file-badge');  
                        if (provinceFileBadge) {  
                            fileName = provinceFileBadge.textContent.trim();  
                            // 确保文件路径正确构造  
                            filePath = `${state.PROVINCE_DIR}/${fileName}`;  
                            console.log("关系五元组面板，文件名:", fileName);  
                        }  
  
                        // 获取五元组各部分  
                        const entity1 = row.querySelector('.entity1')?.textContent.trim() || '';  
                        const type1 = row.querySelector('td:nth-child(3)')?.textContent.trim() || '';  
                        const relation = row.querySelector('td:nth-child(4)')?.textContent.trim() || '';  
                        const entity2 = row.querySelector('.entity2')?.textContent.trim() || '';  
                        const type2 = row.querySelector('td:nth-child(6)')?.textContent.trim() || '';  
  
                        // 构造行内容：entity1,type1,relation,entity2,type2  
                        lineContent = [entity1, type1, relation, entity2, type2].join(',');  
                        console.log("关系五元组面板行内容:", lineContent);  
                        break;  
                }  
  
                // 确保我们获取到了必要的文件路径和内容  
                if (filePath && lineContent) {  
                    deletions.push({  
                        file_path: filePath,  
                        line_content: lineContent  
                    });  
                    console.log("成功收集到删除条目:", { filePath, lineContent });  
                } else {  
                    console.error('无法获取删除所需的信息', {  
                        filePath,  
                        lineContent,  
                        panel,  
                        row: row.outerHTML  
                    });  
                }  
            });  
  
            console.log('最终删除请求数据:', deletions);  
  
            // 如果没有收集到任何删除条目，提示用户  
            if (deletions.length === 0) {  
                alert("没有收集到要删除的数据。可能的原因：\n1. 未正确选择实体\n2. 当前面板不支持删除操作\n3. 系统错误，请检查控制台日志");  
                return;  
            }  
  
            // 调用API删除  
            fetch('/api/delete-lines', {  
                method: 'POST',  
                headers: {  
                    'Content-Type': 'application/json'  
                },  
                body: JSON.stringify({ deletions })  
            })  
            .then(response => {  
                if (!response.ok) {  
                    return response.json().then(errData => {  
                        throw new Error(`API错误: ${response.status} - ${errData.error || '未知错误'}`);  
                    });  
                }  
                return response.json();  
            })  
            .then(data => {  
                if (data.success) {  
                    // 从DOM中移除已删除的行  
                    state.selectedRows.forEach(row => {  
                        row.remove();  
                    });  
  
                    // 清除选择状态  
                    clearAllSelections();  
                    updateSelectionStatus();  
  
                    // 显示成功消息  
                    alert(`成功删除 ${data.deleted} 个实体条目！`);  
  
                    // 刷新面板数据  
                    if (state.eaCurrentFile) {  
                        loadEAFile(state.eaCurrentFile);  
                    }  
                    loadResultsDirectory();  
                    loadProvinceDirectory();  
                } else {  
                    const errorMsg = data.errors?.join('\n') || '删除操作失败，原因未知';  
                    throw new Error(errorMsg);  
                }  
            })  
            .catch(error => {  
                console.error('删除错误:', error);  
                alert(`删除操作失败: ${error.message}`);  
            });  
        }  
  
        // 加载EA文件列表  
        function loadEAFiles() {  
            fetch('/api/list-files')  
                .then(response => response.json())  
                .then(data => {  
                    if (data.error) throw new Error(data.error);  
  
                    elements.ea.fileSelect.innerHTML = '<option value="">选择实体文件...</option>';  
                    data.ea.files.forEach(file => {  
                        const option = document.createElement('option');  
                        option.value = `${data.ea.path}/${file}`;  
                        option.textContent = file;  
                        elements.ea.fileSelect.appendChild(option);  
                    });  
                })  
                .catch(error => {  
                    console.error('加载文件列表错误:', error);  
                    elements.ea.status.textContent = "错误: 无法加载文件列表";  
                });  
        }  
  
        // 加载EA文件内容  
        function loadEAFile(filePath) {  
            state.eaCurrentFile = filePath;  
            elements.ea.status.textContent = "加载文件中...";  
  
            fetch(`/api/read-file?path=${encodeURIComponent(filePath)}`)  
                .then(response => response.json())  
                .then(data => {  
                    if (data.error) throw new Error(data.error);  
  
                    state.eaData = data.content;  
                    renderEAContent(data.content);  
  
                    elements.ea.status.innerHTML =  
                        `当前文件: <strong>${filePath.split('/').pop()}</strong> | 已加载${data.count}个实体`;  
                    elements.ea.stats.textContent = `${data.count}个实体`;  
                })  
                .catch(error => {  
                    console.error('加载EA文件错误:', error);  
                    elements.ea.content.innerHTML = `<tr><td colspan="3" class="text-center py-5 text-danger">错误: ${error.message}</td></tr>`;  
                    elements.ea.status.textContent = "文件加载失败";  
                });  
        }  
  
        // 渲染EA内容  
        function renderEAContent(content) {  
            const tbody = elements.ea.content;  
            tbody.innerHTML = '';  
            state.originalRows.ea = []; // 重置原始行数组  
  
            if (!content || content.length === 0) {  
                tbody.innerHTML = '<tr><td colspan="3" class="empty-state"><i class="fas fa-exclamation-circle"></i><p>文件内容为空</p></td></tr>';  
                return;  
            }  
  
            // 获取当前文件名（不含路径）  
            const fileName = state.eaCurrentFile.split('/').pop();  
  
            content.forEach(item => {  
                const row = document.createElement('tr');  
                row.innerHTML = `  
                    <td><span class="file-badge">${fileName}</span></td>  
                    <td><span class="entity-name">${item.entity}</span></td>  
                    <td>  
                        ${item.attributes.map(attr =>  
                            `<div class="badge bg-secondary me-1">${attr}</div>`  
                        ).join('')}  
                    </td>  
                    <td><span class="line-badge">${item.line_number}</span></td>  
                `;  
                tbody.appendChild(row);  
                state.originalRows.ea.push(row); // 保存原始行  
            });  
        }  
  
        // 加载分类实体目录  
        function loadResultsDirectory() {  
            elements.results.status.textContent = "加载分类实体数据...";  
  
            fetch(`/api/read-directory?path=${encodeURIComponent(state.RESULTS_DIR)}`)  
                .then(response => response.json())  
                .then(data => {  
                    if (data.error) throw new Error(data.error);  
  
                    state.resultsData = data.content;  
                    renderResultsContent(data.content);  
  
                    elements.results.status.textContent = `已加载全部实体 | ${data.count}个实体`;  
                    elements.results.stats.textContent = `${data.count}个实体`;  
                })  
                .catch(error => {  
                    console.error('加载分类实体错误:', error);  
                    elements.results.content.innerHTML = `<tr><td colspan="3" class="text-center py-5 text-danger">错误: ${error.message}</td></tr>`;  
                    elements.results.status.textContent = "数据加载失败";  
                });  
        }  
  
        // 渲染分类实体内容  
        function renderResultsContent(content) {  
            const tbody = elements.results.content;  
            tbody.innerHTML = '';  
            state.originalRows.results = []; // 保存原始行顺序  
  
            if (!content || content.length === 0) {  
                tbody.innerHTML = '<tr><td colspan="3" class="empty-state"><i class="fas fa-exclamation-circle"></i><p>未找到数据</p></td></tr>';  
                return;  
            }  
  
            content.forEach(item => {  
                const row = document.createElement('tr');  
                row.innerHTML = `  
                    <td><span class="file-badge">${item.file}</span></td>  
                    <td><span class="entity-name">${item.entity}</span></td>  
                    <td><span class="line-badge">${item.line_number}</span></td>  
                `;  
                tbody.appendChild(row);  
                state.originalRows.results.push(row); // 保存原始行  
            });  
        }  
  
        // 加载关系五元组目录  
        function loadProvinceDirectory() {  
            elements.province.status.textContent = "加载关系数据...";  
  
            fetch(`/api/read-directory?path=${encodeURIComponent(state.PROVINCE_DIR)}`)  
                .then(response => response.json())  
                .then(data => {  
                    if (data.error) throw new Error(data.error);  
  
                    state.provinceData = data.content;  
                    renderProvinceContent(data.content);  
  
                    elements.province.status.textContent = `已加载全部关系 | ${data.count}个关系`;  
                    elements.province.stats.textContent = `${data.count}个关系`;  
                })  
                .catch(error => {  
                    console.error('加载关系五元组错误:', error);  
                    elements.province.content.innerHTML = `<tr><td colspan="7" class="text-center py-5 text-danger">错误: ${error.message}</td></tr>`;  
                    elements.province.status.textContent = "数据加载失败";  
                });  
        }  
  
        // 渲染关系五元组内容  
        function renderProvinceContent(content) {  
            const tbody = elements.province.content;  
            tbody.innerHTML = '';  
            state.originalRows.province = []; // 保存原始行顺序  
  
            if (!content || content.length === 0) {  
                tbody.innerHTML = '<tr><td colspan="7" class="empty-state"><i class="fas fa-exclamation-circle"></i><p>未找到数据</p></td></tr>';  
                return;  
            }  
  
            content.forEach(item => {  
                const row = document.createElement('tr');  
                row.innerHTML = `  
                    <td><span class="file-badge">${item.file}</span></td>  
                    <td><span class="entity1">${item.entity1}</span></td>  
                    <td>${item.type1}</td>  
                    <td>${item.relation}</td>  
                    <td><span class="entity2">${item.entity2}</span></td>  
                    <td>${item.type2}</td>  
                    <td><span class="line-badge">${item.line_number}</span></td>  
                `;  
                tbody.appendChild(row);  
                state.originalRows.province.push(row); // 保存原始行  
            });  
        }  
  
        // 初始化事件监听  
        function initEventListeners() {  
            // EA文件加载  
            elements.ea.loadBtn.addEventListener('click', () => {  
                const filePath = elements.ea.fileSelect.value;  
                if (!filePath) {  
                    alert("请选择实体文件");  
                    return;  
                }  
                loadEAFile(filePath);  
            });  
  
            // 分类实体刷新  
            elements.results.refreshBtn.addEventListener('click', loadResultsDirectory);  
  
            // 关系五元组刷新  
            elements.province.refreshBtn.addEventListener('click', loadProvinceDirectory);  
  
            // 搜索功能  
            elements.ea.searchBtn.addEventListener('click', () => {  
                const term = elements.ea.searchInput.value.trim().toLowerCase();  
                if (!term) {  
                    renderEAContent(state.eaData);  
                    return;  
                }  
  
                const filtered = state.eaData.filter(item =>  
                    item.entity.toLowerCase().includes(term) ||  
                    item.attributes.some(attr => attr.toLowerCase().includes(term))  
                );  
                renderEAContent(filtered);  
            });  
  
            elements.results.searchBtn.addEventListener('click', () => {  
                const term = elements.results.searchInput.value.trim().toLowerCase();  
                if (!term) {  
                    renderResultsContent(state.resultsData);  
                    return;  
                }  
  
                const filtered = state.resultsData.filter(item =>  
                    item.entity.toLowerCase().includes(term)  
                );  
                renderResultsContent(filtered);  
            });  
  
            elements.province.searchBtn.addEventListener('click', () => {  
                const term = elements.province.searchInput.value.trim().toLowerCase();  
                if (!term) {  
                    renderProvinceContent(state.provinceData);  
                    return;  
                }  
  
                const filtered = state.provinceData.filter(item =>  
                    item.entity1.toLowerCase().includes(term) ||  
                    item.entity2.toLowerCase().includes(term) ||  
                    item.relation.toLowerCase().includes(term)  
                );  
                renderProvinceContent(filtered);  
            });  
        }  
  
        // 初始化应用  
        function initApp() {  
            // 初始化状态  
            state.originalRows = {  
                ea: [],  
                results: [],  
                province: []  
            };  
  
            // 初始化事件监听  
            initEventListeners();  
            initMultiSelect();  
  
            // 加载初始数据  
            loadEAFiles();  
            loadResultsDirectory();  
            loadProvinceDirectory();  
        }  
  
        // 启动应用  
        window.addEventListener('DOMContentLoaded', initApp);  
    </script>  
</body>  
</html>
```

### 3. 创建Flask应用

安装必要的依赖：



```bash
sudo apt update
sudo apt install python3 python3-pip
pip3 install flask
```

创建Flask应用文件：



```bash
nano ~/entity_editor/app.py
```

添加以下内容：



```python
import os  
import json  
from flask import Flask, request, jsonify, render_template  
  
app = Flask(__name__)  
  
# 配置三个目标目录 - 使用绝对路径  
EA_DIR = os.path.abspath("/home/ps/Austin/AI_policy/results/EA")  
RESULTS_DIR = os.path.abspath("/home/ps/Austin/AI_policy/results")  
PROVINCE_DIR = os.path.abspath("/home/ps/Austin/AI_policy/data_ER5/省")  
  
# 确保目录存在  
for directory in [EA_DIR, RESULTS_DIR, PROVINCE_DIR]:  
    if not os.path.exists(directory):  
        os.makedirs(directory, exist_ok=True)  
        print(f"创建目录: {directory}")  
  
  
def is_valid_path(path, valid_dirs):  
    """检查路径是否在允许的目录内"""  
    try:  
        abs_path = os.path.abspath(path)  
        return any(abs_path.startswith(d) for d in valid_dirs)  
    except Exception:  
        return False  
  
  
@app.route('/')  
def index():  
    return render_template('index.html',  
                           EA_DIR=EA_DIR,  
                           RESULTS_DIR=RESULTS_DIR,  
                           PROVINCE_DIR=PROVINCE_DIR)  
  
  
@app.route('/api/list-files')  
def list_files():  
    """列出三个目录中的文件"""  
    try:  
        data = {  
            "ea": {  
                "path": EA_DIR,  
                "files": [f for f in os.listdir(EA_DIR) if f.endswith('.txt')]  
            },  
            "results": {  
                "path": RESULTS_DIR,  
                "files": [f for f in os.listdir(RESULTS_DIR) if f.endswith('.txt')]  
            },  
            "province": {  
                "path": PROVINCE_DIR,  
                "files": [f for f in os.listdir(PROVINCE_DIR) if f.endswith('.txt')]  
            }  
        }  
        return jsonify(data)  
    except Exception as e:  
        return jsonify({"error": str(e)}), 500  
  
  
@app.route('/api/read-file')  
def read_file():  
    """读取单个文件内容"""  
    file_path = request.args.get('path')  
  
    # 安全验证  
    valid_dirs = [EA_DIR, RESULTS_DIR, PROVINCE_DIR]  
    if not is_valid_path(file_path, valid_dirs):  
        return jsonify({  
            "error": "Invalid file path",  
            "requested": file_path,  
            "valid_dirs": valid_dirs  
        }), 403  
  
    if not os.path.exists(file_path):  
        return jsonify({"error": "File not found"}), 404  
  
    try:  
        with open(file_path, 'r', encoding='utf-8') as f:  
            content = f.readlines()  
  
        # 解析EA文件内容  
        parsed_content = []  
        for i, line in enumerate(content):  
            line = line.strip()  
            if not line:  
                continue  
            parts = line.split(',')  
            if parts:  
                parsed_content.append({  
                    "entity": parts[0],  
                    "attributes": parts[1:] if len(parts) > 1 else [],  
                    "line_number": i + 1  
                })  
  
        return jsonify({  
            "path": file_path,  
            "content": parsed_content,  
            "count": len(parsed_content)  
        })  
    except Exception as e:  
        return jsonify({"error": str(e)}), 500  
  
  
@app.route('/api/read-directory')  
def read_directory():  
    """读取整个目录的内容"""  
    dir_path = request.args.get('path')  
  
    # 安全验证  
    valid_dirs = [RESULTS_DIR, PROVINCE_DIR]  
    abs_dir_path = os.path.abspath(dir_path) if dir_path else None  
  
    if not abs_dir_path or abs_dir_path not in [os.path.abspath(d) for d in valid_dirs]:  
        return jsonify({  
            "error": "Invalid directory path",  
            "requested": dir_path,  
            "valid_dirs": valid_dirs  
        }), 403  
  
    try:  
        merged_content = []  
        total_count = 0  
  
        for file_name in os.listdir(dir_path):  
            if not file_name.endswith('.txt'):  
                continue  
  
            file_path = os.path.join(dir_path, file_name)  
            if not os.path.exists(file_path):  
                continue  
  
            with open(file_path, 'r', encoding='utf-8') as f:  
                content = f.readlines()  
  
            # 解析分类实体目录  
            if dir_path == RESULTS_DIR:  
                for i, line in enumerate(content):  
                    line = line.strip()  
                    if not line:  
                        continue  
                    merged_content.append({  
                        "file": file_name,  
                        "entity": line,  
                        "line_number": i + 1  
                    })  
                    total_count += 1  
  
            # 解析关系五元组目录  
            elif dir_path == PROVINCE_DIR:  
                for i, line in enumerate(content):  
                    line = line.strip()  
                    if not line:  
                        continue  
                    parts = line.split(',')  
                    if len(parts) == 5:  
                        merged_content.append({  
                            "file": file_name,  
                            "entity1": parts[0],  
                            "type1": parts[1],  
                            "relation": parts[2],  
                            "entity2": parts[3],  
                            "type2": parts[4],  
                            "line_number": i + 1  
                        })  
                        total_count += 1  
  
        return jsonify({  
            "path": dir_path,  
            "content": merged_content,  
            "count": total_count  
        })  
    except Exception as e:  
        return jsonify({"error": str(e)}), 500  
  
  
@app.route('/api/delete-lines', methods=['POST'])  
def delete_lines():  
    data = request.json  
    app.logger.info(f"收到删除请求: {json.dumps(data, ensure_ascii=False)}")  
  
    if not data or 'deletions' not in data:  
        app.logger.error("请求缺少 deletions 字段")  
        return jsonify({"error": "请求缺少 deletions 字段"}), 400  
  
    deletions = data.get('deletions')  
  
    if not deletions or not isinstance(deletions, list):  
        app.logger.error(f"无效的删除数据格式: {type(deletions)}")  
        return jsonify({"error": "Invalid deletion data"}), 400  
  
    # 按文件分组删除操作  
    file_deletions = {}  
    for deletion in deletions:  
        file_path = deletion.get('file_path')  
        line_content = deletion.get('line_content')  
  
        if not file_path or not line_content:  
            app.logger.warning(f"缺少文件路径或内容: {deletion}")  
            continue  
  
        if file_path not in file_deletions:  
            file_deletions[file_path] = []  
        file_deletions[file_path].append(line_content)  
  
    app.logger.info(f"需要处理的文件数: {len(file_deletions)}")  
  
    # 处理每个文件的删除  
    total_deleted = 0  
    errors = []  
    valid_dirs = [EA_DIR, RESULTS_DIR, PROVINCE_DIR]  
  
    for file_path, lines_to_delete in file_deletions.items():  
        # 安全验证  
        if not is_valid_path(file_path, valid_dirs):  
            app.logger.error(f"无效文件路径: {file_path}")  
            errors.append(f"Invalid file path: {file_path}")  
            continue  
  
        if not os.path.exists(file_path):  
            app.logger.error(f"文件不存在: {file_path}")  
            errors.append(f"File not found: {file_path}")  
            continue  
  
        try:  
            # 读取原始文件内容  
            with open(file_path, 'r', encoding='utf-8') as f:  
                original_lines = f.readlines()  
  
            app.logger.info(f"处理文件 {file_path}，需要删除 {len(lines_to_delete)} 行")  
  
            # 筛选保留的行  
            updated_lines = []  
            deleted_count = 0  
  
            for line in original_lines:  
                stripped_line = line.strip()  
                # 只保留不在删除列表中的行  
                if stripped_line not in lines_to_delete:  
                    updated_lines.append(line)  
                else:  
                    deleted_count += 1  
                    app.logger.debug(f"删除行: {stripped_line}")  
  
            app.logger.info(f"文件 {file_path} 删除了 {deleted_count} 行")  
  
            # 写回文件  
            with open(file_path, 'w', encoding='utf-8') as f:  
                f.writelines(updated_lines)  
  
            total_deleted += deleted_count  
  
        except Exception as e:  
            error_msg = f"处理文件 {file_path} 时出错: {str(e)}"  
            app.logger.error(error_msg, exc_info=True)  
            errors.append(error_msg)  
  
    if errors:  
        app.logger.error(f"删除操作失败，错误数: {len(errors)}")  
        return jsonify({  
            "success": False,  
            "deleted": total_deleted,  
            "errors": errors  
        }), 500  
  
    app.logger.info(f"成功删除 {total_deleted} 行")  
    return jsonify({  
        "success": True,  
        "deleted": total_deleted  
    })  
  
  
if __name__ == '__main__':  
    app.run(host='0.0.0.0', port=8502, debug=True)
```

style.css文件：
```css
:root {
    --header-bg: #2c3e50;
    --primary-color: #3498db;
    --secondary-color: #2ecc71;
    --warning-color: #e74c3c;
    --panel-bg: #ecf0f1;
    --border-color: #bdc3c7;
    --selected-bg: rgba(46, 204, 113, 0.25);
}

body {
    background-color: #f8f9fa;
    font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
    margin: 0;
    padding: 0;
    height: 100vh;
    overflow: hidden;
}

.app-header {
    background: var(--header-bg);
    color: white;
    padding: 0.8rem 2rem;
    box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    position: sticky;
    top: 0;
    z-index: 100;
}

.header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-title {
    margin: 0;
    font-weight: 600;
    font-size: 1.5rem;
}

.directory-info {
    font-size: 0.9rem;
    color: #ecf0f1;
    background: rgba(255,255,255,0.1);
    padding: 0.5rem 1rem;
    border-radius: 4px;
}

.container-fluid {
    padding: 1rem;
    height: calc(100% - 70px);
}

.panel-container {
    display: flex;
    height: 100%;
    gap: 15px;
}

.panel {
    flex: 1;
    background: white;
    border-radius: 8px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.08);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    min-height: 0;
    transition: all 0.3s ease;
}

.panel:hover {
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.panel-header {
    background: var(--primary-color);
    color: white;
    padding: 0.8rem 1.2rem;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: relative;
}

.panel-header.warning {
    background: var(--warning-color);
}

.panel-action-bar {
    padding: 0.5rem 1rem;
    background: var(--panel-bg);
    border-bottom: 1px solid var(--border-color);
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 10px;
}

.panel-content-container {
    flex-grow: 1;
    overflow: auto;
    position: relative;
    border-top: 1px solid var(--border-color);
    height: 100%;
}

.panel-table {
    width: 100%;
    border-collapse: collapse;
}

.panel-table th {
    background: var(--panel-bg);
    position: sticky;
    top: 0;
    padding: 0.8rem 0.6rem;
    text-align: left;
    font-weight: 600;
    border-bottom: 2px solid var(--border-color);
    font-size: 0.9rem;
}

.panel-table td {
    padding: 0.8rem 0.6rem;
    border-bottom: 1px solid var(--border-color);
    font-size: 0.95rem;
}

.panel-table tr {
    transition: background 0.2s;
    cursor: pointer;
}

.panel-table tr:hover {
    background: rgba(52, 152, 219, 0.08);
}

.panel-table tr.selected {
    background: var(--selected-bg) !important;
    box-shadow: inset 0 0 10px rgba(46, 204, 113, 0.3);
}

.stats-bar {
    padding: 0.5rem 1rem;
    background: var(--panel-bg);
    border-top: 1px solid var(--border-color);
    font-size: 0.85rem;
    color: #7f8c8d;
    position: sticky;
    bottom: 0;
}

.btn-action {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.4rem 0.8rem;
    font-size: 0.9rem;
}

.btn-delete {
    background: var(--warning-color);
    border: none;
    color: white;
}

.btn-delete:hover {
    background: #c0392b;
}

.directory-tag {
    background: rgba(236, 240, 241, 0.3);
    color: white;
    padding: 0.2rem 0.6rem;
    border-radius: 20px;
    font-size: 0.8rem;
    margin-left: 0.5rem;
}

.empty-state {
    text-align: center;
    color: #95a5a6;
    padding: 4rem 2rem;
}

.empty-state i {
    font-size: 3rem;
    margin-bottom: 1rem;
    opacity: 0.3;
}

.file-badge {
    background-color: #6c757d;
    color: white;
    border-radius: 10px;
    padding: 2px 8px;
    font-size: 0.8em;
    margin-right: 5px;
}

.line-badge {
    background-color: #17a2b8;
    color: white;
    border-radius: 10px;
    padding: 2px 8px;
    font-size: 0.8em;
    margin-left: 5px;
}

.selection-info {
    padding: 0.5rem 1rem;
    background: rgba(46, 204, 113, 0.1);
    border-top: 1px solid #2ecc71;
    font-size: 0.9rem;
    display: none;
}

.selected-entity-card {
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 0.8rem;
    width: 180px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.selected-entity-card .entity-name {
    font-weight: bold;
    font-size: 1.1rem;
    margin-bottom: 0.3rem;
}

.selected-entity-card .entity-type {
    font-size: 0.85rem;
    color: #6c757d;
}
```
### 4. 运行应用程序

启动应用：



```bash
cd ~/entity_editor
python3 app.py
```

现在你的应用应该可以通过`http://服务器IP:5000`访问了。

### 5. 配置防火墙

如果无法访问，可能需要配置防火墙：



```bash
sudo ufw allow 5000
```

### 6. (可选) 创建服务以长期运行

创建systemd服务文件：



```bash
sudo nano /etc/systemd/system/entity-editor.service
```

添加以下内容：



```ini
[Unit]
Description=Entity Editor Web Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/entity_editor
ExecStart=/usr/bin/python3 /home/ubuntu/entity_editor/app.py
Restart=always

[Install]
WantedBy=multi-user.target
```

启用并启动服务：



```bash
sudo systemctl daemon-reload
sudo systemctl start entity-editor
sudo systemctl enable entity-editor
```

## 完整部署脚本

下面是一个完整的部署脚本，可以直接在Ubuntu服务器上运行：



```bash
#!/bin/bash

# 安装必要依赖
sudo apt update
sudo apt install -y python3 python3-pip
sudo pip3 install flask

# 创建项目目录
mkdir -p ~/entity_editor/{templates,static}

# 创建HTML文件
cat > ~/entity_editor/templates/index.html << 'EOL'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>实体关系管理工具 - 多目录实体关联系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --header-bg: #2c3e50;
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --warning-color: #e74c3c;
            --panel-bg: #ecf0f1;
            --border-color: #bdc3c7;
        }
        
        /* 所有CSS样式放在这里 */
        /* ... 省略完整的CSS样式 ... */
    </style>
</head>
<body>
    <!-- 完整的HTML结构 -->
    <!-- ... 省略完整的HTML内容 ... -->
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 所有JavaScript代码放在这里
        // ... 省略完整的JS代码 ...
    </script>
</body>
</html>
EOL

# 创建Flask应用
cat > ~/entity_editor/app.py << 'EOL'
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOL

# 配置防火墙
sudo ufw allow 5000

# 创建系统服务
sudo bash -c 'cat > /etc/systemd/system/entity-editor.service << EOL
[Unit]
Description=Entity Editor Web Application
After=network.target

[Service]
User=$(whoami)
WorkingDirectory=/home/$(whoami)/entity_editor
ExecStart=/usr/bin/python3 /home/$(whoami)/entity_editor/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOL'

# 启用并启动服务
sudo systemctl daemon-reload
sudo systemctl start entity-editor
sudo systemctl enable entity-editor

echo "部署完成！访问地址：http://$(curl -s ifconfig.me):5000"
```

## 使用说明

1. 将上面的脚本保存为`deploy.sh`文件
2. 上传到Ubuntu服务器或者直接在服务器上创建：
    
    
    ```bash
    nano deploy.sh
    ```
    
3. 赋予执行权限：
    
  
    
    ```bash
    chmod +x deploy.sh
    ```
    
4. 运行部署脚本：
    
  
    
    ```bash
    ./deploy.sh
    ```
    

## 访问应用

部署完成后，你可以通过以下方式访问应用：

- `http://<your-server-ip>:5000`
- 或者如果服务器有域名：`http://your-domain.com:5000`

## 调试建议

如果遇到问题，可以查看日志：

bash

复制

```bash
sudo journalctl -u entity-editor -f
```

## 安全注意事项

1. ​**限制访问**：如果部署在公共服务器，建议使用防火墙限制访问IP
2. ​**使用Nginx反向代理**：对于生产环境，建议使用Nginx作为反向代理并添加HTTPS
3. ​**文件权限**：确保应用目录和文件有适当的权限
4. ​**定期更新**：保持Python包和系统更新

这个部署方案提供了一种简单可靠的方式来托管你的实体关系管理工具，确保可以通过远程访问。