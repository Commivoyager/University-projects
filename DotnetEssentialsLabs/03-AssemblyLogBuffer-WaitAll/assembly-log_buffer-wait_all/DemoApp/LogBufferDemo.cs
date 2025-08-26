using LB = LogBuffer.LogBuffer;
namespace DemoApp
{
    internal static class LogBufferDemo
    {
        const string logPath = "..\\..\\..\\TasksDemoData\\Tasks\\LogBuffer\\log.txt";
        const int logMSInterval = 1500;
        const int logNumBound = 50;
        public static void demoFunc() {
            LB logBuf = new LB(logPath, logMSInterval, logNumBound);

            int logInterval = logMSInterval + 200;
           
            logBuf.Add($"Single log message before {logInterval} msec sleep");
            Thread.Sleep(logInterval);
            
            logBuf.Add($"Second log message before {logInterval} msec sleep");
            Thread.Sleep(logInterval);

            int logIterationsNum = logNumBound*5;
            for (int i = 0; i < logIterationsNum; i++)
            {
                logBuf.Add($"{i} iteration log message");
                Thread.Sleep(10);
            }

            for (int i = 0; i < logIterationsNum; i++)
            {
                logBuf.Add($"{i} iteration log message");
            }
            logBuf.Dispose();
        }
        
    }
}
