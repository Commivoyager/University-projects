package com.epam.rd.autotasks;

public class HalvingCarousel extends DecrementingCarousel {

    public HalvingCarousel(final int capacity) {

        super(capacity);
    }


    @Override
    public CarouselRun run(){
        if(accumState){
            accumState = false;
            elements.moveNext();
            return new HalvingCarouselRun(elements);
        }else{
            return null;
        }
    }
}
