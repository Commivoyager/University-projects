using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WinFormsApp1
{
    internal class VigenereMethod
    {
        public static string messageStr = "";
        static String alphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
        static int alphLen = alphabet.Length;
        static string initKey;
        public static char[] key;
        public static int keyLen;
        public static string procText;
        public static char[] resText;
        public static int charNum;
        delegate char Selector(int i);

        public static bool initEncryptor(string k)
        {
            initKey = k.ToUpper();
            if (!IsKeyCorrect(initKey))
            {
                messageStr = "Ключ должен содержать только буквы русского алфавита";
                return false;
            }
            keyLen = initKey.Length;
            //key = initKey.ToCharArray();
            return true;
        }

        public static bool IsKeyCorrect(String key)
        {
            for (int i = 0; i < key.Length; i++)
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
            if ((symb < 'А' || symb > 'Я') && symb != 'Ё')
            {
                return false;
            }
            return true;
        }

        public static bool cryptoFunc(string plainPath, string cipherPath, bool encryption)
        {
            if (!File.Exists(plainPath))
            {
                messageStr = "Файл с таким именем не существует";
                return false;
            }
            using(StreamReader sr = new StreamReader(plainPath))
            {
                procText = sr.ReadToEnd();
            }
            procText = procText.ToUpper();
            charNum = procText.Length;
            resText = new char[charNum];
            key = new char[charNum + keyLen];
            for(int i = 0; i < keyLen; i++)
            {
                key[i] = initKey[i];
            }
            int keyFormat;
            Selector keyFormingChar;
            if (encryption)
            {
                keyFormingChar = (int i) => procText[i];
                keyFormat = 0;
            }
            else
            {
                keyFormingChar = (int i) => resText[i];
                keyFormat = alphLen;
            }
            int plainCPos, keyCPos;
            int indKey = 0;//, prevIndKey = 0;
            for(int i = 0; i < charNum; i++)
            {
                if (IsSymbRus(procText[i]))
                {
                    plainCPos = determShift(procText[i]);
                    keyCPos = determShift(key[indKey]);
                    keyCPos = Math.Abs(keyFormat - keyCPos);
                    resText[i] = alphabet[(plainCPos + keyCPos) % alphLen];
                    key[indKey + keyLen] = keyFormingChar(i);
                    indKey++;
                }
                else
                {
                    resText[i] = procText[i];
                }
            }
            keyLen = indKey + keyLen;
            using(StreamWriter sw = new StreamWriter(cipherPath))
            {
                sw.Write(resText);
            }
            return true;
        }

        
        static int determShift(char symb)
        {
            int shft = 0;
            while(symb != alphabet[shft])
            {
                shft++;
            }
            return shft;
        }
    }
}
