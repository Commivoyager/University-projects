using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;


namespace Metrology1
{
    internal static class CodeLexer
    {
        static string programPath = @"..\..\..\Files\lexer\a.exe";

        public static string inputFilePath = @"..\..\..\Files\code.rb";

        static string outputFilePath = @"..\..\..\Files\tokens";

        public static void Lex()
        {
            // Создание процесса
            Process process = new Process();
            process.StartInfo.FileName = programPath;

            // Настройка перенаправления стандартных потоков
            process.StartInfo.RedirectStandardInput = true;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.CreateNoWindow = true;

            // Запуск процесса
            process.Start();

            // Передача данных из входного файла в стандартный ввод программы
            using (StreamWriter writer = process.StandardInput)
            {
                using (StreamReader reader = new StreamReader(inputFilePath))
                {
                    writer.Write(reader.ReadToEnd());
                }
            }

            // Чтение данных из стандартного вывода программы и запись их в файл
            using (StreamReader outputReader = process.StandardOutput)
            {
                string result = outputReader.ReadToEnd();
                File.WriteAllText(outputFilePath, result);
            }

            // Ожидание завершения процесса
            process.WaitForExit();
        }
    }
}
