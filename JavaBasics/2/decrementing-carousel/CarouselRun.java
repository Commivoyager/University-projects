package com.epam.rd.autotasks;

public class CarouselRun {
    private CarouselList carousEls;
    //private int capacity;
    //private int currInd = -1;
   // private int nonZeroNum;
    CarouselRun(CarouselList list/*, int realCapacity*/){
        carousEls = list;
        //this.capacity = realCapacity;
        //nonZeroNum = realCapacity;
    }
    public int next() {
        if(carousEls.isNtEmpty()){
            int currVal = carousEls.getVal();
            if(currVal - 1 == 0){
                carousEls.removeEl();
            }else{
                carousEls.addToCurr(-1);
                carousEls.moveNext();
            }
            return currVal;
        }
        return -1;
        //throw new UnsupportedOperationException();
    }

    public boolean isFinished() {
        return !carousEls.isNtEmpty();
        //throw new UnsupportedOperationException();
    }

}
