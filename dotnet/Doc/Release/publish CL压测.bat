cd /d ../../

echo 'publish Client'
cd /d Sers\Sers.CL\Test\CommunicationManage\Client
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\Doc\Release\CLѹ��\CLClient
cd /d ../../../../../
   
echo 'publish Client'
cd /d Sers\Sers.CL\Test\CommunicationManage\Server
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\Doc\Release\CLѹ��\CLServer
cd /d ../../../../../

cd /d Doc\Release

@echo copy from ReleaseFile
 xcopy  "..\ReleaseFile\CLѹ��" "CLѹ��" /e /i /r /y

echo 'publish CLѹ�� succeed��'
echo 'publish CLѹ�� succeed��'
echo 'publish CLѹ�� succeed��'


pause