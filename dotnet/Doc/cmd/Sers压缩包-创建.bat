::��ȡ��ǰ�汾��
:: set version=2.1.1.356 
for /f "tokens=3 delims=><" %%a in ('type ..\..\Library\Sers\Sers.Core\Sers.Core\Sers.Core.csproj^|findstr "<Version>.*Version"') do set version=%%a



echo ["%version%"]

cd /d ..\Publish
 
mkdir release
mkdir release/Sers-%version%


echo 1.���� nuget
xcopy "nuget" "release/Sers-%version%/nuget" /e /i /r /y 

echo 2.���� SersPublish
xcopy "SersPublish" "release/Sers-%version%/SersPublish" /e /i /r /y

echo 3.���� CLѹ��
xcopy "CLѹ��" "release/Sers-%version%/CLѹ��" /e /i /r /y

echo 4.���� Sersѹ��
xcopy "Sersѹ��" "release/Sers-%version%/Sersѹ��" /e /i /r /y

echo 5.���� docker��������Sers
xcopy "SersDocker/docker��������Sers" "release/Sers-%version%/docker��������Sers" /e /i /r /y

echo 6.���� docker����Sers
xcopy "SersDocker/docker����Sers" "release/Sers-%version%/docker����Sers" /e /i /r /y
 



echo 7.���� Sers-%version%.zip
dotnet ../cmd/FileZip/FileZip.dll zip -p -i "release/Sers-%version%" -o "release/Sers-%version%.zip" 


cd /d ..\cmd


:: pause

