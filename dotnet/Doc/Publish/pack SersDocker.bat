

@echo "copy  SersDocker"
xcopy  "..\PublishFile\SersDocker" "SersDocker" /e /i /r /y

@echo "copy Demo"
xcopy  "SersPublish\Demo\appsettings.json" "SersDocker\docker����Sers\Demo" 
xcopy  "SersPublish\Demo" "SersDocker\docker��������Sers\demo_station\root\app\Demo" /e /i /r /y

@echo "copy Gateway"
xcopy  "SersPublish\Gateway\appsettings.json" "SersDocker\docker����Sers\Gateway" 
xcopy  "SersPublish\Gateway" "SersDocker\docker��������Sers\gateway\root\app\Gateway" /e /i /r /y

@echo "copy Gover"
xcopy  "SersPublish\Gover\appsettings.json" "SersDocker\docker����Sers\Gover" 
xcopy  "SersPublish\Gover" "SersDocker\docker��������Sers\gover\root\app\Gover" /e /i /r /y

@echo "copy Robot"
xcopy  "SersPublish\Robot\appsettings.json" "SersDocker\docker����Sers\Robot" 
xcopy  "SersPublish\Robot" "SersDocker\docker��������Sers\demo_robot\root\app\Robot" /e /i /r /y

@echo "copy ServiceCenter"
xcopy  "SersPublish\ServiceCenter\appsettings.json" "SersDocker\docker����Sers\ServiceCenter" 
xcopy  "SersPublish\ServiceCenter" "SersDocker\docker��������Sers\servicecenter\root\app\ServiceCenter" /e /i /r /y

@echo "copy SersAll"
xcopy  "Sers����ѹ��\ServiceCenter\appsettings.json" "SersDocker\docker����Sers\SersAll" 
xcopy  "Sers����ѹ��\ServiceCenter" "SersDocker\docker��������Sers\demo_sersall\root\app\ServiceCenter" /e /i /r /y
 