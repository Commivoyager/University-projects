namespace OSHandle
{
    public class OSHandle : IDisposable
    {
        private IntPtr _handle;
        private bool _disposed = false;
        public IntPtr Handle {
            get {
                if (_disposed) {
                    throw new ObjectDisposedException(ToString());
                }
                return _handle;
            }
            set {
                if (_disposed)
                {
                    throw new ObjectDisposedException(ToString());
                }
                _handle = value;
            }
        }

        public OSHandle(IntPtr handle) { 
            _handle = handle;
        }

        ~OSHandle() {
            Dispose(false);
        }
        protected virtual void Dispose(bool disposing) {
            if (_disposed)
            {
                return;
            }
            if (disposing)
            {
                // Очистка managed ресурсов
                // Только при ручном вызове, иначе они могут быть уже освобождены
                Console.WriteLine("Free managed resources");
            }
            if (_handle != IntPtr.Zero)
            {
                ReleaseHandle();
                _handle = IntPtr.Zero;
            }
            _disposed = true;
        }

        public void Dispose() {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void ReleaseHandle() {
            // Освобождение дескриптора
            Console.WriteLine("Releasing handle");
        }
    }
}
