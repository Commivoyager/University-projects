namespace OOP1
{
    //Класс абстрактный, так как нет смысла в создании
    //объекта DisplayObject, потому что данный класс
    //представляет собой лишь общую функциональность,
    //необходимую для графических примитивов, общую для них всех
    abstract public class DisplayObject
    {
        //Координаты точки привязки
        protected int pivotX;
        protected int pivotY;

        //Координаты левой верхней и правой
        //нижней точек внешней рамки фигур
        public int frameX1;
        public int frameY1;
        public int frameX2;
        public int frameY2;

        //Координаты левой верхней и правой
        //нижней точек внутренней рамки фигур - границы
        //заливки
        public int clientX1;
        public int clientY1;
        public int clientX2;
        public int clientY2;

        //Толщина обводки фигур
        protected int borderThickns;
        //Цвет заливкки
        protected Color fillColor;
        //Цвет обводки
        protected Color borderColor;

        //
        public DisplayObject(int pvtX, int pvtY, int width, int height,
            int fillR = 0, int fillG = 0, int fillB = 0, 
            int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 0)
        {
            pivotX = pvtX;
            pivotY = pvtY;
            frameX1 = pvtX - width / 2;
            frameY1 = pvtY - height / 2;
            frameX2 = pvtX + width / 2;
            frameY2 = pvtY + height / 2;

            //Внутренняя рамка должна содержать саму фигуру
            //без обводки
            clientX1 = frameX1 + brdrThickns;
            clientY1 = frameY1 + brdrThickns;
            clientX2 = frameX2 - brdrThickns;
            clientY2 = frameY2 - brdrThickns;

            fillColor = Color.FromArgb(fillR, fillG, fillB);
            borderColor = Color.FromArgb(brdrG, brdrB, brdrR);
            borderThickns = brdrThickns;
        }

        public abstract void Draw(Graphics g);
    }
}
