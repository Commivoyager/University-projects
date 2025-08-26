using System.Reflection;
using System.Text;
using System.Linq;
using LB = LogBuffer.LogBuffer;
public class Program {
    static string assemblyPath = "";
    const string logPath = "..\\..\\..\\..\\DemoApp\\TasksDemoData\\Tasks\\AssemblyInfo\\log.txt";

    public static void Main(string[] args) {
        LB log = new (logPath);

        GetAssemblyInfo(args, log);

        log.Dispose();

        //Console.ReadLine();
    }

    private static void GetAssemblyInfo(string[] args, LB log)
    {
        if (args.Length != 1)
        {
            log.Add("Missed required command line argument: path to .Net assembly");
            return;
        }
        assemblyPath = args[0];
        if (!File.Exists(assemblyPath))
        {
            log.Add(".Net assembly with this path doesn't exist");
        }

        Assembly assembly;
        try
        {
            assembly = Assembly.LoadFrom(assemblyPath);
        }
        catch (Exception ex)
        {
            log.Add($"Exception during loading assembly information: {ex.Message}");
            return;
        }

        log.Add($"Assembly \"{assembly.FullName}\" was loaded");

        // Форматирование данных с помощью LINQ
        var sortedPublicTypes = assembly
            .GetTypes()
            .Where(t => t.IsPublic)
            .OrderBy(t => t.Namespace)
            .ThenBy(t => t.Name);

        log.Add("Extracted types:");
        foreach (Type group in sortedPublicTypes)
        {
            log.Add(group.FullName);
            //Console.WriteLine(group.FullName);
        }
    }
}