# Sers΢����ܹ�Э�飨Sers 2.1.1/release��

SersΪһ�׿�ƽ̨�����ԵĿ�Դ΢����ܹ�Э�顣
�� �����ԣ�Ŀǰ��֧��c#��java��c++��javascript��
�� ������࣬javascript������벻��1000�У�ѹ����ֻ��8KB�����������������ͨ��javascript�����ṩapi����
�� ��Ч�߲�����.net core�汾��2.1.1������QPS���ȶ���15�����ϡ�
�� ����չ�ԣ�����������չ���롣
�� ֧��tcp��zmp��websocket��ipc�ȶ���ͨѶ��ʽ��
�� ���Է�����ʽ����.net core web api���������ֻ��1�С�


Դ���ַ��https://github.com/serset/Sers

�˰汾Ϊv2.1.1�档(RequestQueueģʽ)


# ����
�μ�[Release-Sers-v2.1.1](https://github.com/serset/Sers/tree/2.1.1/release/Release/Sers2.1.1/netcore)

[���Ҳ鿴docker����](https://github.com/serset/Sers/tree/2.1.1/release/Release/Sers2.1.1/netcore/docker)


# ���ܲ���
>���𣨻����У�ServiceCenter Gover Gateway Robot StationDemo�����Ŀ��


>qps������Դ�� ab �� http://ip:6022/ApiStationMng.html ҳ���е�ͳ��

��Ŀ������ͬһ����, Robot��StationDemo��������ServiceCenter��

 robot�ڲ�����	��
  ����	 ��ʽ �߳���������/����     qps	        


i7-7700K(4.2GHZ) 4��8�߳�
win10  ApiClientAsync 8/8	      140�� 


 
CentOs8(2x24��)
.net5 ApiClientAsync 12/12	     130-200��13%��   
 


 
 


   
| Os  |  robot�ڲ�����(8�߳�)   |  abѹ��(32�̣߳�CGateway)   |
| ------------ | ------------ | ------------ |
| Windows10 |  150000 | |
| CentOs7(2��1G) |15000|3500|
| CentOs7(4��1G) |25000|5000|
 

��Ŀ��������ͬһ����,��Ϣ����ʹ��SocketMq
   
| Os  | �����߳��� | qps(�ڲ�����)  | qps(http���ص���-����)  |qps(jmeter����http����-�ⲿ)  |
| ------------ | ------------ | ------------ | ------------ |------------ |
|  Ubuntu(6��2G) | 10 | 7000  | 2000 | 1700 |
|  CentOs7(1��1G) | 10 | 4000  | 1100 | 840 |
|  CentOs7(2��1G) | 10 | 5000  | 1500-2000 | 1300|
|  CentOs7(6��1G) | 10 | 8000-9400  | 3000 | 1800 |
| Windows10| 10 | 6000 | 400| 1600 |
| Server2012(6��2G)| 10 | 15000-17000 |  | 2200 |


# ģ��

## (x.1)��������(ServiceCenter)
>���ܣ�����ע�ᣬ����ַ������ؾ��⣩����Ϣ���ĵȡ����з���վ�㶼��Ҫ���վ��ע�ᡣ


## (x.2)��������(Gover)
>���ܣ������ط���վ�㣬��������������ͳ�Ƶȡ���������ʵ�ʲ����ڷ������ģ���վ��Ϊ����������û����档

�����ɴ򿪵�ַ���й��� http://ip:6022/index.html


  
## (x.3)Http����(ServiceStation)
>���ܣ��ⲿ�ӿ�ͨ�������ص����ڲ�����

�����������汾��c++�棨CGateway����dotnet��(Gateway)�� c++�棨CGateway����Ը���Ч��


## (x.4)����վ��(ServiceStation)

### (x.x.1)StationDemo
>���ܣ�վ��Demo��

dotnet\netcore\Station\StationDemo\App.StationDemo.Station

### (x.x.2)Robot
>���ܣ�����ѭ������ָ���ӿڣ����������ز��ԡ�

dotnet\netcore\Station\Robot\App.Robot.Station
http://ip:6022/_robot_/TaskMng.html
 
 
