## mqtt库c接口，使用版本1.3.10

https://github.com/eclipse/paho.mqtt.c

```bash
git clone https://github.com/eclipse/paho.mqtt.c.git
cd paho.mqtt.c-1.3.10/
mkdir build
cd build
cmake ..
make
make install
```
请根据自己的需求改变目录中`./paho.mqtt.c-1.3.10/CMakeLists.txt`

```bash
## build options
# ssl功能需要openssl库支持
SET(PAHO_WITH_SSL TRUE CACHE BOOL "Flag that defines whether to build ssl-enabled binaries too. ")
# 默认开启
SET(PAHO_BUILD_SHARED TRUE CACHE BOOL "Build shared library")
# 如果要编译c++库需要编出静态库
SET(PAHO_BUILD_STATIC TRUE CACHE BOOL "Build static library")
SET(PAHO_BUILD_DOCUMENTATION FALSE CACHE BOOL "Create and install the HTML based API documentation (requires Doxygen)")
SET(PAHO_BUILD_SAMPLES TRUE CACHE BOOL "Build sample programs")
SET(PAHO_BUILD_DEB_PACKAGE FALSE CACHE BOOL "Build debian package")
SET(PAHO_ENABLE_TESTING TRUE CACHE BOOL "Build tests and run")
SET(PAHO_ENABLE_CPACK TRUE CACHE BOOL "Enable CPack")
SET(PAHO_HIGH_PERFORMANCE FALSE CACHE BOOL "Disable tracing and heap tracking")
SET(PAHO_USE_SELECT FALSE CACHE BOOL "Revert to select system call instead of poll")
```

## mqtt库c++接口，使用版本1.2.0

https://github.com/eclipse/paho.mqtt.cpp
请注意，如果想要使用该库，首先需要编译**版本号大于等于1.3.8**的paho.mqtt.c库并**生成对应的静态库**

```bash
git clone https://github.com/eclipse/paho.mqtt.cpp
cd paho.mqtt.cpp-1.2.0
mkdir build
cd build
# 用该指令指定c库的安装路径
cmake -DCMAKE_INSTALL_PREFIX=/home/shecannotsee/desktop/all_code/libraries/paho.mqtt.c-1.3.10 ..
make
make install
```
同样，请根据自己的需求修改`./paho.mqtt.cpp-1.2.0/CMakeLists.txt`

```bash
## --- Build options ---

if(WIN32)
  option(PAHO_BUILD_STATIC "Build static library" TRUE)
  option(PAHO_BUILD_SHARED "Build shared library (DLL)" TRUE)
  option(PAHO_WITH_SSL "Build SSL-enabled library" FALSE)
else()
  # 生成静态库
  option(PAHO_BUILD_STATIC "Build static library" TRUE)
  # 默认开启
  option(PAHO_BUILD_SHARED "Build shared library" TRUE)
  # 支持ssl
  option(PAHO_WITH_SSL "Build SSL-enabled library" TRUE)
  option(PAHO_BUILD_DEB_PACKAGE "Build debian package" FALSE)
endif()

option(PAHO_BUILD_SAMPLES "Build sample programs" FALSE)
option(PAHO_BUILD_TESTS "Build tests" FALSE)
option(PAHO_BUILD_DOCUMENTATION "Create and install the API documentation (requires Doxygen)" FALSE)
```

可以手动指定openssl库，也可以通过以下命令来安装libssl以支持生成支持ssl的库

```bash
sudo apt-get install libssl-dev
```