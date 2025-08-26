using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IT_RSA_Lab
{
    internal static class RSALogic
    {
        public static int pNum, qNum, rNum;
        public static int fEuler, privateKey, publicKey;
        public static string messageStr = "";
        const int maxRVal = 0xFFFF;
        const int minRVal = 0xFF;
        public static byte[] plainBuf;
        public static ushort[] encrBuf;
        static int bufSize;

        //initialization functions
        public static bool initNumbers(int p, int q)
        {
            if ((double)p / q > 100 || (double)p / q < 0.01)
            {
                messageStr = "The numbers p and q must have the same order";
                return false;
            }
            if (primeCheck(p))
            {
                if (primeCheck(q))
                {
                    rNum = p * q;
                    if (rNum > maxRVal)
                    {
                        messageStr = "p or q is too large";
                        return false;
                    }
                    if(rNum <= minRVal)
                    {
                        messageStr = "p or q is too small";
                        return false;
                    }
                    if (p == q)
                    {
                        // Because Euler function f(p^n) = p^n-p^(n-1)
                        // n=2 => f(p^2) = p^2-p = p*(p-1)
                        // Or f(m*n) = f(m)*f(n)*(m,n)/f((m,n))
                        // where (m,n) - gcd of m and n
                        //fEuler = p * (p - 1);
                        messageStr = "p can't be equal to q";
                        return false;
                    }
                    else
                    {
                        fEuler = (p - 1) * (q - 1);
                    }
                    pNum = p;
                    qNum = q;
                }
                else
                {
                    messageStr = "q must be prime number";
                    return false;
                }
            }
            else
            {
                messageStr = "p must be prime number";
                return false;
            }
            //messageStr = "";
            return true;
        }

        public static bool initKeys(int privK)
        {
            if (privK > 1 && privK < fEuler)
            {
                if (relPrimeCheck(privK, fEuler))
                {
                    privateKey = privK;
                    publicKey = extEuler(privK, fEuler);
                    return true;
                }
                else
                {
                    messageStr = "Private key must be relatively prime to value of Euler function";
                    return false;
                }
            }
            else
            {
                messageStr = "Value of private key must be greater than 1 and less than the value of the Euler function: " + fEuler;
                return false;
            }
        }

        //crypto functions
        public static bool encrypt(string pathF, string pathEncr)
        {
            if (!File.Exists(pathF))
            {
                messageStr = "File with that path doesn't exist";
                return false;
            }
            using (FileStream fs = File.OpenRead(pathF))
            {
                bufSize = (int)fs.Length;
                plainBuf = new byte[bufSize];
                encrBuf = new ushort[bufSize];
                fs.Read(plainBuf, 0, bufSize);
            }
            encrMainFunc();
            using (FileStream fs = new FileStream(pathEncr, FileMode.Create))
            {
                foreach(ushort value in encrBuf)
                {
                    byte[] byteRepresent  = BitConverter.GetBytes(value);
                    fs.Write(byteRepresent, 0, byteRepresent.Length);
                }
                
            }
            return true; 
        }

        public static bool  decrypt(string pathF, string pathDecr)
        {
            if (!File.Exists(pathF))
            {
                messageStr = "File with that path doesn't exist";
                return false;
            }
            using(FileStream fs = File.OpenRead(pathF))
            {
                bufSize = (int)fs.Length / 2;
                plainBuf = new byte[bufSize];
                encrBuf = new ushort[bufSize];
                byte[] tempEncrBuf = new byte[bufSize*2];
                fs.Read(tempEncrBuf, 0, tempEncrBuf.Length);
                for(int i = 0; i < bufSize; i++)
                {
                    encrBuf[i] = BitConverter.ToUInt16(tempEncrBuf, i*2);
                }
            }
            decrMainFunc();
            using (FileStream fs = new FileStream(pathDecr, FileMode.Create))
            {
                fs.Write(plainBuf, 0, bufSize);
            }
            return true;
        }

        static void encrMainFunc()
        {
            for(int i = 0; i < bufSize; i++)
            {
                int degr = publicKey;
                ushort tempNum = plainBuf[i], res = 1;
                while(degr != 0)
                {
                    while(degr % 2 == 0)
                    {
                        degr /= 2;
                        tempNum = (ushort)((tempNum * tempNum) % rNum);
                    }
                    degr--;
                    res = (ushort)((res * tempNum) % rNum);
                }
                encrBuf[i] = res;
            }
        }

        static void decrMainFunc()
        {
            for(int i = 0; i < bufSize; i++)
            {
                int degr = privateKey;
                ushort tempNum = encrBuf[i], res = 1;
                while(degr != 0)
                {
                    while(degr %2 == 0)
                    {
                        degr /= 2;
                        tempNum = (ushort)((tempNum*tempNum)%rNum);
                    }
                    degr--;
                    res = (ushort)((res * tempNum) % rNum);
                }
                plainBuf[i] = (byte)res;
            }
        }


        //check functions
        static bool primeCheck(int num) 
        {
            if(num <= 2)
            {
                if(num == 2)
                {
                    return true;
                }
                return false;
            }
            List<int> primeNumbers = new List<int>();
            for(int i = 2; i <= num; i++)
            {
                primeNumbers.Add(i);
            }
            int primeBordr = (int)(Math.Sqrt(num)) + 1;
            int lastPrime = 2;
            int lastInd = 0;
            while(lastInd < primeNumbers.Count && lastPrime <= primeBordr)
            {
                lastPrime = primeNumbers[lastInd];
                lastInd++;
                int i = lastInd;
                while (i < primeNumbers.Count)
                {
                    if (primeNumbers[i] % lastPrime == 0)
                    {
                        primeNumbers.RemoveAt(i);
                    }
                    else
                    {
                        i++;
                    }
                }
            }
            if (primeNumbers[primeNumbers.Count-1] != num)
            {
                return false;
            }
            return true;
        }

        static bool relPrimeCheck(int num1, int num2)
        {
            if(gcdByEuler(num1, num2) != 1)
            {
                return false;
            }
            return true;
        } 

        static int gcdByEuler(int num1, int num2)
        {
            if(num1 < num2)
            {
                num1 ^= num2;
                num2 ^= num1;
                num1 ^= num2;
            }
            //num1 > num2
            int gcd;
            while (num2 != 0)
            {
                gcd = num1 % num2;
                num1 = num2;
                num2 = gcd;
            }
            return num1;
        }

        static int extEuler(int numb, int module) // module == n
        {
            int uPrev = 1, uCurr = 0;
            int vPrev = 0, vCurr = 1;
            int divNum;
            int numbPrev = module;
            int temp;
            while(numb != 0)
            {
                divNum = numbPrev / numb;
                temp = numb;
                numb = numbPrev - divNum * numb;
                numbPrev = temp;
                temp = uCurr;
                uCurr = uPrev - divNum * uCurr;
                uPrev = temp;
                temp = vCurr;
                vCurr = vPrev - divNum * vCurr;
                vPrev = temp;
            }
            if(vPrev < 0)
            {
                vPrev += module;
            }
            return vPrev;
        }
    }
}
