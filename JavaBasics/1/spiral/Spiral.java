package com.epam.rd.autotasks;

class Spiral {
    static int[][] spiral(int rows, int columns) {

        int[][] arr = new int [rows][columns];
        int elNum = rows*columns;

        int xRBoard = columns-1;
        int yBBoard = rows-1;
        int xLBoard = 0;
        int yTBoard = 0;

        int xInd = 0;
        int yInd = 0;

        int fillNum = 1;
        do{
            while(xInd <= xRBoard && yBBoard >= yTBoard){
                arr[yInd][xInd] = fillNum++;
                xInd++;
            }
            //xRBoard--;
            yTBoard++;
            xInd--;
            yInd++;
            while(yInd <= yBBoard && xRBoard >= xLBoard){
                arr[yInd][xInd] = fillNum++;
                yInd++;
            }
            //yBBoard--;
            xRBoard--;
            xInd--;
            yInd--;

            while(xInd >= xLBoard && yBBoard >= yTBoard){
                arr[yInd][xInd] = fillNum++;
                xInd--;
            }
            //xLBoard++;
            yBBoard--;
            xInd++;
            yInd--;
            while(yInd >= yTBoard && xRBoard >= xLBoard){
                arr[yInd][xInd] = fillNum++;
                yInd--;
            }
            //yTBoard++;
            xLBoard++;
            xInd++;
            yInd++;
        }while(fillNum <= elNum);

        return arr;
    }
}
