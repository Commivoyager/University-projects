using System.Text;

namespace LogBuffer
{
    public class LogBuffer: IDisposable
    {
        private readonly StringBuilder _msgs = new();
        private int _msgsNum = 0;
        private readonly Timer _timer;
        private readonly string _logPath;
        private readonly int _flushIntrvl;
        private readonly int _flushSize;
        private readonly SemaphoreSlim _flushSemphr = new(1, 1);
        private readonly object _msgsLock = new object();
        private bool _disposed = false;

        public LogBuffer(string logPath, int flushInterval = 5000, int flushSize = 100) { 
            _logPath = logPath;
            _flushSize = flushSize;
            _flushIntrvl = flushInterval;
            _timer = new Timer(_ => _ = FlushAsync(0), null, flushInterval, flushInterval);
        }

        public void Add(string item) {
            lock (_msgsLock) {
                DateTime now = DateTime.Now;
                _msgs.Append($"{now:HH:mm:ss}.{now.Millisecond:D3}: ");
                _msgs.AppendLine(item);
                _msgsNum++;
            }
            if (_msgsNum >= _flushSize) {
                // Не ждём асинхронную ф-ию
                _ = FlushAsync(0);
            }
        }
        
        private async Task FlushAsync(int waitTime) {
            bool isTookSemaphr = false;
            try {
                string logStr;
                isTookSemaphr = await _flushSemphr.WaitAsync(waitTime);
                if (!isTookSemaphr)
                {
                    return;
                }
                if (_msgsNum == 0) { 
                    return; 
                }
                lock (_msgsLock)
                {
                    //! debug
                        //
                        _msgs.AppendLine("END OF LOG BATCH");
                    logStr = _msgs.ToString();
                    _msgs.Clear();
                    _msgsNum = 0;
                }
                
                // Сброс таймера
                _timer.Change(_flushIntrvl, _flushIntrvl);
                await File.AppendAllTextAsync(_logPath, logStr);
            }
            catch (Exception ex) {
                Console.WriteLine($"Exception during flushing logs: {ex.Message}");
            }
            finally{
                if (isTookSemaphr)
                {
                    _flushSemphr.Release();
                    isTookSemaphr = false;
                }
               
            }
        }

        public void Dispose() {
            if (!_disposed)
            {
                FlushAsync(-1).GetAwaiter().GetResult();
                _timer.Dispose();

                _disposed = true;
            }
        }


    }
}
