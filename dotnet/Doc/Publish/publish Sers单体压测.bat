

@echo "copy  ServiceCenter"
xcopy  "SersPublish\ServiceCenter" "Sers����ѹ��\ServiceCenter" /e /i /r /y

@echo "copy demo"
xcopy  "SersPublish\Demo\wwwroot" "Sers����ѹ��\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\Demo\Did.SersLoader.Demo.dll" "Sers����ѹ��\ServiceCenter" /i /r /y
xcopy  "SersPublish\Demo\Did.SersLoader.Demo.pdb" "Sers����ѹ��\ServiceCenter" /i /r /y
xcopy  "SersPublish\Demo\Did.SersLoader.Demo.xml" "Sers����ѹ��\ServiceCenter" /i /r /y


@echo "copy  xml of Robot"
xcopy  "SersPublish\Robot\wwwroot" "Sers����ѹ��\ServiceCenter\wwwroot" /e /i /r /y
xcopy  "SersPublish\Robot\App.Robot.Station.dll" "Sers����ѹ��\ServiceCenter" /i /r /y
xcopy  "SersPublish\Robot\App.Robot.Station.pdb" "Sers����ѹ��\ServiceCenter" /i /r /y
xcopy  "SersPublish\Robot\App.Robot.Station.xml" "Sers����ѹ��\ServiceCenter" /i /r /y


@echo "copy PublishFile"
xcopy  "..\PublishFile\Sers����ѹ��" "Sers����ѹ��" /e /i /r /y