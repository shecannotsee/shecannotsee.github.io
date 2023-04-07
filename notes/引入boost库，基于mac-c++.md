通过 https://www.boost.org/ 下载boost(1.79)

通过下载的源代码，找到./boost_1_79_0/index.html，通过浏览器打开

找到对应安装步骤

```bash
# 在目录./boost_1_79_0下
# 我这里需要安装在该文件夹下
./bootstrap.sh --prefix=/usr/local/
.b2 install
```
安装结束后发现/usr/local/include/下并无boost头文件
所以需要手动将头文件进行移动

```bash
cp -rf ./boost/ /usr/local/include
```
然后开始进行测试
main.cpp

```cpp
#include <iostream>
#include <boost/version.hpp>

using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    cout << "Boost版本:" << BOOST_VERSION << endl;
    return 0;
}
```
CMakeLists.txt

```bash
cmake_minimum_required(VERSION 3.10)

#设置项目名称
project(boost_test)

set(CMAKE_CXX_STANDARD 11)

set(BOOST_ROOT "/usr/local/include/boost")

#添加头文件搜索路径
include_directories(/usr/local/include)
#添加库文件搜索路径
link_directories(/usr/local/lib)

#用于将当前目录下的所有源文件的名字保存在变量 DIR_SRCS 中
aux_source_directory(. DIR_SRCS)
add_executable(boost_test ${DIR_SRCS})

#在这里根据名字boost_thread去寻找libboost_thread.a文件
target_link_libraries(boost_test boost_thread boost_system)
```
最后通过脚本运行

```bash
BUILD=./build
if [ ! -d "$BUILD" ]; then
    mkdir build
fi

cd build
cmake -G Ninja ..
ninja boost_test

./boost_test
```
出现结果
Hello, World!
Boost版本:107900


cmake参考
http://t.zoukankan.com/kolane-p-12071055.html