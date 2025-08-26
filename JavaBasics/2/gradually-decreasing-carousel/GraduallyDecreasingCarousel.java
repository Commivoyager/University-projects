package com.epam.rd.autotasks;

public class GraduallyDecreasingCarousel extends DecrementingCarousel{
    public GraduallyDecreasingCarousel(final int capacity) {
        super(capacity);
    }

    @Override
    public GradDecrCarouselRun run(){
        if(accumState){
            accumState = false;
            elements.moveNext();
            return new GradDecrCarouselRun(elements);
        }else{
            return null;
        }
    }
}
