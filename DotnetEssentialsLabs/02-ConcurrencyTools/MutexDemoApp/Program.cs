using System.Diagnostics;
using LogginingServices;
using MutexDemoApp;

class Program {
    static void Main() {

        Stopwatch sw = Stopwatch.StartNew();
        sw.Start();

        ILogger _logger = new ConsoleLogger();

        MutexDemo.Logger = _logger;
        MutexDemo.NormalDemo();
        MutexDemo.RecursiveDemo();
        MutexDemo.IncorrectDemo();


        _logger.LogInfo($"Demo time: {sw.ElapsedMilliseconds} ms");
        sw.Stop();
    }
}
