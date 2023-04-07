M1
1.安装mysql

```bash
brew install mysql
```
2.通过驱动将mysql接口引入项目
根据mysql官方文档，需要下载驱动源代码或者是现成的二进制文件
我下载了二进制文件mysql-connector-c++-8.0.29-macos12-arm64
然后将其拷贝到/usr/local

```bash
cp  -rf ./mysql-connector-c++-8.0.29-macos12-arm64 /usr/local/
```
接下来编写main.cpp和CMakeLists.txt
CMakeLists.txt

```bash
cmake_minimum_required(VERSION 3.10)
#设置项目名称
project(mysql_test)

set(CMAKE_CXX_STANDARD 11)

set(MYSQL_INCLUDE "/usr/local/mysql-connector-c++-8.0.29-macos12-arm64/include")
set(MYSQL_LIB "/usr/local/mysql-connector-c++-8.0.29-macos12-arm64/lib64")

#添加头文件搜索路径
include_directories(/usr/local/mysql-connector-c++-8.0.29-macos12-arm64/include)
#添加库文件搜索路径
link_directories(/usr/local/mysql-connector-c++-8.0.29-macos12-arm64/lib64)

#用于将当前目录下的所有源文件的名字保存在变量 DIR_SRCS 中
aux_source_directory(. DIR_SRCS)
add_executable(mysql_test ${DIR_SRCS})

#链接时加入 -lmysqlcppconn8
target_link_libraries(mysql_test mysqlcppconn8)
```
main.cpp

```cpp
#include <iostream>
#include <mysqlx/xdevapi.h>

using ::std::cout;
using ::std::endl;
using namespace ::mysqlx;


int main(int argc, const char* argv[]) {
try {
  const char   *url = (argc > 1 ? argv[1] : "mysqlx://root@127.0.0.1");
  cout << "Creating session on " << url
       << " ..." << endl;
  Session sess(url);
  cout <<"Session accepted, creating collection..." <<endl;
  Schema sch= sess.getSchema("test");
  Collection coll= sch.createCollection("c1", true);
  cout <<"Inserting documents..." <<endl;
  coll.remove("true").execute();
  {
    DbDoc doc(R"({ "name": "foo", "age": 1 })");

    Result add =
      coll.add(doc)
          .add(R"({ "name": "bar", "age": 2, "toys": [ "car", "ball" ] })")
          .add(R"({ "name": "bar", "age": 2, "toys": [ "car", "ball" ] })")
          .add(R"({
                 "name": "baz",
                  "age": 3,
                 "date": { "day": 20, "month": "Apr" }
              })")
          .add(R"({ "_id": "myuuid-1", "name": "foo", "age": 7 })")
          .execute();

    std::list<string> ids = add.getGeneratedIds();
    for (string id : ids)
      cout <<"- added doc with id: " << id <<endl;
  }
  cout <<"Fetching documents..." <<endl;
  DocResult docs = coll.find("age > 1 and name like 'ba%'").execute();
  int i = 0;
  for (DbDoc doc : docs)
  {
    cout <<"doc#" <<i++ <<": " <<doc <<endl;
    for (Field fld : doc)
      cout << " field `" << fld << "`: " <<doc[fld] << endl;
    string name = doc["name"];
    cout << " name: " << name << endl;
    if (doc.hasField("date") && Value::DOCUMENT == doc.fieldType("date"))
    {
      cout << "- date field" << endl;
      DbDoc date = doc["date"];
      for (Field fld : date)
        cout << "  date `" << fld << "`: " << date[fld] << endl;
      string month = doc["date"]["month"];
      int day = date["day"];
      cout << "  month: " << month << endl;
      cout << "  day: " << day << endl;
    }
    if (doc.hasField("toys") && Value::ARRAY == doc.fieldType("toys"))
    {
      cout << "- toys:" << endl;
      for (auto toy : doc["toys"])
        cout << "  " << toy << endl;
    }
    cout << endl;
  }
  cout <<"Done!" <<endl;
}
catch (const mysqlx::Error &err) {
  cout <<"ERROR: " <<err <<endl;
  return 1;
}
catch (std::exception &ex) {
  cout <<"STD EXCEPTION: " <<ex.what() <<endl;
  return 1;
}
catch (const char *ex) {
  cout <<"EXCEPTION: " <<ex <<endl;
  return 1;
}
}//main

```
再加一个临时的Makefile

```bash
test:
	g++ -std=c++11 main.cpp -o test \
		-I/usr/local/mysql-connector-c++-8.0.29-macos12-arm64/include/ \
		-L/usr/local/mysql-connector-c++-8.0.29-macos12-arm64/lib64/ -lmysqlcppconn8
```
编译通过之后开始运行，会报关于openssl的错误

```bash
# 运行
➜  ./mysql_test
# 输出信息
dyld[32900]: Library not loaded: libssl.1.1.dylib
  Referenced from: /usr/local/lib/libmysqlcppconn8.2.dylib
  Reason: tried: 'libssl.1.1.dylib' (no such file), '/usr/local/lib/libssl.1.1.dylib' (no such file), '/usr/lib/libssl.1.1.dylib' (no such file), '/Users/shecannotsee/Desktop/AllCode/testcode/mysql_test/libssl.1.1.dylib' (no such file), '/usr/local/lib/libssl.1.1.dylib' (no such file), '/usr/lib/libssl.1.1.dylib' (no such file)
[1]    32900 abort      ./mysql_test
# 运行
➜  ./mysql_test
# 输出信息
dyld[34130]: Library not loaded: libcrypto.1.1.dylib
  Referenced from: /usr/local/lib/libmysqlcppconn8.2.dylib
  Reason: tried: 'libcrypto.1.1.dylib' (no such file), '/usr/local/lib/libcrypto.1.1.dylib' (no such file), '/usr/lib/libcrypto.1.1.dylib' (no such file), '/Users/shecannotsee/Desktop/AllCode/testcode/mysql_test/libcrypto.1.1.dylib' (no such file), '/usr/local/lib/libcrypto.1.1.dylib' (no such file), '/usr/lib/libcrypto.1.1.dylib' (no such file)
[1]    34130 abort      ./mysql_test
```

解决该问题
https://pavcreations.com/dyld-library-not-loaded-libssl-1-1-dylib-fix-on-macos/
由于下载的mysql-connector-c++-8.0.29-macos12-arm64文件中有相应的lib，需要只需要进行符号链接的处理

```bash
ln -s /usr/local/mysql-connector-c++-8.0.29-macos12-arm64/lib64/libssl.1.1.dylib /usr/local/lib
ln -s /usr/local/mysql-connector-c++-8.0.29-macos12-arm64/lib64/libcrypto.1.1.dylib /usr/local/lib
```
最后再次运行

```bash
# 运行
➜  ./mysql_test
# 输出
Creating session on mysqlx://root@127.0.0.1 ...
Session accepted, creating collection...
ERROR: CDK Error: Unknown database 'test'
```