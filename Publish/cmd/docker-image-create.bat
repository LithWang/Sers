
cd /d ../release/release

set netVersion=net6.0

echo copy SersDocker
xcopy  "../../PublishFile/SersDocker" "." /e /i /r /y

echo copy sers
xcopy  "SersPublish\%netVersion%\ServiceCenter\appsettings.json" "docker����Sers\sers" 
xcopy  "SersPublish\%netVersion%\ServiceCenter" "docker��������Sers\sers\app" /e /i /r /y


echo copy sers-gateway
xcopy  "SersPublish\%netVersion%\Gateway\appsettings.json" "docker����Sers\sers-gateway" 
xcopy  "SersPublish\%netVersion%\Gateway" "docker��������Sers\sers-gateway\app" /e /i /r /y


echo copy sers-gover
xcopy  "SersPublish\%netVersion%\Gover\appsettings.json" "docker����Sers\sers-gover" 
xcopy  "SersPublish\%netVersion%\Gover" "docker��������Sers\sers-gover\app" /e /i /r /y


echo copy sers-demo
xcopy  "SersPublish\%netVersion%\Demo\appsettings.json" "docker����Sers\sers-demo" 
xcopy  "SersPublish\%netVersion%\Demo" "docker��������Sers\sers-demo\app" /e /i /r /y


echo copy sers-demo-robot
xcopy  "SersPublish\%netVersion%\Robot\appsettings.json" "docker����Sers\sers-demo-robot" 
xcopy  "SersPublish\%netVersion%\Robot" "docker��������Sers\sers-demo-robot\app" /e /i /r /y


echo copy sers-demo-sersall
xcopy  "Sersѹ��\sersѹ��-����ѹ��%netVersion%\ServiceCenter\appsettings.json" "docker����Sers\sers-demo-sersall" 
xcopy  "Sersѹ��\sersѹ��-����ѹ��%netVersion%\ServiceCenter" "docker��������Sers\sers-demo-sersall\app" /e /i /r /y



echo %~n0.bat ִ�гɹ���

cd /d ../../cmd


 