行为测试 逻辑测试 契约测试 安全测试 性能测试

## 测试分类

#### 功能测试（Functional Testing）

正常功能（Normal function test），异常or边界测试（Exception and boundary test）

#### 性能测试（Performance Testing）

#### 安全测试（Security Testing）



## mock方面:

(1)**函数**的输入和输出的预期检查

(2)**类**成员变量在成员函数执行后的预期变化

(3)**操作文件**后，对文件的预期进行检查

(4)**网络通讯**测试，需要对收发端数据进行验证（可以模拟网络环境，延迟丢包拥塞等等）

(5)**数据库**交互前后数据库数据的预期以及检查

(6)并发和多线程测试



## 其他

逻辑测试就是mock测试

契约测试说白了就是测返回的结构体 结构