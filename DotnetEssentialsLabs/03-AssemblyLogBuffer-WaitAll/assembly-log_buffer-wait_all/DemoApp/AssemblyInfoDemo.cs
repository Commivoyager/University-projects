using System.Diagnostics;

namespace DemoApp
{
    internal static class AssemblyInfoDemo
    {
        const string conf = "Debug";
        //const string conf = "Release";
        public static void demoFunc()
        {
            string exePath = $"..\\..\\..\\..\\AssemblyInfo\\bin\\{conf}\\net8.0\\AssemblyInfo.exe";
            //string assemblyPath = "..\\..\\..\\..\\DemoApp\\TasksDemoData\\Tasks\\AssemblyInfo\\AssemblyInfo.dll";
            string assemblyPath = "..\\..\\..\\..\\DemoApp\\TasksDemoData\\Tasks\\AssemblyInfo\\ConsoleApp1.dll";

            if (!File.Exists(exePath))
            {
                Console.WriteLine($"File ({exePath}) doesn't exist");
                return;
            }
            if (!File.Exists(assemblyPath))
            {
                Console.WriteLine($"File ({assemblyPath}) doesn't exist");
                return;
            }

            Process.Start(exePath, assemblyPath);

        }
    }
}
// "D:\main\study\current\СПП\ЛР3\assembly-log_buffer-wait_all\AssemblyInfo\bin\Debug\net8.0\AssemblyInfo.exe"