#���ͻ�ȡqps����
curl -H "Cookie: user=admin_123456" http://192.168.56.1:4580/_gover_/serviceCenter/statistics


#��ʾqps
curl -s -H "Cookie: user=admin_123456" http://192.168.56.1:4580/_gover_/serviceCenter/statistics | grep -Eo '[0-9|\.]+'


#ÿ����ʾһ��qps
for i in {1..10}   
do  
curl -s -H "Cookie: user=admin_123456" http://192.168.56.1:4580/_gover_/serviceCenter/statistics | grep -Eo '[0-9|\.]+'
sleep 1
done  
 

 
 