## MqManager

### (x.1)Frame����֡��ʽ
��1���֣� ��Ϣģʽ EFrameType         1 byte
��2���֣� ������� ERequestType     1 byte
��3���֣� ��Ϣ����

### (x.2)��Ϣ������
��Ϣ����3��(EFrameType)

	1.request
	//����Ӧ��Ϣ�е�����

	2.reply
	//����Ӧ��Ϣ�еĻ�Ӧ

	3.message
	//�޻�Ӧ��Ϣ����Ϣ����



### (x.3)ģʽ����

#### (x.x.1) ����Ӧ����ReqRepģʽ��

>ʹ��ReqRepFrame��ʽ����
//ReqRepFrame ��Ϣ֡(byte[])	 
��1���֣� �����ʶ��reqKey��(long)			����Ϊ8�ֽ�
��2���֣� ��Ϣ����(oriMsg)


�ڲ��ַ�2��
##### (x.x.x.1) heartBeat
>����������RequestTypeΪheartBeat
>�������ݺͻ�Ӧ���ݶ�Ϊ�汾��

##### ��x.x.x.2) app
>����api���á�RequestTypeΪapp 

##### (x.x.x.3)ERequestTypeö��˵�� ��byte��
	0: app
	1: heartBeat



### (x.x.2) Message
>�޻�Ӧ��Ϣ��������Ϣ��