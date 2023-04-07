---
layout: post
custom_js: mouse_coords
date: 2023-02-14
---
参考链接https://clang.llvm.org/docs/ClangFormatStyleOptions.html

# 格式化代码文件

tips：前提是需要在该目录下有`.clang-format`文件

对于**单个文件的格式化**:

```shell
clang-format -i filename.cpp
```

其中 `-i` 指定在格式化文件之后覆盖该文件，并且 `filename.cpp` 是您希望格式化的文件的名称。



可以通过执行以下命令来对**整个目录进行格式化**:

```shell
find <directory_path> -name "*.cpp" -o -name "*.h" | xargs clang-format -i
```

上面的命令使用`find`命令搜索目录，并对目录中的所有`*.cpp`和`*.h`文件进行格式化。

如果您使用的是某些自动化构建工具，则可以将上述命令添加到该工具的构建脚本中，以在每次构建时对代码进行格式化。





# 部分字段含义

**BasedOnStyle：指定代码风格的基础**

```
# <LLVM> <Google> <Chromium> <Mozill> <WebKit> <Microsoft> <GNU>
BasedOnStyle: Google
```

**AccessModifierOffset：访问修饰符的额外缩进或缩进，例如 .`public:`**



**AlignAfterOpenBracket**



**AlignConsecutiveAssignments：若true,则对齐连续赋值运算符.**

```
# <true> <false>
AlignConsecutiveAssignments : true
```

```c
int aaaa = 12;
int b    = 23;
int ccc  = 23;
```



**AlignConsecutiveDeclarations：若true，则对齐连续声明**

```
# <true> <false>
AlignConsecutiveDeclarations : true
```

```c
int         aaaa = 12;
float       b = 23;
std::string ccc = 23;
```



**AlignOperands：若true，则水平对齐二目运算符和三目运算符的操作数**

```
# <true> <false>
AlignOperands : true
```

```c
int aaa = bbbbbbbbbbbbbbb +
          ccccccccccccccc;
```

**AlignTrailingComments：若true,则对齐注释**

```
# <true> <false>
AlignTrailingComments : true
```

```
int a;     // My comment a
int b = 2; // comment  b
```



**AllowAllParametersOfDeclarationOnNextLine：若true，则在函数声明中允许将所有参数放下一行**

```
# <true> <false>
AllowAllParametersOfDeclarationOnNextLine : true
```

```
myFunction(foo,
           bar,
           plop);
```



**AllowShortBlocksOnASingleLine：若true，则允许将简单语句放置在一行中**

```
# <true> <false>
AllowShortBlocksOnASingleLine : true
```

```c
if (a) { return; }
```













**temp**

```
BasedOnStyle: Google

# Allow double brackets such as std::vector<std::vector<int>>.
Standard : c++11

# 全局设置
ColumnLimit : 120          # 指定代码行的最大长度
UseTab : false             # 使用空格而不是Tab来缩进代码
IndentWidth : 2            # 指定缩进宽度

# 代码块格式设置
BreakBeforeBraces : Attach                # 设置前括号不换行,该项可改为自定义项
SpaceBeforeParens : ControlStatements     # 设置自动与之前一个字符空出来一个空格。
AllowShortFunctionsOnASingleLine : None   # 设置简单函数将不会省略为一行
AlwaysBreakAfterReturnType : None         # 函数返回值是否换行定义


# 代码书写细节
AccessModifierOffset : -1           # 设置 public 和 private 只缩进一个空格
AlignConsecutiveAssignments : true  # 对齐连续变量和注释
PointerAlignment : Left             # 指定指针和引用的对齐方式


```

