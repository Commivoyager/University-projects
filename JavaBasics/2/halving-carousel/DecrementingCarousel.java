package com.epam.rd.autotasks;

public class DecrementingCarousel {
    protected CarouselList elements;
    private int capacity;
    private int elNum;
    //private int lastInd;
    protected boolean accumState;
    public DecrementingCarousel(int capacity) {
        this.capacity = capacity;
        elements = new CarouselList();
        accumState = true; ///
        elNum = 1;
        //lastInd = -1;
    }

    public boolean addElement(int element){
        if(element > 0 ){
            if(elNum <= capacity){
                if(accumState){
                    //elements[++lastInd] = element;
                    elements.addEl(element);
                    elNum++;
                    return true;
                }else{
                    return false;
                }
            }else{
                return false;
            }
        }else{
            return false; ///
        }
        //throw new UnsupportedOperationException();
    }

    public CarouselRun run(){
        if(accumState){
            accumState = false;
            elements.moveNext();
            return new CarouselRun(elements/*, elNum*/);
        } else{
            return null;
        }
        // throw new UnsupportedOperationException();
    }
}
