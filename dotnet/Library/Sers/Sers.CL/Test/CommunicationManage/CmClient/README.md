

 


 
dotnet /root/app/CmServer/CmServer.dll


dotnet /root/app/CmClient/CmClient.dll > console.log 2>&1 &


#ɱ������
kill -s 9 `pgrep -f 'CmClient.dll'`
 
#--------------------------------

dotnet CLClient.dll > console.log 2>&1 &

����10�����̵�qpsΪ 10��

����1�����̵�qps��4��

 
#--------------------------------
# centos8
1server;  2client; 4000 thead;	mode: Timer ;      msgLen:10	qps: 98��

1server;  2client; 1000 thead;	mode: Timer ;      msgLen:100	qps: 84��