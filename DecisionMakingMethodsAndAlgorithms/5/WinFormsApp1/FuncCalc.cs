using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace WinFormsApp1
{
    internal class FuncCalc
    {
        const int randPntNum = 10000;
        float maxX = 5;
        float maxY = 3;
        const int c1Num = 2;
        const int c2Num = 2;
        const int xNum = c1Num + c2Num;
        Point[] cPoints = new Point[xNum] { new Point(-1, 0), new Point(1, 1), new Point(2, 0), new Point(1, -2) };
        //Point[] c2Points = new Point[c2Num] { new Point(2, 0), new Point(1, -2) };
        int[] coeffRes = new int[4];
        int[] coeffK = { 1, 4, 4, 16 };
        int c0, c1, c2, c3;
        
        public void Calc()
        {
            bool flag = true;
            //int p;
            int valOfNext = 0;// Ki(cPoints[0]);
            while(flag)
            {
                flag = false;
                for (int i = 0; i < xNum; i++)
                {
                    if (i < c1Num && valOfNext <= 0)
                    {
                        SumPotent(1, cPoints[i]);
                        flag = true;
                    }
                    else if (i >= c1Num && valOfNext > 0)
                    {
                        SumPotent(-1, cPoints[i]);
                        flag = true;
                    }
                    valOfNext = Ki(cPoints[(i + 1) % xNum]);
                }
                if(valOfNext <= 0)
                {
                    flag = true;
                }
            }
            (c0, c1, c2, c3) = (coeffRes[0], coeffRes[1], coeffRes[2], coeffRes[3]); 
        }
        
        public int Ki(Point p)
        {
            int res;
            res = coeffRes[0] + coeffRes[1] * p.X + coeffRes[2] * p.Y + coeffRes[3] * p.X * p.Y;
            return res;
        }

        public void SumPotent(int sign, Point p)
        {
            coeffRes[0] = coeffRes[0] + sign * coeffK[0];
            coeffRes[1] = coeffRes[1] + sign * coeffK[1]*p.X;
            coeffRes[2] = coeffRes[2] + sign * coeffK[2]*p.Y;
            coeffRes[3] = coeffRes[3] + sign * coeffK[3]* p.X * p.Y;
        }

        public double func(double x)
        {
            double res;
            res = (double)(-c0 - c1 * x) / (c2 + c3 * x);
            return res;
        }

        public double separateFunc(double X, double Y)
        {
            double res;
            res = coeffRes[0] + coeffRes[1] * X + coeffRes[2] * Y + coeffRes[3] * X * Y;
            return res;
        }
        public struct PointInf
        {
            public double x;
            public double y;
            public int c;
        };
        public PointInf [] pntArr = new PointInf[randPntNum];

        Random rand = new Random();
        public void RandP()
        {
            for(int i = 0; i < randPntNum; i++)
            {
                double x = rand.NextDouble() * 2 * maxX - maxX;
                pntArr[i].x = x;
                double y = rand.NextDouble() * 2 * maxY - maxY;
                pntArr[i].y = y;
                double funcRes = separateFunc(x, y);
                if(funcRes < 0.8 && funcRes > - 0.8)
                {
                    pntArr[i].c = 0;
                }
                else
                if (funcRes > 0)
                {
                    pntArr[i].c = 1;
                }
                else if(funcRes < 0)
                {
                    pntArr[i].c = 2;
                }
                else
                {
                    pntArr[i].c = 0;
                }
            }
        }

        public void drawFunc(Graphics g, int fieldW, int fieldH)
        {
            fieldW = fieldW / 2;
            fieldH = fieldH/2;
            //float maxX = 5;
            //float maxY = 3;
            float relateX = fieldW / maxX;
            float relateY = fieldH / maxY;


            g.TranslateTransform(fieldW, fieldH);
            //g.RotateTransform(180);

            float x = -maxX;
            float y = (float)func(x);
            //float piece;
            //piece = maxX / x;
            float xDr = x * relateX;
            float yDr;
            float xPrevDr, yPrevDr;
            float step = maxX / 100;

            Pen graphPen = new Pen(Brushes.Red, 2);
            while (x < maxX)
            {
                xPrevDr = xDr;
                yPrevDr = -y * relateY;

                x += step;
                y = (float)func(x);
                xDr = x * relateX;
                yDr = -y * relateY;

                g.DrawLine(graphPen, xPrevDr, yPrevDr, xDr, yDr);
                
            }
            graphPen.Brush = Brushes.Black;
            g.DrawLine(graphPen, -fieldW, 0, fieldW, 0);
            g.DrawLine(graphPen, 0, -fieldH, 0, fieldH);
            for(int i = 0; i < randPntNum; i++)
            {
                int c = pntArr[i].c;
                if(c != 0)
                {
                    if (c == 1)
                    {
                        graphPen.Brush = Brushes.Blue;
                    }
                    else if (c == 2)
                    {
                        graphPen.Brush = Brushes.Green;
                    }
                    float xp = (float)pntArr[i].x;
                    float yp = -(float)pntArr[i].y;

                    g.DrawEllipse(graphPen, xp * relateX, yp * relateY, 3, 3);
                }
                
                //else
                //{
                //    graphPen.Brush = Brushes.White;
                //}
                
            }
        }
    }
}
