# hugo-blog

hugo_blog是一个用Hugo搭建的静态网站,需要使用[docker](https://www.docker.com/)。[Hugo](https://gohugo.io/)能帮助进行快速搭建静态网站网站。

docker-machine用户
```shell
git clone https://github.com/xingyulc/hugo-blog.git
cd hugo-blog
sh build.sh
sh run.sh 
#重启
sh restart.sh 
#停止，删除镜像
sh stop.sh
```

在主机上直接使用docker用户,需要输入主机ip
```shell
git clone https://github.com/xingyulc/hugo-blog.git
cd hugo-blog
sh build.sh
sh run.sh yourIp(127.0.0.1)
#重启
sh restart.sh yourIp(127.0.0.1)
#停止，删除镜像
sh stop.sh
```