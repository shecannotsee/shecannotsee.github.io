---
layout: post
markdown: kramdow
---
#### 0.download

https://github.com/filebrowser/filebrowser/releases/



#### 1.初始化

```bash
./filebrowser config init
```

#### 2.修改配置

修改监听**端口**

```bash
./filebrowser config set --port 9010
```

设置中文

```bash
./filebrowser config set --locale zh-cn
```

设置日志

```bash
./filebrowser config set --log .\filebrowser.log
```

添加用户和权限（--perm.admin是赋予管理员权限）

```bash
./filebrowser users add myaccount mypassword --perm.admin
```



#### 3.启动

这样启动可从外界进行访问

```bash
./filebrowser -a 0.0.0.0
```

这样可以指定文件管理的目录（管理home目录）

```bash
./filebrowser -a 0.0.0.0 -r /home/
```

