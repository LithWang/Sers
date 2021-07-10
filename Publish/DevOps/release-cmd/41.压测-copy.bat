@echo off

::���ñ����ӳ�
setlocal EnableDelayedExpansion



::(x.1)��ȡbasePath
set curPath=%cd%
cd /d "%~dp0"
cd /d ../../..
set basePath=%cd%



::(x.2)
set publishPath=%basePath%/Publish/release/release/ѹ��





echo ------------------------------------------------------------------
echo "(x.3)����CLѹ��"

::Client
cd /d "%basePath%\dotnet\Library\Sers\Sers.CL\Test\CommunicationManage\CmClient"
dotnet build --configuration Release
dotnet publish --configuration Release --output "%publishPath%\CLѹ��netcoreapp2.1\CmClient"
@if errorlevel 1 (echo . & echo .  & echo ���������Ų飡& pause) 

::Server
cd /d "%basePath%\dotnet\Library\Sers\Sers.CL\Test\CommunicationManage\CmServer"
dotnet build --configuration Release
dotnet publish --configuration Release --output "%publishPath%\CLѹ��netcoreapp2.1\CmServer"
@if errorlevel 1 (echo . & echo .  & echo ���������Ų飡& pause) 


::copy bat
xcopy  "%basePath%\Publish\ReleaseFile\ѹ��\CLѹ��" "%publishPath%\CLѹ��netcoreapp2.1" /e /i /r /y




echo ------------------------------------------------------------------
::(x.4)����Sersѹ��
for %%i in (netcoreapp2.1,net6.0) do (  
	set netVersion=%%i
	set appPath=%basePath%/Publish/release/release/Station^(!netVersion!^)

	echo ���� ѹ��-!netVersion!

	::����ѹ��
	set targetPath=%publishPath%/����ѹ��!netVersion!

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

	::(x.x.4)copy ReleaseFile
	xcopy "%basePath%\Publish\ReleaseFile\ѹ��\����ѹ��" "!targetPath!" /e /i /r /y



	::�ֲ�ʽѹ��
	set targetPath=%publishPath%/�ֲ�ʽѹ��!netVersion!

	::(x.x.1)copy  station
	xcopy "!appPath!\ServiceCenter" "!targetPath!\ServiceCenter" /e /i /r /y
	xcopy "!appPath!\Demo" "!targetPath!\Demo" /e /i /r /y
	xcopy "!appPath!\Robot" "!targetPath!\Robot" /e /i /r /y

	::(x.x.2)copy ReleaseFile
	xcopy  "%basePath%\Publish\ReleaseFile\ѹ��\�ֲ�ʽѹ��" "!targetPath!" /e /i /r /y
)



 


echo %~n0.bat ִ�гɹ���

cd /d "%curPath%"



