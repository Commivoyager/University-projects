using DemoApp;
using LogginingServices;
using System.Diagnostics;
class Program
{
    static void Main(string[] args) {
        string sourceDir = "..\\..\\..\\AppData\\1_Music\\SourceFiles";
        // 1_Music
        // 2_light
        // 3_Music_light
        string destDir = "..\\..\\..\\AppData\\DestFiles";
        if (args.Length == 2) {
            sourceDir = args[0];
            destDir = args[1];
        }
        Stopwatch sw = Stopwatch.StartNew();
        sw.Start();

        ILogger _logger = new ConsoleLogger();
        FileCopier.Logger = _logger;
        int copied = 0;

        _logger.LogInfo($"Copying started");
        copied = FileCopier.CopyFiles(sourceDir, destDir, false);

        _logger.LogInfo($"Copying time: {sw.ElapsedMilliseconds} ms");
        sw.Stop();
        Console.WriteLine($"Copied quantity: {copied}");
    
    }
}