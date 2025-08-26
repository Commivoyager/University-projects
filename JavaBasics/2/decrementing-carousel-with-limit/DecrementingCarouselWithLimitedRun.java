package com.epam.rd.autotasks;

public class DecrementingCarouselWithLimitedRun extends DecrementingCarousel{
    protected int runLimit;
    public DecrementingCarouselWithLimitedRun(final int capacity, final int actionLimit) {
        super(capacity);
        runLimit = actionLimit;
    }

    protected CarouselLimitedRun createRun(CarouselList list){
        return new CarouselLimitedRun(list, runLimit);
    }

}
