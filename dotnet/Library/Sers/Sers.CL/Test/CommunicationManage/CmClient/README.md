

1 server 
20 client 1000thead   qps 160��
 




cd /root/app
dotnet CmServer/CmServer.dll


cd /root/app
dotnet CmClient/CmClient.dll > console.log 2>&1 &


#ɱ��mc�û��� 
kill -s 9 `pgrep -f 'CmClient.dll'`

#--------------------------------
#--------------------------------

dotnet CLClient.dll > console.log 2>&1 &

����10�����̵�qpsΪ 10��

����1�����̵�qps��4��


 