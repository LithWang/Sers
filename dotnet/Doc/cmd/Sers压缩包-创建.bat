::��ȡ��ǰ�汾��
:: set version=2.1.1.356 
for /f "tokens=3 delims=><" %%a in ('type ..\Sers\dotnet\Library\Vit\Vit.Core\Vit.Core\Vit.Core.csproj^|findstr "<Version>.*Version"') do set version=%%a



echo ["%version%"]

 
mkdir Publish
mkdir Publish\Sers%version%

cd /d ..\Sers\dotnet\Doc\Publish

echo 1.���� nuget-Sers.zip
dotnet ../../../../����ѹ����/FileZip/FileZip.dll zip -i "nuget" -o "../../../../����ѹ����/Publish/Sers%version%/nuget-Sers%version%.zip"
 

echo 2.���� SersPublish.zip
dotnet ../../../../����ѹ����/FileZip/FileZip.dll zip -i "SersPublish" -o "../../../../����ѹ����/Publish/Sers%version%/SersPublish%version%.zip"

echo 3.���� CLѹ��.zip
dotnet ../../../../����ѹ����/FileZip/FileZip.dll zip -i "CLѹ��" -o "../../../../����ѹ����/Publish/Sers%version%/CLѹ��%version%.zip"

echo 4.���� Sersѹ��.zip
dotnet ../../../../����ѹ����/FileZip/FileZip.dll zip -i "Sersѹ��" -o "../../../../����ѹ����/Publish/Sers%version%/Sersѹ��%version%.zip"




echo 5.���� docker��������Sers.zip
dotnet ../../../../����ѹ����/FileZip/FileZip.dll zip -i "SersDocker/docker��������Sers" -o "../../../../����ѹ����/Publish/Sers%version%/docker��������Sers%version%.zip"

echo 6.���� docker����Sers.zip
dotnet ../../../../����ѹ����/FileZip/FileZip.dll zip -i "SersDocker/docker����Sers" -o "../../../../����ѹ����/Publish/Sers%version%/docker����Sers%version%.zip" 


cd /d ..\..\..\..\����ѹ����





 



:: pause

