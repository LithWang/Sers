:: start Sers\dotnet\Doc\Publish


call "nuget-pack.bat"
pause
call "sers-publish(netcoreapp2.1).bat"
pause
call "sers-publish(net6.0).bat"
pause
call "docker-build.bat"
pause
call "sersѹ��-publish.bat"
 pause

::call "Sersѹ����-����.bat" 
 

echo %~n0.bat ִ�гɹ���

pause