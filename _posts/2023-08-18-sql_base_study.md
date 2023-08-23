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
( product_id     CHAR(4)			NOT NULL,	# 商品编号
  product_name   VARCHAR(100)	NOT NULL,	# 商品名称
  product_type   VARCHAR(32)		NOT NULL,	# 商品种类
  sale_price     INTEGER			,			# 销售单价
  purchase_price INTEGER			,			# 进货单价
  regist_date    DATE			,			# 登记日期
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
(product_id, product_name, product_type, sale_price) VALUE
('0001',     'T恤衫',       '衣服',       500);
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
UPDATE <表名> 
SET    <列名1> = <表达式>,
       <列名2> = <表达式>,
       ...... ;

# 带条件的更新
UPDATE <表名> 
SET    <列名> = <表达式>
WHERE  <条件>;
```

举例如下：

```sql
# 基本：将表 Product 的所有数据的 regist_date 字段修改为 2009-10-10
UPDATE Product 
SET    regist_date = '2009-10-10';

# 带条件的更新：将商品种类为厨房用具的记录的销售单价更新为原来的10倍
UPDATE Product
SET    sale_price = sale_price * 10
WHERE  product_type = '厨房用具';
```



#### 查询

查询语法如下：

```sql
# 基本查询
SELECT <列名1>, ...... 
FROM   <表名>;
# 条件查询
SELECT <列名1>, ......
FROM   <表名>
WHERE  <条件表达式>;

```

举例如下：

```sql
# 从Product表中输出三列
SELECT product_id, product_name, purchase_price
FROM   Product;
# 输出Product表中全部的列
SELECT *
FROM   Product;
# 用来选取 product_type 列为 '衣服' 的记录的 SELECT 语句
SELECT product_name, product_type
FROM   Product
WHERE  product_type = '衣服';
```



**别名**举例如下：查询表 Product 中的三列数据并且使用别名

```sql
SELECT product_id     AS id,
       product_name   AS name,
       purchase_price AS price
FROM   Product;
# 若使用中文，则需要双引号
SELECT product_id     AS "序列",
       product_name	  AS "名称",
       purchase_price AS "价格"
FROM   Product;
```



查询结果**删除重复行**举例如下：

```sql
# 使用 DISTINCT 删除 product_type 列中重复的数据
SELECT DISTINCT product_type
FROM   Product;
```

注意：对于有 NULL 的数据也会被合并为一条 NULL 数据，并且 **DISTINCT 关键字只能用在第一个列名之前**



#### 对表进行分组

`GROUP BY`语法如下：

```sql
# 一般语法
SELECT   <列名1>, <列名2>, <列名3>, ......
FROM     <表名>
GROUP BY <列名1>, <列名2>, <列名3>, ...... ;
# 使用 WHERE 子句和 GROUP BY 子句进行汇总处理
SELECT <列名1>, <列名2>, <列名3>, ...... 
FROM   <表名>
WHERE
GROUP BY <列名1>, <列名2>, <列名3>, ...... ;
-- 像这样使用 WHERE 子句进行汇总处理时，会先根据 WHERE 子句指定的条件进行过滤，然后再进行汇总处理
```

举例如下：

```sql
# 按照商品种类统计数据行数
SELECT   product_type, COUNT(*)
FROM     Product
GROUP BY product_type;
-- 不使用 GROUP BY 子句时，是将表中的所有数据作为一组来对待的。而使用 GROUP BY 子句时，会将表中的数据分为多个组进行处理
```

请注意：
1.聚合键中包含 NULL 时，在结果中会以""不确定"行（空行）的形式表现出来。
2.在`GROUP BY`字句中不能使用`AS`别名（postgresql支持该用法）
3.`GROUP BY`的结果是随机顺序的
4.只有`SELECT`子句和`HAVING`子句（以及`ORDER BY`子句）中能够使用聚合函数。



#### 为聚合结果指定条件

`HAVING`语法如下：

```sql
SELECT   <列名1>, <列名2>, <列名3>, ......
FROM     <表名>
GROUP BY <列名1>, <列名2>, <列名3>, ...... 
HAVING   <分组结果对应的条件>;
```

举例如下：

```sql
# 从按照商品种类进行分组后的结果中，取出"包含的数据行数为2行"的组
SELECT   product_type, COUNT(*)
FROM     Product
GROUP BY product_type
HAVING   COUNT(*) = 2;
```

请注意：HAVING 子句要写在 GROUP BY 子句之后。

便捷理解：WHERE 子句 = 指定行所对应的条件，HAVING 子句 = 指定组所对应的条件



#### 对查询排序

可以使用`ORDER BY`字句来明确指定排列顺序（升序，对于表来说，从上往下，越来越大），`ORDER BY`语法如下：

```sql
# 升序
SELECT   <列名1>, <列名2>, <列名3>, ...... 
FROM     <表名>
ORDER BY <排序基准列1>, <排序基准列2>, ...... ASC;
-- 做升序排序时ASC关键字可省略
# 降序
SELECT   <列名1>, <列名2>, <列名3>, ...... 
FROM     <表名>
ORDER BY <排序基准列1>, <排序基准列2>, ...... DESC;
```

举例如下：

```sql
# 按照销售单价由低到高（升序）进行排列
SELECT   product_id, product_name, sale_price, purchase_price
FROM     Product
ORDER BY sale_price;
# 按照销售单价由高到低（降序）进行排列
SELECT   product_id, product_name, sale_price, purchase_price
FROM     Product
ORDER BY sale_price DESC;

# 按照销售单价和商品编号的升序进行排序
SELECT   product_id, product_name, sale_price, purchase_price
FROM     Product
ORDER BY sale_price, product_id;
-- 价格相同时按照商品编号的升序排列
```

请注意：
1.排序键中包含`NULL`时，会在开头或末尾进行汇总。
2.`ORDER BY`子句中可以使用列的别名，因为SELECT子句的执行顺序在`GROUP BY`子句之后，`ORDER BY`子句之前



## 四、sql中的类型与计算

### 1.算数运算符

使用 `+`，`-`，`*`，`/` 来处理加减乘除

举例如下：

```sql
# 把各个商品单价的 2 倍（ sale_price 的 2 倍）以 "sale_price_x2" 列的形式读取出来。
SELECT product_name, 
       sale_price,
       sale_price * 2 AS "sale_price_x2"
FROM   Product;
```



### 2.比较运算符

使用 `=`，`<>`，`>=`，`>`，`<`，`<=` 来处理等于等于，不等于，大于等于，大于，小于，小于等于

举例如下：

```sql
# 选取出销售单价大于等于1000的记录
SELECT product_name, product_type, sale_price
FROM   Product
WHERE  sale_price >= 1000;
# 选出销售单价(sale_price)比进货单价(purchase_price)高出500元以上的记录
SELECT product_name, sale_price, purchase_price
FROM   Product
WHERE  sale_price - purchase_price >= 500;
```



**不能对NULL使用比较运算符**，对于NULL可以使用`IS NULL`或者`IS NOT NULL`运算符

举例如下：

```sql
# 选取 NULL 的记录
SELECT product_name, purchase_price
FROM   Product
WHERE  purchase_price IS NULL;
# 选取不为 NULL 的记录
SELECT product_name, purchase_price
FROM   Product
WHERE  purchase_price IS NOT NULL;
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
SELECT    product_name, product_type, sale_price
FROM      Product
WHERE NOT sale_price >= 1000;
# 等价于
SELECT product_name, product_type
FROM   Product
WHERE  sale_price < 1000;
```



#### AND 和 OR

AND 运算符在其两侧的查询条件都成立时整个查询条件才成立，其意思相当于“并且”

true AND true => true，true AND false => false， false AND false => false

OR 运算符在其两侧的查询条件有一个成立时整个查询条件都成立，其意思相当于“或者”

true OR true => true，true OR false => true， false OR false => false

举例如下：

```sql
# 选取售价大于3000并且是厨房用具的记录
SELECT product_name, purchase_price
FROM   Product
WHERE  product_type = ' 厨房用具 '
AND    sale_price >= 3000;

# 选取售价大于3000或者是厨房用具的记录
SELECT product_name, purchase_price
FROM   Product
WHERE  product_type = ' 厨房用具 '
OR     sale_price >= 3000;
```

请注意，**AND 运算符优先于 OR 运算符**，但是为了sql的可读性，请多使用括号来处理复杂的逻辑关系，而不是记忆运算符的优先级，例如：

```sql
# 选取 商品种类为办公用品并且登记日期是 2009-09-11 或者 2009-09-20 的记录
SELECT product_name, product_type, regist_date
FROM   Product
WHERE  product_type = ' 办公用品 '
AND    regist_date = '2009-09-11'
OR     regist_date = '2009-09-20';
-- 由于AND的运算符优先于OR，所以上述条件会被解释成
-- (product_type=' 办公用品 ' AND regist_date = '2009-09-11')OR
-- (regist_date = '2009-09-20')
# 使用括号的写法如下
SELECT product_name, product_type, regist_date
FROM   Product
WHERE  product_type = ' 办公用品 '
AND    ( regist_date = '2009-09-11' OR 
         regist_date = '2009-09-20');
```



### 5.UNKNOWN

除了true以及false，sql中还有**不确定(UNKNOWN)**

unknown AND true => unknown，unknown AND false => false，unknown AND unknown => unknown

unknown OR true => TRUE，unknown OR false => unknown，unknown OR unknown => unknown



### 5.分支处理

`CASE`表达式语法如下：

```sql
CASE WHEN <求值表达式> THEN <表达式>
     WHEN <求值表达式> THEN <表达式>
     ......
     ELSE <表达式>
END
```

举例如下：

```sql
# 通过 CASE 表达式将 ABC 的字符串加入到商品种类当中
SELECT product_name,
    CASE WHEN product_type = ' 衣服 '
             THEN 'A ： ' | | product_type
         WHEN product_type = ' 办公用品 '
             THEN 'B ： ' | | product_type
         WHEN product_type = ' 厨房用具 '
             THEN 'C ： ' | | product_type
         ELSE NULL
         END AS abc_product_type
FROM Product;
-- 执行结果如下
-- product_name   | abc_product_type
-- ---------------+------------------
-- T恤衫           | A ： 衣服
-- 打孔器          | B ： 办公用品
-- 运动T恤         | A ：衣服
-- 菜刀            | C ：厨房用具
-- 高压锅          | C ：厨房用具
-- 叉子            | C ：厨房用具
-- 擦菜板          | C ：厨房用具
-- 圆珠笔          | B ：办公用品
```





## 五、函数使用

### 1.聚合函数

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
SELECT COUNT(*),	-- 计算结果包含NULL行
       COUNT(col_1)-- 计算结果不包含NULL行 
FROM   NullTbl;

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



### 2.字符串函数

#### 拼接字符串

使用`||`对字符串进行拼接，语法如下：

```sql
<字符串1> || <字符串2>
```

请注意：mysql以及sql server可能无法使用该函数

#### 字符串长度

使用`LENGTH`函数来查看字符串的长度，语法如下：

```sql
LENGTH(<字符串>)
```

请注意：sql server可能无法使用该函数

#### 小写转换

使用`LOWER`函数可以将参数中的字符串全都转换为小写，语法如下：

```sql
LOWER(<字符串>)
```

#### 大写转换

`UPPER`函数只能针对英文字母使用，它会将参数中的字符串全都转换为大写，语法如下：

```sql
UPPER(<字符串>)
```

#### 字符串替换

使用`REPLACE`函数可以将字符串的一部分替换为其他的字符串，语法如下：

```sql
REPLACE(<对象字符串>, <替换前的字符串>, <替换后的字符串> )
```

#### 字符串的截取

使用`SUBSTRING`函数可以截取出字符串中的一部分字符串，语法如下：

```sql
SUBSTRING(<对象字符串> FROM <截取的起始位置> FOR <截取的字符数>)
```

请注意：该函数可能无法在postgresql以及mysql之外的数据库使用



### 3.日期函数

略，自己找去

### 4.转换函数

略，自己找去



## 六、对查询结果的进一步操作

#### LIKE

当需要进行字符串的部分一致查询时需要使用`LIKE`，语法如下：

```sql
SELECT <列名1>, <列名2>, ......
FROM   <表名>
WHERE  <列名x> LIKE <模式匹配规则> ;
```

举例如下：

```sql
# 查询以ddd开头的所有字符串，例如dddabc
SELECT *
FROM   SampleLike
WHERE  strcol LIKE 'ddd%';
-- 其中的 % 是代表 "0字符以上的任意字符串" 的特殊符号
# 查询包含ddd的字符串，例如abcddd，dddabc，abdddc
SELECT *
FROM   SampleLike
WHERE  strcol LIKE '%ddd%';
# 查询以ddd结尾的字符串，例如abcddd
SELECT *
FROM   SampleLike
WHERE  strcol LIKE '%ddd';
# 使用 LIKE 和_（下划线）进行后方一致查询
SELECT *
FROM   SampleLike
WHERE  strcol LIKE 'abc_ _';
```



#### BETWEEN

使用`BETWEEN`可以进行范围查询，语法如下：

```sql
SELECT <列名1>, <列名2>, ......
FROM   <表名>
WHERE  <列名x> BETWEEN <范围下限> AND <范围上限> ;
```

举例如下：

```sql
# 选取销售单价为[100,1000]的商品(包含100和10000)
SELECT product_name, sale_price
FROM   Product
WHERE  sale_price BETWEEN 100 AND 1000;
```



#### IN

举例如下：

```sql
# 通过 IN 来指定多个进货单价进行查询
SELECT product_name, purchase_price
FROM   Product
WHERE  purchase_price IN (320, 500, 5000);
-- 选取进货价格为320，500，5000的商品信息

SELECT product_name, purchase_price
FROM   Product
WHERE  purchase_price NOT IN (320, 500, 5000);
-- 选取进货价格不为320，500，5000的商品信息
```



#### EXISTS

`EXISTS` 只关心记录是否存在，举例如下：

```sql
# 用 EXIST 选取出"000C店在售商品的销售单价"
SELECT product_name, sale_price
FROM   Product AS P
WHERE EXISTS (SELECT *
              FROM   ShopProduct AS SP
              WHERE  SP.shop_id = '000C'
              AND    SP.product_id = P.product_id);
# 使用 NOT EXIST 读取出"000C店在售之外的商品的销售单价"
SELECT product_name, sale_price
FROM   Product AS P
WHERE NOT EXISTS (SELECT *
                  FROM   ShopProduct AS SP
                  WHERE  SP.shop_id = '000C'
                  AND    SP.product_id = P.product_id);
```





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
SELECT   product_type, COUNT(*)
FROM     Product
GROUP BY product_type;
# 使用创建的视图，该视图可以看做一张临时表，对于表来说，可以使用 WHERE,GROUP BY,HAVING 等关键字
SELECT product_type, cnt_product
FROM   ProductSum;
# 以视图为基础创建视图
CREATE VIEW	ProductSumJim (product_type, cnt_product)
AS
SELECT product_type, cnt_product
FROM   ProductSum
WHERE  product_type = '办公用品';
# 使用多重视图
SELECT product_type, cnt_product
FROM   ProductSumJim;
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



## 八、子查询

子查询就是将用来定义视图的 SELECT 语句直接用于 FROM 子句当中，并且子查询作为内层查询会首先执行。

### 1.标量子查询

标量子查询就是返回单一值的子查询，**必须而且只能返回 1 行 1 列的结果**。所以标量子查询的返回值可以用在 = 或者 <> 这样需要单一值的比较运算符之中。请注意，使用标量子查询时**绝对不能返回多行结果**。

举例如下：

```sql
# 错误的语法，在 WHERE 子句中不能使用聚合函数
SELECT product_id, product_name, sale_price
FROM Product
WHERE sale_price > AVG(sale_price); # 错误
# 正确方式，使用标量子查询
SELECT product_id, product_name, sale_price
FROM Product
WHERE sale_price > (SELECT AVG(sale_price)
                    FROM Product);
```



### 2.关联子查询

在细分的组内进行比较时，需要使用关联子查询。

举例如下：

```sql
# 通过关联子查询按照商品种类对平均销售单价进行比较
SELECT product_type, product_name, sale_price
FROM Product AS P1
WHERE sale_price > (SELECT AVG(sale_price)
                    FROM Product AS P2
                    WHERE P1.product_type = P2.product_type
                    GROUP BY product_type);
```



## 九、表的集合操作

集合操作主要是以**行方向**为单位进行操作，其操作主要导致记录行数的增加和减少。

### 1.UNION（并集）



### 2.INTERSECT（交集）



### 3.EXCEPT（差集）





## 十、表的联结

联结操作主要是以列方向为单位进行操作，其操作主要导致列的增加和减少。

请注意：

1.进行联结时需要在FROM子句中使用多张表。

2.进行内联结时必须使用ON子句，并且要书写在FROM和WHERE之间。

3.使用联结时SELECT子句中的列需要按照"<表的别名>.<列名>"的格式进行书写。

### 1.INNER JOIN（内联结）

对于内联结来说，如果记录在多表内不是都存在的，就不会读取出来，也就是说内联结**只返回共同匹配的行**。

举例如下：

```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM   ShopProduct AS SP INNER JOIN 
       Product     AS P
ON     SP.product_id = P.product_id;
```



### 2.OUTER JOIN（外联结）

对于外联结来说，**只要数据存在于某一张表当中，就能够读取出来**。

举例如下：

```sql
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name,P.sale_price
FROM   ShopProduct AS SP RIGHT OUTER JOIN 
       Product     AS P 
ON     SP.product_id = P.product_id;
```

对于外联结来说，可以使用关键字`LEFT`和`RIGHT`来指定主表。

```sql
# 使用了 RIGHT，因此，右侧的表，也就是 Product 表是主表
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM   ShopProduct AS SP RIGHT OUTER JOIN 
       Product     AS P
ON     SP.product_id = P.product_id;

# 使用了 LEFT，因此，左侧的表，也就是 Product 表是主表
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price
FROM   Product     AS P LEFT OUTER JOIN 
       ShopProduct AS SP 
ON     SP.product_id = P.product_id;
```

多表联结举例如下：

```sql
# 3张表进行联结
SELECT SP.shop_id, SP.shop_name, SP.product_id, P.product_name, P.sale_price, IP.inventory_quantity
FROM       ShopProduct AS SP 
INNER JOIN Product     AS P
ON         SP.product_id = P.product_id
           INNER JOIN InventoryProduct AS IP
           ON SP.product_id = IP.product_id
WHERE IP.inventory_id = 'P001';
```























































