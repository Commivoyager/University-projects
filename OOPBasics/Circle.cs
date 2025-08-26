namespace OOP1
{
    //Для создания и отрисовки объекта круга
    //достаточно всего, что реализовано для
    //эллипса. Круг - эллипс с равными полуосями
    internal class Circle : Ellipse
    {
        public Circle(int pvtX, int pvtY, int rad,
            int fillR = 0, int fillG = 0, int fillB = 0,
            int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 0) : base(pvtX, pvtY, rad, rad,
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        { }
    }
}
