****
内容参考`/docs/AbutionGraph-2.8.0-安装文档.docx`中`AbutionGraph-完整版安装`的内容
`abution_graph_db_install_package.tar.xz`请从release中下载
****
# AbutionGraph下载
modelscope下载地址:[AbutionGraph时序知识图谱数据库](https://modelscope.cn/models/AbutionGraph/abution_graph_db_install_package/summary)
SKD下载方式：
```
#模型下载  
from modelscope import snapshot_download  
model_dir = snapshot_download('AbutionGraph/abution_graph_db_install_package',cache_dir='/home/modelscope') #修改了默认下载地址
```
Git下载方式：
```
git clone https://www.modelscope.cn/AbutionGraph/abution_graph_db_install_package.git
```
GitHub地址:[AbutionGraph](https://github.com/ThutmoseAI/AbutionGraph)

AbutionGraph-2.8 集成软件参考版本信息：
# 软硬件要求
## 软件
清空缓存命令：echo 1 > /proc/sys/vm/drop_caches
基础组件:【】内标注是解压后的组件相对路径

Jdk-1.8.0_211 (Abution-jshell使用自带jdk11)【/abution_graph_db_install_package/jdk1.8.0_211 】

Hadoop-3.3.5/Hadoop-2.7.7【/abution_graph_db_install_package/hadoop-3.3.5】

Zookeeper-3.4.13（默认包含在Abution安装包中）【./abution_graph_db_install_package/abution-graph-db-2.8.1/zk】

大数据生态组件（推荐版本）:

Python-3.8.5

Scala-2.12.8

Spark-3.3.2 （AI算法计算引擎；AbutionGCS-图计算定制版；Mlep可融合Python）

MySQL-8.0

Flink-1.12.1（实时计算引擎）

Hive-3.1.3（数据仓库API，推荐配置运行在Spark上）

RocketMQ-4.5.3

Kafka-2.2.1

Jcache

**安装目录结构（JDK、Hadoop、AbutionDB），为了少改动系统环境变量，建议都装在/thutmose/app/（**mkdir -p /thutmose/app**）下**
![安装目录结构](https://raw.githubusercontent.com/HOTSaber/AbutionGraph/tar.xz/images/%E5%AE%89%E8%A3%85%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84.png)
## 硬件版本
最好是使用CentOS7或者Ubuntu18以上系统，不满足的话请升级系统内核gcc版本至8以上版本。由于我们实际上同时在整个群集中运行两个或三个系统：HDFS，AbutionDB和MapReduce，因此硬件通常由4至8个内核和8至32 GB RAM组成。这样一来，每个正在运行的进程至少可以具有一个内核，每个内核可以具有2-4 GB，提高吞吐和速度只需配置进程使用更多的资源。

一个运行HDFS的内核通常可以使2到4个磁盘繁忙，因此每台计算机通常可能只有2 x 300GB磁盘，最多有4 x 1TB或2TB磁盘。

AbutionDB的最低配置：如使用2H4GB的1u服务器，建议每台计算机最多运行两个进程-即DataNode和AbutionServer或DataNode和MR Worker，不建议同时启动3个服务。这个约束是为机器上的所有进程提供足够的可用堆空间。

**服务器设置**

1. 关闭防火墙；

2. （已安装则跳过）安装SSH无密通信：sudo apt-get install openssh-server，并执行：ssh-keygen -t rsa，一路回车即可，然后复制.ssh/id_rsa.pub内容到.ssh/authorized_keys中，最后启动服务：service ssh start；

3. （可选）在群集内运行NTP协议同步时间，时间不一致可能会导致节点间的数据同步延缓；

4. 如果是阿里等云服务器，请把端口号9090、50070、9990-9999 加入到安全组，否则web无法连通。

# 环境配置
## **规范化软件目录**
1. 执行命令新建安装目录：`
   ```
	mkdir -p /thutmose/app/abution_graph_db_install_package/
	```

2. 上传所有安装文件到：abution_graph_db_install_package/下

3. 依次解压所有安装文件到文件夹abution_graph_db_install_package/下：tar -xvf xxx.tar.xz
```
# 进入abution_graph_db_install_package/
tar -xvf xxx.tar.xz -C abution_graph_db_install_package/
```

4. 对所有软件目录创建软连接到/thutmose/app/（如上图目录结构）：

cd /thutmose/app/

ln -s ./abution_graph_db_install_package/jdk1.8.0_211 ./jdk

ln -s ./abution_graph_db_install_package/scala-2.12.8 ./scala【无，需自安】

ln -s ./abution_graph_db_install_package/hadoop-3.3.5 ./hadoop

ln -s ./abution_graph_db_install_package/abution-graph-db-2.8.1 ./abution

ln -s ./abution_graph_db_install_package/hive-3.1.3 ./hive【无，需自安】

ln -s ./abution_graph_db_install_package/spark-3.3.2 ./spark【无，需自安】
## 配置系统环境变量
如为root用户，追加以下内容到~/.profile
```
## Hadoop-3.x

export HADOOP_HOME=/thutmose/app/hadoop

export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

export CLASSPATH=".:$JAVA_HOME/lib:$CLASSPATH"

export HADOOP_COMMON_HOME=$HADOOP_HOME

export HADOOP_HDFS_HOME=$HADOOP_HOME

export HADOOP_MAPRED_HOME=$HADOOP_HOME

export HADOOP_YARN_HOME=$HADOOP_HOME

export HADOOP_INSTALL=$HADOOP_HOME

export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native

export HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec

export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$JAVA_LIBRARY_PATH

export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

## 遇到权限问题解开注释

export HDFS_DATANODE_USER=root

export HDFS_DATANODE_SECURE_USER=root

export HDFS_SECONDARYNAMENODE_USER=root

export HDFS_NAMENODE_USER=root

export HADOOP_SHELL_EXECNAME=root

export YARN_RESOURCEMANAGER_USER=root

export YARN_NODEMANAGER_USER=root

## AbutionDB

export ABUTION_HOME=/thutmose/app/abution

export ABUTION_CONF_DIR=$ABUTION_HOME/conf

export PATH=$ABUTION_HOME/bin:$PATH

## Zppkeeper

export ZOOKEEPER_HOME=$ABUTION_HOME/zk

export PATH=${ZOOKEEPER_HOME}/bin:$PATH

## java8

export JAVA_HOME=/thutmose/app/jdk

export JRE_HOME=${JAVA_HOME}/jre

export CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar

export PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin:$PATH

## scala-2.12.8【无可忽略】

export SCALA_HOME=/thutmose/app/scala

export PATH=${SCALA_HOME}/bin:$PATH

export TERM=xterm-color

## Hive【无可忽略】

export HIVE_HOME=/thutmose/app/hive

export PATH=${HIVE_HOME}/bin:$PATH

## spark【无可忽略】

export SPARK_HOME=/thutmose/app/spark

export PATH=${SPARK_HOME}/bin:$PATH

#export PYSPARK_PYTHONPATH=${SPARK_HOME}/bin:${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip:$PATH
```
# 安装AbutionGraph
注：我们假定HDFS已经正常运行（单机版可不用，伪分布式可启用），具体在abution.properties中配置，。

1. 进入目录：cd /thutmose/app/abution/conf

2. 更改以下5个文件中localhost为主机名（可选,单机建议无需改动）

	：gc、masters、monitor、slaves、tracers；高可用和多计算节点可依据服务器数量配置为多行的不同主机名。

3. 更改数据库配置文件abution.properties

	1）instance.volumes：更改localhost为主机名（可选,单机建议无需改动）
	
	2）配置数据库为本地单机模式（如下）或分布式模式（改为使用hdfs目录，推荐单机模式也使用hdfs持久化数据）

## 设置数据持久化HDFS默认路径
```

#instance.volumes=hdfs://localhost:9000/abution

instance.volumes=file:///thutmose/app/abution/data
#这里因为data内已经有了数据，在此路径初始化会报错，故改为test1文件夹
```

3）tserver.memory.maps.native.enabled：

	建议设置true，可以解决JavaGC暂停的难题，提高AbutionDB性能，同时修改lib/libabution.so文件为对应服务器版本。
	
	其中关联参数tserver.memory.maps.max和table.compaction.minor.logs.threshold用于调节吞吐量。

4. 启动Zookeeper：
```
cd /thutmose/app/abution/zk/bin
#在环境配置成功的情况下是不用cd进zk/bin的，但如何配置失败，zkServer.sh是在zk/bin下的，可以手动启动
bash zkServer.sh start

```

5. 初始化Abution：
```
Source /etc/profile

abution init --instance-name [AbutionGraph可修改] --user root --password [abutiongraph]
```


6. 启动Abution：abution-local-start.sh
```
#这里在看app/abution/bin/下没有abution-db-start.sh,只有abution-local-start.sh故
abution-local-start.sh
#使用abution-loccal-start.sh启动，与abution-cluster start功能相同
```

jps查看是否启动成功，正常启动会有>5个Main服务，否则检查abution/logs排除异常。如以下：
```
ZooKeeper JMX enabled by default
Using config: /thutmose/app/abution/zk/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
ps : monitor already running (1937318)
Starting tablet servers .... done
ps : tserver already running (1937406)
ps : master already running (1937681)
ps : gc already running (1937756)
ps : tracer already running (1937809)
```
zookeeper启动，monitor、tserver、master、gc、tracer均已启动成功

**AbutionDB监控页面：ip:9995**

**AbutionGraph-UI页面：ip:9995/graph**

Abution起停命令：
```
abution-cluster stop
abution-cluster start #与abution-local-start.sh功能相同
abution-cluster restart
```

停止zk：`zkServer.sh stop` （启动Abution前必须先启动zk）
## 配置Hadoop
注：Hadoop的配置可自行决定，与开源版本一致。
1. 进入目录：cd /thutmose/app/hadoop/etc/hadoop/
2. 配置JAVA_HOME（默认已配好）：vim hadoop-env.sh
3. 更改localhost为主机名（可选,单机建议无需改动）
	**vim core-site.xml**
	```
	    <property>
	        <name>fs.defaultFS</name>
	        <value>hdfs://localhost:9000</value>
	    </property>
	```
	**vim hdfs-site.xml**
	```
	<property>
	        <name>dfs.http.address</name>
	        <value>localhost:50070</value>
	    </property>
	```
	**vim workers**
	```
	localhost
	```
	**vim yarn-site.xml****（可选****-****需要****YARN****时配置）**
	```
	<property>
	        <name>yarn.resourcemanager.address</name>
	        <value>localhost:8032</value>
	    </property>
	    <property>
	        <name>yarn.resourcemanager.scheduler.address</name>
	        <value>localhost:8030</value>
	    </property>
	    <property>
	        <name>yarn.resourcemanager.resource-tracker.address</name>
	        <value>localhost:8031</value>
	    </property>
	``` 
4. 格式化HDFS：
	```
	cd /thutmose/app/hadoop/bin
	bash hdfs namenode -format -clusterid AbutionGraph
	```
5. 启动hdfs：
	```
	cd /thutmose/app/hadoop/sbin
	#注意这里要将本机的pubkey加进authorized_keys中，实现ssh免密访问namenode，也就是自己
	start-dfs.sh   
	```
6. 查看hdfs服务是否启动成功：jps
	正常启动会有3个服务（NameNode、DataNode、SecondaryNameNode），否则检查log排除异常
	hdfs监控页面：ip:50070
## **MySQL-8**的安装

1. 下载MySQL
```
sudo apt install mysql-server
```
在shell中使用`mysql -V`或在MySQL中使用`SELECT VERSION();`查看版本。
2. 配置MySQL
以下是在Ubuntu中执行你提供的命令的步骤：

1. **打开终端**：你可以通过应用程序菜单搜索“终端”来打开它，或者使用快捷键`Ctrl + Alt + T`。
    
2. **登录MySQL**：  
    首先，你需要登录到MySQL服务器。如果你已经设置了root用户的密码，你可以使用以下命令登录：
    

```bash
mysql -u root -p
```

系统会提示你输入root用户的密码。输入正确的密码后，你将登录到MySQL提示符。

3. **执行命令**：  
    在MySQL提示符下，你可以直接执行SQL命令。对于你提供的命令，你应该这样做：

```sql
use mysql;
select user,host from mysql.user;
update user set authentication_string='' where user='root';
--将字段置为空，注意修改用户名'raini'为自己的
ALTER user 'root'@'localhost' IDENTIFIED BY 'abution-hive';
flush PRIVILEGES;
--修改 `root` 用户在 `localhost` 上的密码。`FLUSH PRIVILEGES` 语句用于立即重新加载授权表，这样您不需要重启MySQL服务器就能使密码更改生效。
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
--`GRANT` 命令会授予 `root` 用户在所有数据库和所有表上的所有权限，并且带有 `WITH GRANT OPTION`，这意味着 `root` 用户可以将这些权限授予其他用户。
flush PRIVILEGES;
```
4. **退出MySQL**：  
    完成所有操作后，你可以使用以下命令退出MySQL提示符：
```sql
EXIT;
```
此外：
```sql
#要检查 `root` 用户使用的认证方法，你可以登录MySQL后执行以下SQL查询：
SELECT user, host, plugin FROM mysql.user WHERE user = 'root';
#如如认证方式plugin为`auth_socket` 插件，那么作为系统的 `root` 用户，你可以无需密码直接登录MySQL的 `root` 账户。
#如果你希望更改为传统的密码认证方式，可以执行类似下面的命令：
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的新密码';
FLUSH PRIVILEGES;
这将把 `root` 用户的认证方式更改为 `mysql_native_password`，并设置一个新的密码。记得替换 `'你的新密码'` 为你自己的密码。之后，你将需要使用这个新密码进行登录。
```
## Spark-3.3.2安装

1. 在shell中使用`hadoop version`查看hadoop版本
2. 访问[spark官网](https://spark.apache.org/downloads.html)的`Archived releases`下载Spark-3.3.2-without-hadoop。
3. 使用以下命令解压:
```
tar -zxvf spark-3.3.2-bin-without-hadoop.tgz -C /thutmose/app/
```
4. 改名:
```
cd /thutmose/app
#如果在之前配置了spark软链接，还要删除原软链接，或修改软链接。
rm -rf spark
#这里我们先删除软链接，然后直接修改文件名
mv ./spark-1.6.2-bin-without-hadoop/ ./spark
```
5. 环境已经在**环境配置**中配置过了，所以不用再次配置了
6. 配置conf/spark-env.sh（[官方文档](https://spark.apache.org/docs/latest/hadoop-provided.html)）
	在Spark的conf目录中，复制spark-env.sh.template为spark-env.sh，并根据需要配置JAVA_HOME，内存分配等。以下为示例：
```
# 设置Master为local（单机模式）
export SPARK_MASTER_HOST=localhost
export SPARK_MASTER_PORT=7077
 
# 设置工作目录
export SPARK_WORKING_DIR=/thutmose/spark-work
 
# 分配给Executor的内存，默认1G
export SPARK_EXECUTOR_MEMORY=1g
 
# 设置cores per executor，默认为1
export SPARK_EXECUTOR_CORES=1
 
# 设置local模式下的线程池大小，默认为1
export SPARK_DRIVER_MEMORY=1g

#如果选择下载不带Hadoop的版本，需要在${SPARK_HOME}/conf/spark-env.sh中export环境变量SPARK_DIST_CLASSPATH，否则会在启动时遇到A JNI error has occurred, please check your installation and try again；而下载带Hadoop的Spark就不需要。
### in conf/spark-env.sh ###
#【下面内容三选一】
# If 'hadoop' binary is on your PATH
### 如果 'hadoop' 命令在你的 PATH 环境变量中
export SPARK_DIST_CLASSPATH=$(hadoop classpath)

# With explicit path to 'hadoop' binary
###如果 `hadoop` 命令不在你的 PATH 中，或者你想使用系统上某个特定版本的 Hadoop
export SPARK_DIST_CLASSPATH=$(/path/to/hadoop/bin/hadoop classpath)

# Passing a Hadoop configuration directory
###如果你需要 Spark 使用特定的 Hadoop 配置文件（这在使用多个 Hadoop 集群或特定的 Hadoop 配置时很常见），可以通过 `--config` 参数指定 Hadoop 配置目录：
export SPARK_DIST_CLASSPATH=$(hadoop --config /path/to/configs classpath)

```
配置完成后，您可以通过运行以下命令在本地启动Spark shell来测试配置是否正确：
```
/thutmose/app/spark/bin/spark-shell --master local[*]
#运行成功会进入spark shell-scala,可以使用quit或ctrl+D来退出
```
这里`--master local[*]`指定了Spark运行在本地模式，`[*]`表示使用所有可用的CPU核心。如果一切正常，你将看到Spark shell启动并且可以开始编写Spark程序了。
## Hive-3.1.3安装
****
参考[Hive3.1.3版本安装部署](https://blog.csdn.net/weixin_43153588/article/details/134986163)
****
1. 访问[Apache Hive](https://hive.apache.org/general/downloads/)官网进入[下载页面](https://dlcdn.apache.org/hive/)，下载Hive-3.1.3
2. 使用以下命令解压:
```
tar -zxvf apache-hive-3.1.3-bin.tar.gz -C /thutmose/app/
```
3. 修改软链接：
```
cd /thutmose/app
#如果在之前配置了spark软链接，还要删除原软链接，或修改软链接。
#这里我们修改原有软链接，使用-f参数强行覆盖
ln -sf ./apache-hive-3.1.3-bin ./hive
```
4. 环境已经在**环境配置**中配置过了，所以不用再次配置了。
5. 配置./conf/hive-env.sh，**需要将原tamplate文件复制后改名**
```
HADOOP_HOME=/thutmose/app/hadoop
export HIVE_CONF_DIR=/thutmose/app//hive/conf
```
6. 配置日志
	只需将conf目录中的hive-log4j2.properties.template复制一份修改名称为 hive-log4j2.properties 即可，并执行以下命令，避免输出日志时报冲突错误：
```
mv /thutmose/app/hive/lib/log4j-slf4j-impl-2.17.1.jar /thutmose/app/hive/lib/log4j-slf4j-impl-2.17.1.bak
```
1. 使用管理员账户运行`vim $HIVE_HOME/conf/hive-site.xml`新建并配置hive_site.xml
	增加mysql的【连接地址】和【用户名】【密码】，然后把mysql的驱动下载到 HIVE_HOME/lib目录下
```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<!--JDBC元数据仓库连接字符串-->
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>【jdbc:mysql://localhost:3306/metastore_db?createDatabaseIfNotExist=true&amp;useSSL=false】</value>
    <description>JDBC connect string for a JDBC metastore</description>
  </property>
  <!--JDBC元数据仓库驱动类名-->
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.cj.jdbc.Driver</value>
    <description>Driver class name for a JDBC metastore</description>
  </property>
  <!--元数据仓库用户名-->
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>【用户名】</value>
    <description>Username to use against metastore database</description>
  </property>
   <!--元数据仓库密码-->
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>【密码】</value>
    <description>password to use against metastore database</description>
  </property>
</configuration>

```
8. 访问[MySQL的官方网站](https://dev.mysql.com/downloads/connector/j/),找到适合你的Java版本和MySQL版本的`mysql-connector-java`驱动。,下载并复制MySQL依赖mysql-connector-java-8.0.33.jar到hive/lib/下
```
#下载，选用8.0.33的ubuntu22.04版本
wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-j_8.0.33-1ubuntu22.04_all.deb
#安装
dpkg -i mysql-connector-j_8.0.33-1ubuntu22.04_all.deb
#安装完成后，你可以检查MySQL Connector/J是否已成功安装
dpkg -l | grep mysql-connector-j
#安装后，MySQL Connector/J的JAR文件通常会被放置在`/usr/share/java/`目录下。你可以在你的Java项目中引用这个JAR文件来连接MySQL数据库。
#监制驱动到./hive/lib/下
cd /usr/share/java
cp mysql-connector-java-8.0.33.jar /thutmose/app/hive/lib/
```
9. 初始化元数据库
```
cd /thutmose/app/hive/bin
bash schematool -dbType mysql -initSchema --verbose
#初始化需要一定时间
#输出"initialization script completed"字样，则表示初始化成功
```
注：如果想要急速的查询响应，可配置Hive执行引擎为Spark。
在 Hive 配置文件 `hive-site.xml` 中添加以下配置项：
```
<property>
    <name>hive.execution.engine</name>
    <value>spark</value>
</property>

<property>
    <name>spark.master</name>
    <value>spark://<Master-IP>:<Master-Port></value>
</property>

<property>
    <name>spark.yarn.jar</name>
    <value>hdfs://<path_to_spark_assembly_jar></value>
</property>

```
请替换 `<Master-IP>` 和 `<Master-Port>` 为您的 Spark 集群的主节点 IP 地址和端口号（如果您使用的是 standalone 模式）。如果您是在 YARN 上运行 Spark，`spark.master` 的值应该设置为 `yarn`。

对于 `spark.yarn.jar`，您需要将 Spark 的 assembly JAR 上传到 HDFS，并提供其路径。这个 JAR 包含了 Spark 所需的所有依赖，通常可以在 Spark 安装目录的 `assembly/target/scala-<version>/` 下找到。

一些sql设置：
```sql
set hive.exec.dynamici.partition=true; #开启动态分区，默认是false
set hive.exec.dynamic.partition.mode=nonstrict; #开启允许所有分区都是动态的，否则须要有静态分区才能使用。
set hive.exec.dynamic.partition=true;(可通过这个语句查看：set hive.exec.dynamic.partition;)
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions=100000;(如果自动分区数大于这个参数，将会报错)
set hive.exec.max.dynamic.partitions.pernode=100000;
```
# AbutionGraph命令
停止AbutionGraph集群：
1. abution-rest-stop.sh（若几秒后还存在Bootstrap进程，请kill掉）
2. abution-db-stop.sh
3. zkServer.sh stop（可选）
启动AbutionGraph集群：
1. zkServer.sh start （已启动请忽略）
2. abution-local-start.sh
3. abution-rest-start.sh
Abution起停命令：
```
abution-cluster stop
abution-cluster start #与abution-local-start.sh功能相同
abution-cluster restart
```
HDFS启动/停止：start-dfs.sh / stop-dfs.sh
添加AbutionDB节点（在某个节点服务器中执行）：start-here.sh （需$ABUTION_HOME/conf/slaves中已具有该节点）
停止AbutionDB节点（在某个节点服务器中执行）：stop-here.sh 

清空缓存命令：echo 1 > /proc/sys/vm/drop_caches

# Hive on Abution storage
Hive是行式存储，检索效率底，但API很完善，拥有极大量的用户。Abution是列式存储，检索效率高，key-value的储存形式对于开发人员来说比较灵活，也意味着存储结构需要更深入的设计。而Hive-Abution-Storage则是将Abution用作Hive的数据存储，使用Hive的API来操作Abution，达到列式存储拥有表格存储的使用效果，并且达到列存的高效查询检索性能。


此外在自己的虚拟环境下使用`pip install pymysql`，实现python调用mysql

```
import pymysql
 
# 建立连接
conn = pymysql.connect(host='localhost', user='user', password='passwd', db='mydb', charset='utf8')
 
# 创建游标对象
cursor = conn.cursor()
 
# 执行SQL语句
cursor.execute("select version()")
 
# 获取查询结果
data = cursor.fetchone()
print(data)
 
# 关闭连接
cursor.close()
conn.close()
```
或`pip install mysql-connector-python`
```
import mysql.connector
 
# 建立连接
conn = mysql.connector.connect(user='user', password='passwd', host='localhost', database='mydb')
 
# 创建游标对象
cursor = conn.cursor()
 
# 执行SQL语句
cursor.execute("select version()")
 
# 获取查询结果
data = cursor.fetchone()
print(data)
 
# 关闭连接
cursor.close()
conn.close()
```
测试使用：

1. 启动Hive命令：
（用户名和密码查看abution/conf/abution.propties）
hive -hiveconf abution.instance.name=AbutionGraph -hiveconf abution.zookeepers=localhost -hiveconf abution.user.name=root -hiveconf abution.user.pass=abutiongraph

2. 建表：

CREATE TABLE abution_table(rowid STRING, name STRING, age INT, weight DOUBLE, height INT)
    STORED BY 'org.apache.hadoop.hive.abution.AbutionStorageHandler'
WITH SERDEPROPERTIES('abution.columns.mapping' = ':rowid, person:name, person:age, person:weight, person:height');

3.插入数据：

insert into table abution_table values('ADB', 'AbutionGrapn', 5, 1.0, 1);

4.查询数据：

select * from abution_table;

更多命令请见[Hive使用手册](https://www.docs4dev.com/docs/zh/apache-hive/3.1.1/reference/LanguageManual_Commands.html)