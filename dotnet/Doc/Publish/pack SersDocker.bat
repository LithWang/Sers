
set netVersion=net5.0

@echo "copy  SersDocker"
xcopy  "..\PublishFile\SersDocker" "SersDocker" /e /i /r /y

@echo "copy Demo"
xcopy  "SersPublish\%netVersion%\Demo\appsettings.json" "SersDocker\docker����Sers\Demo" 
xcopy  "SersPublish\%netVersion%\Demo" "SersDocker\docker��������Sers\demo_station\root\app\Demo" /e /i /r /y

@echo "copy Gateway"
xcopy  "SersPublish\%netVersion%\Gateway\appsettings.json" "SersDocker\docker����Sers\Gateway" 
xcopy  "SersPublish\%netVersion%\Gateway" "SersDocker\docker��������Sers\gateway\root\app\Gateway" /e /i /r /y

@echo "copy Gover"
xcopy  "SersPublish\%netVersion%\Gover\appsettings.json" "SersDocker\docker����Sers\Gover" 
xcopy  "SersPublish\%netVersion%\Gover" "SersDocker\docker��������Sers\gover\root\app\Gover" /e /i /r /y

@echo "copy Robot"
xcopy  "SersPublish\%netVersion%\Robot\appsettings.json" "SersDocker\docker����Sers\Robot" 
xcopy  "SersPublish\%netVersion%\Robot" "SersDocker\docker��������Sers\demo_robot\root\app\Robot" /e /i /r /y

@echo "copy ServiceCenter"
xcopy  "SersPublish\%netVersion%\ServiceCenter\appsettings.json" "SersDocker\docker����Sers\ServiceCenter" 
xcopy  "SersPublish\%netVersion%\ServiceCenter" "SersDocker\docker��������Sers\servicecenter\root\app\ServiceCenter" /e /i /r /y

@echo "copy SersAll"
xcopy  "Sers����ѹ��\%netVersion%\ServiceCenter\appsettings.json" "SersDocker\docker����Sers\SersAll" 
xcopy  "Sers����ѹ��\%netVersion%\ServiceCenter" "SersDocker\docker��������Sers\demo_sersall\root\app\ServiceCenter" /e /i /r /y
 