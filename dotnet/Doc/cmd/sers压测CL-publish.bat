
cd /d ../../

echo 'publish Client'
cd /d Library\Sers\Sers.CL\Test\CommunicationManage\CmClient
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\..\Doc\Publish\CLѹ��\CmClient
@if errorlevel 1 (echo . & echo .  & echo �������Ų飡& pause) 
cd /d ../../../../../../
   
echo 'publish Server'
cd /d Library\Sers\Sers.CL\Test\CommunicationManage\CmServer
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\..\Doc\Publish\CLѹ��\CmServer
@if errorlevel 1 (echo . & echo .  & echo �������Ų飡& pause) 
cd /d ../../../../../../

cd /d Doc\Publish

@echo "copy from PublishFile"
 xcopy  "..\PublishFile\CLѹ��" "CLѹ��" /e /i /r /y

echo 'publish CLѹ�� succeed��'
echo 'publish CLѹ�� succeed��'
echo 'publish CLѹ�� succeed��'


cd /d ../cmd