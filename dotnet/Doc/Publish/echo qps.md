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





 dotnet /root/app/ServiceCenter/App.ServiceCenter.dll
 

 http://lanxing.cloud:4580/_gover_/index.html?user=admin_123456



 # qps: 150��	workThread: 16	requestThread: 16 

 # qps:		workThread: 24	requestThread: 24 


��ʽ �߳���������/����     qps
workThread/requestThread qps

CentOs8(2x24��) .net6

ApiClientAsync 16/16	140-150��15%��   
ApiClientAsync 24/24	160-180��21%��   

   
ApiClientAsync 22/22	160-190��19%��	 

ApiClientAsync 20/20	160-230��18%��

ApiClientAsync 18/18	150-180��18%��
