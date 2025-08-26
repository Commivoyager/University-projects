package com.epam.rd.autotasks;

public class CarouselRun {
    private CarouselList carousEls;

    CarouselRun(CarouselList list){
        carousEls = list;

    }
    public int next() {
        if(carousEls.isNtEmpty()){
            int currVal = carousEls.getVal();
            if(currVal - 1 == 0){
                carousEls.removeEl();
            }else{
                //changeEl(carousEls, currVal);
                //carousEls.addToCurr(-1);
                carousEls.replaceVal(modifyEl(currVal));
                carousEls.moveNext();
            }
            return currVal;
        }
        return -1;
        //throw new UnsupportedOperationException();
    }

    protected int modifyEl(int oldVal){
        return --oldVal;
    }

    public boolean isFinished() {
        return !carousEls.isNtEmpty();
        //throw new UnsupportedOperationException();
    }

}
