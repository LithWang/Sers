
cd /d ../Publish

set netVersion=net6.0
set basePath=Sersѹ��\sersѹ��-����ѹ��%netVersion%


@echo "copy  ServiceCenter"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "%basePath%\ServiceCenter" /e /i /r /y

@echo "copy demo"
xcopy  "SersPublish\%netVersion%\Demo\wwwroot" "%basePath%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.dll" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.pdb" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.xml" "%basePath%\ServiceCenter" /i /r /y


@echo "copy  xml of Robot"
xcopy  "SersPublish\%netVersion%\Robot\wwwroot" "%basePath%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.dll" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.pdb" "%basePath%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.xml" "%basePath%\ServiceCenter" /i /r /y


@echo "copy PublishFile"
xcopy  "..\PublishFile\Sersѹ��\����ѹ��" "%basePath%" /e /i /r /y


cd /d ../cmd