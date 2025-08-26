using MyParallel = Concurrency.Parallel;
using LB = LogBuffer.LogBuffer;
namespace DemoApp
{
    internal class WaitAllDemo
    {
        const string logPath = "..\\..\\..\\TasksDemoData\\Tasks\\Parallel.WaitAll\\log.txt";
        const int TaskNum = 100;
        public static void DemoFunc()
        {
            LB log = new LB(logPath);

            MyParallel.log = log;

            Action[] tasks = new Action[TaskNum];  
            for(int i = 0; i < TaskNum; i++)
            {
                int ind = i;
                tasks[i] = () =>
                {
                    log.Add($"Execution of action number {ind} started...");
                    Thread.Sleep(50);
                    log.Add($"Execution of action number {ind} finished");
                };
            }

            log.Add("Explicit ThreadPool: calling WaitAll");
            MyParallel.WaitAll(tasks);
            log.Add("Explicit ThreadPool: WaitAll completed");

            log.Add("Implicit ThreadPool: calling WaitAll");
            MyParallel.WaitAll(tasks, false);
            log.Add("Implicit ThreadPool: WaitAll completed");

            MyParallel.log = null;
            log.Dispose();
        }
    }
}
