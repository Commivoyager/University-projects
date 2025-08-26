package com.epam.rd.autotasks;

public class CarouselLimitedRun extends CarouselRun{
    protected int nextLimit;
    protected int nextCount;
    public CarouselLimitedRun(CarouselList list, final int nextLimit){
        super(list);
        this.nextLimit = nextLimit;
        nextCount = 0;
    }

    @Override
    public int next() {
        if(nextCount < nextLimit){
            int nextRes = super.next();
            if(nextRes > 0){
                nextCount++;
            }
            return nextRes;
        }else{
            return -1;
        }
    }

    @Override
    public boolean isFinished() {
        if(nextCount < nextLimit){
            return super.isFinished();
        }else{
            return true;
        }
    }

}
