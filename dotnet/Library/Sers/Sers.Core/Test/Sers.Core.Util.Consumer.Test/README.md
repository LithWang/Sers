
#--------------------------------
cd Sers.Core.Util.PubSub.Test
dotnet Sers.Core.Util.PubSub.Test.dll 

����20��������
����22��������

//disruptor = new Disruptor<Entry>(() => new Entry(), 2 << 18, TaskScheduler.Default, ProducerType.Multi, new BlockingWaitStrategy());   //qps 350��
//disruptor = new Disruptor<Entry>(() => new Entry(), 2 << 18, TaskScheduler.Default, ProducerType.Multi, new SleepingWaitStrategy());   //qps 580��
disruptor = new Disruptor<Entry>(() => new Entry(), 2 << 18, TaskScheduler.Default, ProducerType.Multi, new YieldingWaitStrategy());     //qps 590��
 
Worker_BlockingCollection  //qps 260��

 