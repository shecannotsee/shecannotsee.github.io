---
layout: post
categories: blog
---
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
- 单行注释使用`--`，多行注释使用`/**/`



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

**添加列**语法如下：

```sql
ALTER TABLE <表名> ADD COLUMN <列的定义>;
# oracle和sql server中不用写COLUMN，并且oracle中可以使用小括号同事添加多列
ALTER TABLE <表名> ADD (<列1>,<列2>, ...... );
```

举例如下：为表 Product 中添加列 product_name_english，该列存储100位可变长字符串

```sql
ALTER TABLE Product ADD COLUMN product_name_english VARCHAR(100);
```



**删除列**语法如下

```sql
ALTER TABLE <表名> DROP COLUMN <列名>;
```

举例如下：删除表 Product 中的列 product_name_english 

```sql
ALTER TABLE Product DROP COLUMN product_name_english;
```



**重命名**表名语法如下

```sql
# postgregsql,oracle
ALTER TABLE <旧表名> RENAME TO <新表名>;
# mysql
RENAME TABLE <旧表名> TO <新表名>;
```

举例如下：重命名表 P 名为 Product

```sql
ALTER TABLE P RENAME TO Product;
```



### 2.DML

#### 向表中插入数据

插入数据语法如下：

```sql
INSERT INTO <表名> (<列1>,<列2>,<列3>, ...... )
VALUE (<值1>,<值2>,<值3>, ...... );
```

举例如下：向表 Product 中插入数据 

```sql
INSERT INTO Product 
(product_id,	product_name,	product_type, sale_price) VALUE
('0001',		'T恤衫',		   '衣服',	   500);
```



#### 删除表中数据

删除语法如下：

```sql
# 保留数据表，仅删除全部数据行
DELETE FROM <表名>;
# 删除指定条件的数据行
DELETE FROM <表名> WHERE <条件>;
# 只能删除表中全部数据(pgsql,mysql,oracle)
TRUNCATE <表名>;
```

举例如下：

```sql
# 删除Product表内的所有数据
DELETE FROM Product;
# 删除Product表内所有销售单价(sale_price)大于等于4000的数据
DELETE FROM Product WHERE sale_price >= 4000;
```



#### 更新表中数据

更新语法如下：

```sql
# 基本语法
UPDATE 	<表名> 
SET		<列名1> = <表达式>,
		<列名2> = <表达式>,
		...... ;

# 带条件的更新
UPDATE 	<表名> 
SET		<列名> = <表达式>
WHERE 	<条件>;
```

举例如下：

```sql
# 基本：将表 Product 的所有数据的 regist_date 字段修改为 2009-10-10
UPDATE Product 
SET regist_date = '2009-10-10';

# 带条件的更新：将商品种类为厨房用具的记录的销售单价更新为原来的10倍
UPDATE Product
SET sale_price = sale_price * 10
WHERE product_type = '厨房用具';
```



#### 查询

查询语法如下：

```sql
# 基本查询
SELECT <列名1>, ...... 
FROM <表名>;
# 条件查询
SELECT <列名1>, ......
FROM <表名>
WHERE <条件表达式>;

```

举例如下：

```sql
# 从Product表中输出三列
SELECT	product_id, product_name, purchase_price
FROM 	Product;
# 输出Product表中全部的列
SELECT	*
FROM	Product;
# 用来选取 product_type 列为 '衣服' 的记录的 SELECT 语句
SELECT	product_name, product_type
FROM 	Product
WHERE 	product_type = '衣服';

```



**别名**举例如下：查询表 Product 中的三列数据并且使用别名

```sql
SELECT	product_id		AS id,
		product_name	AS name,
		purchase_price	AS price
FROM	Product;
# 若使用中文，则需要双引号
SELECT	product_id		AS "序列",
		product_name	AS "名称",
		purchase_price	AS "价格"
FROM	Product;
```



查询结果**删除重复行**举例如下：

```sql
# 使用 DISTINCT 删除 product_type 列中重复的数据
SELECT 	DISTINCT product_type
FROM 	Product;
```

注意：对于有 NULL 的数据也会被合并为一条 NULL 数据，并且 **DISTINCT 关键字只能用在第一个列名之前**



## 四、sql中的类型与计算

### 1.算数运算符

使用 `+`，`-`，`*`，`/` 来处理加减乘除

举例如下：

```sql
# 把各个商品单价的 2 倍（ sale_price 的 2 倍）以 "sale_price_x2" 列的形式读取出来。
SELECT	product_name, 
		sale_price,
		sale_price * 2 AS "sale_price_x2"
FROM Product;
```



### 2.比较运算符

使用 `=`，`<>`，`>=`，`>`，`<`，`<=` 来处理等于等于，不等于，大于等于，大于，小于，小于等于

举例如下：

```sql
# 选取出销售单价大于等于1000的记录
SELECT	product_name, product_type, sale_price
FROM	Product
WHERE	sale_price >= 1000;
# 选出销售单价(sale_price)比进货单价(purchase_price)高出500元以上的记录
SELECT	product_name, sale_price, purchase_price
FROM	Product
WHERE	sale_price - purchase_price >= 500;
```



**不能对NULL使用比较运算符**，对于NULL可以使用`IS NULL`或者`IS NOT NULL`运算符

举例如下：

```sql
# 选取 NULL 的记录
SELECT	product_name, purchase_price
FROM	Product
WHERE	purchase_price IS NULL;
# 选取不为 NULL 的记录
SELECT	product_name, purchase_price
FROM	Product
WHERE	purchase_price IS NOT NULL;
```



### 3.NULL

**所有包含 NULL 的计算，结果肯定是 NULL**



### 4.逻辑运算符

#### NOT

使用`NOT`来处理一些等价关系

NOT true => false，NOT false => true

举例如下：

```sql
# 选取出销售单价大于等于1000的记录
SELECT		product_name, product_type, sale_price
FROM		Product
WHERE NOT 	sale_price >= 1000;
# 等价于
SELECT	product_name, product_type
FROM	Product
WHERE	sale_price < 1000;
```



#### AND 和 OR

AND 运算符在其两侧的查询条件都成立时整个查询条件才成立，其意思相当于“并且”

true AND true => true，true AND false => false， false AND false => false

OR 运算符在其两侧的查询条件有一个成立时整个查询条件都成立，其意思相当于“或者”

true OR true => true，true OR false => true， false OR false => false

举例如下：

```sql
# 选取售价大于3000并且是厨房用具的记录
SELECT	product_name, purchase_price
FROM	Product
WHERE	product_type = ' 厨房用具 '
AND		sale_price >= 3000;

# 选取售价大于3000或者是厨房用具的记录
SELECT	product_name, purchase_price
FROM	Product
WHERE	product_type = ' 厨房用具 '
OR		sale_price >= 3000;
```

请注意，**AND 运算符优先于 OR 运算符**，但是为了sql的可读性，请多使用括号来处理复杂的逻辑关系，而不是记忆运算符的优先级，例如：

```sql
# 选取 商品种类为办公用品并且登记日期是 2009-09-11 或者 2009-09-20 的记录
SELECT	product_name, product_type, regist_date
FROM	Product
WHERE	product_type = ' 办公用品 '
AND		regist_date = '2009-09-11'
OR		regist_date = '2009-09-20';
-- 由于AND的运算符优先于OR，所以上述条件会被解释成
-- (product_type=' 办公用品 ' AND regist_date = '2009-09-11')OR
-- (regist_date = '2009-09-20')
# 使用括号的写法如下
SELECT	product_name, product_type, regist_date
FROM	Product
WHERE	product_type = ' 办公用品 '
AND		(	regist_date = '2009-09-11' OR 
    		regist_date = '2009-09-20');
```



### 5.UNKNOWN

除了true以及false，sql中还有**不确定(UNKNOWN)**

unknown AND true => unknown，unknown AND false => false，unknown AND unknown => unknown

unknown OR true => TRUE，unknown OR false => unknown，unknown OR unknown => unknown





## 五、函数使用

对于函数来说，**输入的是数据库表**，**输出的是值**；使用函数 `COUNT`，`SUM`，`AVG`，`MAX`，`MIN` 来处理以下事情

COUNT： 计算表中的记录数（行数）
SUM： 计算表中数值列中数据的合计值
AVG： 计算表中数值列中数据的平均值
MAX： 求出表中任意列中数据的最大值
MIN： 求出表中任意列中数据的最小值

#### COUNT统计

```sql
# 计算全部数据的行数，包括NULL行
SELECT COUNT(*) FROM Product;
-- 这里传给COUNT的参数是*，COUNT的输出就是sql语句的结果值

# 计算全部数据的行数
SELECT 	COUNT(*),	-- 计算结果包含NULL行
		COUNT(col_1)-- 计算结果不包含NULL行 
FROM 	NullTbl;

# 先计算数据行数再删除重复数据的结果
SELECT DISTINCT COUNT(product_type)
FROM Product;
```

#### SUM求和

SUM会将 NULL 排除在外。但 COUNT (*) 例外，并不会排除 NULL 。

```sql
# 计算销售单价和进货单价的合计值
SELECT SUM(sale_price), SUM(purchase_price)
FROM Product;
```

#### AVG平均值

AVG在计算前也会将NULL排除在外。

```sql
# 计算销售单价的平均值
SELECT AVG(sale_price)
FROM Product;
```

#### MAX和MIN

```sql
# 计算销售单价的最大值和进货单价的最小值
SELECT MAX(sale_price), MIN(purchase_price)
FROM Product;
```



## 六、对查询结果的进一步操作





## 七、视图（缓存，临时变量？）

### 1.创建与使用

创建视图语法如下：

```sql
CREATE VIEW <视图名称>(<视图列名1>,<视图列名2> ...... )
AS
<SELECT语句>
```

举例如下：

```sql
# 创建视图
CREATE VIEW ProductSum (product_type, cnt_product)
AS
SELECT		product_type, COUNT(*)
FROM 		Product
GROUP BY 	product_type;
# 使用创建的视图，该视图可以看做一张临时表，对于表来说，可以使用 WHERE,GROUP BY,HAVING 等关键字
SELECT	product_type, cnt_product
FROM 	ProductSum;
# 以视图为基础创建视图
CREATE VIEW	ProductSumJim (product_type, cnt_product)
AS
SELECT	product_type, cnt_product
FROM	ProductSum
WHERE	product_type = '办公用品';
# 使用多重视图
SELECT	product_type, cnt_product
FROM	ProductSumJim;
```

- 请注意，对于多数DBMS来说，**多重视图会降低sql的性能**
- 创建视图时不能使用 ORDER BY 子句（非通用语法，但是Postgresql可以）
- 对视图进行更新有更复杂的限制：1.SELECT 子句中未使用 DISTINCT；2.FROM 子句中只有一张表；3.未使用 GROUP BY 子句；4.未使用 HAVING 子句
- 视图和表需要同时进行更新，因此通过汇总得到的视图无法进行更新。也就是说，**视图的更新是通过表更新而来**的，请注意严格的逻辑关系。



### 2.删除视图

删除视图语法如下：

```sql
DROP VIEW <视图名称>(<视图列名1>,<视图列名2>,…… );
```

举例如下：

```sql
DROP VIEW ProductSum;
```

- 在 PostgreSQL 中，如果删除以视图为基础创建出来的多重视图，由于存在关联的视图，因此会发生错误



















