using System.Drawing.Drawing2D;

namespace OOP1
{
    internal class Rectangle : DisplayObject
    {
        public Rectangle(int pvtX, int pvtY, int width, int height,
            int fillR = 0, int fillG = 0, int fillB = 0,
            int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 1) : base(pvtX, pvtY, width, height,
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        {}

                public override void Draw(Graphics g)
        {
            Pen pen = new Pen(borderColor, borderThickns);
            pen.Alignment = PenAlignment.Inset;
            //При заливке прямоугольника следует учитывать тот факт, что
            //ширина области заливки на 1 единицу длины (пиксель) больше, чем
            //разность крайних координат внутренней рамки
            g.FillRectangle(new SolidBrush(fillColor), clientX1-1, clientY1-1, clientX2 - clientX1+1, clientY2 - clientY1+1);
            if(0 != borderThickns){ g.DrawRectangle(pen, frameX1, frameY1, frameX2 - frameX1, frameY2 - frameY1); }
            //g.DrawRectangle(new Pen(borderColor), frameX1, frameY1, frameX2-frameX1, frameY2-frameY1);
        }
    }
}
