using System.Reflection;
using LB = LogBuffer.LogBuffer;
using AssemblyAttributeInfo.Attributes;
class Program
{
    static string assemblyPath = "";
    const string logPath = "..\\..\\..\\..\\DemoApp\\TasksDemoData\\Tasks\\AssemblyAttributeInfo\\log.txt";

    public static void Main(string[] args)
    {
        LB log = new(logPath);

        var classes = GetAssemblyAttributeInfo(args, log);
        if(classes == null)
        {
            return;
        }
        log.Add("Extracted types (all classes with ExportClass attribute):");
        foreach (var c in classes)
        {
            log.Add(c.FullName);
        }
        log.Dispose();
    }

    private static Type[]? GetAssemblyAttributeInfo(string[] args, LB log)
    {
        if(args.Length != 1)
        {
            log.Add("Missed required command line argument: path to .Net assembly");
            return null;
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
            return null;
        }
        log.Add($"Assembly \"{assembly.FullName}\" was loaded");

        var assemblyExpClasses = assembly
            .GetTypes()
            .Where(t => t.IsPublic &&
                t.GetCustomAttributes(typeof(ExportClassAttribute), false).Any())
            .ToArray();
        return assemblyExpClasses;
    }
}