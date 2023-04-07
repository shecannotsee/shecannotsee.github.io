## 一、版本选择

由于最开始从github上clone的项目并不能编译成功所以考虑其他稳定版（有可能是因为之前项目的缓存导致的！）
考虑postgre的两个稳定版11和14，因为11足够稳定，但是14能够处理json。具体版本考虑到11.13 和14.1（这两版本均为稳定版） ，最后选择了14.1
下载地址为：https://www.postgresql.org/ftp/source/

## 二、编译与安装
参考文档
https://www.postgresql.org/docs/current/install-procedure.html

```bash
cd postgresql-14.1/
mkdir build
cd build
../configure
make
# 将包安装到指定目录
make install DESTDIR=/home/shecannotsee/desktop/all_code/libraries/postgresql-14.1
```
tips:若在configure过程中出现部分包找不到的情况，则需要手动去安装，readline和zlib缺少参考如下

```bash
# 安装readline
sudo apt install libreadline-dev
# 安装zlib包
sudo apt-get install zlib1g-dev
# bison
sudo apt-get install bison
# flex
sudo apt-get install flex
```

如果您只是想使用postgresql，那么本文看到这里就可以了。

## 三、使用clion调试
使用clion的过程中，**务必千万不要将源代码文件夹加载成Makefile项目**，我们使用项目自带的Makefile配置只是为了生成中间文件和可执行文件，后续我们将使用cmakelists.txt（如下）来构建该项目

```bash
cmake_minimum_required(VERSION 3.6)
project(postgres)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
add_custom_target(postgres COMMAND make -C ${postgres_SOURCE_DIR})
```

抛开上述的安装问题，继续从源码出发
```bash
cd postgresql-14.1/
# 将生成的bin-include-lib均放置在本目录下
./configure --prefix=/home/shecannotsee/desktop/all_code/postgresql-14.1 --enable-depend --enable-cassert --enable-debug CFLAGS="-ggdb -O0"
make
make install
```
tips：更多开发者选项可参考https://wiki.postgresql.org/wiki/Developer_FAQ
至此，源码目录已经成为一个具有源码，debug的中间文件（可见目录下很多的.o文件以及其他中间文件）和最后生成的可执行文件和包

**初始化数据库**
```bash
cd postgresql-14.1/
# 创建数据存储文件夹
mkdir data
cd bin
# 初始化数据库
./initdb -D /home/shecannotsee/desktop/all_code/postgresql-14.1/data
```

接下来用clion打开cmake项目。并配置可执行文件选项
在**加载cmake项目**后，需要去配置运行时参数，如图所示，需要将-D后的路径指定为刚刚生成的data文件夹，然后将可执行文件指定为刚刚在make时生成的postgres文件（可执行文件）


接下来启动程序即可进行调试，大功告成



**千万不要让clion将项目识别成Makefile项目**，clion可恶的缓存让我在配置调试配置的时候一直无法切换到cmake项目，非常恶心

## 四、使用
服务启动与停止脚本

```bash
/home/shecannotsee/desktop/all_code/libraries/postgresql-14.1/bin/pg_ctl \
	# start 启动，stop停止
	start \
	# 日志写入文件
	-l /home/shecannotsee/desktop/all_code/libraries/postgresql-14.1/log/log.log \
	# 存储位置
	-D /home/shecannotsee/desktop/all_code/libraries/postgresql-14.1/data

```
数据库初始化问题
参考https://stackoverflow.com/questions/32629604/postgres-does-not-know-where-to-find-server-configuration
进入安装的bin目录

```bash
./createdb <dbname>
./psql <dbname>
```
即可正常使用，也可以用dbeaver连接使用

