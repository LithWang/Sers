cd /d Demo

:begin
dotnet Did.SersLoader.Demo.dll

 
 TIMEOUT /T 10
@echo restart
goto begin