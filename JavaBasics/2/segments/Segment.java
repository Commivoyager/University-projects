package com.epam.rd.autotasks.segments;

import static java.lang.Math.abs;
import static java.lang.Math.sqrt;
import static java.lang.StrictMath.pow;

class Segment {
    private static final double eps = 1e-5;
    private final Point startP;
    private final Point endP;

    public Point getStPoint(){
        return startP;
    }
    public Point getEndPoint(){
        return endP;
    }
    //public double getTang(){
      //  return startP.getX(
    //}
    public Segment(Point start, Point end) {
        if(abs(start.getX() - end.getX()) < eps && abs(start.getY() - end.getY()) < eps){
            throw new IllegalArgumentException();
        }
        startP = start;
        endP = end;
    }

    double length() {
        double xDiff = endP.getX() - startP.getX();
        double yDiff = endP.getY() - startP.getY();
        return Math.sqrt(xDiff*xDiff + yDiff*yDiff);
    }

    Point middle() {
        double midlX = (startP.getX() + endP.getX()) / 2;
        double midlY = (startP.getY() + endP.getY()) / 2;
        return new Point(midlX, midlY);
    }

    Point intersection(Segment another) {

        double startX1 = startP.getX();
        double startY1 = startP.getY();
        double endX1 = endP.getX();
        double endY1 = endP.getY();

        Point stP2 = another.getStPoint();
        Point endP2 = another.getEndPoint();
        double startX2 = stP2.getX();
        double startY2 = stP2.getY();
        double endX2 = endP2.getX();
        double endY2 = endP2.getY();

        double xDiff1 = startX1 - endX1; // x1-x2
        double xDiff2 = startX2-endX2;  // x3-x4
        double yDiff1 = startY1-endY1; // y1-y2
        double yDiff2 = startY2 - endY2; // y3-y4

        double intrDenomtr = xDiff1*yDiff2 - yDiff1*xDiff2;
        if(intrDenomtr == 0){
            return null;
        }
        double intrNumrtr1 = startX1*endY1 - startY1*endX1; // x1y2-y1x2
        double intrNumrtr2 = startX2*endY2 - startY2*endX2; // x3y4-y3x4
        double intrX = (intrNumrtr1*xDiff2 - xDiff1*intrNumrtr2)/intrDenomtr;
        double intrY = (intrNumrtr1*yDiff2 - yDiff1*intrNumrtr2)/intrDenomtr;

        if(intrX > startX1 && intrX > endX1
                || intrX < startX1 && intrX < endX1
                || intrY > startY1 && intrY > endY1
                || intrY < startY1 && intrY < endY1

                ||intrX > startX2 && intrX > endX2
                || intrX < startX2 && intrX < endX2
                || intrY > startY2 && intrY > endY2
                || intrY < startY2 && intrY < endY2
        ){
            return null;
        }
        return new Point(intrX, intrY);
    }

}
