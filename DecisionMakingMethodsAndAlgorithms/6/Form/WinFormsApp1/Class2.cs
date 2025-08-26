using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Rebar;

namespace WinFormsApp1
{
    static internal class Class2
    {
        //static public int n = 5;
        static public double[,] distTable;//= new double[n, n];
        static public Random rand = new Random();
        static public double minDelta = 0.01;
        static public string distTableStr = string.Empty;
        static public void genMatr(int n)
        {
            distTable = new double[n, n];
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < i; j++)
                {
                    distTable[i, j] = distTable[j, i];
                }
                distTable[i, i] = 0;
                for (int j = i + 1; j < n; j++)
                {
                    distTable[i, j] = ((double)rand.Next(10, 100)) / 100 + rand.Next(2);
                }
            }
            for (int i = 0; i < n - 1; i++)
            {
                for (int j = i + 1; j < n; j++)
                {
                    for (int k = 0; k < n - 1; k++)
                    {
                        for (int l = k; l < n; l++)
                        {
                            if ((Math.Abs(distTable[i, j] - distTable[k, l]) < minDelta) && (i != k || j != l))
                            {
                                distTable[i, j] = ((double)rand.Next(10, 100)) / 100 + rand.Next(2);
                                i = 0;
                                j = 0;
                                k = 0;
                                l = 0;
                            }
                        }
                    }
                }
            }

            //n = 4;
            //n = 5;
            /*distTable = new double[,] {
                {0.98, 1.78, 0.39, 1.28, 1.99},
                {1.78, 0.00, 1.48, 0.34, 1.98},
                {1.28, 1.48, 0.00, 1.23, 0.59},
                {1.28, 0.34, 1.23, 0.00, 0.23},
                {1.99, 1.98, 0.59, 0.23, 0.00}
            };*/
            //default
            //n = 4;
            //distTable = new double[,] { { 0, 5, 0.5, 2 }, { 5, 0, 1, 0.6 }, { 0.5, 1, 0, 2.5 }, { 2, 0.6, 2.5, 0 } };

            //distTable = new double[,] { { 0, 5, 0.5, 2 }, { 5, 0, 1, 0.6 }, { 0.5, 1, 0, 2.5 }, { 2, 0.6, 2.5, 0 } };
            //distTable = new double[,] { { 0, 0.1, 1.4, 1.6 }, { 0.1, 0, 0.2, 0.5 }, { 1.4, 0.2, 0, 1.5 }, { 1.6, 0.5, 1.5, 0 } };
            //distTable = new double[,] { { 0, 0.9, 1.8, 1.6 }, { 0.9, 0, 1.3, 1.1 }, { 1.8, 1.3, 0, 1.1 }, { 1.6, 1.1, 1.1, 0 } 

            distTableStr = "";
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n; j++)
                {
                    distTableStr += string.Format("{0:f2}", distTable[i, j]) + "; ";
                }
                distTableStr += Environment.NewLine;
            }
        }

        static public void GenMatrForMax(int n)
        {
            for(int i = 0; i < n - 1; i++)
            {
                for(int j = i + 1; j < n; j++)
                {
                    distTable[i, j] = 1/distTable[i, j];
                    distTable[j, i] = distTable[i, j];
                }
            }
            distTableStr = "";
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n; j++)
                {
                    distTableStr += string.Format("{0:f2}", distTable[i, j]) + "; ";
                }
                distTableStr += Environment.NewLine;
            }
        }
    }
}
