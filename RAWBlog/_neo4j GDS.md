****
[官网教程](https://neo4j.com/docs/graph-data-science/current/installation/)
****
### 1. 下载Graph Data Science Library插件

前往[Neo4j Graph Data Science Library插件页面]https://neo4j.com/deployment-center/#gds-tab)下载与您Neo4j版本兼容的GDS插件。请确保下载的是正确版本。

### 2. 安装插件

将下载的GDS插件（.jar文件）复制到Neo4j安装目录的`plugins`文件夹中(可在neo4j.conf中查看plugins的目录)。以下是示例路径：

- **Linux**: `/var/lib/neo4j/plugins`

### 3. 配置Neo4j

打开Neo4j的配置文件（`etc/neo4j/neo4j.conf`），添加以下配置来启用GDS插件：

```plaintext
dbms.security.procedures.unrestricted=gds.*
dbms.security.procedures.allowlist=gds.*
```

配置文件路径通常在以下位置：

- **Windows**: `C:\Users\<your-username>\Documents\Neo4j\relate-data\dbmss\dbms-<your-database-id>\conf\neo4j.conf`
- **macOS/Linux**: `/Users/<your-username>/Library/Application Support/Neo4j Desktop/Application/relate-data/dbmss/dbms-<your-database-id>/conf/neo4j.conf`

### 4. 重启Neo4j

完成上述步骤后，重启Neo4j数据库，以便加载新的插件和配置。

### 5. 验证安装

在Neo4j Browser中执行以下Cypher查询，验证GDS插件是否成功安装：

```cypher
CALL gds.version();
```

如果安装成功，你会看到GDS库的版本信息。

### 6. 使用GDS库

现在你可以使用GDS库中的各种算法进行图数据分析。例如，以下是一个简单的示例，使用PageRank算法：

```cypher
// 创建图
CALL gds.graph.create(
  'myGraph',
  'User',
  'KNOWS'
);

// 运行PageRank算法
CALL gds.pageRank.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC;
```

通过这些步骤，你应该能够成功安装并使用Neo4j Graph Data Science Library进行图数据分析。如果在安装过程中遇到问题，可以参考Neo4j的官方文档或社区论坛寻求帮助。