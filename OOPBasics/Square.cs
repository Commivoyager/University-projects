namespace OOP1
{
    internal class Square : Rectangle
    {
        public Square(int pvtX, int pvtY, int side,
            int fillR = 0, int fillG = 0, int fillB = 0,
            int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 1) : base(pvtX, pvtY, side, side,
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        { }
    }
}
