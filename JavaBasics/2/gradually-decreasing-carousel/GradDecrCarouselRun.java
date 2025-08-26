package com.epam.rd.autotasks;

public class GradDecrCarouselRun extends CarouselRun{
    public GradDecrCarouselRun(CarouselList list){
        super(list);
        decrVal = 1;
    }

    private static int decrVal = 1;
    @Override
    public int next(){
        if(carousEls.isNtEmpty()){

            int currVal = carousEls.getVal();
            if(isValCorrect(currVal)){
                carousEls.replaceVal(modifyEl(currVal));
                if(carousEls.isNextHead()){
                    decrVal++;
                }
                carousEls.moveNext();
            }else{
                if(carousEls.isNextHead()){
                    decrVal++;
                }
                carousEls.removeEl();
            }
            //System.out.println(currVal);
            return currVal;

        }else{
            return -1;
        }
    }

    protected boolean isValCorrect(int val){
        return val - decrVal > 0;
    }
    @Override
    protected int modifyEl(int oldVal){
        return oldVal-decrVal;
    }
}
