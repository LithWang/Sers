
cd /d ../Publish


set netVersion=netcoreapp2.1
set basePath=Sersѹ��\sersѹ��-�ֲ�ʽѹ��%netVersion%


@echo "copy  station"
xcopy  "SersPublish\%netVersion%\ServiceCenter" "%basePath%\ServiceCenter" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Demo" "%basePath%\Demo" /e /i /r /y
xcopy  "SersPublish\%netVersion%\Robot" "%basePath%\Robot" /e /i /r /y


@echo "copy PublishFile"
xcopy  "..\PublishFile\Sersѹ��\�ֲ�ʽѹ��" "%basePath%" /e /i /r /y

cd /d ../cmd
