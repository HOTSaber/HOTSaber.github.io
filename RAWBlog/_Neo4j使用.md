# 创建neo4j数据库
## 源代码
```
from py2neo import Graph  
  
# 连接到 Neo4jgraph = Graph("bolt://10.240.44.140:7688", auth=("neo4j", "88888888"))   #【bolt://10.240.44.140:7688是采用局域网在自己电脑上跑；如果把文件放到4090上，“10.2400.44.140”改成“0.0.0.0”或者“127.0.0.1”】
  
# 打开文件并读取数据  
with open('output.txt', 'r') as file:  #文件在同一个文件夹里面就直接引用
    for line in file:  
        parts = line.strip().split('\t')  # 根据实际分隔符分割  
        entity1_id, relation_type, entity2_id = parts[0], parts[1], parts[2]  
        # 创建或获取节点和关系  
        graph.run("MERGE (a:User {id: $entity1_id}) "  #【User是实体1名字，自己创建】
                  "MERGE (b:Item {id: $entity2_id}) "  #【Item是实体2名字，自己创建】  
                  "MERGE (a)-[:buy {type: $relation_type}]->(b)",  #[buy是实体间关系，自己区]
                  entity1_id=entity1_id, relation_type=relation_type, entity2_id=entity2_id)
```

# 怎么读取多关系的TXT，并创建Neo4j数据库
## 源代码
```
#python
from py2neo import Graph, Node, Relationship

# 连接到Neo4j数据库
graph = Graph("bolt://localhost:7687", auth=("neo4j", "your_password"))[改成自己的]

# 读取数据文件
def read_data(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        data = file.readlines()
    return data

# 解析数据并创建节点和关系
def import_data(data):
    for line in data:
        parts = line.strip().split('\t')  # 假设数据以制表符分隔
        if len(parts) != 3:
            continue  # 跳过格式不正确的行
        movie, role, person = parts

        # 检查电影节点是否已存在
        movie_node = graph.nodes.match("Movie", title=movie).first()
        if not movie_node:
            movie_node = Node("Movie", title=movie)
            graph.create(movie_node)

        # 检查人物节点是否已存在
        person_node = graph.nodes.match(role[:-1], name=person).first()  # 移除复数形式的's'
        if not person_node:
            person_node = Node(role[:-1], name=person)
            graph.create(person_node)

        # 创建关系
        rel = Relationship(movie_node, role.upper(), person_node)
        graph.create(rel)

# 主函数
def main():
    file_path = 'path_to_your_data_file.txt'  # 设置数据文件的路径[这里要改]
    data = read_data(file_path)
    import_data(data)

if __name__ == "__main__":
    main()
```

# 删除neo4j数据库中所有数据
## 源代码
```
MATCH (n)
DETACH DELETE n;
```

# 列出所有的数据库
```
SHOW DATABASES;
```

# GDS包下载（没成功）
## 在本机上下载neo4j_5.19.0_all.deb后
### 网址：https://neo4j.com/deployment-center/#gds-tab
## 通过XFTP 传至/var/lib/neo4j/plugins




# 在Neo4j生成图谱后，怎么生成推荐
## 源代码
```
#cypher
// 遍历每个用户
MATCH (user:User)
// 找到该用户购买的商品以及其他购买了同一商品的用户
MATCH (user)-[:buy]->(item:Item)<-[:buy]-(other:User)
WITH user, other, item
// 查找这些其他用户购买的其他商品
MATCH (other)-[:buy]->(recommendation:Item)
// 确保这些推荐商品不是原用户已经购买的，并且不是用户自己
WHERE NOT (user)-[:buy]->(recommendation) AND user <> other
// 为每个推荐创建一个新的关系：MAY_BUY
MERGE (user)-[r:MAY_BUY]->(recommendation)
// 可选：设置关系属性，例如推荐分数
ON CREATE SET r.score = 1
ON MATCH SET r.score = r.score + 1
// 返回每个用户的推荐商品列表，按推荐次数排序
RETURN user.id AS UserId, recommendation, r.score AS Score
ORDER BY UserId, Score DESC
LIMIT 100; #按照自己需要的量调整
```

# Neo4j的推荐输出到TXT
## 源代码
```
#pyhton
from py2neo import Graph  
  
  
def export_recommendations_to_txt(username, password, uri, filepath):  
    graph = Graph(uri, auth=(username, password))  
  
    query = """  
    MATCH (user:User)-[:buy]->(:Item)<-[:buy]-(other:User)    MATCH (other)-[:buy]->(recommendation:Item)    WHERE NOT (user)-[:buy]->(recommendation) AND user <> other    RETURN user.id AS UserId, recommendation.id AS ItemId, COUNT(*) AS Score    ORDER BY Score DESC    LIMIT 100;    """  
    results = graph.run(query)  
  
    with open(filepath, 'w', encoding='utf-8') as file:  
        file.write("UserId\tItemId\tScore\n")  
        for result in results:  
            user_id = result['UserId']  
            item_id = result['ItemId']  # 注意这里改成了 'ItemId'            score = result['Score']  
            line = f"{user_id}\t{item_id}\t{score}\n"  
            file.write(line)  
  
    print(f"Data exported to {filepath}")  
  
  
export_recommendations_to_txt('neo4j', '88888888', 'bolt://10.240.44.140:7688', 'recommendations.txt')
```

# 导出TXT时，显示进度条
## 源代码
```
#python
from py2neo import Graph
from tqdm import tqdm

def export_user_recommendations_to_txt(username, password, uri, filepath):
    graph = Graph(uri, auth=(username, password))

    query = """
    // 你的查询逻辑
    """

    # 运行查询，将结果转换为列表以便使用tqdm
    results = list(graph.run(query))

    # 准备写入文件，并使用tqdm显示进度
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write("UserId\tTopBookIds\n")  # 写入标题行
        for result in tqdm(results, desc="Exporting Recommendations"):
            user_id = result['UserId']
            # 将书籍ID列表转换为逗号分隔的字符串
            top_book_ids = ','.join(map(str, result['TopBookIds']))
            line = f"{user_id}\t{top_book_ids}\n"
            file.write(line)  # 写入每行数据

    print(f"Data exported to {filepath}")

# 调用函数以导出数据到文本文件
export_user_recommendations_to_txt('neo4j', '88888888', 'bolt://10.240.44.140:7688', 'user_recommendations.txt')
```

# 输出结果准确度（未完成）
## 源代码
```

```



# 删除movie节点
## 源代码
```
#cypher
MATCH (m:Movie)
DELETE m
```

# 匹配并删除相关关系
## 源代码
```
#cypher
MATCH (m:Movie)-[r]-()
DELETE r
```

# 删除特定关系
## 源代码
```
MATCH ()-[r:may_like]->()
DELETE r
```


# 整合TXT时，只保留相应数据列
## 源代码
```
#python
import pandas as pd  
try:  
    # 读取数据，指定使用制表符作为分隔符  
    data = pd.read_csv('items_info.dat', sep='\t', usecols=[0, 2, 3, 4, 5], header=None,  encoding='utf-8')  # 只留第1，3，4，5，6列
  
    # 保存处理后的数据到新的TXT文件，不保留索引  
    data.to_csv('book_info1.txt', index=False, sep='\t', header=False, encoding='utf-8')  
except Exception as e:  
    print(f"Error reading or writing the data file: {e}")
```
# 划分数据集
## 源代码
```
#python
import numpy as np  
def split_data(file_path, train_ratio=0.8): [按照8：2划分的] 
    # 读取文件  
    with open(file_path, 'r', encoding='utf-8') as file:  
        lines = file.readlines()  
  
    # 打乱数据  
    np.random.shuffle(lines)  
  
    # 计算分割点  
    split_idx = int(len(lines) * train_ratio)  
  
    # 分割数据  
    train_lines = lines[:split_idx]  
    test_lines = lines[split_idx:]  
  
    # 保存训练数据  
    with open('train.txt', 'w', encoding='utf-8') as file:  
        file.writelines(train_lines)  
  
    # 保存测试数据  
    with open('test.txt', 'w', encoding='utf-8') as file:  
        file.writelines(test_lines)  
# 调用函数  
split_data('output.txt')
```

# 运用train.txt等构建多关系知识图谱
## 源代码
```
#python
from py2neo import Graph, Node, Relationship  
  
# 设置Neo4j连接  
graph = Graph("bolt://10.240.44.140:7688", auth=("neo4j", "88888888"))  
  
def import_users(filename):  
    with open(filename, "r", encoding='utf-8') as file:  
        for line_number, line in enumerate(file, start=1):  
            parts = line.strip().split('\t')  
            if len(parts) != 3:  
                print(f"Skipping invalid line {line_number}: {line.strip()}")  
                continue  
            user_id, location, age = parts  
            user_node = Node("User", id=user_id, location=location, age=int(age))  
            graph.merge(user_node, "User", "id")  
  
def import_books(filename):  
    with open(filename, "r", encoding='utf-8') as file:  
        next(file)  # 跳过标题行，如果有的话  
        for line_number, line in enumerate(file, start=2):  # 从第二行开始  
            parts = line.strip().split('\t')  
            if len(parts) != 5:  
                print(f"Skipping invalid line {line_number}: {line.strip()}")  
                continue  
            book_id, title, author, year, publisher = parts  
            try:  
                # 创建或获取书籍节点  
                book_node = Node("Book", id=book_id, title=title, author=author, year=year, publisher=publisher)  
                graph.merge(book_node, "Book", "id")  
            except Exception as e:  
                print(f"Error on line {line_number}: {e}")  
  
def import_borrowing_relationships(filename):  
    with open(filename, "r", encoding='utf-8') as file:  
        for line_number, line in enumerate(file, start=1):  
            parts = line.strip().split('\t')  
            if len(parts) != 3:  
                print(f"Skipping invalid line {line_number}: {line.strip()}")  
                continue  
            user_id, borrow_type, book_id = parts  
            match_query = """  
            MATCH (user:User {id: $user_id})            MATCH (book:Book {id: $book_id})            MERGE (user)-[r:BORROWED {type: $borrow_type}]->(book)            """            graph.run(match_query, user_id=user_id, book_id=book_id, borrow_type=borrow_type)  
  
  
def main():  
    import_users("users_info.txt")  
    import_books("book_info1.txt")  
    import_borrowing_relationships("train.txt")  
  
if __name__ == "__main__":  
    main()
```

# 多因素推荐
## 源代码：
```
#cypher
// 找到User:A借阅的书籍

MATCH (userA:User {id: '1'})-[:BORROWED]->(bookX:Book)

// 找到同一作者写的其他书籍

OPTIONAL MATCH (bookX)-[:WROTE]->(authorB:Author)<-[:WROTE]-(otherBooksBySameAuthor:Book)

WHERE NOT (userA)-[:BORROWED]->(otherBooksBySameAuthor)

// 找到同一出版社出版的其他书籍

OPTIONAL MATCH (bookX)-[:PUBLISHED]->(publisherC:Publisher)<-[:PUBLISHED]-(otherBooksBySamePublisher:Book)

WHERE NOT (userA)-[:BORROWED]->(otherBooksBySamePublisher)

// 找到借阅了相同书籍的其他用户，并根据评分推荐他们借阅的其他书籍

OPTIONAL MATCH (otherUser:User)-[:BORROWED]->(otherBooks)<-[rated:RATED]-(userA)

WHERE NOT (userA)-[:BORROWED]->(otherBooks) AND otherUser <> userA

WITH otherBooksBySameAuthor, otherBooksBySamePublisher, COLLECT(otherBooks) AS collectedBooks, rated.rating AS rating

ORDER BY rating DESC

WITH otherBooksBySameAuthor, otherBooksBySamePublisher, collectedBooks[..10] AS topRecommendations

// 创建may_like关系

UNWIND topRecommendations AS topBook

MATCH (userA:User {id: '1'}), (topBook)

MERGE (userA)-[:MAY_LIKE]->(topBook)

// 返回结果

RETURN otherBooksBySameAuthor AS RecommendationsFromSameAuthor, 

       otherBooksBySamePublisher AS RecommendationsFromSamePublisher, 

       topRecommendations AS TopRecommendationsFromOtherUsers
```
## 源代码2
```
// 找到User:A借阅的书籍

MATCH (userA:User {id: '1'})-[:BORROWED]->(bookX:Book)

  

// 找到同一作者写的其他书籍

OPTIONAL MATCH (bookX)-[:WROTE]->(authorB:Author)<-[:WROTE]-(otherBooksBySameAuthor:Book)

WHERE NOT (userA)-[:BORROWED]->(otherBooksBySameAuthor)

  

// 找到同一出版社出版的其他书籍

OPTIONAL MATCH (bookX)-[:PUBLISHED]->(publisherC:Publisher)<-[:PUBLISHED]-(otherBooksBySamePublisher:Book)

WHERE NOT (userA)-[:BORROWED]->(otherBooksBySamePublisher)

  

// 找到借阅了相同书籍的其他用户，并根据评分推荐他们借阅的其他书籍

OPTIONAL MATCH (otherUser:User)-[:BORROWED]->(otherBooks)<-[rated:RATED]-(userA)

WHERE NOT (userA)-[:BORROWED]->(otherBooks) AND otherUser <> userA

WITH otherBooksBySameAuthor, otherBooksBySamePublisher, COLLECT(otherBooks) AS collectedBooks, rated.rating AS rating

ORDER BY rating DESC

WITH otherBooksBySameAuthor, otherBooksBySamePublisher, collectedBooks[..10] AS topRecommendations

  

// 创建may_like关系

UNWIND topRecommendations AS topBook

MATCH (userA:User {id: '1'}), (topBook)

MERGE (userA)-[:MAY_LIKE]->(topBook)

// 返回结果

RETURN otherBooksBySameAuthor AS RecommendationsFromSameAuthor, 

       otherBooksBySamePublisher AS RecommendationsFromSamePublisher, 

       topRecommendations AS TopRecommendationsFromOtherUsers
```

# 使用Jaccard 指数来推荐相似用户喜欢的高评分书籍
## 具体逻辑

1. **计算所有用户间的相似度**：使用 Jaccard 指数计算所有用户对之间的相似度。
2. **找出每个用户的最相似的五位用户**：对于每位用户，找到其他最相似的五位用户。
3. **为每位用户推荐这五位用户评分最高的书籍**：对于找到的每组用户，推荐其中用户评分最高的书籍。

## 源代码
```
// 计算所有用户间的相似度并找出最相似的五位用户

MATCH (userA:User {id: '1'})-[:BORROWED]->(b:Book)<-[:BORROWED]-(otherUser:User)

WHERE userA <> otherUser

WITH userA, otherUser, COUNT(DISTINCT b) AS sharedBooks

MATCH (userA)-[:BORROWED]->(b1:Book)

WITH userA, otherUser, sharedBooks, COUNT(DISTINCT b1) AS totalBooksUserA

MATCH (otherUser)-[:BORROWED]->(b2:Book)

WITH userA, otherUser, sharedBooks, totalBooksUserA, COUNT(DISTINCT b2) AS totalBooksOtherUser

WITH userA, otherUser, sharedBooks, totalBooksUserA + totalBooksOtherUser - sharedBooks AS unionBooks

WITH userA, otherUser, sharedBooks * 1.0 / unionBooks AS jaccardIndex

ORDER BY jaccardIndex DESC

WITH userA, COLLECT({otherUserId: otherUser.id, index: jaccardIndex})[0..5] AS topFiveSimilarUsers

  

// 对于每位用户，找出最相似用户的最高评分的书籍

UNWIND topFiveSimilarUsers AS similarUser

MATCH (similar:User {id: similarUser.otherUserId})-[:BORROWED]->(book:Book)<-[:RATED]-(ratingUser:User)

WITH userA, similar, book, MAX(ratingUser.rating) AS MaxRating

ORDER BY MaxRating DESC

WITH userA, COLLECT({book: book, maxRating: MaxRating})[0..5] AS TopRecommendations

  

// 创建may_read关系

UNWIND TopRecommendations AS rec

MATCH (book:Book {id: rec.book.id})

MERGE (userA)-[:MAY_READ]->(book)

  

// 返回结果

RETURN userA.id AS UserId, [r IN TopRecommendations | r.book.title] AS TopBookTitles
```

# 使用余弦相似度进行推荐
## 源代码
```
// 计算用户之间的余弦相似度

MATCH (u1:User1)-[x:buy]->(item:Item1)<-[y:buy]-(u2:User1)

WITH u1, u2, SUM(toFloat(x.type) * toFloat(y.type)) AS dotProduct,

     sqrt(sum(toFloat(x.type) ^ 2)) AS u1Length,

     sqrt(sum(toFloat(y.type) ^ 2)) AS u2Length

WITH u1, u2, dotProduct, u1Length, u2Length, dotProduct / (u1Length * u2Length) AS cosineSimilarity

WHERE cosineSimilarity > 0.8 // 设置阈值，只关注高度相似的用户

WITH u1, u2, cosineSimilarity

  

// 找到相似用户u2喜欢的，但用户u1还未交互的商品

MATCH (u2)-[:buy]->(rec:Item1)

WHERE NOT (u1)-[:buy]->(rec)

WITH u1, rec, cosineSimilarity

  

// 为u1与推荐结果创建 yexu_goumai 关系

MERGE (u1)-[r:yexu_goumai]->(rec)

ON CREATE SET r.created = timestamp(), r.score = cosineSimilarity

  

RETURN u1.id AS User, rec.id AS RecommendedItem, cosineSimilarity

ORDER BY cosineSimilarity DESC, rec.id

LIMIT 10;
```

# 显示某一特定节点
## 源代码
```
MATCH (u:User {id: '特定ID'})
RETURN u
```
## 同时显示特定关系
```
MATCH (u:User {id: '特定ID'})-[r:buy]->(i:Item)
RETURN u, r, i
```