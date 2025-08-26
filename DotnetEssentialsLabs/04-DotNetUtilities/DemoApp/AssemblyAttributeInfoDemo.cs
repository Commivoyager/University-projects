using System.Diagnostics;

namespace DemoApp
{
    internal static class AssemblyAttributeInfoDemo
    {
        const string conf = "Debug";
        //const string conf = "Release";
        public static void DemoFunc()
        {
            string exePath = $"..\\..\\..\\..\\AssemblyAttributeInfo\\bin\\{conf}\\net8.0\\AssemblyAttributeInfo.exe";
            string assemblyPath = "..\\..\\..\\..\\DemoApp\\TasksDemoData\\Tasks\\AssemblyAttributeInfo\\DemoAssembly.dll";

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
