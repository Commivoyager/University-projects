using System.Drawing.Drawing2D;

namespace OOP1
{
    internal class Triangle : DisplayObject
    {
        protected int trnglX1, trnglX2, trnglX3;
        protected int trnglY1, trnglY2, trnglY3;

        public Triangle(int x1, int y1, int x2, int y2, int x3, int y3,
            int fillR, int fillG, int fillB, int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 1) : this(FrameInfo(x1, x2, x3, y1, y2, y3), 
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        {
            //Координаты трёх вершин треугольника
            trnglX1 = x1;
            trnglX2 = x2;
            trnglX3 = x3;

            trnglY1 = y1;
            trnglY2 = y2;
            trnglY3 = y3;
        }

        public Triangle(int[] frameInf, int fillR, int fillG, int fillB, int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 0) : base(frameInf[0], frameInf[1], frameInf[2], frameInf[3],
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        { }

        //Расчёты для определения координат прямоугольной рамки, ограничивающей
        //треугольник снаружи. Для этого необходимо найти самые большие
        //и самые малые значения абсцисс и ординат координат вершин треугольника
        private static int[] FrameInfo(int x1, int x2, int x3, int y1, int y2, int y3)
        {
            int minX = x1 < x2 ? (x1 < x3 ? x1 : x3) : (x2 < x3 ? x2 : x3);
            int maxX = x1 > x2 ? (x1 > x3 ? x1 : x3) : (x2 > x3 ? x2 : x3);
            int minY = y1 < y2 ? (y1 < y3 ? y1 : y3) : (y2 < y3 ? y2 : y3);
            int maxY = y1 > y2 ? (y1 > y3 ? y1 : y3) : (y2 > y3 ? y2 : y3);
            return new int[] { (minX + maxX) / 2, (minY + maxY) / 2, maxX - minX, maxY - minY};
        }

        public override void Draw(Graphics g)
        {
            Pen pen = new Pen(borderColor, borderThickns);
            pen.Alignment = PenAlignment.Inset;
            Point[] trnglPoints = new Point[] { 
                new Point(trnglX1, trnglY1),
                new Point(trnglX2, trnglY2),
                new Point(trnglX3, trnglY3)};
            g.FillPolygon(new SolidBrush(fillColor), trnglPoints);
            g.DrawPolygon(pen, trnglPoints);
            //g.DrawRectangle(new Pen(borderColor), frameX1, frameY1, frameX2 - frameX1, frameY2 - frameY1);
        }
    }
}
