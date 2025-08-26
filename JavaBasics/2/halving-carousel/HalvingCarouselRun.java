package com.epam.rd.autotasks;

public class HalvingCarouselRun extends CarouselRun {

    public HalvingCarouselRun(CarouselList list){
        super(list);
    }

    @Override
    protected int modifyEl(int oldVal){
        return oldVal/2;
    }

}
