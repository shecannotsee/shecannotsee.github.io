# sqlite3
下载sqlite-version-3.8.5的源代码
开始编译

```powershell
➜  3rd cd sqlite-version-3.8.5 
➜  sqlite-version-3.8.5 mkdir build
➜  sqlite-version-3.8.5 cd build 
➜  build pwd
#这里获取build路径
/home/shecannotsee/Desktop/AllCode/3rd/sqlite-version-3.8.5/build
➜  build cd ..
➜  sqlite-version-3.8.5 ./configure --prefix=/home/shecannotsee/Desktop/AllCode/3rd/sqlite-version-3.8.5/build
#这里设置构建路径
➜  sqlite-version-3.8.5 make#开始构建
#......
➜  sqlite-version-3.8.5 make install# 这一步将所需文件放入build中
➜  sqlite-version-3.8.5 tree build 
build
├── bin
│   └── sqlite3
├── include
│   ├── sqlite3ext.h
│   └── sqlite3.h
└── lib
    ├── libsqlite3.a
    ├── libsqlite3.la
    ├── libsqlite3.so -> libsqlite3.so.0.8.6
    ├── libsqlite3.so.0 -> libsqlite3.so.0.8.6
    ├── libsqlite3.so.0.8.6
    └── pkgconfig
        └── sqlite3.pc

4 directories, 9 files

```
然后编写cmakelist.txt

```powershell
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(PROJECT_NAME "sqlite3_test")
#
get_filename_component(test ${CMAKE_SOURCE_DIR} DIRECTORY)
get_filename_component(AllCode ${test} DIRECTORY)
message(STATUS "AllCode's path:${AllCode}")# /home/shecannotsee/Desktop/AllCode
set(libraries "${AllCode}/libraries")
#
set(sqlite3 "${libraries}/sqlite3")
#
set(CMAKE_CXX_FLAGS "-g")# 断点无效处理方案
project(${PROJECT_NAME})
# include
include_directories(
  ${sqlite3}/include)
# lib
link_directories(
  ${sqlite3}/lib
)

file(GLOB_RECURSE SRC "${CMAKE_SOURCE_DIR}/main.cpp")
add_executable(${PROJECT_NAME}
        ${SRC}
        )

# 链接库
target_link_libraries(${PROJECT_NAME} sqlite3 pthread dl)#注意链接顺序，有可能导致生成可执行程序失败

```
main.cpp->来源于sqlite3官方举例

```cpp
//
// Created by shecannotsee on 2022/9/28.
//
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <string>

#include <sqlite3.h>

static int callback(void *NotUsed, int argc, char **argv, char **azColName){
  int i;
  for(i=0; i<argc; i++){
    printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
  }
  printf("\n");
  return 0;
}

int main(int argc, char **argv){
  sqlite3 *db;
  char *zErrMsg = 0;
  int rc;

  if( argc!=3 ){
    fprintf(stderr, "Usage: %s DATABASE SQL-STATEMENT\n", argv[0]);
    return(1);
  }
  rc = sqlite3_open(argv[1], &db);
  if( rc ){
    fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return(1);
  }
  rc = sqlite3_exec(db, argv[2], callback, 0, &zErrMsg);
  if( rc!=SQLITE_OK ){
    fprintf(stderr, "SQL error: %s\n", zErrMsg);
    sqlite3_free(zErrMsg);
  }
  sqlite3_close(db);
  return 0;
}

```
程序编译链接成功了，但是并没有正确使用的错误警告
```powershell
Usage: /home/shecannotsee/Desktop/AllCode/test/sqlite3_test/cmake-build-debug/sqlite3_test DATABASE SQL-STATEMENT
```
ps：使用sudo apt-get install sqlite3 libsqlite3-dev安装sqlite3以及开发包之后，对应文件的路径为

```powershell
ubuntu20.04通过apt install的lib
lib文件在/usr/lib/x86_64-linux-gnu下
头文件在/usr/include下
可执行文件在bin里
```
缺点是版本可能需要手动选择，笔者使用apt install 最后安装的版本是3.31.0

# libevent
下载源代码

```powershell
➜  3rd cd libevent-release-2.1.12-stable 
➜  libevent-release-2.1.12-stable mkdir build
➜  libevent-release-2.1.12-stable cd build
➜  build cmake .. 
# ......
➜  build make
# ......
# 可见生成了include文件夹和lib文件夹
```
cmakelists.txt

```powershell
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(PROJECT_NAME "libevent_test")
###################################################
get_filename_component(test ${CMAKE_SOURCE_DIR} DIRECTORY)
get_filename_component(AllCode ${test} DIRECTORY)
message(STATUS "AllCode's path:${AllCode}")# /home/shecannotsee/Desktop/AllCode
set(libraries "${AllCode}/libraries")
###################################################
set(libevent "${libraries}/libevent-2.1.12")
###################################################
set(CMAKE_CXX_FLAGS "-g")# 断点无效处理方案
project(${PROJECT_NAME})
# include
include_directories(
        ${libevent}/include)
# lib
link_directories(
        ${libevent}/lib
)
###################################################
file(GLOB_RECURSE SRC "${CMAKE_SOURCE_DIR}/main.cpp")
add_executable(${PROJECT_NAME}
        ${SRC}
        )
###################################################
# 链接库
target_link_libraries(${PROJECT_NAME} event pthread)
```
main.cpp->只是为了测试编译链接过程而不是功能

```cpp
//
// Created by shecannotsee on 2022/9/28.
//
#include <event.h>

int main() {
  struct event_base* base = event_init();
  event_base_free(base);
  return 0;
};


```

一点小细节：在build中生成的include文件夹是不完整的，源代码中的include文件夹依赖生成的include中的文件，所以需要整合一下include文件夹，也就是将生成的include文件夹和源代码中的按照目录格式放一起即可