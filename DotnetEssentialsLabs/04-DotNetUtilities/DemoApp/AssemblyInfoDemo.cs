using System.Diagnostics;

namespace DemoApp
{
    internal static class AssemblyInfoDemo
    {
        const string conf = "Debug";
        //const string conf = "Release";
        public static void DemoFunc()
        {
            string exePath = $"..\\..\\..\\..\\AssemblyInfo\\bin\\{conf}\\net8.0\\AssemblyInfo.exe";
            string assemblyPath = "..\\..\\..\\..\\DemoApp\\TasksDemoData\\Tasks\\AssemblyInfo\\DemoAssembly.dll";

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
