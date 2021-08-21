
#--------------------------------
 
dotnet /root/app/publish/Sers.Core.Util.Consumer.Test.dll  8 16 BufferBlock

����20��������
����22��������

//disruptor = new Disruptor<Entry>(() => new Entry(), 2 << 18, TaskScheduler.Default, ProducerType.Multi, new BlockingWaitStrategy());   //qps 350��
//disruptor = new Disruptor<Entry>(() => new Entry(), 2 << 18, TaskScheduler.Default, ProducerType.Multi, new SleepingWaitStrategy());   //qps 580��
disruptor = new Disruptor<Entry>(() => new Entry(), 2 << 18, TaskScheduler.Default, ProducerType.Multi, new YieldingWaitStrategy());     //qps 590��
 
Worker_BlockingCollection  //qps 260��

 
---------------------------------------------------------------------------------

        public static IConsumer<T> CreateConsumer<T>() 
        {

            //return new ConsumerCache<T, Consumer_BlockingCollection<T>>();
            IConsumer<T> consumer;
            switch (ConsumerMode)
            {
                //case "ActionBlock":
                //    consumer = new Consumer_ActionBlock<T>();  // 16 16 700��     24 24 900-1000��
                //    break;
                //case "BufferBlock":
                //    consumer = new Consumer_BufferBlock<T>();   //2 36 800-1000��
                //    break;
                case "BlockingCollection":
                    consumer = new Consumer_BlockingCollection<T>();  //16 16 440��          2  2  800��
                    break;


                //case "Disruptor":
                //    consumer = new Consumer_Disruptor<T>(); // 16 16 800��
                //    break;
                //case "WorkerPool":
                //    consumer = new Consumer_WorkerPool<T>(); //16 16 800-900��
                //    break;

                //case "ConsumerCache_ActionBlock":
                //    consumer = new ConsumerCache<T, Consumer_ActionBlock<T>>(); // 16 16  4000-4200��
                //    break;
                //case "ConsumerCache_BufferBlock":
                //    consumer = new ConsumerCache<T, Consumer_BufferBlock<T>>(); // 16 16  1500-1600��
                //    break;
                case "ConsumerCache_BlockingCollection":
                    consumer = new ConsumerCache<T, Consumer_BlockingCollection<T>>(); //16 16 4200-4500��
                    break;



                //case "ConsumerCache_WorkerPool":
                //    consumer = new ConsumerCache<T, Consumer_WorkerPool<T>>(); //750��  �쳣
                //    break;
                //case "WorkerPoolCache":
                //    consumer = new Consumer_WorkerPoolCache<T>();        //940�� �쳣
                //    break;
                //case "WorkerPoolCascade":
                //    consumer = new Consumer_WorkerPoolCascade<T>();   //1400�� �쳣
                //    break;

                default:
                    consumer = new Consumer_BlockingCollection<T>();
                    break;
            }

            return consumer;
        }