namespace CustomConcurrency.Mutex
{
    public class Mutex
    {
        private Thread? capturedThread = null;
        private int recoursCounter = 0;
        public void Lock() {
            Thread curThread = Thread.CurrentThread;
            if (capturedThread == curThread)
            {
                recoursCounter++;
            }
            else
            {
                while (Interlocked.CompareExchange(ref capturedThread, curThread, null) != null)
                {

                    Thread.Yield();
                }
                recoursCounter++;
            }
            Thread.MemoryBarrier();
        }

        public void Unlock() {
            Thread curThread = Thread.CurrentThread;
            if (curThread != capturedThread)
                throw new SynchronizationLockException();
            if (--recoursCounter == 0)
            {
                capturedThread = null;
            }
            else if (recoursCounter < 0) { 
                throw new SynchronizationLockException();
            }
            Thread.MemoryBarrier();
        }
    }
}
