# 清空数据库
```cypher
MATCH (n)
DETACH DELETE n
```
# 同时显示两种节点
如果你想同时显示文件编号和层级两种节点，并且假设这两种节点之间存在某种关系，你可以使用以下的Cypher查询来检索它们：
```cypher
MATCH (file:文件编号)-[r]-(level:层级)  
RETURN file, r, level  
LIMIT 250
```
如果你想查询标签为'文件编号'且`name`属性值为`12`的节点，你可以使用Cypher查询语言来完成这个操作。假设你正在使用Neo4j数据库，并且已经通过`py2neo`或其他方式连接到了数据库，你可以执行如下Cypher查询：

```cypher
MATCH (n:文件编号 {name: '12'})  RETURN n;
```

这条查询会找到所有标签为'文件编号'且`name`属性为'12'的节点，并返回它们。

如果你是在Python代码中使用`py2neo`库来执行这个查询，你可以这样做：

```python
from py2neo import Graph 
# 假设你的Neo4j服务正在本地运行，且端口号为7687 graph = 
Graph("bolt://localhost:7687", user="neo4j", password="your_password") 
# 执行Cypher查询 
query = "MATCH (n:文件编号 {name: '12'}) RETURN n" nodes = graph.run(query).data() 
# 输出查询结果 
for node in nodes: 
	print(node['n'])
```
# 展示与某节点有关的所有节点
为了展示与标签为'文件编号'且`name`为'12'的节点有关系的所有其他节点，你可以使用以下的Cypher查询：

```cypher
MATCH (n:文件编号 {name: '12'})-[r]-(m)  
RETURN n, r, m;
```

这个查询会找到标签为'文件编号'、`name`属性为'12'的节点`n`，以及通过任意类型的关系`r`与`n`相连的所有节点`m`。查询结果将包括节点`n`、关系`r`和节点`m`。

如果你想在Python代码中使用`py2neo`执行这个查询，可以这样做：

```python
from py2neo import Graph    
# 假设Neo4j服务正在本地运行，且端口号为7687  graph = 
Graph("bolt://localhost:7687", user="neo4j", password="your_password")    
# 执行Cypher查询  
query = "MATCH (n:文件编号 {name: '12'})-[r]-(m) RETURN n, r, m"  results = graph.run(query)    
# 输出查询结果  
for record in results:      
	n, r, m = record['n'], record['r'], record['m']      
	print(f"节点 {n} 通过关系 {r} 与节点 {m} 相连")
```
# 多跳关系遍历
如果你想要获取更多与`m`相连的节点，而不仅仅是直接相连的节点，你可以增加关系的长度。例如，以下查询将找到与`m`通过1到3个关系相连的节点：

```cypher
MATCH (n:文件编号 {name: '12'})-[r]-(m), (m)-[*1..3]-(o)  
RETURN n, r, m, o;
```

在这个查询中，`[*1..3]`表示与`m`相连的关系长度为1到3的任意节点`o`。你可以根据需要调整这个数字范围。

请注意，增加关系长度可能会导致查询变得非常慢，特别是当图中存在大量节点和关系时。因此，建议谨慎使用，并根据实际情况调整查询性能。

在Python中使用`py2neo`执行上述查询的示例代码如下：

```python
from py2neo import Graph    
graph = Graph("bolt://localhost:7687", user="neo4j", password="your_password")    
query = """  MATCH (n:文件编号 {name: '12'})-[r]-(m), (m)-[*1..3]-(o)  RETURN n, r, m, o  """  
results = graph.run(query)    
for record in results:      
	n, r, m, o = record['n'], record['r'], record['m'], record['o'] 
	print(f"节点 {n} 通过关系 {r} 与节点 {m} 相连，节点 {m} 又与节点 {o} 相连")
```
# 排除语句
如果您想要筛选出与`文件编号`节点有关系，并且`m`节点不是`层级`标签的节点，您可以在MATCH语句中添加一个WHERE子句来排除具有特定标签的节点。以下是一个修改后的Cypher查询示例：

```cypher
MATCH (file:文件编号 {name: '100'})-[r]-(m)  
WHERE NOT m:层级  
RETURN file, r, m  
LIMIT 250
```

在这个查询中，`WHERE NOT m:层级`确保`m`节点不具有`层级`标签。这样，返回的`m`节点将排除所有带有`层级`标签的节点。`LIMIT 250`则限制了返回结果的数量，最多返回250条记录。
# 示例
```
MATCH (n:文件编号 {name: '12'})-[r]-(m)-[s]-(o) 
WHERE NOT o:条款编号 AND NOT o:文件编号 AND NOT o:层级 AND NOT m:文件编号
RETURN n, r, m, s, o
LIMIT 300
```
## 查询解释

- **MATCH** 部分：这里定义了一个图模式，表示从具有特定属性的节点 `n` 开始，通过任意类型的关系 `r` 连接到节点 `m`，再通过关系 `s` 连接到节点 `o`。
    
    - `(n:文件编号 {name: '12'})`：选择一个标签为 `文件编号`，属性 `name` 值为 `'12'` 的节点。
    - `-[r]-(m)-[s]-(o)`：节点 `n` 通过关系 `r` 连接到任何节点 `m`，然后节点 `m` 通过关系 `s` 连接到任何节点 `o`。
- **WHERE** 部分：这里用来过滤掉不想要的节点。
    
    - `NOT (o:条款编号 OR o:文件编号 OR o:层级)`：确保节点 `o` 不是 `条款编号`、`文件编号` 或 `层级`。
    - `NOT (m:文件编号)`：确保节点 `m` 不是 `文件编号`。
- **RETURN** 部分：返回符合条件的节点和关系。
    
    - `n, r, m, s, o`：返回节点 `n`、关系 `r`、节点 `m`、关系 `s` 和节点 `o`。
- **LIMIT** 部分：限制返回的结果数量，这里限制为300。这对于大数据集合很有用，可以防止返回太多结果而导致性能问题。
    

这个查询适用于你想要查找与某个特定文件编号相关的其他节点和关系，同时排除特定类型的节点。确保你的数据库中有正确的索引，以优化这类带有属性查找和多个节点类型过滤的查询的性能。