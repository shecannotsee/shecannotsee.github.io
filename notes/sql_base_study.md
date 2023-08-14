## 一、sql的种类

### 1.DDL（Data Definition Language）

主要是处理**数据库**和**表**

CREATE ： 创建**数据库**和**表**等对象
DROP ： 删除**数据库**和**表**等对象
ALTER ： 修改**数据库**和**表**等对象的结构



### 2.DML（Data Manipulation Language）  

主要处理**表内的数据**

SELECT ：查询**表**中的数据
INSERT ：向**表**中插入新数据
UPDATE ：更新**表**中的数据
DELETE ：删除**表**中的数据



### 3.DCL（Data Control Language） 

主要用来做**事务**，权限控制

COMMIT ： 确认对数据库中的数据进行的变更
ROLLBACK ： 取消对数据库中的数据进行的变更
GRANT ： 赋予用户操作权限
REVOKE ： 取消用户的操作权限



## 二、一些简单的语法规则

- sql语句以`;`结尾
- **关键字**不区分大小写
- 字符串和日期常数需要使用单引号（'）括起来，数字常数无需加注单引号（直接书写数字即可）
- 单词需要用**半角空格**或者**换行**来分隔
- 数据库名称、表名和列名等可以使用以下三种字符：1.半角英文字母；2.半角数字；3.下划线（_）
- 名称必须以半角英文字母作为开头



## 三、sql详细用法

### 1.DDL

#### 创建数据库

语法如下

```sql
CREATE DATABASE <数据库名称> ;
```

举例如下：下列例子创建了一个名为shop的数据库实例

```sql
CREATE DATABASE shop;
```



#### 创建表

语法如下

```sql
CREATE TABLE <表名>
(	<列名1>  <数据类型>  <该列的约束>,
    <列名2>  <数据类型>  <该列的约束>,
    <列名3>  <数据类型>  <该列的约束>,
	......  ,
<该表的约束1>, <该表的约束2>, ...... );
```

举例如下：

```sql
CREATE TABLE Product
(	product_id		CHAR(4)			NOT NULL,	# 商品编号
	product_name	VARCHAR(100)	NOT NULL,	# 商品名称
 	product_type	VARCHAR(32)		NOT NULL,	# 商品种类
 	sale_price		INTEGER			,			# 销售单价
 	purchase_price	INTEGER			,			# 进货单价
 	regist_date		DATE			,			# 登记日期
PRIMARY KEY(product_id) );
```



#### 删除表

语法如下：

```sql
DROP TABLE <表名称>;
```

举例如下：假设先前创建了表Product

```sql
DROP TABLE Product;
```



#### 更新表

语法如下：

```sql

```

举例如下：

```sql

```

