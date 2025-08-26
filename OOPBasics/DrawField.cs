namespace OOP1
{
    //Так как поле для рисования представляет собой прямоугольник
    //c обводкой, то рационально наследовать его от класса прямоугольника
    internal class DrawField : Rectangle
    {
        public DisplayObject[] fieldObjects;
        public int currObjNum;
        public int maxObjNum;
        public DrawField(int pvtX, int pvtY, int width, int height, int objectsNum,
            int fillR = 0, int fillG = 0, int fillB = 0, 
            int brdrR = 0, int brdrG = 0, int brdrB = 0,
            int brdrThickns = 0) : base(pvtX, pvtY, width, height,
                fillR, fillG, fillB, brdrR, brdrG, brdrB, brdrThickns)
        {
            currObjNum = 0;
            maxObjNum = objectsNum;
            fieldObjects = new DisplayObject[objectsNum];
        }
        
        public void AddObj(DisplayObject obj)
        {
            //DEBUG
            if(currObjNum == maxObjNum - 1)
            {
                if(currObjNum == maxObjNum - 1)
                {}
            }
            //DEBUG
            if (maxObjNum == currObjNum)
            {
                ResizeObjArr();
            }
            fieldObjects[currObjNum] = obj;
            currObjNum++;
        }
        public void DeleteObj(int index)
        {
            if(0 != currObjNum)
            {
                for(int i = index+1; i < currObjNum; i++)
                {
                    fieldObjects[i -1] = fieldObjects[i];
                }
                currObjNum--;
            }
        }
        private void ResizeObjArr()
        {
            DisplayObject[] tempArr;
            maxObjNum = 2 * maxObjNum;
            tempArr = new DisplayObject[maxObjNum];
            for(int i = 0; i < currObjNum; i++)
            {
                tempArr[i] = fieldObjects[i];
            }
            fieldObjects = tempArr;
        }
    }
}
