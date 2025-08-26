using OSHandle;

class Program {
    static void Main() {
        IntPtr ptr = new IntPtr(123456);
        using (OSHandle.OSHandle handle = new OSHandle.OSHandle(ptr)) { 
            handle.Handle = new IntPtr(6789);
        }

        try
        {
            OSHandle.OSHandle handle = new OSHandle.OSHandle(new IntPtr(101010));
            handle.Dispose();
            Console.WriteLine("handle disposed");
            handle.Dispose();
            Console.WriteLine("handle disposed again");
            Console.WriteLine("Try to assign value to disposed handle");
            handle.Handle = new nint(11111);
            Console.WriteLine("Assigned value to disposed handle");
        }
        catch (ObjectDisposedException ex) { 
            Console.WriteLine($"Exception: {ex.GetType().Name}");
        }
    }
}