---
layout: post
custom_js: mouse_coords
date: 2023-02-14
---
# 1.在ubuntu20.04上安装编译器解释器

```shell
sudo apt-get update
sudo apt-get install haskell-platform
```

# 2.使用

## (1)输入ghci开始使用

```shell
shecannotsee@pc:~$ ghci
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
Prelude> xxxxxxxxxx ghcishecannotsee@pc:~$ ghciGHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for helpPrelude> 
```

```shell
# 退出ghci
Prelude> :quit
Leaving GHCi.
shecannotsee@pc:~$
```

## (2)编译

```shell
ghc hello.hs
./hello
```

# 3.示例

在 Haskell 中，一个简单的 "Hello, World!" 程序可以写为：

```
main :: IO ()
main = putStrLn "Hello, World!"
```

运行这段代码可以在终端中输出 "Hello, World!"。

如果你在交互式环境 `ghci` 中，可以运行以下命令：

```
putStrLn "Hello, World!"
```

# 4.简单开发环境搭建

可参考目录结构

```
.
├── 01_compile.sh
├── 02_run.sh
├── helloworld.hs
├── output
│   ├── helloworld
│   ├── Main.hi
│   └── Main.o
└── yes.hs
```

01_compile.sh

```shell
#!/bin/bash
source_file_name=$1
target_file_name="${source_file_name%.*}"
ghc -outputdir output -o output/$target_file_name $source_file_name
```

02_run.sh

```shell
#!/bin/bash
executable_program=$1
./output/$executable_program
```

