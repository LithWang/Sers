:: start Sers\dotnet\Doc\Publish

cd /d Sers
call "nuget һ���������ϴ�.bat"
cd /d ..


cd /d Sers\dotnet\Doc\Publish

call "publish sers(netcoreapp2.1).bat"
call "publish sersѹ��-����ѹ��(netcoreapp2.1).bat"
call "publish sersѹ��-�ֲ�ʽѹ��(netcoreapp2.1).bat"

call "publish sers(net6.0).bat"
call "publish sersѹ��-����ѹ��(net6.0).bat"
call "publish sersѹ��-�ֲ�ʽѹ��(net6.0).bat"

call "pack SersDocker.bat"


call "publish CLѹ��.bat"


cd /d ../../../..

 
cd /d ����ѹ����
call "����Sersѹ����.bat" 
start Publish
cd /d ..

echo succeed
echo succeed
echo succeed

pause