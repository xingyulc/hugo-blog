#配置ip和端口号，ip是docker-machine处于active的
#若命令为: sh run.sh,ip是docker-machine处于active的
#若不是使用的docker-machine，则用 sh run.sh yourIP

if [ "" = "$1" ] ;then
    docker run --name=my_hugo_blog -p 1313:1313 -e HUGO_BASE_URL=http://$(docker-machine ip $(docker-machine active)) myhugo
else
    docker run --name=my_hugo_blog -p 1313:1313 -e HUGO_BASE_URL=http://$1 myhugo
fi
