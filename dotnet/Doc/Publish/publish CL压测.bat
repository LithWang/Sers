cd /d ../../

echo 'publish Client'
cd /d Sers\Sers.CL\Test\CommunicationManage\Client
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\Doc\Publish\CLѹ��\CLClient
cd /d ../../../../../
   
echo 'publish Client'
cd /d Sers\Sers.CL\Test\CommunicationManage\Server
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\Doc\Publish\CLѹ��\CLServer
cd /d ../../../../../

cd /d Doc\Publish

@echo "copy from PublishFile"
 xcopy  "..\PublishFile\CLѹ��" "CLѹ��" /e /i /r /y

echo 'publish CLѹ�� succeed��'
echo 'publish CLѹ�� succeed��'
echo 'publish CLѹ�� succeed��'


