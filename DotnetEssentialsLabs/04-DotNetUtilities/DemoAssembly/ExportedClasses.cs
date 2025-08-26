using AssemblyAttributeInfo.Attributes;

namespace DemoAssembly
{
    internal class NonExportedClasses
    {
        public void Display()
        {
            Console.WriteLine("ExportedClasses из пространства имен DemoAssembly");
        }
    }

    [ExportClass]
    public class ExportedClassA
    {
        public string Name { get; set; }
        public void Display()
        {
            Console.WriteLine("ExportedClassA из пространства имен DemoAssembly");
        }
    }

    public class ExportedClassAChild : ExportedClassA
    {
        public void Display()
        {
            Console.WriteLine("ExportedClassAChild из пространства имен DemoAssembly");
        }
    }

    public class ExportedClassAGrandChild : ExportedClassAChild
    {
        public void Display()
        {
            Console.WriteLine("ExportedClassAGrandChild из пространства имен DemoAssembly");
        }
    }
}

namespace DemoAssembly2
{
    [ExportClass]
    internal class IncorrectExportedClasses
    {
        public void Display()
        {
            Console.WriteLine("ExportedClasses из пространства имен DemoAssembly2");
        }
    }

    [ExportClass]
    public class ExportedClassA
    {
        public string Name { get; set; }
        public void Display()
        {
            Console.WriteLine("ExportedClassA из пространства имен DemoAssembly2");
        }
    }

    public class ExportedClassAChild : ExportedClassA
    {
        public void Display()
        {
            Console.WriteLine("ExportedClassAChild из пространства имен DemoAssembly2");
        }
    }

    public class ExportedClassAGrandChild : ExportedClassAChild
    {
        public void Display()
        {
            Console.WriteLine("ExportedClassAGrandChild из пространства имен DemoAssembly2");
        }
    }
}


namespace DemoAssemblyB
{
    internal class NonExportedClasses
    {
        public void Display()
        {
            Console.WriteLine("ExportedClasses из пространства имен DemoAssemblyB");
        }
    }

    [ExportClass]
    public class ExportedClassB
    {
        public string Name { get; set; }
        public void Display()
        {
            Console.WriteLine("ExportedClassB из пространства имен DemoAssemblyB");
        }
    }

    [ExportClass]
    public class ExportedClassBChild : ExportedClassB
    {
        public void Display()
        {
            Console.WriteLine("ExportedClassBChild из пространства имен DemoAssemblyB");
        }
    }

    public class ExportedClassBGrandChild : ExportedClassBChild
    {
        public void Display()
        {
            Console.WriteLine("ExportedClassBGrandChild из пространства имен DemoAssemblyB");
        }
    }
}