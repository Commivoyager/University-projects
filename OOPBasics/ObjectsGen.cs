namespace OOP1
{
    internal class ObjectsGen
    {
        //Крайние значения ширины и высоты фигур
        private static int minWidth = 50;
        private static int maxWidth = 150;
        private static int minHeight = 50;
        private static int maxHeight = 150;
        //Кооридинаты поля для рисования
        private static int clientX1;
        private static int clientY1;
        private static int clientX2;
        private static int clientY2;

        private static Random random = new Random();

        //Количество объектов каждого класса
        private static int objNum = 10;
        private delegate DisplayObject GenFunc();
        //Массив делегатов для более гибкого вызова функций отрисовки
        private static GenFunc[] allGenFunc = { GenEllipse, GenCircle, GenRectangle, 
            GenSquare, GenLine, GenTriangle };

        public static void GenObjects(ref DrawField field,
            int x1, int y1, int x2, int y2, int brdr)
        {
            //Область отрисовки должна не
            //включать в себя обводку 
            clientX1 = x1 + brdr;
            clientY1 = y1 + brdr;
            clientX2 = x2 - brdr;
            clientY2 = y2 - brdr;
            DisplayObject[] genArr;
            int genFuncNum = allGenFunc.Length;
            field = new DrawField((x1 + x2) / 2, (y1 + y2) / 2, x2 - x1, y2 - y1, objNum * genFuncNum,  255, 255, 153,
                0, 25, 51, brdr);
            for(int i = 0; i <  objNum; i++)
            {
                for(int j = 0; j < genFuncNum; j++)
                {
                    field.AddObj(allGenFunc[j]());
                    //field.fieldObjects[i * genFuncNum + j] = allGenFunc[j]();
                }
            }
        }
        //Функции получения произвольных значений размеров,
        //точки привязки, цвета
        private static int GetRandWidth()
        {
            return random.Next(minWidth, maxWidth);
        }
        private static int GetRandHeight()
        {
            return random.Next(minHeight, maxHeight);
        }
        //Точка привязки должна генерироваться таким образом,
        //чтобы фигура не выходила за границы игрового поля
        private static (int, int) GetRandPivot(int width, int height)
        {
            int x = random.Next(clientX1 + width / 2, clientX2 - width / 2);
            int y = random.Next(clientY1 + height / 2, clientY2 - height / 2);
            return (x, y);
        }
        private static Color GetRandColor()
        {
            return Color.FromArgb((byte)random.Next(255), (byte)random.Next(255), random.Next(255));
        }
        //Функции генерации объектов фигур
        private static Ellipse GenEllipse()
        {
            int centreX, centreY;
            int width = GetRandWidth();
            int height = GetRandHeight();
            Color fillC = GetRandColor();
            (centreX, centreY) = GetRandPivot(width, height);
            return new Ellipse(centreX, centreY, width/2, height / 2, fillC.R, fillC.G, fillC.B);
        }
        private static Circle GenCircle()
        {
            int centreX, centreY;
            int width = GetRandWidth();
            Color fillC = GetRandColor();
            (centreX, centreY) = GetRandPivot(width, width);
            return new Circle(centreX, centreY, width / 2, fillC.R, fillC.G, fillC.B);
        }
        private static Rectangle GenRectangle()
        {
            int centreX, centreY;
            int width = GetRandWidth();
            int height = GetRandHeight();
            Color fillC = GetRandColor();
            (centreX, centreY) = GetRandPivot(width, height);
            return new Rectangle(centreX, centreY, width, height, fillC.R, fillC.G, fillC.B);
        }
        private static Square GenSquare()
        {
            int centreX, centreY;
            int width = GetRandWidth();
            Color fillC = GetRandColor();
            (centreX, centreY) = GetRandPivot(width, width);
            return new Square(centreX, centreY, width, fillC.R, fillC.G, fillC.B);
        }
        private static Line GenLine()
        {
            int centreX, centreY;
            int height = GetRandHeight();
            int width = GetRandWidth();
            Color fillC = GetRandColor();
            (centreX, centreY) = GetRandPivot(width, height);
            return new Line(centreX - width / 2, centreY - height / 2, centreX + width / 2, centreY + height / 2,
                5, fillC.R, fillC.G, fillC.B);
        }
        private static Triangle GenTriangle()
        {
            int centreX, centreY;
            int height = GetRandHeight();
            int width = GetRandWidth();
            Color fillC = GetRandColor();
            (centreX, centreY) = GetRandPivot(width, height);
            return new Triangle(centreX - width / 2, centreY + height / 2,
                centreX, centreY - height / 2, centreX + width / 2, centreY + height / 2, fillC.R, fillC.G, fillC.B);
        }
    }
}
