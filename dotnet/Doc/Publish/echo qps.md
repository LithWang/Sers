#���ͻ�ȡqps����
curl -H "Cookie: user=admin_123456" http://localhost:4580/_gover_/serviceCenter/statistics


#��ʾqps
curl -s -H "Cookie: user=admin_123456" http://localhost:4580/_gover_/serviceCenter/statistics | grep -Eo '[0-9|\.]+'


#ÿ3����ʾһ��qps
for i in {1..10}   
do  
curl -s -H "Cookie: user=admin_123456" http://localhost:4580/_gover_/serviceCenter/statistics | grep -Eo '[0-9|\.]+'
sleep 3
done  

#ÿ3����ʾһ��qps
for i in {1..100}; do curl -s -H "Cookie: user=admin_123456" http://localhost:4580/_gover_/serviceCenter/statistics | grep -Eo '[0-9|\.]+'; sleep 3; done 



#----------------------------------------------
# sers����ѹ��(net6.0)

dotnet /root/app/ServiceCenter/App.ServiceCenter.dll 

http://127.0.0.1:4580/_gover_/index.html?user=admin_123456





CentOs8(2x24��) .net6

Sers.CL.workThreadCount			1
Sers.CL.Client-Iocp.Mode		Simple
Sers.RpcDataSerializeMode		BytePointor
Sers.LocalApiService.workThreadCount	{workThread}
Vit.ConsumerMode			ConsumerCache_BlockingCollection


��ʽ �߳���������/����	qps��cpu�����ʣ�
    workThread/requestThread


ApiClientAsync 16/16	140-150��15%��   

ApiClientAsync 18/18	150-180��18%�� 

ApiClientAsync 20/20	160-230��18%��
   
ApiClientAsync 22/22	160-190��19%��	

ApiClientAsync 24/24	160-180��21%��   




#----------------------------------------------
# sers�ֲ�ʽѹ��(net6.0)

dotnet /root/app/ServiceCenter/App.ServiceCenter.dll 

 


dotnet /root/app/Demo/Did.SersLoader.Demo.dll  > console.log 2>&1 &


dotnet /root/app/Robot/App.Robot.Station.dll  > console.log 2>&1 &


#ɱ������
kill -s 9 `pgrep -f 'dotnet'`





CentOs8(2x24��) .net6


# ServiceCenter:

Sers.CL.workThreadCount			4
Sers.CL.Client-Iocp.Mode		Timer
Sers.RpcDataSerializeMode		BytePointor
Sers.LocalApiService.workThreadCount	4
Vit.ConsumerMode			ConsumerCache_BlockingCollection



# Demo and Robot

Sers.CL.workThreadCount			2
Sers.CL.Client-Iocp.Mode		Timer
Sers.RpcDataSerializeMode		BytePointor
Sers.LocalApiService.workThreadCount	20
Vit.ConsumerMode			ConsumerCache_BlockingCollection




��ʽ �߳���������/����	qps��cpu������-����� �ͻ��ˣ�
    workThread/requestThread	

ApiClientAsync 20/5000		18-20��20% 14%��   