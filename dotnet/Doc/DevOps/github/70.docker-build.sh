set -e


#---------------------------------------------------------------------
#(x.1)参数
args_="

export codePath=/root/temp/svn/dotnet

export version=`grep '<Version>' ${codePath} -r --include *.csproj | grep -oP '>(.*)<' | tr -d '<>'`

export DOCKER_USERNAME=serset
export DOCKER_PASSWORD=xxx

# "

 
netVersion=net6.0

#---------------------------------------------------------------------
echo "(x.2)dotnet-构建项目文件"

echo "copy SersDocker"
cp -rf "$codePath/Doc/PublishFile/SersDocker/." "$codePath/Doc/Publish/SersDocker"

echo "copy sers"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/ServiceCenter/appsettings.json" "$codePath/Doc/Publish/SersDocker/docker部署Sers/sers"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/ServiceCenter/." "$codePath/Doc/Publish/SersDocker/docker制作镜像Sers/sers/app"


echo "copy sers-gateway"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Gateway/appsettings.json" "$codePath/Doc/Publish/SersDocker/docker部署Sers/sers-gateway"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Gateway/." "$codePath/Doc/Publish/SersDocker/docker制作镜像Sers/sers-gateway/app"

echo "copy sers-gover"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Gover/appsettings.json" "$codePath/Doc/Publish/SersDocker/docker部署Sers/sers-gover"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Gover/." "$codePath/Doc/Publish/SersDocker/docker制作镜像Sers/sers-gover/app"



echo "copy sers-demo"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Demo/appsettings.json" "$codePath/Doc/Publish/SersDocker/docker部署Sers/sers-demo"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Demo/." "$codePath/Doc/Publish/SersDocker/docker制作镜像Sers/sers-demo/app" 

echo "copy sers-demo-robot"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Robot/appsettings.json" "$codePath/Doc/Publish/SersDocker/docker部署Sers/sers-demo-robot"
cp -rf "$codePath/Doc/Publish/SersPublish/$netVersion/Robot/." "$codePath/Doc/Publish/SersDocker/docker制作镜像Sers/sers-demo-robot/app"



echo "copy sers-demo-sersall"
cp -rf "$codePath/Doc/Publish/Sers压测/sers压测-单体压测$netVersion/ServiceCenter/appsettings.json" "$codePath/Doc/Publish/SersDocker/docker部署Sers/sers-demo-sersall"
cp -rf "$codePath/Doc/Publish/Sers压测/sers压测-单体压测$netVersion/ServiceCenter" "$codePath/Doc/Publish/SersDocker/docker制作镜像Sers/sers-demo-sersall/app"





#---------------------------------------------------------------------
#(x.3.1)docker-初始化多架构构建器

#启用 buildx 插件
export DOCKER_CLI_EXPERIMENTAL=enabled

#验证是否开启
docker buildx version

#启用 binfmt_misc
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d

#验证是 binfmt_misc 否开启
ls -al /proc/sys/fs/binfmt_misc/


#创建一个新的构建器
docker buildx create --use --name mybuilder

#启动构建器
docker buildx inspect mybuilder --bootstrap

#查看当前使用的构建器及构建器支持的 CPU 架构，可以看到支持很多 CPU 架构：
docker buildx ls



#---------------------------------------------------------------------
#(x.3.2)docker-构建多架构镜像（ arm、arm64 和 amd64 ）并推送到 Docker Hub

#docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

#docker buildx build $codePath/Publish/06.Docker/制作镜像/$name -t $DOCKER_USERNAME/$name:$version -t $DOCKER_USERNAME/$name --platform=linux/amd64,linux/arm64,linux/arm/v7 --push
 




 




 
