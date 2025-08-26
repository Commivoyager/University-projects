using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinFormsApp1
{
    internal static class ColumnMethod
    {
        public static string messageStr = "";
        static string key1 , key2;            // абёвеёмеёжмытспретиёсть
        static int[] columnNums1, columnNums2;
        public static string sourceString;
        static string procText;
        public static char[] resText;
        public static int charNum;

        static char[] textLetters;
        static int letterInd;

        public static bool initEncryptor(string k1, string k2)
        {
            key1 = k1.ToUpper();
            if (!IsKeyCorrect(key1))
            {
                messageStr = "Ключ должен содержать только буквы русского алфавита";
                return false;
            }
            key2 = k2.ToUpper();
            if (!IsKeyCorrect(key2))
            {
                messageStr = "Ключ должен содержать только буквы русского алфавита";
                return false;
            }
            return true;
        }

        public static bool IsKeyCorrect(String key)
        {
            for(int i = 0; i < key.Length; i++)
            {
                if (!IsSymbRus(key[i]))
                {
                    return false;
                }
            }
            return true;
        }

        static bool IsSymbRus(char symb)
        {
            if ((symb < 'А' || symb > 'я') && symb != 'Ё' && symb != 'ё')
            {
                return false;
            }
            return true;
        }

        public static bool encrypt(string path, string encrPath)
        {
            if (!File.Exists(path))
            {
                messageStr = "Файл с таким именем не существует";
                return false;
            }
            using (StreamReader sr = new StreamReader(path))
            {
                procText = sr.ReadToEnd();
                charNum = procText.Length;
            }
            sourceString = procText;
            resText = new char[charNum];
            columnNums1 = genKeySequence(key1);
            columnNums2 = genKeySequence(key2);

            textLetters = new char[charNum];
            //int letterInd = 0;
            letterInd = 0;
            for (int i = 0; i < charNum; i++)
            {
                if (IsSymbRus(procText[i]))
                {
                    textLetters[letterInd] = procText[i];
                    letterInd++;
                }
            }
            encrAlg(columnNums1);
            Array.Copy(resText, textLetters, charNum);
            encrAlg(columnNums2);
            Array.Copy(resText, textLetters, charNum);
            letterInd = 0;
            for (int i = 0; i < charNum; i++)
            {
                if (IsSymbRus(sourceString[i]))
                {
                    resText[i] = textLetters[letterInd];
                    letterInd++;
                }
                else
                {
                    resText[i] = sourceString[i];
                }
            }
            using (StreamWriter sw = new StreamWriter(encrPath))
            {
                sw.Write(resText);
            }
            return true;
        }

        public static void encrAlg(int[] colNums)
        {
            int keyL = colNums.Length;
            int mainInd = 0;
            for (int i = 0; i < keyL; i++)
            {
                int columnInd = colNums[i];
                while (columnInd < letterInd)
                {
                    resText[mainInd] = textLetters[columnInd];
                    columnInd += keyL;
                    mainInd++;
                }
            }
        }

        public static bool decrypt(string path, string decrPath)
        {
            if (!File.Exists(path))
            {
                messageStr = "Файл с таким именем не существует";
                return false;
            }
            using (StreamReader sr = new StreamReader(path))
            {
                procText = sr.ReadToEnd();
                charNum = procText.Length;
            }
            sourceString = procText;
            resText = new char[charNum];
            columnNums1 = genKeySequence(key1);
            columnNums2 = genKeySequence(key2);

            textLetters = new char[charNum];
            letterInd = 0;
            for (int i = 0; i < charNum; i++)
            {
                if (IsSymbRus(procText[i]))
                {
                    textLetters[letterInd] = procText[i];
                    letterInd++;
                }
            }
            decrAlg(columnNums2);
            Array.Copy(resText, textLetters, charNum);
            decrAlg(columnNums1);
            Array.Copy(resText, textLetters, charNum);
            letterInd = 0;
            for (int i = 0; i < charNum; i++)
            {
                if (IsSymbRus(sourceString[i]))
                {
                    resText[i] = textLetters[letterInd];
                    letterInd++;
                }
                else
                {
                    resText[i] = sourceString[i];
                }
            }
            using (StreamWriter sw = new StreamWriter(decrPath))
            {
                sw.Write(resText);
            }
            return true;
        }

        public static void decrAlg(int[] colNums)
        {
            int keyL = colNums.Length;
            int mainInd = 0;
            for (int i = 0; i < colNums.Length; i++)
            {
                int columnInd = colNums[i];
                while (columnInd < letterInd)
                {
                    resText[columnInd] = textLetters[mainInd];
                    columnInd += keyL;
                    mainInd++;
                }
            }
        }

        public static int[] genKeySequence(string key)
        {
            int kLen = key.Length;
            int[] columns = new int[kLen];
            char[] keyChars = key.ToCharArray();
            Array.Sort(keyChars);
            sortCorrection(keyChars);
            int ind = 0;
            char currCh = key[0];
            for(int i = 0; i < kLen; i++)
            {
                if(currCh != keyChars[i])
                {
                    ind = 0; 
                    currCh = keyChars[i];
                }
                for(int j = ind; j < kLen; j++)
                {
                    if (currCh == key[j])
                    {
                        columns[i] = j;
                        ind = j + 1;
                        j = kLen;
                    }
                }
            }
            return columns;
        }

        static void sortCorrection(char[] arr)
        {
            const char borderChar = 'Е';
            const char exceptChar = 'Ё';
            int lastInd = arr.Length - 1;
            int exceptCharCount = 0;
            int searchInd = 0;
            while (searchInd <= lastInd && arr[searchInd] == exceptChar)
            {
                exceptCharCount++;
                searchInd++;
            }
            if( exceptCharCount > 0 )
            {
                searchInd = exceptCharCount;//
                while (searchInd < arr.Length && arr[searchInd] <= borderChar)
                {
                    searchInd++;
                }
                for (int i = exceptCharCount; i < searchInd; i++)
                {
                    arr[i - exceptCharCount] = arr[i];
                }
                for (int i = searchInd - exceptCharCount; i < searchInd; i++)
                {
                    arr[i] = exceptChar;
                }
            }
        }
    }
}
