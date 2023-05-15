set -e


#---------------------------------------------------------------------
#(x.1)参数
args_="

export basePath=/root/temp/svn

export appVersion=1.0

export APPNAME=xxxxxx

# "

#----------------------------------------------
echo "压缩文件"

docker run --rm -i \
-v $basePath:/root/code \
serset/filezip bash -c "
set -e

releasePath=/root/code/Publish/release
rm -rf \$releasePath/release-zip

for dirname in \`ls /root/code/Publish/release/release\`
do
  if [ -d \$releasePath/release/\$dirname ]
  then
    filezip zip -p -i \$releasePath/release/\$dirname -o \$releasePath/release-zip/${APPNAME}-\${dirname}-${appVersion}.zip 
  fi
done

echo zip files:
ls /root/code/Publish/release/release-zip

"