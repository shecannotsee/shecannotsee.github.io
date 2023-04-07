---
layout: post
categories: blog lib
---
# glog
根据官方文档安装即可
*https://github.com/google/glog*

```bash
% git clone https://github.com/google/glog.git
% cd glog
% cmake -S . -B build -G "Unix Makefiles" //这句含义未知
% cmake --build build
```
安装完后可以去/usr/local目录下查看是否有对应的头文件和lib文件
若没有可以尝试make install命令

```bash
% make install
```

源文件如下
demo.cpp

```cpp
#include <glog/logging.h>
 
#pragma comment(lib, "glog.lib")
 
using namespace std;
 
int main(int argc, char* argv[])
{
    string logpath = "./";
     //init   
    google::InitGoogleLogging(argv[0]);
    string info_log = logpath + "info_";
    google::SetLogDestination(google::INFO, info_log.c_str());
    string warning_log = logpath + "warning_";
    google::SetLogDestination(google::WARNING, warning_log.c_str());
 
    LOG(INFO) << "Hello Glog";
    LOG(WARNING) << "Hello Glog";
    getchar();
    return 0;
}
```

makefile

```cpp
test:
	g++ demo.cpp -o main \
		-I/usr/local/include/glog \
		-L/usr/local/lib \
		-lglog
```

# fltk
官方网站*https://www.fltk.org/*
1.3.7版本安装
然后cd进入fltk-1.3.7

```bash
% pwd
..../fltk-1.3.7
% mkdir build
% cd build
% cmake ..../fltk-1.3.7
【一些输出】
% make
【一些输出】
% make install
```
到此为止安装结束
源文件
base.hpp

```cpp
#ifndef _BASE_HPP_
#define _BASE_HPP_

#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Box.H>

#endif//!_BASE_HPP_
```
demo.cpp

```cpp
#include "base.hpp"
using namespace std;
 
int main(int argc, char **argv) {
  Fl_Window *window = new Fl_Window(340,180);
  Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
  box->box(FL_UP_BOX);
  box->labelfont(FL_BOLD+FL_ITALIC);
  box->labelsize(36);
  box->labeltype(FL_SHADOW_LABEL);
  window->end();
  window->show(argc, argv);
  return Fl::run();
}
```
makefile

```cpp
#1.from document
test:
    fltk-config —compile demo.cpp

#2.from document
CXX = $(shell fltk-config --cxx)
DEBUG = -g
CXXFLAGS = $(shell fltk-config --use-gl --use-images --cxxflags ) -I.
LDFLAGS = $(shell fltk-config --use-gl --use-images --ldflags )
LDSTATIC = $(shell fltk-config --use-gl --use-images --ldstaticflags )
LINK = $(CXX)
TARGET = cube
OBJS = demo.o
SRCS = demo.cpp
.SUFFIXES: .o .cpp
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(DEBUG) -c $<
all: $(TARGET)
	$(LINK) -o $(TARGET) $(OBJS) $(LDSTATIC)
$(TARGET): $(OBJS)
demo.o: demo.cpp
clean: $(TARGET) $(OBJS)
	rm -f *.o 2> /dev/null
	rm -f $(TARGET) 2> /dev/null
```
makefile里有两种选择，任选一种即可，均来自于fltk的官方文档

插两张windows下使用fltk的图片
![安装](https://img-blog.csdnimg.cn/fa0dc36983114ca7848517b6c3477219.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAYSBsaXR0bGUgYmVjYXVzZQ==,size_19,color_FFFFFF,t_70,g_se,x_16
补上windows下编译通过的makefile，最后一行命令我找了很久才找到，但是我对其表示的含义目前尚不明确

```cpp
test:
	g++ base.hpp demo.cpp \
		-o test \
		-I F:\CommonlyUsed\AllCode\fltk-1.3.5 \
		-I F:\CommonlyUsed\AllCode\fltk-1.3.5\build \
		-L F:\CommonlyUsed\AllCode\fltk-1.3.5\build\lib \
		-lfltk -lcomctl32 -lwsock32 -lole32 -luuid -mwindows
```

**2022-7-26更新**
mac下用cmake编译的一个问题，简述就是在链接的时候不仅要加fltk，而且要"-framework Cocoa"
先放cmake文件

```bash
####################################################################
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
####################################################################
set(PROJECT_NAME "fltk_test")
set(LOCAL_INCLUDE "/usr/local/include")
set(LOCAL_LIB "/usr/local/lib")
set(BREW "/opt/homebrew/Cellar/")
# protobuf
set(PROTOBUF_INCLUDE "${BREW}/protobuf/3.17.3/include/google")
set(PROTOBUF_LIB "${BREW}/protobuf/3.17.3/lib")
####################################################################
project(${PROJECT_NAME})
####################################################################
# include
include_directories(${LOCAL_INCLUDE})
# lib
link_directories(${LOCAL_LIB})
####################################################################
# aux_source_directory(. SOURCE)
file(GLOB_RECURSE SRC "${CMAKE_SOURCE_DIR}/src/*")
add_executable(${PROJECT_NAME} ${SRC})

####################################################################
# 链接库
target_link_libraries(${PROJECT_NAME} pthread fltk  "-framework Cocoa" )
#可以成功编译的构建指令
#g++ -o cube main.o
#   /usr/local/lib/libfltk_images.a
#   /usr/local/lib/libfltk_png.a -lz
#   /usr/local/lib/libfltk_jpeg.a
#   /usr/local/lib/libfltk_gl.a -framework OpenGL
#   /usr/local/lib/libfltk.a -lpthread -framework Cocoa
```
重点是在target_link_libraries里面需要加入"-framework Cocoa"