---
layout: post
categories: blog
---
# nginx的使用与部署

nginx的官方文档：http://nginx.org/en/docs/

以下经验以 **nginx-1.24.0 Stable version** 为例

一些通用的依赖：

- openssl-1.1.0l.tar.gz：https://www.openssl.org/source/old/1.1.0/
- zlib-1.2.11.tar.gz：https://github.com/madler/zlib/tags



### 普通构建（基于x86-64）

构建文档：http://nginx.org/en/docs/configure.html

```bash
./configure \
	# Generate the installation path for the library
	--prefix=/home/shecannotsee/desktop/temp/nginx_docs_test/nginx-1.24.0-build \
	# Enable HTTPS
	--with-http_ssl_module \
	# openssl source code directory, not build directory
	--with-openssl=/home/shecannotsee/desktop/temp/nginx_docs_test/openssl-1.1.0l \
	# openssl build option
	#--with-openssl-opt=[param]
	# zlib source code directory, not build directory
	--with-zlib=/home/shecannotsee/desktop/temp/nginx_docs_test/zlib-1.2.11 \
	# zlib build option
	#--with-zlib-opt=[param]

# simple example
./configure \
	--prefix=/home/shecannotsee/desktop/temp/nginx_docs_test/nginx-1.24.0-build \
	--with-http_ssl_module \
	--without-http_rewrite_module
	
make
make install
```

注1：在使用`--with-http_ssl_module`时需要根据需求在启用或者关闭`--without-http_rewrite_module`，关于该编译命令的含义请参考nginx的构建文档

注2：在使用`--prefix`编译命令的时候，生成的项目的配置受到**--prefix**所**指定目录的影响**



### 交叉编译（基于arm64）

**建议使用docker来作为交叉编译的环境，便于解决权限问题和局部交叉编译器的环境问题**

```bash
# 交叉编译链配置,在这里配置交叉编译链的编译器以及交叉编译环境
...

./configure \
	--without-http_rewrite_module \
	--with-zlib=/home/root/in/zlib-1.2.11 \
	--with-openssl=/home/root/in/openssl-1.1.0l \
	--with-openssl-opt=linux-aarch64\
	--with-http_ssl_module \
	--prefix=/home/root/nginx-1.24.0-build \
	--without-http_upstream_zone_module \
	--without-stream_upstream_zone_module
	
make
make install
```

注：编译后的产物与`--prefix`的路径严重挂钩，若有交叉编译的权限问题，可以考虑使用docker来处理

一些需要修改的注意事项

#### 1.处理找不到交叉编译器的问题(在./configure之前)

修改 .../nginx-1.24.0/auto/cc/name 中

```bash
10| ngx_feature_run=yes
```

修改为

```bash
10| ngx_feature_run=no
```

#### 2.处理byte size的问题(在./configure之前)

修改 .../nginx-1.24.0/auto/types/sizeof 中

```bash
43|	ngx_size=`$NGX_AUTOTEST`
```

修改为（修改内容根据目标平台大小来选择，例如arm64这里填8，若是arm32则填4）

```bash
43|	ngx_size=8
```

#### 3.处理make时编译器搜寻问题（./configure之后，make之前）

修改 .../nginx-1.24.0/objs/Makefile 中

```bash
2|	CC =	aarch64-poky-linux-gcc  --sysroot=/opt/fsl-imx-wayland/4.14-sumo/sysroots/aarch64-poky-linux
```

修改为

```
2|	CC =	gcc
```

#### 4.处理编译中的问题（./configure之后，make之前）

在 .../nginx-1.24.0/objs/ngx_auto_config.h 中添加以下内容

```c
#ifndef NGX_HAVE_SYSVSHM
#define NGX_HAVE_SYSVSHM 1
#endif
```



### docker环境

```bash
# 拉取镜像,最好与主机系统相同,便于同步和处理错误
sudo docker pull ubuntu:20.04

# 创建容器,-v用来做文件的映射,前者是真机,宿主机的目录,:后是docker里的目录
sudo docker run -it --name cce \
-v /home/shecannotsee/desktop/cross_compilation_environment/ubuntu20.04/in:/home/root/in  \
-v /home/shecannotsee/desktop/cross_compilation_environment/ubuntu20.04/out:/home/root/out \
ubuntu:20.04

# 进入创建好的容器
sudo docker exec -it cce /bin/bash
```



### 配置文件与使用

一些简单的使用脚本

**start_nginx.sh**

```bash
.../nginx-1.24.0-build/sbin/nginx \
-c \
.../nginx-1.24.0-build/conf/nginx.conf
```

**stop_nginx.sh**

```bash
sudo pkill nginx
```

**nginx_is_running.sh**

```bash
#!/bin/bash

pid_file=".../nginx-1.24.0-build/logs/nginx.pid"

if [ -e "$pid_file" ]; then
  echo "Nginx is running!"
else
  echo "Nginx is not running."
fi
```

#### 

#### 代理http接口示例

nginx.conf

```nginx
user root;
worker_processes  1;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       8088;
        server_name  localhost;

        # 静态资源目录，一般放前端打包的目录
        location / {
            root   /root/web_server/dist;
            try_files $uri $uri/ /index.html;
        }
		
        # 代理的接口,这个是 https://localhost:5000/login
        location /login {
            proxy_pass http://localhost:5000/;
        }
		location /logout {
            proxy_pass http://localhost:5000/;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }


    }



}

```



#### 代理https接口示例

nginx.conf

```nginx
user root;
worker_processes  1;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        # 指定服务器监听的端口号为8088，并启用SSL/TLS加密
        listen       8088 ssl;
        server_name  localhost;
		
        # 指定SSL证书的路径，这是用于对传输进行加密的公钥证书。
        ssl_certificate      .../ca.crt;
        # 指定SSL证书的私钥文件路径，这是用于解密传输的私钥文件
        ssl_certificate_key  .../private.key;
        
        # 指定支持的SSL/TLS协议版本，这里配置为支持TLSv1.2和TLSv1.3版本。
        ssl_protocols TLSv1.2 TLSv1.3;
        # 设置支持的加密套件，这里配置了一组加密套件的优先级
        ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
        # 指定使用服务器端定义的加密套件优先级
        ssl_prefer_server_ciphers on;
        # 设置SSL会话的超时时间为1天，超过该时间会自动结束SSL会话
        ssl_session_timeout 1d;
        # 指定SSL会话缓存的共享内存大小为50MB，用于存储SSL会话的信息
        ssl_session_cache shared:SSL:50m;
        # 禁用SSL会话票据，避免会话重用
        ssl_session_tickets off;
        #charset koi8-r;

        #access_log  logs/host.access.log  main;
		
        # 静态资源目录,一般是前端打包项目的存放目录
        location / {
            root   /root/web_server/dist;
            try_files $uri $uri/ /index.html;
        }
		# 这里是https
        location /login {
            proxy_pass https://localhost:5000/;
        }
	    location /logout {
            proxy_pass https://localhost:5000/;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

    }

}
```

