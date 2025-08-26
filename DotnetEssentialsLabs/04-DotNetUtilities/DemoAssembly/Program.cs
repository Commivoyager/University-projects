// Only for assembly analysis
using AssemblyAttributeInfo.Attributes;
using System;

namespace ConsoleApp1
{
    [ExportClass]
    public class MyClass
    {
        public void SayHello()
        {
            Console.WriteLine("Hello from MyClass!");
        }
    }

    class Program
    {
        static void Main()
        {
            Console.WriteLine("DemoApp is running.");
        }
    }
}