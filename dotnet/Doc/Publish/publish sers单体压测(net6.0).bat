
set netVersion=net6.0



@echo "copy  ServiceCenter"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "Sers����ѹ��\%netVersion%\ServiceCenter" /e /i /r /y

@echo "copy demo"
xcopy  "SersPublish\%netVersion%\Demo\wwwroot" "Sers����ѹ��\%netVersion%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.dll" "Sers����ѹ��\%netVersion%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.pdb" "Sers����ѹ��\%netVersion%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Demo\Did.SersLoader.Demo.xml" "Sers����ѹ��\%netVersion%\ServiceCenter" /i /r /y


@echo "copy  xml of Robot"
xcopy  "SersPublish\%netVersion%\Robot\wwwroot" "Sers����ѹ��\%netVersion%\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.dll" "Sers����ѹ��\%netVersion%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.pdb" "Sers����ѹ��\%netVersion%\ServiceCenter" /i /r /y
xcopy  "SersPublish\%netVersion%\Robot\App.Robot.Station.xml" "Sers����ѹ��\%netVersion%\ServiceCenter" /i /r /y


@echo "copy PublishFile"
xcopy  "..\PublishFile\Sers����ѹ��" "Sers����ѹ��\%netVersion%" /e /i /r /y