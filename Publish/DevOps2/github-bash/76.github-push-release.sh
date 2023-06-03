set -e


#---------------------------------------------------------------------
# args
args_="

export basePath=/root/temp/svn

export version=`grep '<Version>' $(grep '<pack>\|<publish>' ${basePath} -r --include *.csproj -l | head -n 1) | grep -oP '>(.*)<' | tr -d '<>'`

export APPNAME=xxxxxx

# "


 


#---------------------------------------------------------------------
#2 init environment for github release




echo "release_name=${APPNAME}-${version}" >> $GITHUB_ENV
echo "release_tag=${version}" >> $GITHUB_ENV

echo "release_draft=false" >> $GITHUB_ENV
echo "release_prerelease=false" >> $GITHUB_ENV

echo "release_body=" >> $GITHUB_ENV


echo "release_dirPath=${basePath}/Publish/release/release-zip" >> $GITHUB_ENV
echo "release_version=${version}" >> $GITHUB_ENV

#filePath=$basePath/Publish/release/release-zip/Sers-ServiceCenter(net6.0)-${version}.zip
#fileType="${filePath##*.}"
#echo "release_assetPath=${filePath}" >> $GITHUB_ENV
#echo "release_assetName=${APPNAME}-${version}.${fileType}" >> $GITHUB_ENV
#echo "release_contentType=application/zip" >> $GITHUB_ENV


# draft or preivew
if [[ $version =~ "preview" ]]
then
  echo preivew
  echo "release_prerelease=true" >> $GITHUB_ENV
else
  if  [[ "" = $(echo $version | tr -d "0-9\.") ]]
  then
    echo release
  else
    echo draft
    echo "release_draft=true" >> $GITHUB_ENV
  fi
fi

