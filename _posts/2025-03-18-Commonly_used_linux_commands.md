---
layout: post
categories: blog
---

### 常用的 linux 命令

#### 系统架构

```bash
# 查看 cpu 架构
$ uname -m
# 查看操作系统信息
$ cat /etc/os-release
$ lsb_release -a
# 查看完整信息 
$ hostnamectl
# 查看 cpu 信息
$ lscpu
```

#### 压缩和解压

对于以 .tar.gz 结尾的文件

```bash
# x：解压文件; v：显示解压过程（可选）; z：处理 .gz 压缩格式; f：指定文件名
$ tar -xvzf sophon-sail_3.8.0.tar.gz
# 解压到特定目录
$ tar -xvzf sophon-sail_3.8.0.tar.gz -C /opt/sophon
```

对于以

```bash
# x：解压文件; v：显示解压过程（可选）; J：使用 xz 解压; f：指定文件名
$ tar -xJvf blender-4.4.0-linux-x64.tar.xz
```



#### 内存

```bash
# 查看内存使用情况
$ free -h
```

#### 硬盘

```bash
# 通用
$ du -h
# 只看一层
$ du -h -d 1
# 查看帮助
$ du --help
```

#### dpkg

```bash
# 安装
$ sudo dpkg -i package.deb
# 卸载
$ sudo dpkg -r package_name
# 查询安装
$ dpkg -l | grep package_name
```

#### apt

```bash
# 安装
$ sudo apt install package_name
# 卸载
$ sudo apt remove package_name
# 完全卸载，包括配置文件
$ sudo apt purge package_name
```

#### find

```bash
# 在 /home 目录下查找名为 main.cpp 文件
$ find /home -type f -name main.cpp
```

#### 强制退出某程序

```bash
# 输入 xkill 然后移动光标到程序
$ xkill
```

