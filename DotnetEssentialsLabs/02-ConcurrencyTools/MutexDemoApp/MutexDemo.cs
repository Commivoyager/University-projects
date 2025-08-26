using CustomConcurrency.Mutex;
using CustomConcurrency.TaskQueue;
using LogginingServices;

namespace MutexDemoApp
{
    internal static class MutexDemo
    {
        const int threadsNum = 10;
        const int mutexActNum = 10;

        public static ILogger? Logger;
        //private static TaskQueue _taskQueue = new TaskQueue(poolThreadsNum);
        private static CustomConcurrency.Mutex.Mutex _mutex = new CustomConcurrency.Mutex.Mutex();
        private static Random _random = new Random();
        private static int mutexCycleCounter = 0;
        //private delegate void ThreadAct(Object param);
        public static void NormalDemo() {
            RunThreads(NormalThrAct);
        }
        public static void RecursiveDemo() {
            RunThreads(RecursiveAct);
        }
        public static void IncorrectDemo()
        {
            Thread normalMutThr = new Thread(NormalThrAct);
            Thread recursiveMutThr = new Thread(RecursiveAct);
            Thread incorrectMutThr = new Thread(IncorrectAct);
            normalMutThr.Start(0);
            recursiveMutThr.Start(1);
            incorrectMutThr.Start(2);

            normalMutThr.Join();
            recursiveMutThr.Join();
            incorrectMutThr.Join();
            Logger?.LogInfo($"All threads are completed");
            
        }

        private static void RunThreads(ParameterizedThreadStart act) {
            Thread[] threads = new Thread[threadsNum];
            for (int i = 0; i < threadsNum; i++) {
                threads[i] = new Thread(act);
            }
            for (int i = 0; i < threadsNum; i++)
            {
                threads[i].Start(i);
            }
            for (int i = 0; i < threadsNum; i++)
            {
                threads[i].Join();
            }
            Logger?.LogInfo($"All threads are completed");
        }

        private static void NormalThrAct(Object thrNum) {
            int waitTime = _random.Next(10, 101);
            Logger?.LogInfo($"Thread {thrNum} starts waiting for {waitTime}");
            Thread.Sleep(waitTime);
            Logger?.LogInfo($"Thread {thrNum} tries to lock mutex");
            _mutex.Lock();
            Logger?.LogInfo($"Thread {thrNum} locked mutex");
            for (int i = 0; i < mutexActNum; i++) { 
                Logger?.LogInfo($"Thread {thrNum} - {mutexCycleCounter++} iteration of mutex cycle");
                Thread.Sleep(50);
            }
            Logger?.LogInfo($"Thread {thrNum} before recursive mutex blocking");
            _mutex.Lock();
            Logger?.LogInfo($"Thread {thrNum} in recursive mutex blocking");
            Thread.Sleep(50);
            _mutex.Unlock();
            Logger?.LogInfo($"Thread {thrNum} after recursive mutex blocking");
            _mutex.Unlock();
            Logger?.LogInfo($"Thread {thrNum} unlocked mutex");
        }


        private static void RecursiveAct(object thrNum) {
            int waitTime = _random.Next(10, 101);
            Logger?.LogInfo($"Thread {thrNum} starts waiting for {waitTime}");
            Thread.Sleep(waitTime);
            Logger?.LogInfo($"Thread {thrNum} tries to lock mutex");
            _mutex.Lock();
            Logger?.LogInfo($"Thread {thrNum} locked mutex");
            
            for (int i = 0; i < mutexActNum; i++)
            {
                Logger?.LogInfo($"Thread {thrNum} before {i+1} recursive mutex locking");
                _mutex.Lock();
                Logger?.LogInfo($"Thread {thrNum} locked {i + 1} recursive mutex");
                Thread.Sleep(20);
            }
            for (int i = 0; i < mutexActNum; i++) {
                Logger?.LogInfo($"Thread {thrNum} before {mutexActNum - i} recursive mutex unlocking");
                _mutex.Unlock();
            }
            _mutex.Unlock();
            Logger?.LogInfo($"Thread {thrNum} unlocked mutex");
        }

        private static void IncorrectAct(object thrNum) {
            try
            {
                int waitTime = _random.Next(10, 101);
                Logger?.LogInfo($"INCORRECT Thread {thrNum} starts waiting for {waitTime}");
                Thread.Sleep(waitTime);

                Logger?.LogInfo($"INCORRECT Thread before unlocking mutex");
                _mutex.Unlock();
                Logger?.LogInfo($"INCORRECT Thread {thrNum} unlocked mutex");
            }
            catch (SynchronizationLockException ex)
            {
                Logger.LogError("Exception", ex);
            }
        }
    }
}
