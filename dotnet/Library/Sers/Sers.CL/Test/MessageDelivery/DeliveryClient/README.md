#--------------------------------
qps 160�� 
no sleep
1  server 
20 client thead:1000   msgLen:1
#--------------------------------


#���������
dotnet /root/app/DeliveryServer/DeliveryServer.dll


#�����ͻ���
dotnet /root/app/DeliveryClient/DeliveryClient.dll 192.168.10.10 4501 20000 150 


#��̨�����ͻ���
dotnet /root/app/DeliveryClient/DeliveryClient.dll 192.168.10.10 4501 10000 150 > /root/app/console.log 2>&1 &



#ɱ�����пͻ���
kill -s 9 `pgrep -f 'DeliveryClient.dll'`




#--------------------------------
����20������
dotnet DeliveryClient.dll 192.168.10.11 4501 300 102 > console.log 2>&1 &

qpsΪ ������


#--------------------------------
����20������
dotnet DeliveryClient.dll 192.168.10.11 4501 300 512 > console.log 2>&1 &

qpsΪ 1����

ʵʱ����Ϊ   ��:500MB/s  д:500MB/s



#------------------------------------
centos8 ThreadWait
thread = 10000*2		msgLen = 150       qps = 180��





#------------------------------------
windows ThreadWait
thread = 40000		msgLen = 1       qps = 117��


#------------------------------------
windows Timer
thread = 40000		msgLen = 1       qps = 116��










