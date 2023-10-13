---
layout: post
categories: blog

---

### Introducing multiple libraries

she_ini_parse : https://github.com/shecannotsee/she_ini_parse

And clion build library in `she_ini_parse/cmake-build-debug/she_ini_parse`, like this:

```bash
$ pwd
/home/shecannotsee/desktop/all_code/she_base64/cmake-build-debug/she_base64
$ tree
.
├── bin
│   └── she_base64_test
├── cmake
│   └── she_base64-config.cmake
├── include
│   └── she_base64.h
└── lib
    ├── libshe_base64.a
    └── libshe_base64.so

4 directories, 5 files
$ # ......
```

she_base64 : https://github.com/shecannotsee/she_base64

And clion build library in `she_base64/cmake-build-debug/she_base64`, like this:

```bash
$ pwd
/home/shecannotsee/desktop/all_code/she_ini_parse/cmake-build-debug/she_ini_parse
$ tree
.
├── bin
│   ├── she_ini_parse_exec
│   └── she_ini_parse_test
├── cmake
│   └── she_ini_parse-config.cmake
├── include
│   ├── ini_parse.h
│   ├── ini_type.h
│   ├── lexer_DFA_model.h
│   ├── lexer.h
│   ├── parse.h
│   └── scan.h
└── lib
    ├── libshe_ini_parse.a
    └── libshe_ini_parse.so

4 directories, 11 files
$ # ......
```



### Introducing multiple libraries in a project

#### Project Structure

```bash
$ cd test_project/
$ tree
.
├── CMakeLists.txt
├── find_she_base64.cmake
├── find_she_ini_parse.cmake
├── main.cpp
└── parse_test.ini

0 directories, 5 files
$ # ......
```

#### file content

CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.11)

set(project_name "test_project")
project(${project_name})

set(target_list)

include(${CMAKE_SOURCE_DIR}/find_she_base64.cmake)
message(STATUS "----:-----")
include(${CMAKE_SOURCE_DIR}/find_she_ini_parse.cmake)


add_executable(${project_name} ${CMAKE_SOURCE_DIR}/main.cpp)

message(STATUS "####targets####${target_list}")

target_link_libraries(${project_name} "-pthread" ${target_list})
```

find_she_base64.cmake

```cmake
set(CMAKE_PREFIX_PATH "/home/shecannotsee/desktop/all_code/she_base64/cmake-build-debug/she_base64")
find_package(she_base64)
message(STATUS "----${she_base64}")
message(STATUS "----${she_base64_FOUND}")
message(STATUS "----${she_base64_INCLUDE_DIR}")
message(STATUS "----${she_base64_LIBRARIES}")
message(STATUS "----${she_base64_LINK_TARGET}")

if(she_base64_FOUND)
    include_directories(${she_base64_INCLUDE_DIR})
    link_directories(${she_base64_LIBRARIES})
    list(APPEND target_list ${she_base64_LINK_TARGET})
else()
    message(WARNING "can not found")
endif()
```

find_she_ini_parse.cmake

```cmake
set(CMAKE_PREFIX_PATH "/home/shecannotsee/desktop/all_code/she_ini_parse/cmake-build-debug/she_ini_parse")
find_package(she_ini_parse)
message(STATUS "----${she_ini_parse}")
message(STATUS "----${she_ini_parse_FOUND}")
message(STATUS "----${she_ini_parse_INCLUDE_DIR}")
message(STATUS "----${she_ini_parse_LIBRARIES}")
message(STATUS "----${she_ini_parse_LINK_TARGET}")

if(she_ini_parse_FOUND)
    include_directories(${she_ini_parse_INCLUDE_DIR})
    link_directories(${she_ini_parse_LIBRARIES})
    list(APPEND target_list ${she_ini_parse_LINK_TARGET})
else()
    message(WARNING "can not found")
endif()
```

main.cpp

```c++
#include <string>
#include <iostream>
#include <she_base64.h>
#include <ini_parse.h>

int main() {
  {
    std::string temp = "retrain";
    // data to base64
    std::cout<<she_base64::encode(temp)<<std::endl;
    // base to data
    std::cout<<she_base64::decode(she_base64::encode(temp))<<std::endl;
  }
  {
    she::ini_parse entity("../parse_test.ini");
    auto sections = entity.get_all_section();
    auto v = entity.get("s4", "k1");
    std::cout << "[s4]k1: " << v << std::endl;
    std::cout << "quit safely" << std::endl;
  }
  return 0;
};
```

parse_test.ini

```ini
[s4]
k1 = v1
```

#### build test

```bash
$ cd test_project/
$ mkdir build && cd build
$ cmake ..
-- The C compiler identification is GNU 9.4.0
-- The CXX compiler identification is GNU 9.4.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- ----she_base64
-- ----1
-- ----/home/shecannotsee/desktop/all_code/she_base64/cmake-build-debug/she_base64/include
-- ----/home/shecannotsee/desktop/all_code/she_base64/cmake-build-debug/she_base64/lib
-- ----she_base64
-- ----:-----
-- ----she_ini_parse
-- ----1
-- ----/home/shecannotsee/desktop/all_code/she_ini_parse/cmake-build-debug/she_ini_parse/include
-- ----/home/shecannotsee/desktop/all_code/she_ini_parse/cmake-build-debug/she_ini_parse/lib
-- ----she_ini_parse
-- ####targets####she_base64;she_ini_parse
-- Configuring done (0.5s)
-- Generating done (0.0s)
-- Build files have been written to: /home/shecannotsee/desktop/temp/test_project/build
$ make -j8
[ 50%] Building CXX object CMakeFiles/test_project.dir/main.cpp.o
[100%] Linking CXX executable test_project
[100%] Built target test_project
$ # Done
```



### Provide find_package() for the library

for example `she_base64`

she_base64-config.cmake

```cmake
# ${she_base64_FOUND}       : right get
# ${she_base64_INCLUDE_DIR} : include
# ${she_base64_LIBRARIES}   : lib
# ${she_base64_LINK_TARGET} : link target

set(she_base64 "she_base64")
set(${she_base64}_FOUND "1")
set(${she_base64}_INCLUDE_DIR   "${CMAKE_PREFIX_PATH}/include")
set(${she_base64}_LIBRARIES     "${CMAKE_PREFIX_PATH}/lib")
set(${she_base64}_LINK_TARGET   "she_base64")
```

CMakeLists.txt

```cmake
# ......
# install cmake
install(FILES
        ${CMAKE_SOURCE_DIR}/cmake/she_base64-config.cmake
        DESTINATION ${PROJECT_NAME}/cmake
        )
# ......
```

You can also take a look at the generated script I wrote for this code : https://github.com/shecannotsee/some_script

in file `some_script/src/cmake_module_generate/project_config_cmake_generate.py`

**use it**

```bash
$ python3 project_config_cmake_generate.py 
Additional project name：she_ini_parse

# ${she_ini_parse_FOUND}       : right get
# ${she_ini_parse_INCLUDE_DIR} : include
# ${she_ini_parse_LIBRARIES}   : lib
# ${she_ini_parse_LINK_TARGET} : link target

set(she_ini_parse "she_ini_parse")
set(${she_ini_parse}_FOUND "1")
set(${she_ini_parse}_INCLUDE_DIR   "${CMAKE_PREFIX_PATH}/include")
set(${she_ini_parse}_LIBRARIES     "${CMAKE_PREFIX_PATH}/lib")
set(${she_ini_parse}_LINK_TARGET   "she_ini_parse")

$ # ......
```

