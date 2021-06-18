
cd /d ../../

echo ------------------------------------------------------------------
echo '(x.1.1)Sersѹ��CL-publish Client'
cd /d Library\Sers\Sers.CL\Test\CommunicationManage\CmClient
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\..\Doc\Publish\CLѹ��\CmClient
@if errorlevel 1 (echo . & echo .  & echo �������Ų飡& pause) 
cd /d ../../../../../../
   
echo '(x.1.2)Sersѹ��CL-publish Server'
cd /d Library\Sers\Sers.CL\Test\CommunicationManage\CmServer
dotnet build --configuration Release
dotnet publish --configuration Release --output ..\..\..\..\..\..\Doc\Publish\CLѹ��\CmServer
@if errorlevel 1 (echo . & echo .  & echo �������Ų飡& pause) 
cd /d ../../../../../../

cd /d Doc\Publish

@echo "(x.1.3)Sersѹ��CL-copy bat"
 xcopy  "..\PublishFile\CLѹ��" "CLѹ��" /e /i /r /y


cd /d ../cmd




echo ------------------------------------------------------------------

cd /d ../Publish

set netVersion=netcoreapp2.1
set basePath=Sersѹ��\sersѹ��-����ѹ��%netVersion%


@echo "(x.2.1)sersѹ��-publish����ѹ��(netcoreapp2.1)-copy  ServiceCenter"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "%basePath%\ServiceCenter" /e /i /r /y

@echo "copy demo"
xcopy  "SersPublish\%netVersion%\Demo\wwwroot" "%basePath%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.dll" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.pdb" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.xml" "%basePath%\ServiceCenter" /i /r /y


@echo "(x.2.2)sersѹ��-publish����ѹ��(netcoreapp2.1)-copy Robot"
xcopy  "SersPublish\%netVersion%\Robot\wwwroot" "%basePath%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.dll" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.pdb" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.xml" "%basePath%\ServiceCenter" /i /r /y


@echo "(x.2.3)sersѹ��-publish����ѹ��(netcoreapp2.1)-copy PublishFile"
xcopy  "..\PublishFile\Sersѹ��\����ѹ��" "%basePath%" /e /i /r /y

cd /d ../cmd



echo ------------------------------------------------------------------


cd /d ../Publish


set netVersion=netcoreapp2.1
set basePath=Sersѹ��\sersѹ��-�ֲ�ʽѹ��%netVersion%


@echo "(x.3.1)sersѹ��-publish�ֲ�ʽѹ��(netcoreapp2.1)-copy  station"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "%basePath%\ServiceCenter" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo" "%basePath%\Demo" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot" "%basePath%\Robot" /e /i /r /y


@echo "(x.3.2)sersѹ��-publish�ֲ�ʽѹ��(netcoreapp2.1)-copy PublishFile"
xcopy  "..\PublishFile\Sersѹ��\�ֲ�ʽѹ��" "%basePath%" /e /i /r /y

cd /d ../cmd


echo ------------------------------------------------------------------


cd /d ../Publish

set netVersion=net6.0
set basePath=Sersѹ��\sersѹ��-����ѹ��%netVersion%


@echo "(x.4.1)sersѹ��-publish����ѹ��(net6.0)-copy  ServiceCenter"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "%basePath%\ServiceCenter" /e /i /r /y

@echo "(x.4.2)sersѹ��-publish����ѹ��(net6.0)-copy demo"
xcopy  "SersPublish\%netVersion%\Demo\wwwroot" "%basePath%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.dll" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.pdb" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.xml" "%basePath%\ServiceCenter" /i /r /y


@echo "(x.4.3)sersѹ��-publish����ѹ��(net6.0)-copy Robot"
xcopy  "SersPublish\%netVersion%\Robot\wwwroot" "%basePath%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.dll" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.pdb" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.xml" "%basePath%\ServiceCenter" /i /r /y


@echo "(x.4.4)sersѹ��-publish����ѹ��(net6.0)-copy PublishFile"
xcopy  "..\PublishFile\Sersѹ��\����ѹ��" "%basePath%" /e /i /r /y


cd /d ../cmd

echo ------------------------------------------------------------------



cd /d ../Publish


set netVersion=net6.0
set basePath=Sersѹ��\sersѹ��-�ֲ�ʽѹ��%netVersion%


@echo "(x.5.1)sersѹ��-publish�ֲ�ʽѹ��(net6.0)-copy  station"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "%basePath%\ServiceCenter" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo" "%basePath%\Demo" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot" "%basePath%\Robot" /e /i /r /y


@echo "(x.5.2)sersѹ��-publish�ֲ�ʽѹ��(net6.0)-copy PublishFile"
xcopy  "..\PublishFile\Sersѹ��\�ֲ�ʽѹ��" "%basePath%" /e /i /r /y

cd /d ../cmd













