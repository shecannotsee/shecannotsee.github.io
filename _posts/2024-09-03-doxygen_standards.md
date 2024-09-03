---
layout: post
categories: blog
---



# Doxygen standards

## 安装

ubuntu22.04使用`sudo apt-get install doxygen`进行安装

## 使用

### 1.生成配置文件

通过`doxygen -g`创建默认配置文件, 下面是一些比较有用的字段

```ini
# 编码格式, 所有格式在https://www.gnu.org/software/libiconv/可以查看
DOXYFILE_ENCODING = UTF-8
# 项目名称
PROJECT_NAME = "My Project"
# 用于指定生成的文档将写入的（相对或绝对）路径
OUTPUT_DIRECTORY =
# OUTPUT_LANGUAGE 标记用于指定 doxygen 生成的所有文档所用的语言: English, Chinese, ......
OUTPUT_LANGUAGE = Chinese

# 输入文件相关配置
# 指定包含以下内容的文件和/或目录记录的源文件
INPUT = 
# 输入文件的编码格式
INPUT_ENCODING = UTF-8
# 是否递归搜索子目录
RECURSIVE = YES
# 从INPUT中排除的目录
EXCLUDE =
# 文件类型
FILE_PATTERNS = *.c \
                *.cc \
                *.cxx \
                *.cpp

# 更多字段可以参考生成默认配置文件中的注释
```



### 2.通过配置文件生成文档

通过命令`doxygen ./Doxyfile`产生文档



## 示例

### 1.目录结构:

```bash
$ tree
.
├── code_docs_test
    ├── docs
    │   └── doxygen
    ├── Doxyfile
    └── src
        ├── main.cpp
        ├── math_functions.cpp
        └── math_functions.h

5 directories, 15 files
$ 
```

### 2.文件内容:

#### Doxyfile

```
# 编码格式, 所有格式在https://www.gnu.org/software/libiconv/可以查看
DOXYFILE_ENCODING = UTF-8
# 项目名称
PROJECT_NAME = "code_docs_test"
# 用于指定生成的文档将写入的（相对或绝对）路径
OUTPUT_DIRECTORY = ./docs/doxygen/
# OUTPUT_LANGUAGE 标记用于指定 doxygen 生成的所有文档所用的语言: English, Chinese, ......
OUTPUT_LANGUAGE = Chinese

# 指定包含以下内容的文件和/或目录记录的源文件
INPUT = ./src/
# 输入文件的编码格式
INPUT_ENCODING = UTF-8
# 是否递归搜索子目录
RECURSIVE = YES
# 文件类型
FILE_PATTERNS = *.c \
                *.h \
                *.hpp \
                *.cpp
```

#### math_functions.h

```cpp
/**
 * @file math_functions.h
 * @brief Header file for basic math operations.
 *
 * This file contains the declarations of basic math functions 
 * such as addition and multiplication.
 */

#ifndef MATH_FUNCTIONS_H
#define MATH_FUNCTIONS_H

/**
 * @brief Adds two integers.
 *
 * This function takes two integers as inputs and returns their sum.
 *
 * @param[in] a First integer
 * @param[in] b Second integer
 * @return Sum of the two integers
 */
int add(int a, int b);

/**
 * @brief Multiplies two integers.
 *
 * This function takes two integers as inputs and returns their product.
 *
 * @param[in] a First integer
 * @param[in] b Second integer
 * @return Product of the two integers
 */
int multiply(int a, int b);

#endif // MATH_FUNCTIONS_H
```

#### math_functions.cpp

```cpp
/**
 * @file math_functions.cpp
 * @brief Implements basic math operations.
 *
 * This file provides the implementation of the functions declared in
 * math_functions.h for basic math operations like addition and multiplication.
 */

#include "math_functions.h"

/**
 * @brief Adds two integers.
 *
 * @param[in] a First integer
 * @param[in] b Second integer
 * @return Sum of the two integers
 */
int add(int a, int b) {
    return a + b;
}

/**
 * @brief Multiplies two integers.
 *
 * @param[in] a First integer
 * @param[in] b Second integer
 * @return Product of the two integers
 */
int multiply(int a, int b) {
    return a * b;
}
```

#### main.cpp

```cpp
/**
 * @file main.cpp
 * @brief Main file to demonstrate the use of math functions.
 *
 * This file contains the main function which demonstrates how the 
 * math functions (add and multiply) can be used.
 */

#include <iostream>
#include "math_functions.h"

/**
 * @brief Main function to run the program.
 *
 * This function calls the add and multiply functions and outputs 
 * the results to the console.
 *
 * @return 0 on successful execution
 */
int main() {
    int num1 = 5;
    int num2 = 3;

    // Call add function
    int sum = add(num1, num2);
    std::cout << "Sum: " << sum << std::endl;

    // Call multiply function
    int product = multiply(num1, num2);
    std::cout << "Product: " << product << std::endl;

    return 0;
}
```

### 3.生成文档

```bash
$ pwd
~/code_docs_test
$ doxygen ./Doxyfile
...
```

