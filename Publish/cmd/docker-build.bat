
cd /d ../Publish

set netVersion=net6.0

echo copy SersDocker
xcopy  "..\PublishFile\SersDocker" "SersDocker" /e /i /r /y


echo copy sers
xcopy  "SersPublish\%netVersion%\ServiceCenter\appsettings.json" "SersDocker\docker����Sers\sers" 
xcopy  "SersPublish\%netVersion%\ServiceCenter" "SersDocker\docker��������Sers\sers\app" /e /i /r /y


echo copy sers-gateway
xcopy  "SersPublish\%netVersion%\Gateway\appsettings.json" "SersDocker\docker����Sers\sers-gateway" 
xcopy  "SersPublish\%netVersion%\Gateway" "SersDocker\docker��������Sers\sers-gateway\app" /e /i /r /y


echo copy sers-gover
xcopy  "SersPublish\%netVersion%\Gover\appsettings.json" "SersDocker\docker����Sers\sers-gover" 
xcopy  "SersPublish\%netVersion%\Gover" "SersDocker\docker��������Sers\sers-gover\app" /e /i /r /y


echo copy sers-demo
xcopy  "SersPublish\%netVersion%\Demo\appsettings.json" "SersDocker\docker����Sers\sers-demo" 
xcopy  "SersPublish\%netVersion%\Demo" "SersDocker\docker��������Sers\sers-demo\app" /e /i /r /y


echo copy sers-demo-robot
xcopy  "SersPublish\%netVersion%\Robot\appsettings.json" "SersDocker\docker����Sers\sers-demo-robot" 
xcopy  "SersPublish\%netVersion%\Robot" "SersDocker\docker��������Sers\sers-demo-robot\app" /e /i /r /y


echo copy sers-demo-sersall
xcopy  "Sersѹ��\sersѹ��-����ѹ��%netVersion%\ServiceCenter\appsettings.json" "SersDocker\docker����Sers\sers-demo-sersall" 
xcopy  "Sersѹ��\sersѹ��-����ѹ��%netVersion%\ServiceCenter" "SersDocker\docker��������Sers\sers-demo-sersall\app" /e /i /r /y



echo %~n0.bat ִ�гɹ���

cd /d ../cmd


 