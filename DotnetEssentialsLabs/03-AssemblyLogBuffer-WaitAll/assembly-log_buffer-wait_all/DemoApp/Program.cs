using DemoApp;

class Program {
    enum TaskName
    {
        AssemblyInfo,
        LogBuffer,
        WaitAll
    }
    public static void Main(string[] args) {
        TaskName task = TaskName.WaitAll;
        switch (task)
        {
            case TaskName.AssemblyInfo:
                AssemblyInfoDemo.demoFunc();
                break;
            case TaskName.LogBuffer:
                LogBufferDemo.demoFunc();
                break;
            case TaskName.WaitAll:
                WaitAllDemo.DemoFunc();
                break;
            default:
                Console.WriteLine("DemoApp: select task");
                break;
        }
    }
}