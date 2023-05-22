set -e


#---------------------------------------------------------------------
#(x.1)参数
args_="

export basePath=/root/temp/svn

export appVersion=1.0

export DOCKER_ImagePrefix=serset/
export DOCKER_USERNAME=serset
export DOCKER_PASSWORD=xxx

# "




#---------------------------------------------------------------------
echo "73.docker-image-build-push.sh -> #1 docker - init buildx"


export builderName="mybuilder__${appVersion}__"
echo "builderName: $builderName"


echo "#1.1 验证是否开启"
docker buildx version

echo "#1.2 启用binfmt_misc"
docker run --privileged --rm tonistiigi/binfmt --install all

echo "#1.3 创建构建器"
if [ ! "$(docker buildx ls | grep $builderName)" ]; then docker buildx create --use --name $builderName --buildkitd-flags '--allow-insecure-entitlement security.insecure'; fi

echo "#1.4 启动构建器"
docker buildx inspect $builderName --bootstrap

echo "#1.5 查看当前使用的构建器及支持的CPU架构"
docker buildx ls



#---------------------------------------------------------------------
echo "73.docker-image-build-push.sh -> #2 docker - build and push"

echo "#2.1 login if UserName is not empty"
if [ -n "$DOCKER_USERNAME" ]; then docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD; fi

dockerPath=$basePath/Publish/release/release/docker-image

for dockerName in `ls $dockerPath`
do
  if [ -d $dockerPath/$dockerName ]
  then
    platform="linux/amd64,linux/arm64,linux/arm/v7"
    if [ -f "$dockerPath/$dockerName/Dockerfile.platform" ]; then platform=`cat "$dockerPath/$dockerName/Dockerfile.platform"`; fi

    echo "#2.* docker build $dockerName, platform: $platform"
    echo "docker buildx build $dockerPath/$dockerName -t ${DOCKER_ImagePrefix}$dockerName:$appVersion -t ${DOCKER_ImagePrefix}$dockerName --platform=$platform --push --allow security.insecure --builder $builderName"
    docker buildx build $dockerPath/$dockerName -t ${DOCKER_ImagePrefix}$dockerName:$appVersion -t ${DOCKER_ImagePrefix}$dockerName --platform=$platform --push --allow security.insecure --builder $builderName
  fi
done


#---------------------------------------------------------------------
echo "73.docker-image-build-push.sh -> #3 docker - remove buildx"
if [ "$(docker buildx ls | grep $builderName)" ]; then docker buildx rm $builderName; fi
