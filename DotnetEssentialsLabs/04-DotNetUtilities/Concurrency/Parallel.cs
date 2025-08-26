using LB = LogBuffer.LogBuffer;

namespace Concurrency
{
    public static class Parallel
    {
        public static LB? log = null;

        public static void WaitAll(Action[] actArr, bool explicitPool = true)
        {
            if (explicitPool)
            {
                ExplictPoolWaitAll(actArr);
            }
            else
            {
                TaskWaitAll(actArr);
            }
            
        }
        private static void ExplictPoolWaitAll(Action[] actArr)
        {
            CountdownEvent countdown = new CountdownEvent(actArr.Length);
            for (int i = 0; i < actArr.Length; i++)
            {
                int ind = i;
                ThreadPool.QueueUserWorkItem(
                    _ =>
                    {
                        try
                        {
                            log?.Add($"Explicit ThreadPool: Task number {ind} before invoke");
                            actArr[ind].Invoke();
                            log?.Add($"Explicit ThreadPool: Task number {ind} after invoke");
                        }
                        finally
                        {
                            countdown.Signal();
                        }
                    }
                    );
            }
            countdown.Wait();
            log?.Add("Explicit ThreadPool: All tasks are completed");
        }

        private static void TaskWaitAll(Action[] actArr)
        {
            Task[] tasks = new Task[actArr.Length];
            for(int i = 0; i < actArr.Length; i++)
            {
                int ind = i;
                tasks[i] = Task.Run(() => { 
                    log?.Add($"Implicit ThreadPool: task number {ind} after invoke");
                    actArr[ind].Invoke(); 
                    log?.Add($"Implicit ThreadPool: task number {ind} after invoke ");
                });
            }
            Task.WaitAll(tasks);
            log?.Add("Implicit ThreadPool: All tasks are completed");
        }
    }
}
