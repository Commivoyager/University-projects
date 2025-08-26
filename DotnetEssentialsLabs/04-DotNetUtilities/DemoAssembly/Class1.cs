// Only for assembly analysis
namespace Company.ProjectB
{
    // Публичный класс
    public class PublicClassB
    {
        public void Display()
        {
            Console.WriteLine("PublicClassB из пространства имен Company.ProjectB");
        }
    }

    // Непубличный класс
    class InternalClassB
    {
        public void Display()
        {
            Console.WriteLine("InternalClassB из пространства имен Company.ProjectB");
        }
    }

    class InternalClassB2
    {
        public void Display()
        {
            Console.WriteLine("InternalClassB2 из пространства имен Company.ProjectB");
        }
    }
}

namespace Company.ProjectA
{
    // Публичный класс

    public class PublicClassA3
    {
        public void Display()
        {
            Console.WriteLine("PublicClassA3 из пространства имен Company.ProjectA");
        }
    }

    public class PublicClassA
    {
        public void Display()
        {
            Console.WriteLine("PublicClassA из пространства имен Company.ProjectA");
        }
    }
    public class PublicClassA2
    {
        public void Display()
        {
            Console.WriteLine("PublicClassA2 из пространства имен Company.ProjectA");
        }
    }


    // Непубличный класс
    class InternalClassA
    {
        public void Display()
        {
            Console.WriteLine("InternalClassA из пространства имен Company.ProjectA");
        }
    }
}
