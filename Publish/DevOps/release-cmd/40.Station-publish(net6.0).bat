@echo off


::(x.1)��ʼ��
set netVersion=net6.0


::(x.2)�޸�Ҫ������Ŀ��netcore�汾��
VsTool.exe replace -r --path "../../.." --file "App.Gateway.csproj|App.Gover.Gateway.csproj|App.ServiceCenter.csproj|Did.SersLoader.Demo.csproj|App.Robot.Station.csproj" --old "<TargetFramework>netcoreapp2.1</TargetFramework>" --new "<TargetFramework>%netVersion%</TargetFramework>"





::(x.3)������Ŀ
call "40.Station-publish.bat"






::(x.4)��ԭ��Ŀ�İ汾��
VsTool.exe replace -r --path "../../.." --file "App.Gateway.csproj|App.Gover.Gateway.csproj|App.ServiceCenter.csproj|Did.SersLoader.Demo.csproj|App.Robot.Station.csproj" --old "<TargetFramework>%netVersion%</TargetFramework>" --new "<TargetFramework>netcoreapp2.1</TargetFramework>"





echo %~n0.bat ִ�гɹ���
cd /d "%curPath%"