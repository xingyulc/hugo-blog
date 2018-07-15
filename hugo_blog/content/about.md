---
title: "hugo_blog"

date: "2018-07-15"
# draft: true

---

# hugo_blog

hugo_blog是一个用Hugo搭建的静态网站,需要使用[docker](https://www.docker.com/)。[Hugo](https://gohugo.io/)能帮助进行快速搭建静态网站网站。

网上也有很多关于使用Hugo建立静态网站的示例，在docker使用hugo的大多数直接使用docker拉取Hugo镜像，然后运行`hugo server`,这种方法简洁易用。

关于在本地将Hugo静态网站构建成docker镜像的方法主要有两种：

1. 一种是直接FROM 构建
2. 另一种是使用git在[gohugoio/hugo](https://github.com/gohugoio/hugo/releases)上获取hugo的资源然后使用`ADD`加入，这种方法在获取hugo资源的时候会比较慢

这两种方法是主要使用的，由于这两种都会下载其他一些资源，比如在使用git、apk等。

hugo_blog是使用`alpine`作为基础构建镜像，直接将hugo压缩包下载放到hugo网站的根目录，在构建的时候直接使用`ADD`加入，这样在正常网速下构建镜像只需要几秒，但这也增大了网站的大小，不过hugo的压缩包只有6MB大小，问题不是很大。

## 选中hugo theme

hugo_blog选用的是一个简洁的hugo theme，该theme可以在github上的[temple](https://github.com/aos/temple)下载。当然也可以选择更多的[hugo theme](https://themes.gohugo.io/)

## 为什么使用alpine

[Alpine Linux](https://alpinelinux.org)是一个基于安全的轻量级Linux发行版，而Alpine docker镜像完全继承了Alpine Linux的特性，而且Alpine Docker镜像很小，只有5MB左右的大小，下载速度很快。

## 编写Dockerfile

Docker可以通过[Dockerfile](https://docs.docker.com/engine/reference/builder/)构建Docker镜像。Dockerfile中的CMD命令只有最后一个能被执行。

```dockerfile
#获取Linux基础镜像
FROM registry.saas.hand-china.com/tools/alpine:3.7-1

MAINTAINER Chao Li<1352128650li@gmail.com>
 
ENV HUGO_SITE=hugo_blog

COPY hugo_blog/ /hugo_blog/
ADD /hugo_0.44_Linux-64bit.tar.gz /tmp
RUN mv /tmp/hugo /usr/local/bin/

WORKDIR ${HUGO_SITE}

EXPOSE 1313

ENV HUGO_BASE_URL http://localhost:1313
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0
```

Dockerfile文件中的hugo压缩包是在[gohugoio/hugo](https://github.com/gohugoio/hugo/releases)下载的，放在和Dockerfile同一级目录。

在编写Dockerfile的时候出现了几个问题：

1. 使用COPY或ADD命令，ADD指令的功能是将主机构建环境（上下文）目录中的文件和目录、以及一个URL标记的文件拷贝到镜像中，tar压缩会进行自动解压。COPY指令和ADD指令差不多，COPY指令没有自动解压功能。
2. 构建镜像的的时候，需要使用COPY指令将需要构建上下文的文件拷贝到镜像中。
3. 在本地调试的时候是在虚拟机中使用docker运行hugo，之前构建完镜像后默认的是localhost，但是本机无法访问，docker宿主机的ip访问hugo静态网站能访问成功，但是网站的跳转会默认跳转到localhost。最后是在dockerfile文件为运行`hugo server`命令时添加docker宿主机的ip。

## 创建run.sh

run.sh文件是为了方便运行自己构建的镜像而创建的。

```shell
#配置ip和端口号，ip是docker-machine处于active的
#若命令为: sh run.sh,ip是docker-machine处于active的
#若不是使用的docker-machine，则用 sh run.sh youIP
if [ "" = "$1" ] ;then
    docker run -p 1313:1313 -e HUGO_BASE_URL=http://$(docker-machine ip $(docker-machine active)) myhugo
else
    docker run -p 1313:1313 -e HUGO_BASE_URL=http://$1 myhugo
fi
```

将hugo静态网站构建成docker镜像直接在docker中运行，这样的做法会使得操作更简单，但是如果更改了静态网站的内容之后就会重新构建一次docker镜像才行。之前使用的时候是在本地配置了hugo，然后在hugo静态网站中执行`hugo server`，这样的好处是网站更新了新内容，不需要重启。