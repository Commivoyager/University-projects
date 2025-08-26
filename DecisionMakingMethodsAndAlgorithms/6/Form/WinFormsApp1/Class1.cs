using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinFormsApp1
{
    internal class Class1
    {
        public string mainFunc(Graphics g, int heightD, int n, double[,] distTable)
        {
            double[,] nextDistTable = null;
            Pen pen = new Pen(Color.Black, 3);
            int drawDSize = n;
            drawInfoNode[] infArr = new drawInfoNode[drawDSize];
            int group1 = 0, group2 = 0;
            string tempStr = string.Empty;
            int drawDist = 150;
            int drawWidth = 50;
            int startX = 0;
            int startY = heightD - 50;
            int valCoeff = (heightD - 100) / 2;
            double minDist;
            int[] indArr = new int[n];
            string xValSeqnc = string.Empty;
            string yValSeqnc = string.Empty;
            for (int i = 0; i < drawDSize; i++)
            {
                infArr[i] = new drawInfoNode { val = 0, index = i, xCoord = 0};
            }

            while (n > 1)
            {
                bool flagInd = false;
                minDist = 0xFFFFFFFF;
                getNewGroup(distTable, ref group1, ref group2, ref minDist, n);

                int tempInd;
                int x1, x2;
                int y1 = -(int)(infArr[group1].val * valCoeff) + startY;
                int y2 = -(int)(infArr[group2].val * valCoeff) + startY;
                if (infArr[group1].val == 0)
                {
                    //write xn
                    int maxX = 0;
                    for(int i = 0; i < drawDSize;i++)
                    {
                        if(infArr[i].xCoord >= maxX)
                        {
                            maxX = infArr[i].xCoord;
                        }
                    }
                    x1 = maxX + drawDist;
                }
                else
                {
                    x1 = infArr[group1].xCoord;
                }
                if (infArr[group2].val == 0)
                {
                    x2 = x1 + drawDist;
                    //write xn
                }
                else
                {
                    x2 = infArr[group2].xCoord;
                }
                if (infArr[group1].xCoord == 0)
                {
                    xValSeqnc += string.Format("x{0} ", infArr[group1].index + 1);
                }
                if (infArr[group2].xCoord == 0)
                {
                    xValSeqnc += string.Format("x{0} ", infArr[group2].index + 1);
                }
                yValSeqnc += string.Format("{0:f2}; ", minDist);
                infArr[group1].val = minDist;
                int y = -(int)(infArr[group1].val * valCoeff) + startY;
                Point[] p = new Point[] {
                    new Point(x1+startX, y1),
                    new Point(x1+startX, y),
                    new Point(x2+startX, y),
                    new Point(x2+startX, y2)
                };
                for (int i = 0; i < p.Length - 1; i++)
                {
                    g.DrawLine(pen, p[i], p[i + 1]);
                }
                infArr[group1].val = minDist;
                infArr[group1].xCoord = (x1 + x2) / 2;
                drawDSize--;
                for (int i = group2; i < drawDSize; i++)
                {
                    infArr[i].val = infArr[i + 1].val;
                    infArr[i].xCoord = infArr[i + 1].xCoord;
                    infArr[i].index = infArr[i + 1].index;
                }
                g.DrawEllipse(pen, infArr[group1].xCoord + startX-2, y-2, 4, 4);
                getNewMatr(ref n, distTable, ref nextDistTable, group1, group2);
                fillLowMatrTr(nextDistTable, n);
                tempStr = string.Empty;
                for (int i = 0; i < n; i++)
                {
                    for (int j = 0; j < n; j++)
                    {
                        tempStr += string.Format("{0:f2}", nextDistTable[i, j]) + "; ";
                    }
                    tempStr += "\n";
                }
                Console.WriteLine();
                Console.WriteLine(tempStr);
                distTable = nextDistTable;
            }
            g.DrawLine(pen, 100, startY, 2000, startY);
            g.DrawLine(pen, 100, startY, 100, 0);
            return xValSeqnc + Environment.NewLine + yValSeqnc + Environment.NewLine;
        }

        public void getNewGroup(double[,] distTable, ref int group1, ref int group2, ref double minDist, int n)
        {
            for (int i = 0; i < n - 1; i++)
            {
                for (int j = i + 1; j < n; j++)
                {
                    if (distTable[i, j] < minDist)
                    {
                        minDist = distTable[i, j];
                        group1 = i;
                        group2 = j;
                    }
                }
            }
        }

        public void getNewMatr(ref int n, double[,] distTable, ref double[,] nextDistTable, int group1, int group2)
        {
            --n;
            nextDistTable = new double[n, n];
            int stepX = 0;
            int stepY = 0;
            for (int i = 0; i < n - 1; i++)
            {
                if (i == group1)
                {
                    for (int j = i + 1; j < n; j++)
                    {
                        if (j == group2)
                        {
                            stepX = 1;
                        }
                        if (distTable[i, j + stepX] < distTable[group2, j + stepX])
                        {
                            nextDistTable[i, j] = distTable[i, j + stepX];
                        }
                        else
                        {
                            nextDistTable[i, j] = distTable[group2, j + stepX];
                        }
                    }
                    stepX = 0;
                }
                else
                {
                    if (i >= group2)
                    {
                        stepY = 1;
                        stepX = 1;
                    }
                    for (int j = i + 1; j < n; j++)
                    {
                        if (j == group1)
                        {
                            if (distTable[i + stepY, j] < distTable[i + stepY, group2])
                            {
                                nextDistTable[i, j] = distTable[i + stepY, j];
                            }
                            else
                            {
                                nextDistTable[i, j] = distTable[i + stepY, group2];
                            }
                        }
                        else
                        {
                            if (j == group2)
                            {
                                stepX = 1;
                            }
                            nextDistTable[i, j] = distTable[i + stepY, j + stepX];
                        }
                    }
                    stepX = 0;
                }
            }
        }

        public void fillLowMatrTr(double[,] matr, int n)
        {
            for (int i = 0; i < n - 1; i++)
            {
                for (int j = i + 1; j < n; j++)
                {
                    matr[j, i] = matr[i, j];
                }
            }
        }
        public struct drawInfoNode
        {
            public int index;
            public double val;
            public int xCoord;
            //public bool change;
        }

    }
}
