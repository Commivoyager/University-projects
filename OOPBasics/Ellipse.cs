using System.Drawing.Drawing2D;

namespace OOP1
{
    internal class Ellipse : DisplayObject
    {
        protected int centerX, centerY;
        public Ellipse(int pvtX, int pvtY, int radX, int radY,
            int fillR = 0, int fillG = 0, int fillB = 0,
            int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 0) : base(pvtX, pvtY, radX * 2, radY * 2,
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        {
            //Координаты центра эллипса
            centerX = pvtX;
            centerY = pvtY;
        }

        public override void Draw(Graphics g)
        {
            Pen pen = new Pen(borderColor, borderThickns);
            pen.Alignment = PenAlignment.Inset;
            //Заливка эллипса
            g.FillEllipse(new SolidBrush(fillColor), frameX1, frameY1, frameX2 - frameX1, frameY2 - frameY1);
            //g.FillEllipse(new SolidBrush(fillColor), clientX1, clientY1, clientX2 - clientX1, clientY2 - clientY1);
            //Отрисовка обводки эллипса
            g.DrawEllipse(pen, frameX1, frameY1, frameX2 - frameX1, frameY2 - frameY1);
            //g.DrawRectangle(new Pen(borderColor), frameX1, frameY1, frameX2-frameX1, frameY2-frameY1);
        }
    }
}
