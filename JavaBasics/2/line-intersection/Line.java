package com.epam.rd.autotasks.intersection;

public class Line {

    private final int k;
    private final int b;

    public Line(int k, int b) {
        this.k = k;
        this.b = b;
    }

    public int getK(){
        return k;
    }
    public int getB(){
        return b;
    }
    public Point intersection(Line other) {
        int othK = other.getK();
        int othB = other.getB();
        if(othK == k){
            return null;
        }
        int interX = (othB-b)/(k - othK);
        int interY = k*interX+b;
        return new Point(interX,interY);
        //throw new UnsupportedOperationException();
    }

}
