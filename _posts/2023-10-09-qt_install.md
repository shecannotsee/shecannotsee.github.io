---
layout: post
categories: blog
---
### Get source code

```bash
# https://wiki.qt.io/Building_Qt_5_from_Git#Getting_the_source_code
$ git clone git://code.qt.io/qt/qt5.git
# checkout 5.15.2
$ git checkout 5.15.2
```

### build

#### 1.get sources code

```bash
# get submodule
$ git submodule update --init --recursive 
```

And wait to completed  ...

```bash
$ ls
qt5
# Why are there so many directories
$ mkdir qt5_build
$ mkdir qt5_install
$ ls
qt5  qt5_build
$ cd qt5_build/
```

**tips:Why are there so many directories**

```
1. source directory,源目录
2. build directory (your pwd),构建目录（您的 PWD）
3. install directory (assigned with -prefix),安装目录（分配有前缀）
must be 3 different directories.
必须是 3 个不同的目录。
from(https://forum.qt.io/topic/98501/static-compile-error-qt5-12-0-bootstrap-private/15)
```



#### 2.Install system software

make&&g++

```bash
$ apt install make
$ apt install g++
# ERROR: Python is required to build QtQml.
$ apt install python3
# ERROR: The OpenGL functionality tests failed!
$ apt install libgl1-mesa-dev
```



#### 3.Compilation and Installation

```bash
# https://wiki.qt.io/Building_Qt_5_from_Git#Getting_the_source_code
$ ../qt5/configure -developer-build -opensource -nomake examples -nomake tests -skip qtdocgallery -prefix /home/root/qt5_install/

$ make -j7
$ make install
```

**tips:**

**1.before configure**

```
在 ubuntu22.04 中从源码进行编译（在执行./configure之前）时，需要进行如下处理
[1]
diff -Naur a/qtbase/src/corelib/global/qfloat16.h b/qtbase/src/corelib/global/qfloat16.h
--- a/qtbase/src/corelib/global/qfloat16.h	2022-01-08 02:02:37.788088800 +0100
+++ b/qtbase/src/corelib/global/qfloat16.h	2022-01-08 02:01:53.887219900 +0100
@@ -43,6 +43,10 @@
 
 #include <QtCore/qglobal.h>
 #include <QtCore/qmetatype.h>
+
+#include <stdexcept>
+#include <limits>
+
 #include <string.h>
 
 #if defined(QT_COMPILER_SUPPORTS_F16C) && defined(__AVX2__) && !defined(__F16C__)
 [2]
diff -Naur a/qtbase/src/corelib/text/qbytearray.h b/qtbase/src/corelib/text/qbytearray.h
--- a/qtbase/src/corelib/text/qbytearray.h	2022-01-08 02:02:38.709130500 +0100
+++ b/qtbase/src/corelib/text/qbytearray.h	2022-01-08 02:01:52.929472700 +0100
@@ -52,6 +52,9 @@
 #include <string>
 #include <iterator>
 
+#include <stdexcept>
+#include <limits>
+
 #ifdef truncate
 #error qbytearray.h must be included before any header file that defines truncate
 #endif
 
否则会报错from( https://github.com/msys2/MINGW-packages/issues/10502)
```

**2.skip to build qtdocgallery**

There may be bugs in building **qtdocgallery**, so skip it temporarily.(from https://bugreports.qt.io/browse/QTBUG-82690)



### docker build

#### ubuntu20.04

```bash
$ sudo docker run \
	-it \
	--name ubuntu20.04_qt5.15LTS_env \
	--restart always \
	-v /home/shecannotsee/desktop/docker_storage/ubuntu20.04_qt5.15LTS/root:/home/root \
	ubuntu:20.04 \
	/bin/bash
```

#### ubuntu22.04

```bash
$ sudo docker run \
	-it \
	--name ubuntu22.04_qt5.15LTS_env \
	--restart always \
	-v /home/shecannotsee/desktop/docker_storage/ubuntu22.04_qt5.15LTS/root:/home/root \
	ubuntu:22.04 \
	/bin/bash
```

