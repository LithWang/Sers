

1 server 
20 client 1000thead   qps 160��

cd /root/app
dotnet DeliveryServer/DeliveryServer.dll




cd /root/app
dotnet DeliveryClient/DeliveryClient.dll 127.0.0.1 4501 100 1



dotnet DeliveryClient/DeliveryClient.dll 127.0.0.1 4501 100 1 > console.log 2>&1 &


#ɱ��mc�û��� 
kill -s 9 `pgrep -f 'DeliveryClient.dll'`

#--------------------------------
 
dotnet DeliveryClient.dll 192.168.10.11 4501 200 1

qpsΪ 7.3��
cpu  92%






cpu  87%











#--------------------------------
����20������
dotnet DeliveryClient.dll 192.168.10.11 4501 300 102 > console.log 2>&1 &

qpsΪ ������


#--------------------------------
����20������
dotnet DeliveryClient.dll 192.168.10.11 4501 300 512 > console.log 2>&1 &

qpsΪ 1����

ʵʱ����Ϊ   ��:500MB/s  д:500MB/s