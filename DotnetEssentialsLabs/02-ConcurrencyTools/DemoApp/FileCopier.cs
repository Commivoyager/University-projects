using CustomConcurrency.TaskQueue;
using LogginingServices;

namespace DemoApp
{
    internal static class FileCopier
    {
        private delegate void Copier(ref int curInd, int boundInd, string[] arr, string destDir);
        
        const int filesPerThread = 100;
        const int poolThreadsNum = 100;
        static TaskQueue _tasks = new TaskQueue(poolThreadsNum);

        static public ILogger? Logger { get; set; } = null;
        static object _locker = new object();

        static Copier partCopier = RewriteCopier;

        public static int CopyFiles(string sourceDir, string destDir, bool rewrite = true)
        {
            List<int> copiedQuantities = new List<int>();
            CountdownEvent countdown = new CountdownEvent(1);
            if (rewrite)
            {
                partCopier = RewriteCopier;
            }
            else {
                partCopier = NotRewriteCopier;
            }
            // подсчитать скопированные файлы
            try
            {
                if (!Directory.Exists(destDir))
                {
                    Directory.CreateDirectory(destDir);
                }
                CopyAllContent(sourceDir, destDir, copiedQuantities, countdown);
                countdown.Signal();
                countdown.Wait();
            }
            catch (Exception ex) {
                Logger?.LogError("Exception during copying files: ", ex);
            }
            //catch () { 
            //! implement it
            //}
            //finally{} // countdown
            int copiedQuantity = 0;
            lock (_locker) {
                copiedQuantity = copiedQuantities.Sum();
            }
            return copiedQuantity;
        }

        private static void CopyAllContent(string sourceDir, string destDir, List<int> copiedQuantities,  CountdownEvent countdown)
        {
            string[] dirFiles = { };
            string[] sourceSubDirs = { };
            try
            {
                dirFiles = Directory.GetFiles(sourceDir);
                sourceSubDirs = Directory.GetDirectories(sourceDir);
            }
            catch (Exception ex) {
                Logger?.LogError("Exception during copying file: ", ex);
            }
            if (dirFiles.Length != 0) {
                int mainThreadNum = dirFiles.Length / filesPerThread;
                int remainingFiles = dirFiles.Length % filesPerThread;

                int startInd = 0;

                countdown.AddCount(remainingFiles == 0 ? mainThreadNum : mainThreadNum + 1);
                for (int i = 0; i < mainThreadNum; i++)
                {
                    MakePartlyCopying(dirFiles, startInd, filesPerThread, copiedQuantities, destDir, countdown);
                    startInd += filesPerThread;
                }
                MakePartlyCopying(dirFiles, startInd, remainingFiles, copiedQuantities, destDir, countdown);
            }

            foreach (string sourceSubDir in sourceSubDirs)
            {
                string subDirName = Path.GetFileName(sourceSubDir);
                string destSubDir = Path.Combine(destDir, subDirName);
                if (!Directory.Exists(destSubDir)) { 
                    Directory.CreateDirectory(destSubDir);
                }
                CopyAllContent(sourceSubDir, destSubDir, copiedQuantities, countdown);
            }

        }

        private static void MakePartlyCopying(string[] files, int startInd, int filesNum, List<int> copiedQuantities, 
            string destDir, CountdownEvent countdown) {
            TaskQueue.TaskDelegate task = () =>
            {
                int j = startInd;
                int copiedQuantity = filesNum;
                int boundInd = startInd + filesNum;
                while (j < boundInd) {
                    try
                    {
                        partCopier(ref j, boundInd, files, destDir);
                        //for (; j < startInd + filesNum; j++)
                        //{
                        //    string sourceFilePath = files[j];
                        //    string fileName = Path.GetFileName(sourceFilePath);
                        //    File.Copy(sourceFilePath, Path.Combine(destDir, fileName), overwrite: true);
                        //    Logger?.LogInfo($"Copied file: {Path.Combine(destDir, fileName)}");
                        //}
                    }
                    catch (Exception ex)
                    {
                        Logger?.LogError("Exception during copying file: ", ex);
                        j++;
                        copiedQuantity--;
                    }
                }
                lock (_locker) {
                    copiedQuantities.Add(copiedQuantity);
                }
                countdown.Signal();
            };
            _tasks.EnqueueTask(task);
        }

        private static void NotRewriteCopier(ref int curInd, int boundInd, string[] arr, string destDir){
            for (; curInd < boundInd; curInd++)
            {
                string sourceFilePath = arr[curInd];
                string fileName = Path.GetFileName(sourceFilePath);
                string destFilePath = Path.Combine(destDir, fileName);
                if (!File.Exists(destFilePath)) { 
                    File.Copy(sourceFilePath , destFilePath, overwrite: true);
                  //  Logger?.LogInfo($"Copied file: {destFilePath}");
                }
            }
        }

        private static void RewriteCopier(ref int curInd, int boundInd, string[] arr, string destDir) {
            for (; curInd < boundInd; curInd++) {
                string sourceFilePath = arr[curInd];
                string fileName = Path.GetFileName(sourceFilePath);
                string destFilePath = Path.Combine(destDir, fileName);
                FileAttributes destAttributes;


                if (File.Exists(destFilePath)) {
                    destAttributes = File.GetAttributes(destFilePath);
                    if ((destAttributes & FileAttributes.ReadOnly) == FileAttributes.ReadOnly) { 
                        File.SetAttributes(destFilePath, destAttributes & ~FileAttributes.ReadOnly);
                    }

                    File.Copy(sourceFilePath , destFilePath, overwrite: true);

                    if ((destAttributes & FileAttributes.ReadOnly) == FileAttributes.ReadOnly) {
                        File.SetAttributes(destFilePath, destAttributes);
                    }
                }
                else{
                    File.Copy(sourceFilePath, Path.Combine(destDir, fileName), overwrite: false);
                }

                //Logger?.LogInfo($"Copied file: {destFilePath}");
            }
        }
    }
}
