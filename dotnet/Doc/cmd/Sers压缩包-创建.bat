::��ȡ��ǰ�汾��
:: set version=2.1.1.356 
for /f "tokens=3 delims=><" %%a in ('type ..\..\Library\Sers\Sers.Core\Sers.Core\Sers.Core.csproj^|findstr "<Version>.*Version"') do set version=%%a



echo ["%version%"]

cd /d ..\Publish
 
mkdir Publish\Sers%version%



echo 1.���� nuget-Sers
xcopy "nuget" "Publish/Sers%version%/nuget-Sers" /e /i /r /y 

echo 2.���� SersPublish
xcopy "SersPublish" "Publish/Sers%version%/SersPublish" /e /i /r /y

echo 3.���� CLѹ��
xcopy "CLѹ��" "Publish/Sers%version%/CLѹ��" /e /i /r /y

echo 4.���� Sersѹ��
xcopy "Sersѹ��" "Publish/Sers%version%/Sersѹ��" /e /i /r /y

echo 5.���� docker��������Sers
xcopy "SersDocker/docker��������Sers" "Publish/Sers%version%/docker��������Sers" /e /i /r /y

echo 6.���� docker����Sers
xcopy "SersDocker/docker����Sers" "Publish/Sers%version%/docker����Sers" /e /i /r /y
 



echo 7.���� Sers%version%.zip
dotnet ../cmd/FileZip/FileZip.dll zip -i "Publish/Sers%version%" -o "Publish/Sers-%version%.zip" 


cd /d ..\cmd


:: pause

