set -e


#---------------------------------------------------------------------
#(x.1)参数
args_="

export basePath=/root/temp/svn

# "

 
#---------------------------------------------------------------------
#(x.2)
publishPath="$basePath/Publish/release/release/Station(net6.0)"
dockerPath=$basePath/Publish/release/release/docker-image



#---------------------------------------------------------------------
echo "(x.3)copy dir"
\cp -rf "$basePath/Publish/ReleaseFile/docker-image/." "$dockerPath"


#---------------------------------------------------------------------
echo "(x.4)copy station"

\cp -rf "$publishPath/ServiceCenter/." "$dockerPath/sers/app"
\cp -rf "$publishPath/Gateway/." "$dockerPath/sers-gateway/app"
\cp -rf "$publishPath/Gover/." "$dockerPath/sers-gover/app"
\cp -rf "$publishPath/Demo/." "$dockerPath/sers-demo/app"
\cp -rf "$publishPath/Robot/." "$dockerPath/sers-demo-robot/app"
\cp -rf "$basePath/Publish/release/release/压测/单体压测net6.0/ServiceCenter/." "$dockerPath/sers-demo-sersall/app"
 

