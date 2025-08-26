using DemoApp;

class Program {
    enum TaskName
    {
        AssemblyInfo,
        LogBuffer,
        WaitAll,
        AssemblyAttributeInfo,
        DynamicList
    }
    public static void Main(string[] args) {
        TaskName task = TaskName.DynamicList;
        switch (task)
        {
            case TaskName.AssemblyInfo:
                AssemblyInfoDemo.DemoFunc();
                break;
            case TaskName.LogBuffer:
                LogBufferDemo.DemoFunc();
                break;
            case TaskName.WaitAll:
                WaitAllDemo.DemoFunc();
                break;
            case TaskName.AssemblyAttributeInfo:
                AssemblyAttributeInfoDemo.DemoFunc();
                break;
            case TaskName.DynamicList:
                DynamicListDemo.DemoFunc();
                break;
            default:
                Console.WriteLine("DemoApp: select task");
                break;
        }
    }
}