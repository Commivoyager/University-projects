namespace LogginingServices
{
    public class ConsoleLogger : ILogger
    {
        public void LogInfo(string infoMess) =>
            Console.WriteLine($"{DateTime.Now.ToString("HH:mm:ss.fff")} Log (Info): {infoMess}");
        public void LogWarning(string warningMess) =>
            Console.WriteLine($"{DateTime.Now.ToString("HH:mm:ss.fff")} Log (Warning): {warningMess}");
        public void LogError(string errorMess, Exception? ex) =>
            Console.WriteLine($"{DateTime.Now.ToString("HH:mm:ss.fff")} Log (Error): {errorMess}; {ex?.Message}");
    }
}
