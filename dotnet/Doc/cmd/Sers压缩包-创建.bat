::��ȡ��ǰ�汾��
:: set version=2.1.1.356 
for /f "tokens=3 delims=><" %%a in ('type ..\..\Library\Vit\Vit.Core\Vit.Core\Vit.Core.csproj^|findstr "<Version>.*Version"') do set version=%%a



echo ["%version%"]

cd /d ..\Publish
 

mkdir Publish
mkdir Publish\Sers%version%



echo 1.���� nuget-Sers.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "nuget" -o "Publish/Sers%version%/nuget-Sers%version%.zip"
 

echo 2.���� SersPublish.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "SersPublish" -o "Publish/Sers%version%/SersPublish%version%.zip"

echo 3.���� CLѹ��.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "CLѹ��" -o "Publish/Sers%version%/CLѹ��%version%.zip"

echo 4.���� Sersѹ��.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "Sersѹ��" -o ".Publish/Sers%version%/Sersѹ��%version%.zip"




echo 5.���� docker��������Sers.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "SersDocker/docker��������Sers" -o "Publish/Sers%version%/docker��������Sers%version%.zip"

echo 6.���� docker����Sers.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "SersDocker/docker����Sers" -o "Publish/Sers%version%/docker����Sers%version%.zip" 


cd /d ..\cmd


:: pause

