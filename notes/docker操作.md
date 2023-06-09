## 镜像

```bash
# 倒入镜像ubuntu
docker pull ubuntu

# 查看所有镜像
docker images
# REPOSITORY                             TAG       IMAGE ID       CREATED       SIZE

# 删除镜像，需要处理使用镜像的容器才能正常删除
docker rmi [REPOSITORY]
docker rmi [IMAGE ID]

```



## 容器

```bash
# 查看所有容器
docker container ps -a
docker container ps -l
docker ps -a 
docker ps -l
# 查看正在运行的容器
docker container ps
docker ps
#CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

#删除容器
docker rm [CONTAINER ID]

# 启动容器
docker start [CONTAINER ID]
docker restart [CONTAINER ID]
docker stop [CONTAINER ID]

# 进入容器
docker exec -it [CONTAINER ID] /bin/bash

#导出一个已经创建的容器到一个文件
docker export [容器ID]
# 导出的容器快照文件可以再导入为镜像
docker import [路径]
```



## 从镜像创建容器

```bash
docker run \
--name gitlablocal \ # 指定容器名为gitlablocal
--hostname gitlab \ # 发布域名叫gitlab，还需要配置域名绑定
-d \ # -d：容器在后台运行
-p 20080:80 \ # -p：指定端口映射,[宿主机端口]:[docker内端口]
-p 20022:22 \
--restart always \ # –restart always ：电脑启动时自动启动
-v /data/gitlab/config:/etc/gitlab \ # -v: 文件目录映射,[宿主机目录]:[docker内目录]
--volume $GITLAB_HOME/data:/var/opt/gitlab \ 
gitlab/gitlab-ce # 镜像REPOSITORY

```

sudo docker cp CON_ID path



```
       -v /home/shecannotsee/Desktop/docker_info/nginx_server/config/:/etc/nginx \
#       -v /home/shecannotsee/Desktop/docker_info/nginx_server/log:/var/log/nginx \
#       -v /home/shecannotsee/Desktop/docker_info/nginx_server/static_resources:/usr/share/nginx \
```



## 打包镜像

将镜像打包成.tar文件

```shell
docker save image_name -o /path/to/save/image.tar
```

将.tar文件加载为docker镜像

```shell
docker load -i /path/to/image.tar
```



## Dockerfile

Dockerfile文件

```dockerfile
# 使用ubuntu22.04,该镜像下可以直接安装g++11.3以提供c++20的开发环境
FROM ubuntu:22.04

ENV TZ=UTC
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# 安装c++开发环境
RUN apt-get update -y \
    && apt-get install -y vim cmake ssh g++ make cmake 
```



创建镜像

```bash
# 镜像名指定为shecannotsee,查找Dockerfile的路径是.下查找
sudo docker build -t shecannotsee .

# 删除镜像
sudo docker rmi <id或者名称>

# 查看容器modern的ip,以便于后续ssh时使用
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modern
```

