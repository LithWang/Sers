@echo off

::���ñ����ӳ�
setlocal EnableDelayedExpansion


 




::(x.1)��ȡbasePath
set curPath=%cd%
cd /d "%~dp0"
cd /d ../..
set basePath=%cd%
set publishPath=%basePath%/Publish/release/release/CLѹ��





echo ------------------------------------------------------------------
:: ����Sersѹ��CL
echo ����Sersѹ��CL
::publish Client
cd /d "%basePath%\dotnet\Library\Sers\Sers.CL\Test\CommunicationManage\CmClient"
dotnet build --configuration Release
dotnet publish --configuration Release --output "%publishPath%\CmClient"
@if errorlevel 1 (echo . & echo .  & echo �������Ų飡& pause) 

::publish Server
cd /d "%basePath%\dotnet\Library\Sers\Sers.CL\Test\CommunicationManage\CmServer"
dotnet build --configuration Release
dotnet publish --configuration Release --output "%publishPath%\CmServer"
@if errorlevel 1 (echo . & echo .  & echo �������Ų飡& pause) 


::copy bat
xcopy  "%basePath%\Publish\PublishFile\CLѹ��" "%publishPath%" /e /i /r /y




echo ------------------------------------------------------------------
:: ����Sersѹ��
for %%i in (netcoreapp2.1,net6.0) do (  
	set netVersion=%%i
	set appPath=%basePath%/Publish/release/release/SersPublish/!netVersion!

	echo ����Sersѹ��-!netVersion!

	::����ѹ��
	set targetPath=%basePath%/Publish/release/release/Sersѹ��/sersѹ��-����ѹ��!netVersion!

	::(x.x.1)copy ServiceCenter
	xcopy "!appPath!\ServiceCenter" "!targetPath!\ServiceCenter" /e /i /r /y

	::(x.x.2)copy demo
	xcopy "!appPath!\Demo\wwwroot" "!targetPath!\ServiceCenter\wwwroot" /e /i /r /y
	xcopy "!appPath!\Demo\Did.SersLoader.Demo.dll" "!targetPath!\ServiceCenter" /i /r /y
	xcopy "!appPath!\Demo\Did.SersLoader.Demo.pdb" "!targetPath!\ServiceCenter" /i /r /y
	xcopy "!appPath!\Demo\Did.SersLoader.Demo.xml" "!targetPath!\ServiceCenter" /i /r /y

	::(x.x.3)copy Robot
	xcopy "!appPath!\Robot\wwwroot" "!targetPath!\ServiceCenter\wwwroot" /e /i /r /y
	xcopy "!appPath!\Robot\App.Robot.Station.dll" "!targetPath!\ServiceCenter" /i /r /y
	xcopy "!appPath!\Robot\App.Robot.Station.pdb" "!targetPath!\ServiceCenter" /i /r /y
	xcopy "!appPath!\Robot\App.Robot.Station.xml" "!targetPath!\ServiceCenter" /i /r /y

	::(x.x.4)copy bat
	xcopy "%basePath%\Publish\PublishFile\Sersѹ��\����ѹ��" "!targetPath!" /e /i /r /y



	::�ֲ�ʽѹ��
	set targetPath=%basePath%/Publish/release/release/Sersѹ��/sersѹ��-�ֲ�ʽѹ��!netVersion!

	::(x.x.1)copy  station
	xcopy "!appPath!\ServiceCenter" "!targetPath!\ServiceCenter" /e /i /r /y
	xcopy "!appPath!\Demo" "!targetPath!\Demo" /e /i /r /y
	xcopy "!appPath!\Robot" "!targetPath!\Robot" /e /i /r /y

	::(x.x.2)copy bat
	xcopy  "%basePath%\Publish\PublishFile\Sersѹ��\�ֲ�ʽѹ��" "!targetPath!" /e /i /r /y
)




 

 


echo %~n0.bat ִ�гɹ���

cd /d "%curPath%"









