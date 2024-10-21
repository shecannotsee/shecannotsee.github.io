---
layout: post
categories: blog
---



# Installation

## 1 Direct installation

Reference resources https://docs.docker.com/engine/install/



## 2 Installing from source

TODO: ...



# Use

## 1 image

### 1.1 Get from server

```bash
# Get the Ubuntu image with version number 22.04
$ sudo docker pull [image name]:[version]
```

- `image name`: Image name.
- `version`: Image version.



### 1.2 Load from file

```bash
$ sudo docker load -i [/path/to/load/image_file.tar]
```

- `/path/to/load/image_file.tar`: Load file.

This operation contains meta data.



### 1.3 Display information

#### 1.3.1 List images

```bash
# List all images
$ sudo docker images 
# List an image
$ sudo docker images [IMAGE ID]
```

- `IMAGE ID`: Image id.

#### 1.3.2 View detailed information for a specific image

```bash
$ sudo docker inspect [IMAGE ID]
# or
$ sudo docker inspect [REPOSITORY]:[TAG]
```

- `IMAGE ID`: Image id.
- `REPOSITORY`: Image name.
- `TAG`: The version of image.

#### 1.3.3 View the image history

```bash
$ sudo docker history [IMAGE ID]
# or
$ sudo docker history [REPOSITORY]:[TAG]
```

- `IMAGE ID`: Image id.
- `REPOSITORY`: Image name.
- `TAG`: The version of image.



### 1.4 Modify information

```bash
$ sudo docker tag [IMAGE ID] [new_image_name]:[tag]
```

- `IMAGE ID`: Image id.
- `new_image_name`: New image name, new image REPOSITORY.
- `tag`: New image tag.



### 1.5 Save image to file

```bash
$ sudo docker save [IMAGE ID] -o [/path/to/save/image_file.tar]
# or
$ sudo docker save [REPOSITORY] -o [/path/to/save/image_file.tar]
# or
$ sudo docker save [REPOSITORY]:[TAG] -o [/path/to/save/image_file.tar]
```

- `IMAGE ID`: Image id.
- `REPOSITORY`: Image name.
- `TAG`: The version of image.
- `/path/to/save/image_file.tar`: Saved Files.



### 1.6 Delete

```bash
$ sudo docker rmi [IMAGE ID]
# or
$ sudo docker rmi [REPOSITORY]:[TAG]
```

- `IMAGE ID`: Image id.
- `REPOSITORY`: Image name.
- `TAG`: The version of image.





## 2 container

### 2.1 Display information

#### 2.1.1 List running containers

```bash
$ sudo docker container ps
$ sudo docker ps
```

#### 2.1.2 List all containers

```bash
$ sudo docker container ps -a
# or 
$ sudo docker container ps -l
# or
$ sudo docker ps -a
# or
$ sudo docker ps -l
```

#### 2.1.3 View logs and status

View logs:

```bash
$ sudo docker logs [CONTAINER ID]
# or
$ sudo docker logs [NAMES]
```

- `CONTAINER ID`: Container id.
- `NAMES`: Container name.

View status, similar to top:

```bash
$ sudo docker stats
```



### 2.2 Delete

```bash
$ sudo docker rm [CONTAINER ID]
# or
$ sudo docker rm [NAMES]
```

- `CONTAINER ID`: Container id.
- `NAMES`: Container name.

Delete multiple non-running containers at once:

```bash
$ sudo docker rm $(docker ps -a -q -f status=exited)
```



### 2.3 Operation Container

#### 2.3.1 Start

```bash
$ sudo docker start [CONTAINER ID]
# or
$ sudo docker start [NAMES]
```

- `CONTAINER ID`: Container id.
- `NAMES`: Container name.

#### 2.3.2 Stop

```bash
$ sudo docker stop [CONTAINER ID]
$ sudo docker stop [NAMES]
```

- `CONTAINER ID`: Container id.
- `NAMES`: Container name.

#### 2.3.3 Restart

```bash
$ sudo docker restart [CONTAINER ID]
$ sudo docker restart [NAMES]
```

- `CONTAINER ID`: Container id.
- `NAMES`: Container name.



### 2.4 Export and Import

```bash
# Export
$ sudo docker export [CONTAINER ID] -o [/path/to/export/container_file.tar]
# or
$ sudo docker export [NAMES] -o [/path/to/export/container_file.tar]

# Import. After importing, it is a image
$ sudo docker import [/path/to/import/container_file.tar]
```

- `CONTAINER ID`: Container id.
- `NAMES`: Container name.
- `/path/to/export/container_file.tar`: Container export file.
- `/path/to/import/container_file.tar`: Imported file: The file exported by the container.



### 2.5 Create a container

```bash
$ sudo docker run [OPTIONS] [IMAGE ID] [COMMAND] [ARG...]
# or
$ sudo docker run [OPTIONS] [REPOSITORY]:[TAG] [COMMAND] [ARG...]
# or 
$ sudo docker container run [OPTIONS] [IMAGE ID] [COMMAND] [ARG...]
# or
$ sudo docker container run [OPTIONS] [REPOSITORY]:[TAG] [COMMAND] [ARG...]
```

sample:

```bash
$ sudo docker run \
 			-p 20080:80 \ # Port Mapping: host-20080:docker-80
 			ubuntu:22.04 \ # use image: ubuntu:22.08
 			/bin/bash
...... 
$ 
```



#### 2.5.1 OPTIONS

- `-d`, `--detach`: Runs a container in the background and returns the container ID.
- `-p`, `--publish`: Map the container's port to the host. The format is: `host_port:container_port`.
- `--name`: Specify a name for the container.
- `-e`, `--env`: Set environment variables. The format is: `VAR=value`.
- `-v`, `--volume`: Mapping the container's directory to the host. The format is: `host_path:container_path`.
- `--hostname`: Used to set the hostname of the container.
- `--restart`: Used to set the container restart policy.
  - `--restart no`: Do not automatically restart (default).
  - `--restart on-failure`: Restart the container only if it exits with a non-zero status (can specify a maximum retry count).
  - `--restart always`: Always restart the container regardless of the exit status.
  - `--restart unless-stopped`: Always restart the container unless it is manually stopped.
- `-w`, `--workdir`: Used to specify the working directory within the container.



### 2.6 Enter the running container

```bash
$ sudo docker exec [OPTIONS] [CONTAINER ID] [COMMAND] [ARG...]
# 或
$ sudo docker exec [OPTIONS] [NAMES] [COMMAND] [ARG...]
```

Enter the running container:

```bash
$ sudo docker exec -it [CONTAINER ID] /bin/bash
```



## 3 Dockerfile

### 3.1 Create container from Dockerfile

Creating a container from a Dockerfile

```bash
$ sudo docker build -t [image_name] [/path/to/find/dockerfile]
```

- `image_name`: The name of the created container.
- `/path/to/find/dockerfile`: Find the path of file Dockerfile.



### 3.2 Dockerfile core

- `FROM`: Use the `FROM` directive to specify a base image.
- `RUN`: Use the `RUN` command to install the required packages.
- `CPOY`: Use the `COPY` instruction to copy local files into the container.
- `ENV`: Use the `ENV` command to set environment variables.
- `WORKDIR`: Use the `WORKDIR` directive to set the container's working directory.
- `LABEL`: Use the `LABEL` directive to add maintainer information.

#### **sample**

Dockerfile for creating a C++ development environment based on Ubuntu 22.04.

(1) Create Dockerfile

Dockerfile

```dockerfile
# Use ubuntu22.04
FROM ubuntu:22.04

# Set maintainer information
LABEL maintainer="your_email@example.com"

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    vim \
    git \
    build-essential \ # Including GCC, G++, make and other compilation tools
    gdb \
    cmake \
    gdb \
    clang-format \
    clang-tidy \
    valgrind \
    lcov \
    doxygen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy local code into the container (if any)
COPY . /app

# Setting Environment Variables
ENV TZ=UTC
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Expose a port (if necessary)
EXPOSE 8080

# Defines the command to be executed when the container starts
CMD ["bash"]
```

(2) Run the following command in this directory to build the image:

```bash
$ sudo docker build -t cpp_dev_env .
```

(3) Run the container using the following command:

```bash
docker run -it --name my_cpp_container cpp_dev_env
```

