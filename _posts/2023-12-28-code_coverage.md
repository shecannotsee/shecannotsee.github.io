---
layout: post
categories: blog

---

# 使用 lcov 和 gcovr 为项目生成代码覆盖率



### 0.概览以及准备工作

#### (1)概览

主要流程就是在编译时添加相应指令，编译时产生相关文件。然后运行代码产生运行时文件。然后将产生的文件信息进行收集，最后对收集的信息进行可视化的展现（产生html文件以便查看）。

#### (2)准备工作

在ubuntu20.04上进行实践

安装相应的软件

```bash
sudo apt-get update
# 安装 lcov
sudo apt-get install lcov
# 安装 gcovr
sudo apt-get install gcovr
```



### 1.在CMakeList.txt添加相应的指令，构建生成 .gcno 文件

```cmake
SET(CMAKE_CXX_FLAGS "-g -O0 -fprofile-arcs -ftest-coverage")
SET(CMAKE_C_FLAGS "-g -O0 -fprofile-arcs -ftest-coverage")
```

or

```cmake
SET(CMAKE_CXX_FLAGS "-fprofile-arcs -ftest-coverage")
SET(CMAKE_C_FLAGS "-fprofile-arcs -ftest-coverage")
```

该指令会**在编译时为每个文件生成** `.gcno` **文件**

例如对于项目[she_base64](https://github.com/shecannotsee/she_base64)来说

```bash
$ cd she_base64
$ mkdir build
$ cd build
$ cmake ..
$ make -j8
```

在进行构建后，会出现以下文件

build/CMakeFiles/she_base64_test.dir/src/she_base64.cpp.gcno



### 2.运行程序生成 .gcda 文件

将**编译的程序进行运行**后，会为每个文件生成相应的 `.gcda` 文件

例如在`1.在CMakeList.txt添加相应的指令`后，运行构建的测试程序，会生成以下文件

build/CMakeFiles/she_base64_test.dir/src/she_base64.cpp.gcda



### 3.收集代码覆盖率信息

在通过`1.在CMakeList.txt添加相应的指令，构建生成 .gcno 文件`以及`2.运行程序 .gcda 文件`以后，通过 lcov来收集相关的代码覆盖率信息，并且产生响应的 .info 文件

```bash
lcov --directory . \
     --capture \
     --output-file ./coverage/coverage.info
```

`--directory`用于在指定目录下搜集 .gcno 以及 .gcda 文件，该命令会递归遍历指定目录下的所有文件

`--capture`用于执行代码覆盖率测试，并将测试结果保存到 .info 文件中

`--output-file`用于指定 .info 文件的目录



#### 忽略相关目录代码信息

在指定 .info 文件中忽略相关代码

```bash
lcov --remove ./coverage/coverage.info '/usr/*' '*/googletest/*' \
     --output-file ./coverage/coverage.info
```



#### 交叉编译平台问题

对于交叉编译问题，例如在 x86 平台上交叉编译 arm 的程序，在 x86 上编译结束，并且在 arm 上运行结束。相应的文件已经生成，在 x86 下使用 lcov 的时候，需要通过`--gcov-tool`指定交叉编译链中携带的 gcov 工具，否则无法正确生成相应的 .info 文件（猜测可能是不同平台下生成的文件格式不同）。

```bash
lcov --directory . \
     --capture \
     --output-file ./coverage/coverage.info \
     --gcov-tool /cross_compilation_toolchain/arm-oe-linux-gcov
```





### 4.生成可视化代码覆盖率 html 文件

通过以下命令对 .info 文件进行处理，在相应目录下产生 html 文件

```bash
genhtml ./coverage/coverage.info -o ./coverage/coverage_report
```

现在可以在`./coverage/coverage_report`目录下找到 index.html 文件了，打开就可以看到代码覆盖率的相关信息了。