namespace OOP1
{
    internal class Line : DisplayObject
    {
        //Толщина линии
        protected int lThickness;
        public Line(int point1X, int point1Y, int point2X, int point2Y, int lineThickenss,
            int fillR = 0, int fillG = 0, int fillB = 0) : base((point1X + point2X) / 2, (point1Y + point2Y) / 2, 
                Math.Abs(point2X - point1X), Math.Abs(point2Y - point1Y), fillR: fillR, fillG: fillG, fillB: fillB)
        {
            lThickness = lineThickenss;
        }

        public override void Draw(Graphics g)
        {
            g.DrawLine(new Pen(fillColor, lThickness), clientX1, clientY1, clientX2, clientY2);
            //g.DrawRectangle(new Pen(borderColor), frameX1, frameY1, frameX2, frameY2);
        }
    }
}
