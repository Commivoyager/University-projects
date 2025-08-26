using System.Collections;

namespace ConsoleApp1
{
    internal static class Calculates
    {
        // 111111111111111111111111111111111
        // x^33+x^13+1

        public static int copyCount = 200;
        public static string encrRes = "D:\\Asus Tuf Gaming A15\\Different\\Учёба\\ТИ\\2\\Files\\Encrypted";
        public static string decrRes = "D:\\Asus Tuf Gaming A15\\Different\\Учёба\\ТИ\\2\\Files\\Decrypted";
        
        
        public static string fName;
        public static string sourceFileName;
        public static string resFileName = encrRes;
        public static string regState;

        public static List<int> plnmlLst;
        public static byte[] buf;
        public static byte[] key;
        public static int fLen;
        public static int fBitLen;
        public static int regLen;
        public static BitArray bitKey;


        public static BitArray sourceFBitContent;
        public static BitArray resFBitContent;
        public static char[] keyIter;
        public static int iterNum = 100;
        public static void GetFileInf()
        {
            using (FileStream fs = new FileStream(sourceFileName, FileMode.Open))
            {
                fLen = (int)fs.Length;
                fBitLen = fLen * 8;
                //DEBUG
                if(regLen > fBitLen)
                {
                    regLen = fBitLen;
                }
                //DEBUG
                if(fLen < copyCount)
                {
                    copyCount = fLen;
                }
            }
        }

        public static void FillRegBits()
        {              
            bitKey = new BitArray(fBitLen, false);
            //DEBUG
            if (regLen > fBitLen)
            {
                regLen = fBitLen;
            }
            //DEBUG
            for (int i = 0; i < regLen; i++)
            {
                if (regState[i] == '1')
                {
                    bitKey[fBitLen - i - 1] = true;
                }
            }

        }

        public static void GenKey()
        {
            GetFileInf();
            FillRegBits();
            int shift = fBitLen - regLen - 1;
            if (iterNum > shift+1)
            { 
                iterNum = shift+1;
            }
            while (shift >= 0)
            {
                for (int j = 0; j < plnmlLst.Count; j++)
                {
                    bitKey[shift] ^= bitKey[plnmlLst[j] + shift];
                }
                shift--;
            }
            key = new byte[fLen];
            bitKey.CopyTo(key, 0);
        }

        public static void CryptAlg()
        {
            using(FileStream fs = new FileStream(sourceFileName,FileMode.Open))
            {
                buf = new byte[fLen];
                fs.Read(buf, 0, fLen);
            }

            GetBits(ref sourceFBitContent, buf, fLen);
            GetFName();
            for (int i = 0, j = fLen-1; i < fLen; i++, j--)
            {
                buf[j] ^= key[i];
            }
            GetBits(ref resFBitContent, buf, fLen);

            using (FileStream fs = new FileStream(resFileName + "\\" + fName, FileMode.Create))
            {
                fs.Write(buf, 0, fLen);
            }
        }

        public static void GetFName()
        {
            int i = sourceFileName.LastIndexOf('\\');
            fName = sourceFileName.Substring(i+1);
        }
        
        public static void GetBits(ref BitArray bArr, byte[] buf, int len)
        {
            byte[] byteContent = new byte[copyCount];

            for (int i = 0; i < copyCount; i++)
            {
                byteContent[i] = buf[len - copyCount + i];
            }
            bArr = new BitArray(byteContent);
        }
    }
}
