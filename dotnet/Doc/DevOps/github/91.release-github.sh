set -e


#---------------------------------------------------------------------
#(x.1)参数
args_="

export codePath=/root/temp/svn 



export version=`grep '<Version>' ${codePath} -r --include Sers.Core.csproj | grep -oP '>(.*)<' | tr -d '<>'`

export name=Sers

# "


 


#---------------------------------------------------------------------
#(x.2)初始化github release环境变量
releaseFile=$codePath/Doc/Publish/release/${name}-${version}.zip

filePath=${releaseFile}
#name=Vit.Library
#version=2.5



fileType="${filePath##*.}"
echo "release_name=${name}-${version}" >> $GITHUB_ENV
echo "release_tag=${version}" >> $GITHUB_ENV

echo "release_draft=false" >> $GITHUB_ENV
echo "release_prerelease=false" >> $GITHUB_ENV

echo "release_body=" >> $GITHUB_ENV

echo "release_assetPath=${filePath}" >> $GITHUB_ENV
echo "release_assetName=${name}-${version}.${fileType}" >> $GITHUB_ENV
echo "release_contentType=application/${fileType}" >> $GITHUB_ENV




 